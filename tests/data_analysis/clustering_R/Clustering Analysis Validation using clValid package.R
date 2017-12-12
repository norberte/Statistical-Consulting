#import data
library(readr)
library(mclust)
library(clValid)

# ANALYSIS 1 Validation (InferSent with GloVe Model) ------------------------------------------------

# n by n document similarity matrix
docSim <- as.matrix(read_csv("data/similarityMatrices/InferSent_GloveModel_simMatrix.csv", col_names = FALSE))
# n by n document dissimilarity matrix
dissimilarityMat = 1 - docSim

#cluster validation using the clValid package
clustValid <- clValid(dissimilarityMat, 5:15, clMethods = c("hierarchical", "kmeans", "model", "diana","agnes", "pam"), 
                      validation = "stability", method = "complete", verbose = TRUE)

# ANALYSIS 1 Validation Results ----------
summary(clustValid)

#  Compare actual mixture model clustering results against average cross validation results
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("Actual clustering results: model-based optimal number of clusters:", m.best, "\n")   #  13 clusters









# ANALYSIS 2 Validation (Doc2Vec self-trained 300 dimensional model)------------------------------------------------

# n by n document similarity matrix
docSim <- as.matrix(read_csv("data/similarityMatrices/Doc2Vec_Dim300_selfTrained_simMatrix.csv", col_names = FALSE))
# n by n document dissimilarity matrix
dissimilarityMat = 1 - docSim

#cluster validation using the clValid package

clustValid <- clValid(dissimilarityMat, 5:15, clMethods = c("hierarchical", "kmeans", "model", "diana","agnes", "pam"), 
                      validation = "stability", method = "complete", verbose = TRUE)

# ANALYSIS 2 Validation Results ----------
summary(clustValid)

#  Compare actual mixture model clustering results against average cross validation results
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("Actual clustering results: model-based optimal number of clusters:", m.best, "\n")   #  13 clusters




# ANALYSIS 3 Validation (Doc2Vec pre-trained apNews model) ------------------------------------------------

# n by n document similarity matrix
docSim <- as.matrix(read_csv("data/similarityMatrices/apnews_doc2vec_simMatrix.csv", col_names = FALSE))
# n by n document dissimilarity matrix
dissimilarityMat = 1 - docSim

#cluster validation using the clValid package
clustValid <- clValid(dissimilarityMat, 5:15, clMethods = c("hierarchical", "kmeans", "model", "diana","agnes", "pam"), 
                      validation = "stability", method = "complete", verbose = TRUE)

# ANALYSIS 3 Validation Results ----------
summary(clustValid)

#  Compare actual mixture model clustering results against average cross validation results
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("Actual clustering results: model-based optimal number of clusters:", m.best, "\n")   #  13 clusters




# ANALYSIS 4 Validation (Doc2Vec pre-trained wikiModel) ------------------------------------------------

# n by n document similarity matrix
docSim <- as.matrix(read_csv("data/similarityMatrices/enwiki_doc2vec_simMatrix.csv", col_names = FALSE))
# n by n document dissimilarity matrix
dissimilarityMat = 1 - docSim

#cluster validation using the clValid package
clustValid <- clValid(dissimilarityMat, 5:15, clMethods = c("hierarchical", "kmeans", "model", "diana","agnes", "pam"), 
                      validation = "stability", method = "complete", verbose = TRUE)

# ANALYSIS 4 Validation Results ----------
summary(clustValid)

#  Compare actual mixture model clustering results against average cross validation results
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("Actual clustering results: model-based optimal number of clusters:", m.best, "\n")   #  13 clusters




# ANALYSIS 5 Validation (Word's Mover Distance Model with googleNews pre-trained word2vec inner model) ------------------------------------------------

# n by n document similarity matrix
docSim <- as.matrix(read_csv("data/similarityMatrices/WMD_cleanAbstracts_simMatrix.csv", col_names = FALSE))
# n by n document dissimilarity matrix
dissimilarityMat = 1 - docSim

#cluster validation using the clValid package
clustValid <- clValid(dissimilarityMat, 5:15, clMethods = c("hierarchical", "kmeans", "model", "diana","agnes", "pam"), 
                      validation = "stability", method = "complete", verbose = TRUE)

# ANALYSIS 5 Validation Results ----------
summary(clustValid)

#  Compare actual mixture model clustering results against average cross validation results
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("Actual clustering results: model-based optimal number of clusters:", m.best, "\n")   #  13 clusters



# ANALYSIS 6 Validation (Document Similarity using 48 topics with LSI model) ------------------------------------------------

# n by n document similarity matrix
docSim <- as.matrix(read_csv("data/similarityMatrices/docSim_cleanAbstracts_lsi_t48_simMatrix.csv", col_names = FALSE))
# n by n document dissimilarity matrix
dissimilarityMat = 1 - docSim

#cluster validation using the clValid package
clustValid <- clValid(dissimilarityMat, 5:15, clMethods = c("hierarchical", "kmeans", "model", "diana","agnes", "pam"), 
                      validation = "stability", method = "complete", verbose = TRUE)

# ANALYSIS 6 Validation Results ----------
summary(clustValid)

#  Compare actual mixture model clustering results against average cross validation results
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("Actual clustering results: model-based optimal number of clusters:", m.best, "\n")   #  13 clusters
