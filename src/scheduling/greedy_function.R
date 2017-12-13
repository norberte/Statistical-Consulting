Greedy<-function()
{
  
  assignedcluster<-fullcluster
  assignedcluster$CC<-0
  conference<-assign_keynote_speakers(conference)
  nec<-sqldf('select Cluster,Count(Cluster) as CC from conference where assigned=0 and Cluster>0 group by Cluster order by CC desc')
  for(k in 1:numclasses)
  {
    for(i in 1:length(timeslots))
    {
      #numss<-round(timeslots[i]/timelength)#number of subslots
      numss<-timeslots[i]%/%periodlength
      #the first period of each day is reserved for keynote speakers
      ps<-as.numeric(i%in%c(1,4,7))+1
      for(j in ps:numss)
      {
        
        if(length(nec$Cluster)>0)
        {
          absStd<-studentpercluster(conference,nec$Cluster[1],0)
          if(length(absStd$Abstract)>0)
          {
            chosenAbs<-absStd$Abstract[1]
            conference$assigned[conference$Abstract==chosenAbs]<-1
            conference$class[conference$Abstract==chosenAbs]<-k
            conference$maintt[conference$Abstract==chosenAbs]<-i
            conference$subtt[conference$Abstract==chosenAbs]<-j
            assignedones<-assignedcluster$CC[assignedcluster$Cluster==nec$Cluster[1]]+1
            assignedcluster$CC[assignedcluster$Cluster==nec$Cluster[1]]<-assignedones
            full<-fullcluster$CC[fullcluster$Cluster==nec$Cluster[1]]
            if(assignedones==full)
            {
              nec<-sqldf('select Cluster,Count(Cluster) as CC from conference where assigned=0 and Cluster>0 group by Cluster order by CC desc')
              break
            }
            
          }
        }
      }
    }
  }
  conference
}