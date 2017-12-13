import unittest
from data_extraction.map import Map

class MapTest(unittest.TestCase):
    def test_map(self):
        abstracts = [
            ("Test Abstract1", "BlahBlahBlah", "Ronald McDonald", "Monday 10:00-11:00"),
            ("Test Abstract2", "BlahBlahBlah", "McDonald Ronald", "Monday 11:00-12:00"),
            ("Test Abstract3", "BlahBlahBlah", "McDonald Ronald", "Monday 11:00-12:00")
        ]
        prog = [
            ("Test Abstract1", "Invited"),
            ("Test Abstract2", "Contributed")
        ]

        mapping = Map(prog)
        
        result = mapping.map(abstracts)
        self.assertEquals(abstracts[0], ("Test Abstract1", "BlahBlahBlah", "Ronald McDonald", "Monday 10:00-11:00", "Invited"))
        self.assertEquals(abstracts[1], ("Test Abstract2", "BlahBlahBlah", "McDonald Ronald", "Monday 11:00-12:00", "Contributed"))
        self.assertTrue(len(abstracts), 2)
        