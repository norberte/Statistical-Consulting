# turn int to date
source('google_calendar_input_variables.R')

creating_csv_output_all<-function()
{
  
  source('conference_dates.R')
  
  max_subtt_inmaintt<-sqldf('select maintt,max(subtt) as maxsubtt from conference where maintt>0 group by maintt')
  max_subtt_inmaintt[,"timeinterval"]<-timeslots%/%max_subtt_inmaintt$maxsubtt
  
  for(i in 1:length(conference$maintt))
  {
    if(conference$maintt[i]>0)
    {
      accumulator<-max_subtt_inmaintt$timeinterval[max_subtt_inmaintt$maintt==conference$maintt[i]]
      conference[i,"StartTime"]<-turnintToTime(conference$maintt[i],conference$subtt[i],accumulator)
      conference[i,"EndTime"]<-turnintToTime(conference$maintt[i],conference$subtt[i]+1,accumulator)
    }
  }
  conference$StartTime<-as.POSIXct(conference$StartTime,origin = "1970-01-01")
  conference$EndTime<-as.POSIXct(conference$EndTime,origin = "1970-01-01")
  # considering posters in our schedule
  
  conference$StartTime[conference$Flags=="Poster"]<- as.POSIXct(temp_date[4])
  conference$EndTime[conference$Flags=="Poster"]<- as.POSIXct(temp_date[4])+hours(5)
  conference$class[conference$Flags=="Poster"]<-10
  #############################################
  conference[,"Name"]<-paste('Talk',seq(1,length(conference$Abstract)))
  
  
  write.csv(conference,confere_all)
  
  ##########################################
  sorted_conf<-sqldf('select Abstract,Class,Cluster,Flags,StartTime,EndTime from conference order by StartTime,Class')
  
  write.csv(sorted_conf,conference_sorted_by_date)
  
  convertCSVtoGoogleCalendar(conference)
}

turnmainttToday<-function(maintt)
{
  interval<-3
  day<--1
  for(i in 1:3)
  {
    if(maintt%in%seq((i-1)*interval+1,i*interval,by=1))
      day<-i-1
  }
  day
}
turnintToTime<-function(maintt,subtt,accumulator)
{
  interval<-3
  temp_date_index<-maintt%%interval
  if(temp_date_index==0)
    temp_date_index<-3
  date<-temp_date[temp_date_index]
  c_date<-as.POSIXct(date)
  c_date<-c_date+days(turnmainttToday(maintt))
  c_date<-c_date+(subtt-1)*minutes(accumulator)
  c_date
}

convertCSVtoGoogleCalendar<-function(conference)
{
  #headers<-c('Subject','Start Date',	'Start Time',	'End Date','End Time',	'All Day Event',	'Description',	'Location',	'Private')
  temp<-sqldf('select name,StartTime,EndTime,Abstract,class from conference')
  calendar<-sqldf('select name as Subject from conference')
  calendar[,'Start Date']<-format(as.Date(temp$StartTime), "%m/%d/%Y")
  calendar[,'Start Time']<- format(temp$StartTime,"%H:%M:%S")
  calendar[,'End Date']<-format(as.Date(temp$EndTime), "%m/%d/%Y")
  calendar[,'End Time']<- format(temp$EndTime,"%H:%M:%S")
  calendar[,'All Day Event']<-""
  calendar[,'Description']<-temp$Abstract
  calendar[,'Location']<-class_names[temp$class]
  calendar[,'Private']<-'FALSE'
  write.csv(calendar,google_calendar_file_name)
  
}