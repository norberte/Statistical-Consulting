read_csv<-function(filename,type)
{
  
  conference<-read.csv(filename,header = TRUE)
  conference[,'assigned']<-0
  conference[,'class']<-0
  conference[,'maintt']<-0
  conference[,'subtt']<-0
  set.seed(100)
  conference[,'pr']<-round(runif(length(conference[,1]))*length(conference[,1]))
  conference[,'mainpr']<-0
  conference$mainpr[conference$Flags=="Keynote"]<--1#since we are going to assign it in a particular time
  conference$mainpr[conference$Flags=="Student"]<-2
  conference$mainpr[conference$Flags=="Invited"]<-3
  conference$mainpr[conference$Flags=="Contributed"]<-4
  conference$mainpr[conference$Flags=="Poster"]<--1# since we are going to assign it in a particular time
  
  switch(type,conference[,'Cluster']<-conference$Cluster_doc2vec_apnews,conference[,'Cluster']<-conference$Cluster_docSim
         ,conference[,'Cluster']<-conference$cluster_doc2vec_wiki,conference[,'Cluster']<-conference$cluster_wmd,
         conference[,'Cluster']<-conference$cluster_doc2vec_300,conference[,'Cluster']<-conference$cluster_InferSent_GloVe)
  
  conference
}