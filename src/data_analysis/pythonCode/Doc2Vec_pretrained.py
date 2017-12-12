import sys, getopt, os
import smart_open
import numpy as np
from gensim import models
from TextProcessing import text_pre_processing

def read_corpus(fname):
    with smart_open.smart_open(fname, encoding="utf-8") as f:
        for i, line in enumerate(f):
            yield models.doc2vec.TaggedDocument(line, [i])

def doc2vec_pretrained(rawCSVFile, columnNumberForText, modelPath):
    # clean text and create cleaned text corpus file
    abstracts, corpusFile = text_pre_processing(rawCSVFile, columnNumberForText)
    print "documents preprocessed ..."

    textCorpus = list(read_corpus(corpusFile))        # load in the clean text corpus
    model = models.doc2vec.DocvecsArray(modelPath)   # load in model as vector array
    model1 = models.Doc2Vec.load(modelPath)         # load in model as Doc2Vec model
    print "models have been loaded in ..."

    shape = (len(abstracts), len(abstracts))        # define the dimensions of the similarity matrix
    similarityMatrix = np.zeros(shape, dtype=float)     # initialize values inside the similarity matrix to 0

    for i in range(len(abstracts)):
        for j in range(len(abstracts)):
            similarityMatrix[i][j] = model.similarity_unseen_docs(model = model1,
                        doc_words1 = textCorpus[i].words.split(' '), doc_words2 = textCorpus[j].words.split(' '),
                        alpha=0.025, min_alpha=0.001 , steps=5)         # Doc2Vec model's similarity calculation
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
    print "Similarity matrix written to ",simMatOutputFile, " ..."
    return similarityMatrix

def test1():
    rawFile = "../../../data/conference.csv"
    colNum = 2
    modelSavingPath = "../languageModels/apnews_doc2vec.bin"

    return doc2vec_pretrained(rawCSVFile=rawFile, columnNumberForText=colNum, modelPath=modelSavingPath)
    # or use this command to test-run it: Doc2Vec_pretrained.py -i "../../../data/conference.csv" -c 2 -m "../languageModels/apnews_doc2vec.bin"

def test2():
    rawFile = "../../../data/conference.csv"
    colNum = 2
    modelSavingPath = "../languageModels/enwiki_doc2vec.bin"

    return doc2vec_pretrained(rawCSVFile=rawFile, columnNumberForText=colNum, modelPath=modelSavingPath)
    # or use this command to test-run it: Doc2Vec_pretrained.py -i "../../../data/conference.csv" -c 2 -m "../languageModels/enwiki_doc2vec.bin"
def main(argv):
    inputCSVFile = ''
    colNum = 2
    modelPath = ''
    try:
        opts, args = getopt.getopt(argv,"hi:c:m:",["inputFile=", "colNum", "model"])
    except getopt.GetoptError:
        print 'Doc2Vec_pretrained.py -i <inputCSVFile> -c <columnNumberForTextContainedInCSV> -m <modelPath>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'Doc2Vec_pretrained.py -i <inputCSVFile> -c <columnNumberForTextContainedInCSV> -m <modelPath>'
            sys.exit()
        elif opt in ("-i", "--inputFile"):
            inputCSVFile = arg
        elif opt in ("-c", "--colNum"):
            colNum = int(arg)
        elif opt in ("-m", "--model"):
            modelPath = arg

    print 'input CSV File is ', inputCSVFile
    print 'column number of the text contained in the .csv file: ', colNum
    print 'Doc2Vec pre-trained model .bin file Path is ', modelPath
    doc2vec_pretrained(rawCSVFile=inputCSVFile, columnNumberForText=colNum, modelPath=modelPath)

if __name__ == "__main__":
   main(sys.argv[1:])