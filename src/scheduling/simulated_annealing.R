setwd('F:/SVN/DATA 500/Project 3/')
#simulated annealing for scheduling problem
#install.packages('sqldf')
#using sqldf that provides us all functionalities of sql
library('sqldf')


source('create_feasible_schedule.R')

optimization_process<-function()
{
  conference<-feasibleSc()
  yp<-objective_function(conference,w = w,z = z)
  xp<-conference
  # fixing the hard constraints
  
  obj1<-objective_function(conference)
  T0<-1
  Tf<-0.001
  beta<-0.98
  
  while(T0>Tf)
  {
    
    
    T0<-beta*T0
  }
}

random_walk<-function(conference)
{
  
  r<-runif(1,min=1,max=length(class_cap))
  s<-runif(1,min=1,max=length(timeslots))
  conf_sub<-sqldf(paste(paste("select mainpr,pr from conference where Cluster>0 and class=",r)," and maintt= ",s))
  
}


optimization_process()




#write solution in final output
#write.csv(conf,'schedule.csv')

