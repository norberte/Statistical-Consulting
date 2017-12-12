from gensim import models
from stopwords import get_stopwords
import re, nltk, csv
import sys, getopt, os

def importColumnFromCSV(fileName, colNum, header=False):
    csvFile = open(fileName, 'r')   #open csv file
    reader = csv.reader(csvFile, delimiter=',', quotechar='"')      #read csv file
    my_list = list(reader)          # create a list from the content of the file
    if header is True:              # check if file has header (by default it has not)
        my_list = my_list[1:]       # remove the first row, if the file has header
    doc_set = []                    # prepare list for the desired column to be returned
    for item in my_list:
        text = str(item[colNum])    # stringify item in the column to avoid issues with rounding
        doc_set.append(text)        # add column element into document set
    return doc_set

def remove_non_ascii(text):
    return unicode(text, errors='replace')          #replaces non-ascii characters with their unicode representation

def text_pre_processing(csvFile, columnNumberForText):
    # import data-set
    # colNum becomes an index, which should start at 0, and columns in spreadsheets start at 1, so subtract 1 from columnNumberForText
    documents = importColumnFromCSV(fileName=csvFile, colNum=int(columnNumberForText) - 1, header=True)
    print "imported documents..."

    # phrase detection model training
    abstracts = []  # list of abstracts containing a list of words
    for line in documents:
        # tokenize abstract
        tokens = nltk.word_tokenize(remove_non_ascii(line))
        abstracts.append(tokens)

    # create bigram and trigram phrase models
    bigram = models.Phrases(abstracts)
    trigram = models.Phrases(bigram[abstracts])
    print "built bigram and trigram phrase detection models..."

    # text pre-processing tools
    stops = get_stopwords('en')  # stronger stopwords
    STOPS = list(' '.join(str(e).title() for e in stops).split()) # uppercase stopwords
    noNum = re.compile(r'[^a-zA-Z ]')  # number and punctuation remover

    # function that cleans the text
    def clean(text):
        clean_text = noNum.sub(' ', text)               # remove numbers and punctuations
        tokens = nltk.word_tokenize(clean_text)         # tokenize text
        filtered_words = [w for w in tokens if not w in stops]      # filter out lowercase stopwords
        double_filtered_words = [w for w in filtered_words if not w in STOPS]    # filter out uppercase stopwords

        trigrams = trigram[bigram[double_filtered_words]]   # apply the bigram and trigram models to the filtered words
        trigrams_str = ' '.join(str(x) for x in trigrams)   # stringify clean and filtered tokens
        return trigrams_str

    results = []  # create list for storing clean abstracts

    # figure out path for the text corpus
    rawFilePathBase = os.path.basename(csvFile)
    rawFileName = os.path.splitext(rawFilePathBase)[0]
    corpusPath = "../../../data/" + rawFileName + "_textCorpus.txt"

    # write list of clean text documents to text corpus file
    with open(corpusPath, 'w') as f:
        print 'Cleaned up text corpus file has been created at ', corpusPath, ' ...'
        f.truncate()        # if file is not empty, remove everything inside the file
        for abstract in documents:
            text = clean(abstract)      # clean each abstract, one at a time
            f.write(text + '\n')        # write clean abstract to desired text corpus file
            results.append(text)        # append clean abstracts to list
    return results, corpusPath          # return a list of clean abstracts

def test():
    rawFile = "../../../data/conference.csv"
    colNum = 2
    abstracts, corpusPath = text_pre_processing(csvFile=rawFile, columnNumberForText= colNum)
    return abstracts


def main(argv):
    inputCSVFile = ''
    colNum = 1
    try:
        opts, args = getopt.getopt(argv,"hi:c:",["inputFile=", "colNum"])
    except getopt.GetoptError:
        print 'TextProcessing.py -i <inputCSVFile> -c <columnNumberForTextContainedInCSV>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'TextProcessing.py -i <inputCSVFile> -c <columnNumberForTextContainedInCSV>'
            sys.exit()
        elif opt in ("-i", "--inputFile"):
            inputCSVFile = arg
        elif opt in ("-c", "--colNum"):
            colNum = int(arg)
    print 'input CSV File is ', inputCSVFile
    print 'column number of the text contained in the .csv file: ', colNum
    text_pre_processing(inputCSVFile, colNum)

if __name__ == "__main__":
   main(sys.argv[1:])
