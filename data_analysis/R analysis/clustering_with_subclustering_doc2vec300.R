# import libraries and data ---------------------------------------
library(HSAUR2)
library(readr)
library(mclust)
library(cluster)

docSim <- as.matrix(read_csv("../../data/similarityMatrices/Doc2Vec_Dim300_selfTrained_simMatrix.csv", col_names = FALSE))
dissimilarityMat = 1 - docSim

### Determining the number of clusters using various algorithms -----------

# k-Means ---- k = 6 or 10 -------------
clustore <- matrix(0, nrow=283, ncol=283)
wsstore <- NULL
for(i in 1:30){
  dum <- kmeans(dissimilarityMat, i, nstart=25)
  clustore[, i] <- dum$cluster
  wsstore[i] <- dum$tot.withinss
}

plot(1:30, wsstore, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

# mixture model-based clustering ---- k = 12 -------------
library(mclust)
# Run the function to see how many clusters it finds to be optimal, set it to search for at least 1 model and up 30.
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")
plot(d_clust)

# Affinity Propagation clustering ---- k = 29  -------------
require(apcluster)
d.apclus <- apcluster(negDistMat(r=2), x = dissimilarityMat)
cat("affinity propogation optimal number of clusters:", length(d.apclus@clusters), "\n")
heatmap(d.apclus)
plot(d.apclus, docSim)

# k-means elbow criterion---------- k = 19 ---------
library(GMD)
elbow.k <- function(mydata){
  ## determine a "good" k using elbow
  dist.obj <- dist(mydata);
  hclust.obj <- hclust(dist.obj);
  css.obj <- css.hclust(dist.obj,hclust.obj);
  elbow.obj <- elbow.batch(css.obj);
  k <- elbow.obj$k
  return(k)
}
k = elbow.k(dissimilarityMat)
cat('Based on the elbow plot, the value of k is: ', k);

# parallel k-means elbow plot -------------
library(parallel)

elbow <- function(min_max, frame) {
  set.seed(42)
  wss <- (nrow(frame)-1)*sum(apply(frame,2,var))
  for (i in min_max) {
    wss[i] <- sum(kmeans(frame,centers=i,algorithm = c('MacQueen'))$withinss)
  }
  return(wss)
}

parallel_elbow <- function(kmax, frame_choice) {
  # create separate kmin:kmax vectors 
  cut_point <- 3
  centers_vec <- 2:kmax    
  x <- seq_along(centers_vec)
  chunks <- split(centers_vec, ceiling(x/cut_point))
  
  # use shared-memory parallelism on function of choice
  results <- mclapply(chunks, FUN=elbow, frame=frame_choice)
  
  # gather the results of each parallel run 
  no_nas <- list()
  for(i in 1:length(results)) { 
    no_nas[i] <- list(as.numeric(na.omit(results[[i]])))
  }
  
  vec <- unlist(no_nas)
  final_vec <- setdiff(vec, vec[1])
  final_vec <- append(vec[1],final_vec)
  
  # create scree plot of all wss values
  plot(1:length(final_vec), final_vec, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares", pch = 16, main="Elbow Plot", col="steelblue")
}


parallel_elbow(30, dissimilarityMat)


### first clustering using k = 10
# Mixture model ----
doc_mm<- Mclust(dissimilarityMat, G=2:30)
summary(doc_mm)
write.csv(doc_mm$classification, file="../../data/clusterMemberships/mainClusters/doc2vec_dim300_mainClusters_mixtureModels_k=12_membership.csv" )

cluster1 <- dissimilarityMat[doc_mm$classification==1,doc_mm$classification==1]
cluster2 <- dissimilarityMat[doc_mm$classification==2,doc_mm$classification==2]
cluster3 <- dissimilarityMat[doc_mm$classification==3,doc_mm$classification==3]
cluster4 <- dissimilarityMat[doc_mm$classification==4,doc_mm$classification==4]
cluster5 <- dissimilarityMat[doc_mm$classification==5,doc_mm$classification==5]
cluster6 <- dissimilarityMat[doc_mm$classification==6,doc_mm$classification==6]
cluster7 <- dissimilarityMat[doc_mm$classification==7,doc_mm$classification==7]
cluster8 <- dissimilarityMat[doc_mm$classification==8,doc_mm$classification==8]
cluster9 <- dissimilarityMat[doc_mm$classification==9,doc_mm$classification==9]
cluster10 <- dissimilarityMat[doc_mm$classification==10,doc_mm$classification==10]
cluster11 <- dissimilarityMat[doc_mm$classification==11,doc_mm$classification==11]
cluster12 <- dissimilarityMat[doc_mm$classification==12,doc_mm$classification==12]

clusterMembership <- NULL
currentNumberOfClusters <- 0

#Sub-clustering

#cluster 1
divClust <- diana(cluster1, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), k = 2)
table(divClustResults)
clusterMembership <- c(divClustResults, clusterMembership) 
currentNumberOfClusters <- currentNumberOfClusters + 2   #update current number of clusters



#cluster 2
divClust2 <- diana(cluster2, diss = TRUE)
plot(divClust2)

divClustResults <- cutree(as.hclust(divClust2), k = 2)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters)) 
currentNumberOfClusters <- currentNumberOfClusters + 2




#cluster 3
divClust <- diana(cluster3, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), k = 2)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters)) 
currentNumberOfClusters <- currentNumberOfClusters + 2



#cluster 4
divClust <- diana(cluster4, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), k = 2)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters))
currentNumberOfClusters <- currentNumberOfClusters + 2



#cluster 5
divClust <- diana(cluster5, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), k = 4)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters)) 
currentNumberOfClusters <- currentNumberOfClusters + 4



#cluster 6
divClust <- diana(cluster6, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), k = 4)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters))
currentNumberOfClusters <- currentNumberOfClusters + 4



#cluster 7
divClust <- diana(cluster7, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), k = 5)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters))
currentNumberOfClusters <- currentNumberOfClusters + 5



#cluster 8
divClust <- diana(cluster8, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), k = 4)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters))
currentNumberOfClusters <- currentNumberOfClusters + 4



#cluster 9
divClust <- diana(cluster9, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), k = 4)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters))
currentNumberOfClusters <- currentNumberOfClusters + 4



#cluster 10
divClust <- diana(cluster10, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), k = 5)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters))
currentNumberOfClusters <- currentNumberOfClusters + 5



#cluster 11
divClust <- diana(cluster11, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), k = 5)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters))
currentNumberOfClusters <- currentNumberOfClusters + 5



#cluster 12
divClust <- diana(cluster12, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), h = 0.71)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters))
currentNumberOfClusters <- currentNumberOfClusters + 4

write.csv(clusterMembership, file="../../data/clusterMemberships/subClusters/doc2vec_dim300_k=43_membership.csv")
