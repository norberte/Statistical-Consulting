import csv
import unittest
import Doc2Vec_pretrained
import Doc2Vec_selfTrained
import DocSim
import TextProcessing as textProcessing
import WMD

def importTextFromCSV(fileName, colNum, header=True):
    csvFile = open(fileName, 'r')  # open csv file
    reader = csv.reader(csvFile, delimiter=',', quotechar='"')  # read csv file
    my_list = list(reader)  # create a list from the content of the file
    if header is True:  # check if file has header (by default it has not)
        my_list = my_list[1:]  # remove the first row, if the file has header
    doc_set = []  # prepare list for the desired column to be returned
    for item in my_list:
        text = str(item[colNum])  # stringify item in the column to avoid issues with rounding
        doc_set.append(text)  # add column element into document set
    return doc_set


class Tests(unittest.TestCase):
    def setUp(self):
        pass

    def testDocSim(self):
        abstracts = importTextFromCSV("../../data/conference.csv", 1)
        simMatrix = DocSim.test()
        self.assertEqual(len(abstracts), len(simMatrix))
    # check to see if there are as many rows (documents) in the similarity matrix, as in the original abstracts CSV file

    def testDoc2Vec_Wiki(self):
        abstracts = importTextFromCSV("../../data/conference.csv", 1)
        simMatrix = Doc2Vec_pretrained.test2()
        self.assertEqual(len(abstracts), len(simMatrix))
    # check to see if there are as many rows (documents) in the similarity matrix, as in the original abstracts CSV file

    def testDoc2Vec_ApNews(self):
        abstracts = importTextFromCSV("../../data/conference.csv", 1)
        simMatrix = Doc2Vec_pretrained.test1()
        self.assertEqual(len(abstracts), len(simMatrix))
    # check to see if there are as many rows (documents) in the similarity matrix, as in the original abstracts CSV file

    def testDoc2Vec_selfTrained(self):
        abstracts = importTextFromCSV("../../data/conference.csv", 1)
        simMatrix = Doc2Vec_selfTrained.test()
        self.assertEqual(len(abstracts), len(simMatrix))
    # check to see if there are as many rows (documents) in the similarity matrix, as in the original abstracts CSV file

    def testTextProcessing(self):
        abstracts = importTextFromCSV("../../data/conference.csv", 1)
        cleanAbstracts = textProcessing.test()
        self.assertEqual(len(abstracts), len(cleanAbstracts))
    # check to see if there are as many rows (documents) in the cleaned up text, as in the original abstracts CSV file

    def testWMD(self):
        abstracts = importTextFromCSV("../../data/conference.csv", 1)
        simMatrix = WMD.test()
        self.assertEqual(len(abstracts), len(simMatrix))
    # check to see if there are as many rows (documents) in the similarity matrix, as in the original abstracts CSV file

if __name__ == '__main__':
    unittest.main()