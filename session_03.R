# session_03.R

# working with dates

# create some data
dates <- c("03.05.1992 16:53:15", 
           "08.02.1991 18:04:12", 
           "28.08.1998 14:34:23", 
           "09.12.2002 09:12:01", 
           "12.09.2005 08:32:55")
           
values <- c(25, 38, 45, 53, 66)

# put the data in a data frame
df <- data.frame(dates, values)

# check the properties of the data frame
summary(df)

str(df)

# str(df) shows that the dates have been imported as factors, not as dates!!

# dates have to be specified manually (always).

# in this case, we have date and a time at once.
# i.e. date and time in one value are not a calendar data.
# therefore, the most obvious function "as.Date()" does NOT work (is only for calendar dates).
# R follows the POSIX standard ("Portable Operating System Interface") established by IEE
# definition of date and time is given in POSIX time as "seconds since 1.1.1970 00:00:00"
# in R, POSIX time is implemented via "POSIXlt" and "POSIXct"" classes
# from ?DateTimeClasses:
# "Class "POSIXct" represents the (signed) number of seconds since the beginning of 1970 (in the UTC timezone) as a numeric vector. Class "POSIXlt" is a named list of vectors representing [date elements]"
# ""POSIXct" is more convenient for including in data frames, and "POSIXlt" is closer to human-readable forms."

# How to convert the factors in the data frame to a POSIX date?
# We create a new column in the data frame to store the date
# Options for the conversion and an overview on names of date/time elements are given in 
# ?strptime
# i.e. %m indicates the month as number, %j is day of year, %d day of month as number...

# in our example, we give the format of our date, and indicate the punctuation between them:
# check the first element of the dates column as an example:
df$dates[1]

# then we specifically define the format of the date elements and provide the time zone
df$Date <- as.POSIXct(df$dates, 
                      format = "%d.%m.%Y %H:%M:%S", 
                      tz = "EST")

# check the data frame again
head(df)

# specify time zone as name instead of abbreviation see ?Sys.timezone for details
# internally it is still given as "EST"
df$Date <- as.POSIXct(df$dates, 
                      format = "%d.%m.%Y %H:%M:%S", 
                      tz = "Australia/Melbourne")

# check the data frame again
head(df)

# see if the details of df
str(df)

# convert the date to another format for fun
format(df$Date, "%m") # get the month as numeric
format(df$Date, "%C") # get the century (i.e. either 19 or 20 for the example data)
format(df$Date, "%l") # hour based on a 12 hour clock. Careful with this one!!
format(df$Date, "%p") # am/pm information
format(df$Date, "%k") # hour based on a 24 hour clock.
format(df$Date, "%Z") # get time zone information
format(df$Date, "%A") # weekday name
format(df$Date, "%b") # abbreviated month name (based on your computers locale setting)
format(df$Date, "%j") # Day of year
# remember that you can always assign these to a new column in the dataframe

# another example for importing dates
dates2 <- c("August 09, 2010 - 01:05:18 AM", 
            "July 18, 2011 - 3:12:36 PM")
            
values2 <- c(9, 11)

df2 <- data.frame(dates2, values2)

head(df2)

# as a safety pre-caution it is a good idea to wrap such a complex factor in "as.character"
# this helps especially in cases where a date or time component might have been interpreted as a numeric during import.
df2$Dates <- as.POSIXct(
                as.character(df2$dates2),
                format = "%B %d, %Y - %I:%M:%S %p", 
                tz = "EST")
                
head(df2)
str(df2)

# be aware of the importance of am/pm in some date/time formats:
# check this command
df2$Dates2 <- as.POSIXct(
                as.character(df2$dates2), 
                format = "%B %d, %Y - %H:%M:%S",
                tz = "EST")

# check the data again
head(df2)

# get rid of the wrong column, i.e. declare it "undefined" via assigning "NULL" to it.
df2$Dates2 <- NULL

# check again
head(df2)

# and now the original column is obsolete (we are 100% sure the date was imported correctly)
# we get rid of the column as well
df2$dates2 <- NULL

head(df2)

# Once the import / date conversion procedure has been confirmed, it is possible to convert the date in place without using an extra column (Assigning the result to itself )But be careful
# i.e. df2$dates2 <- as.POSIXct(as.character(df2$dates2)..... 


# back to the original data frame
head(df)

# selections with dates
# when providing a date manually, convert it on the fly to POSIXct
df[df$Date > as.POSIXct("2000-01-01"), ]

