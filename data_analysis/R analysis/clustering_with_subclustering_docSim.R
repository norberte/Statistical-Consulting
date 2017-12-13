# import libraries and data ---------------------------------------
library(HSAUR2)
library(readr)
library(mclust)
library(cluster)

docSim <- as.matrix(read_csv("../../data/similarityMatrices/docSim_cleanAbstracts_lsi_t48_simMatrix.csv", col_names = FALSE))
dissimilarityMat = 1 - docSim

### Determining the number of clusters using various algorithms -----------

# k-Means ---- k = 5-6 -------------
clustore <- matrix(0, nrow=283, ncol=283)
wsstore <- NULL
for(i in 1:30){
  dum <- kmeans(dissimilarityMat, i, nstart=25)
  clustore[, i] <- dum$cluster
  wsstore[i] <- dum$tot.withinss
}

plot(1:30, wsstore, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

# mixture model-based clustering ---- k = 7  -------------
library(mclust)
# Run the function to see how many clusters it finds to be optimal, set it to search for at least 1 model and up 30.
d_clust <- Mclust(as.matrix(dissimilarityMat), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")
plot(d_clust)

# Affinity Propagation clustering ---- k = 38 -------------
require(apcluster)
d.apclus <- apcluster(negDistMat(r=2), x = dissimilarityMat)
cat("affinity propogation optimal number of clusters:", length(d.apclus@clusters), "\n")
heatmap(d.apclus)
plot(d.apclus, docSim)

# k-means elbow criterion---------- k = 15 ---------
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
write.csv(doc_mm$classification, file="../../data/clusterMemberships/mainClusters/docSim_mixtureModels_k=7_membership.csv" )

cluster1 <- dissimilarityMat[doc_mm$classification==1,doc_mm$classification==1]
cluster2 <- dissimilarityMat[doc_mm$classification==2,doc_mm$classification==2]
cluster3 <- dissimilarityMat[doc_mm$classification==3,doc_mm$classification==3]
cluster4 <- dissimilarityMat[doc_mm$classification==4,doc_mm$classification==4]
cluster5 <- dissimilarityMat[doc_mm$classification==5,doc_mm$classification==5]
cluster6 <- dissimilarityMat[doc_mm$classification==6,doc_mm$classification==6]
cluster7 <- dissimilarityMat[doc_mm$classification==7,doc_mm$classification==7]

clusterMembership <- NULL
currentNumberOfClusters <- 0

#Sub-clustering
#cluster 1
divClust <- diana(cluster1, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), k = 7)
table(divClustResults)
clusterMembership <- c(divClustResults, clusterMembership) 
currentNumberOfClusters <- currentNumberOfClusters + 7   #update current number of clusters


#cluster 2
divClust2 <- diana(cluster2, diss = TRUE)
plot(divClust2)

divClustResults <- cutree(as.hclust(divClust2), k = 2)
table(divClustResults)
# offset the cluster number, so they don't overlap with the previous clusters
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

divClustResults <- cutree(as.hclust(divClust), h = 0.84)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters))
currentNumberOfClusters <- currentNumberOfClusters + 6


#cluster 5
divClust <- diana(cluster5, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), k = 7)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters)) 
currentNumberOfClusters <- currentNumberOfClusters + 7


#cluster 6
divClust <- diana(cluster6, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), h = 0.92)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters))
currentNumberOfClusters <- currentNumberOfClusters + 7


#cluster 7
divClust <- diana(cluster7, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), k = 2)
table(divClustResults)
clusterMembership <- c(clusterMembership, (divClustResults + currentNumberOfClusters))
currentNumberOfClusters <- currentNumberOfClusters + 2

write.csv(clusterMembership, file="../../data/clusterMemberships/subClusters/docSim_k=33_membership.csv")

