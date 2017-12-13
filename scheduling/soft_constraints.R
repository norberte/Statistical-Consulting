Soft_constraints<-function(conference)
{
  S<-rep(0,7)
  #S1 - the key note speaker should be assigned to the largest class
  
  max_index<-which.max( class_cap)# largest class index
  S[1]<-sum(abs(conference$class[conference$Flags=="Keynote"]-max_index))
  #S2 - the bigger cluster - the larger room need to be assigned. In other words, in each session the classes must be assigned to clusters based on their size
  for(i in 1:length(timeslots))
  {
    #find the indexes of clusters in session i
    Cluster_indexes<-conference$Cluster[conference$maintt==i]
    ci<-paste(Cluster_indexes,collapse=",")
    cluster_sizes<-sqldf(paste(paste('select CC from fullcluster where Cluster IN (',ci),')'))
    #cluster_sizes<-fullcluster$CC[fullcluster$Cluster==Cluster_indexes]
    ordered_cluster_sizes=sort(cluster_sizes$CC,decreasing = TRUE)
    #finding the sum of the clusters are not ordered
    S[2]<-S[2]+sum(as.numeric(ordered_cluster_sizes!=cluster_sizes$CC))
  }
  # #S3 - in each session and in each class, the priority should be like this first, keynote, student, invited, contributed
  for(i in 1:length(timeslots))
  {
    for(j in 1:length(class_cap))
    {
      #find the indexes of clusters in session i
      #Priority_indexes<-conference$mainpr[conference$maintt==i]
      Priority_indexes<-sqldf(paste(paste(paste(paste('select mainpr from conference where mainpr>0 and maintt=',i),' and class='),j),' order by subtt asc'))
      #
      ordered_Priority_indexes=sort(Priority_indexes$mainpr)
      #finding the sum of the clusters are not ordered
      S[3]<-S[3]+sum(as.numeric(ordered_Priority_indexes!=Priority_indexes$mainpr))
    }
  }
  # #S4- The key note talk should be happen in the first period of every day of conference
  sessions<-conference$maintt[conference$Flags=="Keynote"]
  periods<-conference$subtt[conference$Flags=="Keynote"]
  S[4]<-sum(as.numeric(!sessions%in%c(1,4,7)))
  S[4]<-S[4]+sum(as.numeric(!periods%in%1))
  #
  # #S5- No talk should be parallel with keynote talk
  tmp<-sqldf('select count(*) as CC from conference where Flags!="Keynote" and maintt in (1,4,7) and subtt=1')
  S[5]<-tmp$CC
  #
  # #S6- Among two speaker with the same flag (flag means student,invited,...) the speaker with higher priority (pr) will go first.
  # # in other words, at each session, if the flag is the same for speakers, the one with higher priority (pr) will go first
  for(i in 1:length(timeslots))
  {
    for(j in 1:3)
    {
      #find the indexes of clusters in session i
      Priority_indexes<-sqldf(paste(paste(paste('select pr from conference where maintt=',i),'and mainpr ='),j),' order by subtt asc')
      if(length(Priority_indexes)>1)
      {
        #
        ordered_Priority_indexes=sort(Priority_indexes)
        #finding the sum of the clusters are not ordered
        S[6]<-S[6]+sum(as.numeric(ordered_Priority_indexes!=Priority_indexes))
      }
    }
    
  }
  
  #S7-each session,class, Two talks with same mainpr, the one with higher pr should go first
  for(i in 1:length(timeslots))
  {
    for(j in 1:length(class_cap))
    {
      #find the indexes of clusters in session i
      #Priority_indexes<-conference$mainpr[conference$maintt==i]
      Priority_indexes<-sqldf(paste(paste(paste(paste('select pr,mainpr from conference where mainpr>0 and maintt=',i),' and class='),j),' order by subtt asc'))
      #
      for(k in 1:3)
      {
        Pr_indexes<-sqldf(paste(paste(paste(paste(paste(paste('select pr from conference where mainpr>0 and maintt=',i),' and class='),j),' and mainpr='),k), 'order by subtt asc'))
        if(length(Pr_indexes$pr)>0)
        {
          Pr_indexes_sort=sort(Pr_indexes$pr)
          #finding the sum of the clusters are not ordered
          if(is.numeric(Pr_indexes_sort)&&is.numeric(Pr_indexes))
          {
            S[7]<-S[7]+sum(Pr_indexes$pr!=Pr_indexes_sort)
          }
        }
      }
    }
  }
  
  S
}