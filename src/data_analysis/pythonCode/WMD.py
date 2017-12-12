from TextProcessing import text_pre_processing
import numpy as np
from gensim.similarities import WmdSimilarity
import sys, getopt, os


def WMD(rawCSVFile, columnNumberForText, modelPath):
    # clean text and create cleaned text corpus file
    abstracts, corpusFile = text_pre_processing(rawCSVFile, columnNumberForText)
    print "documents preprocessed ..."

    instance = WmdSimilarity.load(fname = modelPath)
    print "similarity model loaded..."

    shape = (len(abstracts), len(abstracts))
    similarityMatrix = np.zeros(shape, dtype= float)

    for i in range(len(abstracts)):
        similarityMatrix[i] = instance[abstracts[i]]
    print "Similarity calculations have been finished ..."

    # writing the similarity matrix to a csv file
    modelPathBase = os.path.basename(modelPath)
    modelName = os.path.splitext(modelPathBase)[0]
    simMatOutputFile = "../../../data/similarityMatrices/" + modelName + "_simMatrix.csv"
    with open(simMatOutputFile, 'w+') as file_vector:
        for i in range(0, len(similarityMatrix)):
            for j in range(0, len(similarityMatrix[i])):
                if j == len(similarityMatrix[i]) - 1:
                    file_vector.write(str(similarityMatrix[i][j]) + '\n')
                else:
                    file_vector.write(str(similarityMatrix[i][j]) + ',')
    print "Similarity matrix written to ", simMatOutputFile, " ..."
    return similarityMatrix

def test():
    rawFile = "../../../data/conference.csv"
    columnNumberForText = 2
    WMD_sim_modelPath = "../languageModels/WMD_model_withGoogleNews_W2V.bin"

    return WMD(rawFile, columnNumberForText, WMD_sim_modelPath)
    # or use this command to test-run it: WMD.py -i "../../../data/conference.csv" -c 2 -m "../languageModels/WMD_model_withGoogleNews_W2V.bin"


def main(argv):
    inputCSVFile = ''
    colNum = 2
    modelPath = ''
    try:
        opts, args = getopt.getopt(argv,"hi:c:m:",["inputFile=", "colNum", "model"])
    except getopt.GetoptError:
        print 'WMD.py -i <inputCSVFile> -c <columnNumberForTextContainedInCSV> -m <WMD_ModelPath>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'WMD.py -i <inputCSVFile> -c <columnNumberForTextContainedInCSV> -m <WMD_ModelPath>'
            sys.exit()
        elif opt in ("-i", "--inputFile"):
            inputCSVFile = arg
        elif opt in ("-c", "--colNum"):
            colNum = int(arg)
        elif opt in ("-m", "--model"):
            modelPath = arg

    print 'input CSV File is ', inputCSVFile
    print 'column number of the text contained in the .csv file: ', colNum
    print 'WMD model file path is ', modelPath
    WMD(rawCSVFile=inputCSVFile, columnNumberForText=colNum, modelPath=modelPath)

if __name__ == "__main__":
   main(sys.argv[1:])