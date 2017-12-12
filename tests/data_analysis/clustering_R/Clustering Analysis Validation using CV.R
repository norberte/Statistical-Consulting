#import data
library(readr)
library(mclust)

# ANALYSIS 1 Validation (InferSent with GloVe Model) ------------------------------------------------

# n by n document similarity matrix
docSim <- as.matrix(read_csv("data/similarityMatrices/InferSent_GloveModel_simMatrix.csv", col_names = FALSE))
# n by n document dissimilarity matrix
dissimilarityMat = 1 - docSim

# Cross validation 
# Step 1: Randomly shuffle the data
set.seed(2017)
shuffle <- sample(nrow(dissimilarityMat))
cvData <- dissimilarityMat[shuffle,shuffle]

# Step 2: Create 10 equally size folds
folds <- cut(seq(1,nrow(cvData)),breaks=10,labels=FALSE)

# Step 3: set up array to store results
someData <- rep(0, 10)
results <- array(someData, 10)

# Step 4: Perform 10 fold cross validation
for(i in 1:10){
  #Segment your data by fold using the which() function 
  testIndexes <- which(folds==i,arr.ind=TRUE)
  cvDissMatr <- cvData[-testIndexes, -testIndexes]
      
  d_clust <- Mclust(as.matrix(cvDissMatr), G=2:30)
  m.best <- dim(d_clust$z)[2]
  cat("Fold ", i , ": model-based optimal number of clusters:", m.best, "\n")
    
  results[i] <- m.best
}

# Step 5: Compare actual mixture model clustering results against average cross validation results
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("Actual clustering results: model-based optimal number of clusters:", m.best, "\n")   #  13 clusters
cat("Average cluster validation results:", mean(results), "\n")     # 11.5 clusters


# ANALYSIS 1 Results ----------
# Actual clustering results: model-based optimal number of clusters: 13
# Average cluster validation results: 11.5


# ANALYSIS 2 Validation (Doc2Vec self-trained 300 dimensional model)------------------------------------------------

# n by n document similarity matrix
docSim <- as.matrix(read_csv("data/similarityMatrices/Doc2Vec_Dim300_selfTrained_simMatrix.csv", col_names = FALSE))
# n by n document dissimilarity matrix
dissimilarityMat = 1 - docSim

# Cross validation 
# Step 1: Randomly shuffle the data
set.seed(2017)
shuffle <- sample(nrow(dissimilarityMat))
cvData <- dissimilarityMat[shuffle,shuffle]

# Step 2: Create 10 equally size folds
folds <- cut(seq(1,nrow(cvData)),breaks=10,labels=FALSE)

# Step 3: set up array to store results
someData <- rep(0, 10)
results <- array(someData, 10)

# Step 4: Perform 10 fold cross validation
for(i in 1:10){
  #Segment your data by fold using the which() function 
  testIndexes <- which(folds==i,arr.ind=TRUE)
  cvDissMatr <- cvData[-testIndexes, -testIndexes]
  
  d_clust <- Mclust(as.matrix(cvDissMatr), G=2:30)
  m.best <- dim(d_clust$z)[2]
  cat("Fold ", i , ": model-based optimal number of clusters:", m.best, "\n")
  
  results[i] <- m.best
}

# Step 5: Compare actual mixture model clustering results against average cross validation results
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("Actual clustering results: model-based optimal number of clusters:", m.best, "\n") # 12 clusters
cat("Average cluster validation results:", mean(results), "\n") # 10.8 clusters

# ANALYSIS 2 Results ----------
# Actual clustering results: model-based optimal number of clusters: 12
# Average cluster validation results: 10.8 


# ANALYSIS 3 Validation (Doc2Vec pre-trained apNews model) ------------------------------------------------

# n by n document similarity matrix
docSim <- as.matrix(read_csv("data/similarityMatrices/apnews_doc2vec_simMatrix.csv", col_names = FALSE))
# n by n document dissimilarity matrix
dissimilarityMat = 1 - docSim

# Cross validation 
# Step 1: Randomly shuffle the data
set.seed(2017)
shuffle <- sample(nrow(dissimilarityMat))
cvData <- dissimilarityMat[shuffle,shuffle]

# Step 2: Create 10 equally size folds
folds <- cut(seq(1,nrow(cvData)),breaks=10,labels=FALSE)

# Step 3: set up array to store results
someData <- rep(0, 10)
results <- array(someData, 10)

# Step 4: Perform 10 fold cross validation
for(i in 1:10){
  #Segment your data by fold using the which() function 
  testIndexes <- which(folds==i,arr.ind=TRUE)
  cvDissMatr <- cvData[-testIndexes, -testIndexes]
  
  d_clust <- Mclust(as.matrix(cvDissMatr), G=2:30)
  m.best <- dim(d_clust$z)[2]
  cat("Fold ", i , ": model-based optimal number of clusters:", m.best, "\n")
  
  results[i] <- m.best
}

# Step 5: Compare actual mixture model clustering results against average cross validation results
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("Actual clustering results: model-based optimal number of clusters:", m.best, "\n")   # 7 clusters
cat("Average cluster validation results:", mean(results), "\n")   # 7.3 clusters


# ANALYSIS 3 Results ----------
# Actual clustering results: model-based optimal number of clusters: 7
# Average cluster validation results: 7.3


