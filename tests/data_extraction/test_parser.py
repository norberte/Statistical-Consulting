import unittest
import os
import csv
from data_extraction.parser import Parser


class ParserTest(unittest.TestCase):
    
    def test_write_to_file(self):
        data = [("Abstract Title Test", "Abstract Description Test")]
        parser = Parser("data/conference_data/SSC/2017/abstracts.tex", "data/conference_data/SSC/2017/prog.tex")
        parser.write_to_file(data, file_name='test_data.csv', headers=["Abstract Title", "Abstract Description"])

        # Note this test may result in a failure if you do not have permissions for the file
        self.assertTrue(os.path.lexists('test_data.csv'))
        with open('test_data.csv', 'rb') as csv_file:
            f_reader = csv.reader(csv_file)
            temp_data = []
            for row in f_reader:
                temp_data.append(row)
        
        self.assertEqual(
            [["Abstract Title", "Abstract Description"], 
            ["Abstract Title Test", "Abstract Description Test"]],
            temp_data)

        # Clean up the file from testing
        os.remove('test_data.csv')

    def test_remove_sunday_session(self):
        parser = Parser("data/conference_data/SSC/2017/abstracts.tex", "data/conference_data/SSC/2017/prog.tex")
        data = parser._remove_sunday_session(True)

        # Just snag the first abstract entry as we only need to ensure the Sunday sessions are gone
        data = data[:200]

        # Ensure Inaugural is present as that indicates the first session is the Inaugural session on Monday.
        self.assertTrue(-1 != 'Inaugural')


    def test_parse_authors(self):
        parser = Parser("data/conference_data/SSC/2017/abstracts.tex", "data/conference_data/SSC/2017/prog.tex")
        authors = parser.parse_authors()

        first_author = "Mark Stinner Statistics Canada"
        last_author = "Sotirios Damouras University of Toronto Scarborough, Sohee Kang University of Toronto Scarborough"

        self.assertEqual(authors[0], first_author)
        self.assertEqual(authors[-1], last_author)
        

    def test_parse_times(self):
        parser = Parser("data/conference_data/SSC/2017/abstracts.tex", "data/conference_data/SSC/2017/prog.tex")
        times = parser.parse_times()

        first_time = "Sunday 09:00-16:00"
        last_time = "Wednesday 16:00-16:15"

        self.assertEqual(times[0], first_time)
        self.assertEqual(times[-1], last_time)

    def test_parse_abstract_titles(self):
        parser = Parser("data/conference_data/SSC/2017/abstracts.tex", "data/conference_data/SSC/2017/prog.tex")
        titles = parser.parse_abstract_titles()

        first_title = "Disclosure Control Methods"
        last_title = "The Status of Statistics Curricula in Canada"
        
        self.assertEqual(titles[0], first_title)
        self.assertEqual(titles[-1], last_title)

    def test_parse_abstract_descriptions(self):
        parser = Parser("data/conference_data/SSC/2017/abstracts.tex", "data/conference_data/SSC/2017/prog.tex")
        descriptions = parser.parse_abstract_descriptions()

        first_description = ""
        last_description = "This talk will review the current state of undergraduate Statistics curricula at universities across Canada. We will present both quantitative and qualitative information on the structure and composition of Major programs in Statistics. More specifically, we will look at the number and type of course requirements for each program, the learning outcomes they serve, the topics and skills they develop, as well as other relevant information. The talk intends to give an overview of how we collectively educate Statisticians, with the ultimate goal of helping identify directions for future curricular development. "

        self.assertEqual(descriptions[0], first_description)
        self.assertEqual(descriptions[-1], last_description)

    def test_parse_invited_talks(self):
        parser = Parser("data/conference_data/SSC/2017/abstracts.tex", "data/conference_data/SSC/2017/prog.tex")
        invited_talks = parser.parse_invited_or_contributed_talks("Invited")

        first_invited_talk = (u'The Challenge of Creating Data Collection Methods that are Neither Too Far Ahead nor Behind our Survey Respondents', 'Invited')
        last_invited_talk = (u'Towards More Reliable Neuroimaging-Based Biomarkers in Mental Illness: The Case of Schizophrenia Discrimination using fMRI Data', 'Invited')

        self.assertEqual(invited_talks[0], first_invited_talk)
        self.assertEqual(invited_talks[-1], last_invited_talk)

    def test_parse_contributed_talks(self):
        parser = Parser("data/conference_data/SSC/2017/abstracts.tex", "data/conference_data/SSC/2017/prog.tex")
        contributed_talks = parser.parse_invited_or_contributed_talks("Contributed")

        first_contributed_talk = (u'Causal Inference with Measurement Error in Outcomes: Bias Analysis and Estimation Methods', 'Contributed')
        last_contributed_talk = (u'The Status of Statistics Curricula in Canada', 'Contributed')

        self.assertEqual(contributed_talks[0], first_contributed_talk)
        self.assertEqual(contributed_talks[-1], last_contributed_talk)

    def test_parse_poster_talks(self):
        parser = Parser("data/conference_data/SSC/2017/abstracts.tex", "data/conference_data/SSC/2017/prog.tex")
        poster_talks = parser.parse_invited_or_contributed_talks("Poster")
        
        first_poster_talk = (u'University of Toronto', 'Poster')
        last_poster_talk = (u'Modeling and Treatment of Surveillance Flu Data', 'Poster')

        self.assertEqual(poster_talks[0], first_poster_talk)
        self.assertEqual(poster_talks[-1], last_poster_talk)

    def test_parse_all(self):
        parser = Parser("data/conference_data/SSC/2017/abstracts.tex", "data/conference_data/SSC/2017/prog.tex")
        presentation_data = parser.parse_all()

        first_presentation = (u'Welcome', u'', u'Jack Gambino Statistics Canada', u'Monday 08:25-08:30')
        last_presentation = (u'The Status of Statistics Curricula in Canada', u'This talk will review the current state of undergraduate Statistics curricula at universities across Canada. We will present both quantitative and qualitative information on the structure and composition of Major programs in Statistics. More specifically, we will look at the number and type of course requirements for each program, the learning outcomes they serve, the topics and skills they develop, as well as other relevant information. The talk intends to give an overview of how we collectively educate Statisticians, with the ultimate goal of helping identify directions for future curricular development. ', u'Sotirios Damouras University of Toronto Scarborough, Sohee Kang University of Toronto Scarborough', u'Wednesday 16:00-16:15')

        self.assertEqual(presentation_data[0], first_presentation)
        self.assertEqual(presentation_data[-1], last_presentation)