# import stuff
import csv
import numpy as np
import torch
import sys

reload(sys)  # Reload does the trick!
sys.setdefaultencoding('UTF8')

GLOVE_PATH = 'dataset/glove.840B.300d.txt'
model = torch.load('encoder/infersent.allnli.pickle', map_location=lambda storage, loc: storage)
torch.set_num_threads(4)
model.set_glove_path(GLOVE_PATH)
model.build_vocab_k_words(K=1000000)

# Load some sentences
def import_data(fileName, colNum):
    csvFile = open(fileName, 'r')
    reader = csv.reader(csvFile, delimiter=',', quotechar='"')
    my_list = list(reader)
    doc_set = []
    counter = 0
    for item in my_list:
        if counter == 0:
            counter += 1
            continue
        else:
            text = str(item[colNum])
            doc_set.append(text)  ### second column of the data set
    return doc_set

# import data-set
rawFile = "dataset/conference.csv"
documents = import_data(rawFile, 1)

sentences = []
for abstract in documents:
    sentences.append(abstract.strip('\n').strip())

embeddings = model.encode(sentences, bsize=128, tokenize=True, verbose=True)
print 'nb sentences encoded : {0}'.format(len(embeddings))


def cosine(u, v):
    return np.dot(u, v) / (np.linalg.norm(u) * np.linalg.norm(v))

shape = (len(documents), len(documents))
similarityMatrix = np.zeros(shape, dtype= float)

for i in range(0, len(documents)):
    for j in range(0, len(documents)):
        similarityMatrix[i][j] = cosine(embeddings[i], embeddings[j])
print "similarity calculated"

outputFile = 'dataset/InferSent_results.csv'
with open(outputFile, 'w+') as file_vector:
    for i in range(0, len(similarityMatrix)):
        for j in range(0, len(similarityMatrix[i])):
            if j == len(similarityMatrix[i]) - 1:
                file_vector.write(str(similarityMatrix[i][j]) + '\n')
            else:
                file_vector.write(str(similarityMatrix[i][j]) + ',')