# ANALYSIS 4 Validation (Doc2Vec pre-trained wikiModel) ------------------------------------------------

# n by n document similarity matrix
docSim <- as.matrix(read_csv("data/similarityMatrices/enwiki_doc2vec_simMatrix.csv", col_names = FALSE))
# n by n document dissimilarity matrix
dissimilarityMat = 1 - docSim

# Cross validation 
# Step 1: Randomly shuffle the data
set.seed(2017)
shuffle <- sample(nrow(dissimilarityMat))
cvData <- dissimilarityMat[shuffle,shuffle]

# Step 2: Create 10 equally size folds
folds <- cut(seq(1,nrow(cvData)),breaks=10,labels=FALSE)

# Step 3: set up array to store results
someData <- rep(0, 10)
results <- array(someData, 10)

# Step 4: Perform 10 fold cross validation
for(i in 1:10){
  #Segment your data by fold using the which() function 
  testIndexes <- which(folds==i,arr.ind=TRUE)
  cvDissMatr <- cvData[-testIndexes, -testIndexes]
  
  d_clust <- Mclust(as.matrix(cvDissMatr), G=2:30)
  m.best <- dim(d_clust$z)[2]
  cat("Fold ", i , ": model-based optimal number of clusters:", m.best, "\n")
  
  results[i] <- m.best
}

# Step 5: Compare actual mixture model clustering results against average cross validation results
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("Actual clustering results: model-based optimal number of clusters:", m.best, "\n")   # 10 clusters
cat("Average cluster validation results:", mean(results), "\n")   # 11.2 clusters


# ANALYSIS 4 Results ----------
# Actual clustering results: model-based optimal number of clusters: 10
# Average cluster validation results: 11.2


# ANALYSIS 5 Validation (Word's Mover Distance Model with googleNews pre-trained word2vec inner model) ------------------------------------------------

# n by n document similarity matrix
docSim <- as.matrix(read_csv("data/similarityMatrices/WMD_cleanAbstracts_simMatrix.csv", col_names = FALSE))
# n by n document dissimilarity matrix
dissimilarityMat = 1 - docSim

# Cross validation 
# Step 1: Randomly shuffle the data
set.seed(2017)
shuffle <- sample(nrow(dissimilarityMat))
cvData <- dissimilarityMat[shuffle,shuffle]

# Step 2: Create 10 equally size folds
folds <- cut(seq(1,nrow(cvData)),breaks=10,labels=FALSE)

# Step 3: set up array to store results
someData <- rep(0, 10)
results <- array(someData, 10)

# Step 4: Perform 10 fold cross validation
for(i in 1:10){
  #Segment your data by fold using the which() function 
  testIndexes <- which(folds==i,arr.ind=TRUE)
  cvDissMatr <- cvData[-testIndexes, -testIndexes]
  
  d_clust <- Mclust(as.matrix(cvDissMatr), G=2:30)
  m.best <- dim(d_clust$z)[2]
  cat("Fold ", i , ": model-based optimal number of clusters:", m.best, "\n")
  
  results[i] <- m.best
}

# Step 5: Compare actual mixture model clustering results against average cross validation results
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("Actual clustering results: model-based optimal number of clusters:", m.best, "\n") # 12 clusters
cat("Average cluster validation results:", mean(results), "\n")   # 9 clusters


# ANALYSIS 5 Results ----------
# Actual clustering results: model-based optimal number of clusters: 12
# Average cluster validation results: 9

# ANALYSIS 6 Validation (Document Similarity using 48 topics with LSI model) ------------------------------------------------

# n by n document similarity matrix
docSim <- as.matrix(read_csv("data/similarityMatrices/docSim_cleanAbstracts_lsi_t48_simMatrix.csv", col_names = FALSE))
# n by n document dissimilarity matrix
dissimilarityMat = 1 - docSim

# Cross validation 
# Step 1: Randomly shuffle the data
set.seed(2017)
shuffle <- sample(nrow(dissimilarityMat))
cvData <- dissimilarityMat[shuffle,shuffle]

# Step 2: Create 10 equally size folds
folds <- cut(seq(1,nrow(cvData)),breaks=10,labels=FALSE)

# Step 3: set up array to store results
someData <- rep(0, 10)
results <- array(someData, 10)

# Step 4: Perform 10 fold cross validation
for(i in 1:10){
  #Segment your data by fold using the which() function 
  testIndexes <- which(folds==i,arr.ind=TRUE)
  cvDissMatr <- cvData[-testIndexes, -testIndexes]
  
  d_clust <- Mclust(as.matrix(cvDissMatr), G=2:30)
  m.best <- dim(d_clust$z)[2]
  cat("Fold ", i , ": model-based optimal number of clusters:", m.best, "\n")
  
  results[i] <- m.best
}

# Step 5: Compare actual mixture model clustering results against average cross validation results
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("Actual clustering results: model-based optimal number of clusters:", m.best, "\n")   # 7 clusters
cat("Average cluster validation results:", mean(results), "\n")  # 7.8 clusters


# ANALYSIS 6 Results ----------
# Actual clustering results: model-based optimal number of clusters: 7
# Average cluster validation results: 7.8

library(clValid)
clustValid <- clValid(dissimilarityMat, 5:20, clMethods = c("model"), 
                  validation = "stability", method = "complete", verbose = TRUE)
summary(clustValid)
