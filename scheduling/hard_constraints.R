hard_constraints<-function(conference)
{
  h<-rep(0,8)
  #H1-(must change to h1) All talks must be scheduled
  h[1]<-sum(as.numeric(!conference$assigned))
  #H2 Talks with the same cluster should not happen at the same time
  for(k in 1:length(fullcluster))
  {
    for(i in 1:length(timeslots))
    {
      numss<-round(timeslots[i]/periodlength)#number of subslots
      for(j in 1:numss)
      {
        count_cluster<-sqldf(paste(paste(paste("select count(*) as CC from conference where Cluster>0 and maintt=",i)," and subtt= ",j)," and Cluster=",k))
        if(count_cluster$CC>1)
        {
          h[2]<-h[2]+1
        }
      }
    }
  }
  #H3 A talk must only appear once in the whole conference.
  #The data structure covers it
  #H4 A cluster c is to be assigned Tc talks in the whole conference
  Cassigned<-sqldf('select Cluster,Count(Cluster) as CC from conference where assigned=1 and Cluster>0 group by Cluster order by CC desc')
  h[4]<- sum(abs(fullcluster$CC-Cassigned$CC))
  #H5 A talk cannot be assigned to more than one period
  # the data structure already cover this one!
  #h6-A room cannot be assigned to more than one talk at each timeslot
  for(k in 1:numclasses)
  {
    for(i in 1:length(timeslots))
    {
      numss<-round(timeslots[i]/periodlength)#number of subslots
      for(j in 1:numss)
      {
        count_class<-sqldf(paste(paste(paste("select count(*) as C from conference where maintt=",i)," and subtt= ",j)," and class=",k))
        if(count_class$C>1)
        {
          h[6]<-h[6]+1
        }
      }
    }
  }
  
  #h7-The talk is scheduled provided that the speaker is available
  for(i in 1:length(conference$assigned))
  {
    if(conference$assigned[i]>0)
    {
      s<-paste(c(conference$maintt[i],conference$subtt[i]),collapse = ",")
      h[7]<-h[7]+sum(as.numeric(s%in%Aprim[i,]))
    }
  }
  
  #h8-The keynote talks should happen only once in each day of conference.
  session<-conference$maintt[conference$Flags=="Keynote"]
  h[8]<-sum(as.numeric(!session%in%c(1,4,7)))
  
  h
}