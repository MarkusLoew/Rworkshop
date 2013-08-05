# session 5
# repetition and excersice

setwd("/path/to/your/preferred/location")

# load the "Orange growth" data set
data(Orange)

# get information on the "Orange" data

# convert "age" to a date
secs.per.day <- 24 * 60 * 60

Orange$age.sec <- Orange$age * secs.per.day

Orange$Date <- as.POSIXct(Orange$age.sec, origin = "1968-12-31", tz= "EST")

# get the month and other elements out of the date
Orange$Month <- format(Orange$Date, "%m")
Orange$Day <- format(Orange$Date, "%j")
Orange$Day.of.Month <- format(Orange$Date, "%d")

# do some aggregation
aggregate(Orange$circumference, by = list(Orange$Month), FUN = mean)
aggregate(Orange$circumference, by = list(Orange$Day),   FUN = mean)

aggregate(Orange$circumference, 
                by  = list(Orange$Month, Orange$Day.of.Month), 
                FUN = mean, na.rm = T)

# create a figure of growth over time
library(ggplot2)

p <- ggplot(data = Orange, aes(x = age, y = circumference))
  p <- p + geom_point(aes(colour = Tree))
  p <- p + geom_smooth(aes(colour = Tree), method = "lm", se = T)
  p <- p + facet_grid(Tree ~ .)
p

# then back to session 4 regarding creating figures for several columns at once

sec.in.a.day <- 24 * 60 * 60
Orange$Date <- Orange$age * sec.in.a.day
Orange$Date <- as.POSIXct(Orange$Date, tz = "EST", origin = "1968-12-31")





