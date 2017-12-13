import re
import codecs
import csv

from os import path

"""
parser.py

This class is required in order to extract information about presenter's at the annual Statistical Society
of Canadaconference.
The following fields of information are extracted:
- authors presenting
- abstract being presented
- abstract description
- time/date of the presentation

Usage Example:
parser = Parser('file_with_abstracts.tex', 'file_with_prog.tex')
data = parser.parse_all()

# Write the file to disk
parser.write_to_csv(data, headers=[...])
"""
class Parser(object):
    def __init__(self, meeting_file_path=None, prog_file_path=None, _encoding='utf-8'):
        self.encoding = _encoding
        self.file = self._open_latex_file(meeting_file_path).read()
        self.prog_file = self._open_latex_file(prog_file_path).read()

    def _open_latex_file(self, file_path):
        """
        Opens a LaTeX file which contains UTF-8 characters

        @param string file the path to a file name
        """

        assert path.lexists(file_path)

        # Ensure the file extension is .tex
        assert path.splitext(file_path)[1] == '.tex'

        return codecs.open(file_path, 'rt', self.encoding)

    def write_to_file(self, data, file_name='../data/conference.csv', headers=['Abstract', 'Abstract Description', 'Name/Institution/Workplace', 'Time Slot']):
        """
        Writes the parsed abstracts data to a CSV file

        @param List<string> data
        @param string file_name
        """

        # Ensure we have data to write, otherwise toss an exception
        assert len(data) > 0

        with open(file_name, 'w') as csv_file:
            conference_writer = csv.writer(csv_file)
            conference_writer.writerow(headers)
            
            for row in data:
                # The inauguration speeches contain no abstract description, so we should ignore writing them
                if row[1] == '':
                    continue

                # Decode the ANSII value from the unicode characters then write out the unicode characters if they exist
                row = [unicode(v).encode('utf-8') for v in row]
                conference_writer.writerow(row)

    def _remove_sunday_session(self, prog_file=False):
        """
        A helper method for _extract_abstracs_from_session_block()
        Eliminates Sunday from the schedule as there are useless abstracts present (they are for workshops, or welcoming speeches)

        @return string a string consisting of the conference schedule with Sunday removed
        """

        file_ = ""
        if (prog_file):
            file_ = self.prog_file
        else:
            file_ = self.file
            
        # Extract the sessions by day in order to trim off the Sunday session since it is primarily workshops, and information sessions which are not desireable
        session_days_pattern = re.compile(r'\\sessionDay{\\.*?}(.*?\\end{longtable})', re.S | re.M)
        session_days = re.findall(session_days_pattern, file_)
        
        session_days = ''.join(session_days[1::])

        return session_days

    def parse_authors(self):
        """
        Parse all of the authors within a given LaTeX file

        @return List<string> a List object containing unicode strings which denote the names, institutions, and/or workplace of the presenters
        """
        
        authors_pattern = re.compile(r'(\\Author.*?)}\n.?}', re.M | re.S)
        authors = re.findall(authors_pattern, self.file)
        
        for i, author_pairs in enumerate(authors):
            # Remove all remaining braces from parsing and split on commas as this indicates more than one author
            authors[i] = unicode(author_pairs) \
                            .replace('{', '') \
                            .replace('}', ' ') \
                            .replace('\\Author', '') \
                            .replace('  ', ' ') \
                            .split(',')
            
            # Iterate over each additional author, and remove any whitespace before/after the author's name/workplace
            for j in xrange(0, len(authors[i])):
                authors[i][j] = authors[i][j].replace('\n', '')

                if authors[i][j].find('%') != -1:
                    authors[i][j] = authors[i][j].replace('%', '')

                authors[i][j] = authors[i][j].strip()
            
            # Concatenate each set of authors into a singular string.
            # i.e, [["John B SFU", "Susan F UBC"]] => "John B SFU, Susan F UBC"
            authors[i] = ", ".join(authors[i])
        
        assert len(authors) > 1

        return authors

    def parse_times(self):
        """
        Parse all the time slots pre-existing within a given abstracts LaTeX file

        @return List<string> a List object containing unicode strings which denote the time of the presentations
        """

        time_pattern = re.compile(r'\\absTime{(.*)}', re.M)
        abstract_times = re.findall(time_pattern, self.file)
        for idx, time in enumerate(abstract_times):
            abstract_times[idx] = time.replace('{', ' ').replace('}', ' ').replace('\\', '').split()
            abstract_times[idx] = " ".join(abstract_times[idx])

        assert len(abstract_times) > 1

        return abstract_times

    def parse_abstract_titles(self):
        """
        Parse all of the English abstract titles from an abstracts LaTeX file. Assumes they are denoted by \\abstitle

        Note: this method does not extract the French translation of the abstract title.
        This can be found by using the following statement: re.compile(r'abstitle\{(.*?)\}\{(.*?)\}')

        @return List<string> a List object containing unicode strings which denote the title of presentation abstracts
        """
        
        abstract_title_pattern = re.compile(r'\\abstitle{(.*?)}', re.M)
        abstract_titles = re.findall(abstract_title_pattern, self.file)

        # Unicode characters present, must wrap to unicode
        abstract_titles[:] = [unicode(x).strip() for x in abstract_titles]

        assert len(abstract_titles) > 1

        return abstract_titles

    def parse_abstract_descriptions(self):
        """
        Parse the abstract descriptions from the defined LaTeX file within the constructor of Parser()

        @return List<string> a List object containing the abstract descriptions in both English and French
        """

        abstract_descriptions_pattern = re.compile(r'\\absSideBySide{(.*?)}', re.M)
        abstract_descriptions = re.findall(abstract_descriptions_pattern, self.file)
        
        assert len(abstract_descriptions) > 1

        return abstract_descriptions

    def parse_invited_or_contributed_talks(self, speaker_type):
        """
        Parse all talks with the flag of "Invited", "Contributed", or "Poster"
        @param speaker_type string denotes the type of flag to search for

        @return List<(string, string)> a list containing tuple elements of (abstract title, speaker_type)
        """

        self.prog_file = self.prog_file.strip()
        sessions = self.prog_file.split('\\grSciSession')
        # Make the mapping a tuple of (abstract_title, speaker_type) as we need to allow for duplicate Welcome talks
        mapped_abstracts = []

        for block in sessions:
            # If there is more than one % sign present, we know the row is a commented out row
            if block.count('%') > 1:
                continue

            # Ensure we can identify the speaker type
            if block.find('\\%s' % speaker_type) != -1:  
                # Find all of the abstracts within the block
                abstract_pattern = re.compile(r'\\Author.*?}\n}\n{(.*?)}\s*{\\bubble[EF] \\enspace \\screen[EBF]}', re.S | re.M)
                abstracts = re.findall(abstract_pattern, block)
                
                for abstract in abstracts:
                    abstract = abstract.split('}')[0]
                    abstract = abstract.strip()
                    abstract = unicode(abstract)

                    mapped_abstracts.append((abstract, speaker_type))

        return mapped_abstracts

    def parse_all(self):
        """
        Performs all relevant parsing functions and returns a single list of tuples containing the entries
        """
            
        data = zip(self.parse_abstract_titles()[4::], self.parse_abstract_descriptions()[4::], self.parse_authors()[4::], self.parse_times()[4::])
        
        return data
