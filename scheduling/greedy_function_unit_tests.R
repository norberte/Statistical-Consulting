
# for this test, we check that if the software does not contain the conference data frame, it should not work
# it should return an error message telling you what you should provide
greedy_function_test1<-function()
{
  source('greedy_function.R')
  Greedy()
}

# for this test, we check that if the software does not contain the timeslots, it should not work
# it should return an error message telling you what you should provide
greedy_function_test2<-function()
{
  source('read_conference_csv_file.R')
  conference<-read_csv(filename,type)
  Greedy()
}

# when everything is okay! checking by conference output, it should contain the conference file plus maintt column
greedy_function_test3<-function()
{
  #install.packages('sqldf')
  #install.packages('lubridate')
  library(lubridate)
  library('sqldf')
  
  #determines the cluster type that has used for clustering the talks
  type<-3
  
  # greedy_input_variables defines sessions and rooms 
  source('greedy_input_variables.R')
  
  # the name of the file containing the csv file of all abstracts and their respective clusters
  filename<-'SSC Consulting - conference.csv'
  
  #read the csv file and put it into conference_ that will be our schedule
  source('read_conference_csv_file.R')
  conference<-read_csv(filename,type)
  
  # a feasible schedule is created on this R file
  source('create_feasible_schedule.R')
  
  # assign all non-essential speakers
  conference<-assign_keynote_speakers(conference)
  
  #assign all panel discussion -- they can be assigned outside of the main schedule
  conference<-assign_panel_discussion_temp(conference)
  #assign poster session. They do not need rooms so they do not need to be inside of our main schedule
  conference<-assign_poster_speakers(conference)
  
  # Setting fullCluster as the cluster number and Cluster size
  fullcluster<-sqldf('select Cluster,Count(Cluster) as CC from conference where Cluster>0 group by Cluster order by CC desc')
  
  # define the inavailability matrix having the inavailability times for speakers, if any
  Aprim<-matrix(list(), nrow=length(conference$Abstract), ncol=24)
  #Aprim[[1,1]] <- "2,3"
  #Aprim[[1,2]]<-"3,1"
  
  #defining the input variables for the greedy algorithm
  source('greedy_input_variables.R')
  
  conference<-Greedy()
  if(!is.null(conference$maintt))
    message("Greedy algorithm works fine!")
  else
    stop("Not working properly")
}


greedy_function_test1()
greedy_function_test2()
greedy_function_test3()