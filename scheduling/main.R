# * 
# * @author Mahdi Aziz
# * @date 2017-12-14
# *mahdi.aziz.tls@gmail.com
# *
#   * Solving the scheduling problem using Greedy algorithm.
# *
#   * MIT License --
#   *
#   * Permission is hereby granted to any person obtaining
# * a copy of this software and associated documentation files ("report","readme"), to deal in the Software without restriction, including
# * without limitation the rights to use, copy, modify, merge, publish,
# * distribute, sublicense, and/or sell copies of the Software:
#   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# * NONINFRINGEMENT.

######### run these three lines below once
#setwd('F:/SVN/DATA 500/Project 3/Final version/')# define the directory of the project
#install.packages('sqldf')
#install.packages('lubridate')
#using sqldf that provides us all functionalities of sql
library(lubridate)
library('sqldf')

#determines the cluster type that has used for clustering the talks
type<-1

if(type<1 ||type>6)
  stop('We only have 6 clustering methods-- please a value between 1 to 6 for type')

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
conference<-assign_panel_discussion(conference)

########checking the schedule--- its hard and soft constraints 
source('hard_constraints.R')
source('soft_constraints.R')
source('objective_function.R')

yp<-objective_function(conference,w = w,z = z)


############converting the schedule to csv google calendar file
source('convert_to_google_calendar.R')
creating_csv_output_all()

