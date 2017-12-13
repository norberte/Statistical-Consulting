import numpy as np
from gensim import corpora, models, similarities
from TextProcessing import text_pre_processing
import sys, getopt, os

def createDictionary(data):
    dictionary = corpora.Dictionary(line.split() for line in data)
    once_ids = [tokenid for tokenid, docfreq in dictionary.dfs.iteritems() if docfreq == 1]
    dictionary.filter_tokens(once_ids)  # filter words that only appear once
    dictionary.filter_extremes(keep_n=100000)
    dictionary.compactify()
    return dictionary

def trainDocSim(rawCSVFile, columnNumberForText):
    MODELS_DIR = "../languageModels/"
    # clean text and create cleaned text corpus file
    abstracts, corpusFile = text_pre_processing(rawCSVFile, columnNumberForText)
    print "documents preprocessed ..."

    # create dictionary
    docsDictionary = createDictionary(abstracts)
    # save dictionary
    docsDictionary.save(os.path.join(MODELS_DIR, "cleanAbstracts.dict"))

    # convert tokenized documents into a document-term matrix
    docsCorpus = [docsDictionary.doc2bow(text.lower().split()) for text in abstracts]
    # serialize (and save) text corpus
    corpora.MmCorpus.serialize(os.path.join(MODELS_DIR, "cleanAbstracts.mm"), docsCorpus)

    # somewhere between 44-48, determined with ldatuning R library (need to run ldatuning script for every new dataset)
    topicNum = 48

    # LSI Topic Model
    lsi = models.LsiModel(corpus=docsCorpus, id2word=docsDictionary, num_topics=topicNum)
    lsi.save(os.path.join(MODELS_DIR, "cleanAbstracts.lsi"))  # save model

    # DocSim
    index = similarities.MatrixSimilarity(lsi[docsCorpus]) # transform corpus to LSI space and index it
    index.save(os.path.join(MODELS_DIR, 'cleanAbstract.index'))

    shape = (len(abstracts), len(abstracts))
    similarityMatrix = np.zeros(shape, dtype=float)

    for i in range(0, len(abstracts)):
        vec_bow = docsDictionary.doc2bow(abstracts[i].lower().split())
        vec_lsi = lsi[vec_bow]  # convert the query to LSI space
        sim = index[vec_lsi]  # perform a similarity query against the corpus
        for j in range(0, len(sim)):
            similarityMatrix[i][j] = sim[j]

    # writing the similarity matrix to a csv file
    modelName = "docSim_cleanAbstracts_lsi_t48"
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

def DocSim(rawCSVFile, columnNumberForText):
    MODELS_DIR = "../languageModels/"
    # clean text and create cleaned text corpus file
    abstracts, corpusFile = text_pre_processing(rawCSVFile, columnNumberForText)
    print "documents preprocessed ..."

    # load in pre-built dictionary
    docsDictionary = corpora.Dictionary.load(os.path.join(MODELS_DIR, "cleanAbstracts.dict"))

    # load in pre-built LSI model
    lsi = models.LsiModel.load(os.path.join(MODELS_DIR, "cleanAbstracts.lsi"))

    # load in DocSim model
    index = similarities.MatrixSimilarity.load(os.path.join(MODELS_DIR, 'cleanAbstract.index'))
    print "DocSim model loaded in ..."

    shape = (len(abstracts), len(abstracts))
    similarityMatrix = np.zeros(shape, dtype=float)

    for i in range(0, len(abstracts)):
        vec_bow = docsDictionary.doc2bow(abstracts[i].lower().split())
        vec_lsi = lsi[vec_bow]  # convert the query to LSI space
        sim = index[vec_lsi]  # perform a similarity query against the corpus
        for j in range(0, len(sim)):
            similarityMatrix[i][j] = sim[j]
    print "Similarity calculations have been finished ..."

    # writing the similarity matrix to a csv file
    modelName = "docSim_cleanAbstracts_lsi_t48"
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
    return DocSim(rawCSVFile = rawFile, columnNumberForText=colNum)
    # or use this command to test-run it: DocSim.py -i "../../data/conference.csv" -c 2

def main(argv):
    inputCSVFile = ''
    colNum = 2
    try:
        opts, args = getopt.getopt(argv,"hi:c:",["inputFile=", "colNum"])
    except getopt.GetoptError:
        print 'DocSim.py -i <inputCSVFile> -c <columnNumberForTextContainedInCSV>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'DocSim.py -i <inputCSVFile> -c <columnNumberForTextContainedInCSV>'
            sys.exit()
        elif opt in ("-i", "--inputFile"):
            inputCSVFile = arg
        elif opt in ("-c", "--colNum"):
            colNum = int(arg)

    print 'input CSV File is ', inputCSVFile
    print 'column number of the text contained in the .csv file: ', colNum
    DocSim(rawCSVFile=inputCSVFile, columnNumberForText=colNum)

if __name__ == "__main__":
    main(sys.argv[1:])