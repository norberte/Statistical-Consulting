from gensim import models
from gensim.models import KeyedVectors

# Doc2Vec pre-trained Wikipedia model
modelSavingPath = "../../../src/data_analysis/languageModels/enwiki_doc2vec.bin"
model = models.Doc2Vec.load(modelSavingPath)
print "Model evaluations for Doc2Vec wiki"
print model.evaluate_word_pairs("../benchmarkDatasets/wordsim353.tsv")
print model.evaluate_word_pairs("../benchmarkDatasets/simlex999.txt")
model.accuracy("../benchmarkDatasets/questions-words.txt")
print ""

# Doc2Vec pre-trained AP News model
modelSavingPath = "../../../src/data_analysis/languageModels/apnews_doc2vec.bin"
model = models.Doc2Vec.load(modelSavingPath)
print "Model evaluations for Doc2Vec apnews"
print model.evaluate_word_pairs("../benchmarkDatasets/wordsim353.tsv")
print model.evaluate_word_pairs("../benchmarkDatasets/simlex999.txt")
model.accuracy("../benchmarkDatasets/questions-words.txt")
print ""

# WMD with GoogleNews pre-trained Word2Vec Model
model = KeyedVectors.load_word2vec_format('../../../src/data_analysis/languageModels/GoogleNews-vectors-negative300.bin', binary=True)
print "Model evaluations for Word2Vec GoogleNews inside the  WMD"
print model.evaluate_word_pairs("../benchmarkDatasets/wordsim353.tsv")
print model.evaluate_word_pairs("../benchmarkDatasets/simlex999.txt")
model.accuracy("../benchmarkDatasets/questions-words.txt")
print ""
