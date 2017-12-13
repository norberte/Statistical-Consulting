# import libraries and data ---------------------------------------
library(HSAUR2)
library(readr)
library(mclust)
library(cluster)

docSim <- as.matrix(read_csv("../../data/similarityMatrices/apnews_doc2vec_simMatrix.csv", col_names = FALSE))
dissimilarityMat = 1 - docSim

# DIvisive ANAlysis Clustering ------------------------
divClust <- diana(dissimilarityMat, diss = TRUE)
plot(divClust)

divClustResults <- cutree(as.hclust(divClust), h = 0.47)
table(divClustResults)
write.csv(divClustResults, file="../../data/clusterMemberships/doc2vec_wikiModel_divisive_membership.csv" )


#agglomerative clustering 
aggClust <- agnes(dissimilarityMat, diss = TRUE, method = "complete")
plot(aggClust)

aggClustResults <- cutree(as.hclust(aggClust), h = 0.45)
table(aggClustResults)
write.csv(aggClustResults, file="../../data/clusterMemberships/doc2vec_wikiModel_Agglomerative_membership.csv" )


# Hierarchical clustering --- k = 15 or 30 ---------------------------------
clink <- hclust(dissimilarityMat, method="complete")
plot(clink)

cres <- cutree(clink, k = 3)
write.csv(cres, file="../../data/clusterMemberships/doc2vec_hierarchical_membership.csv" )

table(cres)
plot(cres)

# visualization ------
library(cluster)
library(fpc)
plotcluster(dissimilarityMat, cres)
clusplot(docSim, cres, color=TRUE, shade=TRUE, 
         labels=2, lines=0)

library(ade4)
plot(docSim)
kmeansRes<-factor(cres)
s.class(docSim,fac=kmeansRes, add.plot=TRUE, col=rainbow(nlevels(kmeansRes)))

# dynamicTreeCut -------------
library(dynamicTreeCut)
maxCoreScatter <- 0.99
minGap <- (1 - maxCoreScatter) * 3/4
dynamicCut <- cutreeDynamic(clink, minClusterSize=5, method="hybrid", distM=as.matrix(docSim), deepSplit=4, maxCoreScatter=maxCoreScatter, minGap=minGap, maxAbsCoreScatter=NULL, minAbsGap=NULL)

write.csv(dynamicCut, file="../../data/clusterMemberships/doc2vec_pretrained_dynamicTreeCut_k=3_membership.csv" )

plot(docSim, col=cres)

clusters <- identify(clink)

# Mixture model ----
library(mclust)
BIC = mclustBIC(dissimilarityMat)
plot(BIC)
summary(BIC)


doc_mm<- Mclust(dissimilarityMat, G=2:30)
summary(doc_mm)
write.csv(doc_mm$classification, file="../../data/clusterMemberships/doc2vec_pretrained_mixtureModels_k=7_membership.csv" )


# k-means -----------------------------------------------
clust_kmeans <- kmeans(docSim, 3, nstart=25)
kmeans_membership <- clust_kmeans$cluster
write.csv(kmeans_membership, file="../../data/clusterMemberships/doc2vec_pretrained_kMeans_k=3_membership.csv" )

table(kmeans_membership)

# Partitioning Around Medoids ----------------------------
partition = pam(docSim, 3) # 3 clusters
partitioning_membership_ = partition$clustering
write.csv(partitioning_membership_, file="../../data/clusterMemberships/doc2vec_pretrained_cleanAbstracts_PartitioningAroundMedoids_k=3_membership.csv" )



# 1a k-Means ---- k = 3 -------------
clustore <- matrix(0, nrow=287, ncol=287)
wsstore <- NULL
for(i in 1:30){
  dum <- kmeans(docSim, i, nstart=25)
  clustore[, i] <- dum$cluster
  wsstore[i] <- dum$tot.withinss
}

plot(1:30, wsstore, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

# 1b k-Means ---- k = 2 -------------
wss <- (nrow(docSim)-1)*sum(apply(docSim,2,var))
for (i in 2:30) wss[i] <- sum(kmeans(docSim,
                                     centers=i)$withinss)
plot(1:30, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

# 2a Partitioning Around Medoids ---- k = 2 -------------
require(fpc)
require(cluster)
pamk.best <- pamk(docSim)
cat("number of clusters estimated by optimum average silhouette width:", pamk.best$nc, "\n")
plot(pam(distmat, pamk.best$nc))

# 2b Partitioning Around Medoids ---- k = 1 -------------
asw <- numeric(30)
for (k in 2:30)
  asw[[k]] <- pam(distmat, k) $ silinfo $ avg.width
k.best <- which.max(asw)
cat("silhouette-optimal number of clusters:", k.best, "\n")

# 3 k_means calinksi criterion ---- k = 2 -------------
require(vegan)
fit <- cascadeKM(docSim, 1, 50, iter = 25)
plot(fit, sortg = TRUE, grpmts.plot = TRUE)
calinski.best <- as.numeric(which.max(fit$results[2,]))
cat("Calinski criterion optimal number of clusters:", calinski.best, "\n")

# 4 mixture model-based clustering ---- k = 10  -------------
library(mclust)
# Run the function to see how many clusters it finds to be optimal, set it to search for at least 1 model and up 20.
d_clust <- Mclust(as.matrix(docSim), G=2:30)
m.best <- dim(d_clust$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")
plot(d_clust)

# 5 Affinity Propagation clustering ---- k = 36  -------------
require(apcluster)
d.apclus <- apcluster(negDistMat(r=2), x = docSim)
cat("affinity propogation optimal number of clusters:", length(d.apclus@clusters), "\n")
heatmap(d.apclus)
plot(d.apclus, docSim)

# 6 Gap Statistic for Estimating k ----- k = 1 ---------------
library(cluster)
clus300 <- clusGap(docSim, kmeans, 30, B = 100, verbose = interactive())
clus300

# 7 Clustogram ---- k = inconclusive-------------
clustergram(docSim, k.range = 2:50 , clustering.function = clustergram.kmeans,
              clustergram.plot = clustergram.plot.matlines, line.width = .004, add.center.points = T)


# 8 NbClust for determining the best k ---- k = ?--------takes too much time to run -----
library(NbClust)
nb <- NbClust(data = docSim, distance = "euclidean", 
              min.nc=2, max.nc=100, method = "kmeans", 
              index = "alllong", alphaBeale = 0.1)
hist(nb$Best.nc[1,], breaks = max(na.omit(nb$Best.nc[1,])))



# 9 k-means elbow ---------- k = 14 ---------
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

start.time <- Sys.time();
k = elbow.k(docSim)
end.time <- Sys.time();
cat('Time to find k using Elbow method is',(end.time - start.time),'seconds with k value:', k);

# 10 ---- k = ? ----- takes too much time to run------------
library(pvclust)
library(MASS)

word.pv <- pvclust(docSim)
plot(word.pv)

# 11 --- k = 3 or 5 --- parallel k-means elbox function
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

  
parallel_elbow(30, docSim)
