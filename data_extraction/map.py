"""
map.py

Perform a mapping for an abstract title with the associated flag ("An Tree-Based Approach ..." => "Invited").
Assumes there exists a prog.tex file which outlines the flag of an abstract
(i.e, Invited, Contributed, Poster) and an abstracts.tex file which lists the abstract titles and any additional information.

A typical useage of this call is the following:

program_data = [("Some Abstract Title", "Invited")]
map = Map(program_data)
abstract_data = [("Some Abstract Title", "Some Abstract Description", "Some Other Information")]

map.map(abstract_data)
"""
class Map(object):
    """
    @param List<(string, string)> program_data the data extracted from the prog.tex file
    """
    def __init__(self, program_data):
        self.prog = program_data

    def map(self, abstracts=None):
        """
        """
        assert abstracts is not None
        assert self.prog is not None
        
        abstract_titles = [x[0] for x in self.prog]
        abstracts.sort(key=lambda x: x[0])
        self.prog.sort(key=lambda x: x[0])
        

        # Since there are some abstracts present within one file and not the other, ignore any abstracts which exist within
        # data/conference_data/SSC/2017/abstracts.tex but not within data/conference_data/SSC/2017/prog.tex as they cannot
        # be mapped.
        for elem in abstracts:
            if elem[0] not in abstract_titles:
                abstracts.remove(elem)

        # This converts each tuple entry within the list variable abstracts to a list, inserts the flag (elem) at the end of it, and
        # converts it back to a tuple as tuple are immutable. Perhaps not the most efficient way, but performed this way in order
        # to get it done.
        for i, elem in enumerate(self.prog):
            # Convert tuple element to list
            abstracts[i] = list(abstracts[i])
            # Append flag to the back of the list element
            abstracts[i].insert(len(abstracts[i]), elem[1])
            # Convert back to tuple
            abstracts[i] = tuple(abstracts[i])

        return abstracts
