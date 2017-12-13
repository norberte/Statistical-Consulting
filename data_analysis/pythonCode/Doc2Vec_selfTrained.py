import sys, getopt, os
import numpy as np
from gensim import models
from TextProcessing import text_pre_processing
import smart_open
default_size = 300
default_minWordFreq = 2

def trainDoc2Vec(train_corpus, dim, min):
    model = models.doc2vec.Doc2Vec(size= dim, min_count=min, window = 10, negative=5, hs=0, workers=4)
    model.build_vocab(train_corpus)
    modelSavingPath = "../languageModels/Doc2Vec_Dim" + str(dim) + "_selfTrained.bin"
    model.save(modelSavingPath)
    return modelSavingPath

def read_corpus(fname):
    with smart_open.smart_open(fname, encoding="utf-8") as f:
        for i, line in enumerate(f):
            yield models.doc2vec.TaggedDocument(line, [i])

def Doc2Vec(rawCSVFile, columnNumberForText, dim = default_size, iter = default_minWordFreq):
    # clean text and create cleaned text corpus file
    abstracts, corpusPath = text_pre_processing(rawCSVFile, columnNumberForText)
    print "documents preprocessed ..."

    trainingAbstracts = read_corpus(corpusPath)
    modelPath = trainDoc2Vec(trainingAbstracts, dim = dim, min = iter)
    print "Doc2Vec model trained ..."

    model = models.Doc2Vec.load(modelPath)
    print "Doc2Vec model loaded in ..."

    shape = (len(abstracts), len(abstracts))
    similarityMatrix = np.zeros(shape, dtype=float)

    for i in range(len(abstracts)):
        for j in range(len(abstracts)):
            similarityMatrix[i][j] = model.docvecs.similarity(i,j)
    print "Similarity calculations have been finished ..."

    # writing the similarity matrix to a csv file
    modelPathBase = os.path.basename(modelPath)
    modelName = os.path.splitext(modelPathBase)[0]
    simMatOutputFile = "../../data/similarityMatrices/" + modelName + "_simMatrix.csv"

    with open(simMatOutputFile, 'w+') as file_vector:
        for i in range(0, len(similarityMatrix)):
            for j in range(0, len(similarityMatrix[i])):
                if j == len(similarityMatrix[i]) - 1:
                    file_vector.write(str(similarityMatrix[i][j]) + '\n')
                else:
                    file_vector.write(str(similarityMatrix[i][j]) + ',')
    print "Similarity matrix written to ",simMatOutputFile, " ..."
    return similarityMatrix

def test():
    rawFile = "../../data/conference.csv"
    colNum = 2
    return Doc2Vec(rawCSVFile = rawFile, columnNumberForText=colNum)
    # or use this command to test-run it: Doc2Vec_selfTrained.py -i "../../data/conference.csv" -c 2

def main(argv):
    inputCSVFile = ''
    colNum = 2

    try:
        opts, args = getopt.getopt(argv,"hi:c:",["inputFile=", "colNum"])
    except getopt.GetoptError:
        print 'Doc2Vec_selfTrained.py -i <inputCSVFile> -c <columnNumberForTextContainedInCSV>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'Doc2Vec_selfTrained.py -i <inputCSVFile> -c <columnNumberForTextContainedInCSV>'
            sys.exit()
        elif opt in ("-i", "--inputFile"):
            inputCSVFile = arg
        elif opt in ("-c", "--colNum"):
            colNum = int(arg)

    print 'input CSV File is ', inputCSVFile
    print 'column number of the text contained in the .csv file: ', colNum
    Doc2Vec(rawCSVFile=inputCSVFile, columnNumberForText=colNum)

if __name__ == "__main__":
   main(sys.argv[1:])