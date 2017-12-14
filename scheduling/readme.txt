#Solving the scheduling problem using Greedy algorithm.

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

Creating the schedule and exporting it as csv google calendar is fairly easy and straightforward. You only need to run the main.R in your R studio. If it is the first time running the main.R, you need to uncomment three lines:
1- Setting the current working directory (the directory that you copied your R file):
setwd('F:/SVN/DATA 500/Project 3/Final version/')
2- Installing sql package that treats the dataframe conference like a table in sql:
install.packages('sqldf')
3-installing lubridate to compute time/dates:
install.packages('lubridate')

You are done!

Custom changes:
1- Change the clustering type for scheduling
You simply go to main.R and change Type from 1 to 6 ( 1 associated with the first analysis and 6 with the sixth one).

2- Changing the name and address of csv google calendar file:
By default it is set to 'calendar_type'+ method of clustering+ '.csv', e.g., method 1= 'calendar_type 1.csv' 

You can also have change the name and address for conference_typex.csv, which contain the all information about the conference. 
For doing so, you simply need to change the value of conference_all in google_calendar_input_Variables.R
 
3- Changes the date of conference:
If you want to change the date of conference, you can do from conference_dates.R file:
By default the temp_date array, containing the starting sessions for conference, is set to three time slots '2018/03/18 08:40:00 PST', '2018/03/18 13:30:00 PST' , '2018/03/18 15:30:00 PST'

4- Changing the session length and number of sessions and period length:
You need to simply go to greedy_input_variables.R file and change timeslots for changing the length of each session and so on. You can also change the size of classes and name of them in this file.

