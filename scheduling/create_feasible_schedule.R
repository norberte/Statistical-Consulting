source('greedy_function.R')

assign_keynote_speakers<-function(conference)
{
  
  conference$assigned[conference$Flags=='Keynote']<-1
  conference$class[conference$Flags=='Keynote']<-1
  conference$maintt[conference$Flags=='Keynote']<-sample(c(1,4,7))
  conference$Cluster[conference$Flags=='Keynote']<--1
  conference$subtt[conference$Flags=='Keynote']<-1
  conference
}
assign_poster_speakers<-function(conference)
{
  
  conference$assigned[conference$Flags=='Poster']<-1
  conference$class[conference$Flags=='Poster']<--1
  conference$maintt[conference$Flags=='Poster']<--1
  conference$subtt[conference$Flags=='Poster']<--1
  conference$mainpr[conference$Flags=='Poster']<--1
  conference$Cluster[conference$Flags=='Poster']<--1
  conference
}
assign_panel_discussion_temp<-function(conference)
{
  
  conference$assigned[is.na(conference$Cluster)==TRUE]=1
  conference$class[is.na(conference$Cluster)==TRUE]=-2
  conference$maintt[is.na(conference$Cluster)==TRUE]=-2
  conference$subtt[is.na(conference$Cluster)==TRUE]=-2
  conference$mainpr[is.na(conference$Cluster)==TRUE]=-2
  conference$Cluster[is.na(conference$Cluster)==TRUE]=-2
  conference
}
assign_panel_discussion<-function(conference)
{
  selected_class<-sqldf('select class,count(maintt) as cm from conference where maintt>0 group by class order by cm asc')
  selected_maintt<-sqldf(paste(paste('select distinct maintt from conference where maintt>0 and maintt not in(select maintt from conference where maintt>0 and class=',selected_class$class[1]),
                               ') order by maintt asc'))
  
  conference$subtt[conference$maintt==-2]<-sample(count_speakers)
  count_speakers<-length(conference$maintt[conference$maintt==-2])
  
  if(length(selected_maintt$maintt)>0)
  {
    conference$class[conference$maintt==-2]<-selected_class$class[1]
    conference$maintt[conference$maintt==-2]<-selected_maintt$maintt[1]
  }
  else
  {
    if(numclasses-length(selected_class$class)>0)
    {
      selected_class<-selected_class$class[1]+1
      conference$class[conference$maintt==-2]<-selected_class
      conference$maintt[conference$maintt==-2]<-2
    }
    else
    {
      warning('Panel discussion cannot be scheduled!')
    }
  }
  conference
}
studentpercluster<-function(conference,cluster,assigned)
{
  sqldf(paste(paste(paste(paste('select Abstract from conference where Cluster>0 and Cluster=',cluster),'and assigned ='),assigned),' order by mainpr asc,pr asc'))
}
assign_schedule<-function(numsections,numslots,numdays)
{
  array(0,dim=c(numsections,numslots,numdays))
  
}

timeinMinutes<-function(time)
{
  strsplit(time,split = " ")
}