# calculations with dates
# duration
df$Date[1] - df$Date[3]         # returns an object of class "difftime"
as.numeric(df$Date[1] - df$Date[3])

# be careful with a difftime object! it has a sign
# test if the difference is less than 1000 days
df$Date[1] - df$Date[3] < 1000
df$Date[3] - df$Date[1] < 1000

# addition
# remember, this works in seconds!!
df$Date[1] + 5 # this adds five seconds

# calculations with dates can be tricky in base R
# as everything is based on seconds, calculations are possible when everything is broken down to seconds:
# add one day to a date
sec.in.day <- 60 * 60 * 24
df$Date[1] + sec.in.day

# two days
df$Date[1] + 2 * sec.in.day

# subtract three days
df$Date[1] - 3 * sec.in.day

# another option is to take the date elements separate as shown with the "format" examples above and manipulate them individually.

# using "seq" with "day" is another option in base R
# examples from H. Wickham, lubridate
# add a day to a date
seq(df$Date[1], length = 2, by = "day")[2]

# Subtract 5 days from a day
seq(df$Date[1], length = 2, by = "-5 day")[2]

# i.e. it is complicated
# I recommend the excellent "lubridate" package by H. Wickham for date arithmetic
# introduction http://www.jstatsoft.org/v40/i03/paper
# manual http://cran.r-project.org/web/packages/lubridate/lubridate.pdf
# if you did not install it yet: install.packages("lubridate", dep = TRUE)

# load the package
library(lubridate)

# add one day
df$Date[1] + days(1)

# add three minutes
df$Date[1] + minutes(3)

# add twelve years
df$Date[1] + years(12)

# Be careful regarding leap years when calculating with seconds!
as.POSIXct("2001-02-28", tz = "EST") + 365 * sec.in.day # ok
as.POSIXct("2000-02-29", tz = "EST") + 365 * sec.in.day # a day short
as.POSIXct("2000-02-28", tz = "EST") + 366 * sec.in.day # ok

as.POSIXct("2000-02-28", tz = "EST") + sec.in.day
as.POSIXct("2001-02-28", tz = "EST") + sec.in.day

# better use the "lubridate" package to avoid trouble
as.POSIXct("2000-02-28", tz = "EST") + years(1)
as.POSIXct("2000-02-29", tz = "EST") + years(1)
as.POSIXct("2001-02-29", tz = "EST") # gives an obvious error

# to check for leap_years with the "lubridate" package
# in case you need to do something manually
leap_year(2000)
leap_year(2001)

# But with POSIXct and lubridate there are no problems with leap years or any other dates


# ++++++++++++++++++++++++++++++++++++
# Next session:
# ++++++++++++++++++++++++++++++++++++

# I'll give a quick introduction to the graphics package "ggplot2"
# "Grammar of Graphics" by Hadley Wickham
# see reference manual at: http://had.co.nz/ggplot2/
# and more detailed, updated manual at http://had.co.nz/ggplot2/docs/
# install the package from the repositories
install.packages("ggplot2", dep = TRUE)

# in the list of available CRAN repositories, choose "Uni Melbourne" CRAN mirror
# http://cran.ms.unimelb.edu.au/

# then it will be a more open discussion regarding your needs

# ---------------------------------------------
# Requests what to discuss in the next session:
# ---------------------------------------------
# * change fonts in (base) graphs, length of ticks in base graphics:
# see http://cran.r-project.org/doc/Rnews/Rnews_2004-2.pdf (page 5) for details

# * inward ticks on graphs?
# see ?axis
# see overview on http://www.statmethods.net/advgraphs/axes.html (paragraph "axes")
# "axis" and "par" options: length and direction of tick mark specified via "tck": allows positive/negative numbers for inward/outward tick marks, or "tcl" specifies length relative to plot

# * barplots (base graphis and ggplot2)
# the trick is to calculate the values to be displayed first, then provide them as a vector to "barplot": http://www.statmethods.net/graphs/bar.html

# * secondary y-axis in base graphics
# see ?axis "side" option.

# * time series with gaps... how to check for gaps?
# the idea is to create a gap-less series and merge the gapless series with your data. this will put empty lines in a combined data frame when there was a gap in the data. See ?merge
# Or have a look at the time series package "zoo" (install it first...)

# * saving the code for your own functions in a separate file and using them in another script.


