# set working directory for this session
setwd("/path/to/your/folder/with/data")

# example code to import a csv file
# check available options via ?read.csv
# or use the Dataset import wizard from RStudio
# modify the code below to match your situation
# column headers in the csv file must start with a letter
# otherwise there will be problems.

df <- read.csv("mydata.csv", 
         sep = ",",
         header = TRUE,
         na.strings = "-999")


# for the excercise, we use the iris data set
# load iris example data set
data(iris)

# to answer a question that came up during the previous session:
# select column of a data frame by name
iris[, "Sepal.Width"]
iris[, c("Sepal.Width", "Species")]

# some more complex subsetting of a data frame
# select every third element
# the following gets the job done, but there is lots of code within the []
iris[seq(from = 0, to = nrow(iris), by = 3), ] 

# create a vector with the elements that you want
my.index <- seq(from = 0, to = nrow(iris), by = 3)

# use "my.index" in the bracket statement
iris[my.index, ]

# take a random sample of 25 elements from rows of iris
iris[sample(1:nrow(iris), 25), ]

# apply a function
# the "apply" family of functions is large and very complex

# as iris is a dataframe (which itself is just a list of vectors),
# lapply allows to apply a function to each element of a list

out    <- lapply(iris[, 3:4], mean) # arithmetic mean
out.sd <- lapply(iris[, 3:4], sd)   # standard deviation


# copy the iris data to a new object
my.iris <- iris

# working with missing values
# missing values can cause many headaches
# but there a function available to identify and handle them

# introduce a missing value ("NA") in the iris data
# missing values are represented by "NA". 
# NA is not a text, it is defined as a internal "logical" constant.
# see ?NA

my.iris[1, 3] <- NA
out <- lapply(my.iris[, 3:4], mean)

# as there is one "NA" value, the mean is "NA" as well:
out

# to calculate the mean for columns with missing values, the 
# mean function needs to be told explicitley to remove NA from the sample.
# when options are passed on to a function, the statement becomes more complex:
out <- lapply(my.iris[, 3:4], function(x) mean(x, na.rm = TRUE))
out

# there is a shorthand for this fortunately:
# in many cases, options for the functions can be passed through
out <- lapply(my.iris[, 3:4], mean, na.rm = TRUE)
out
# But the long form with the additional function(x) is useful in many occasions!


# checking for missing values with "is.na"
# calculate the amount of "NA" in columns
# results in either "true" or "false"
is.na(iris[1,1])
is.na(my.iris[1,3])

# sapply returns the result of an "lapply" function in a simplyfied format.
# sapply is a replacement for lapply. Difference is only the output format.
# Compare the two statements below. See ?lapply
lapply(my.iris[, 1:5], function(x) sum(is.na(x))) # returns a list
sapply(my.iris[, 1:5], function(x) sum(is.na(x))) # returns named integers (vector)

# get rid of rows that have any "NA"
my.iris.com <- na.omit(my.iris)

# check the amount of rows
nrow(my.iris.com)

# how many rows did the original iris data have in comparison?
# Find a way to check!

# create a dataframe that indicates "NA" for each individual element
is.na(my.iris[1:nrow(my.iris), ])

# to kick out rows for that thave "NA" in a specific column
my.iris.com <- my.iris[!is.na(my.iris$Petal.Length), ]

# to kick out the first row if it has at least one "NA"
my.iris.com <- my.iris[, !is.na(my.iris[1:]) ]


# aggregate data
aggregate(x = iris, by=list(iris$Species), FUN = mean)

# the above "aggregate" gives errors for non-numeric elements
# see the warnings "returning NA" for the elements in "Species"
# i.e. it is not possible to calculate a mean value from species names.

# Please note as well, that missing values result in a missing mean
aggregate(x = my.iris, by=list(iris$Species), FUN = mean)

# but "aggregate" allows to pass additional arguments to the function
# this is indicated in ?aggregate by the "..." "further arguments passed to or used by methods"
# so, the following works for missing numerics.
aggregate(x = my.iris, by=list(iris$Species), FUN = mean, na.rm = TRUE)

# of course, the complex statement used before works here as well:
aggregate(x = my.iris, by=list(iris$Species), FUN = function(x) mean(x, na.rm = TRUE))


# But there are still errors for the Species names:
# how to apply "aggregate"" to numeric elements only?
# the simple way is to manually indicate the columns that are
# but is there a "better" way?

# First, figure out which element of iris is numeric via:
# check if a column is a factor
col.num <- sapply(iris[, 1:ncol(iris)], is.factor)
col.num

# keep only the numeric columns in this object
# "is.factor" results in FALSE for numeric elements, therefor, "is.factor == FALSE" is the stuff we want to keep
# "which" returns elements of an object for which a test returns TRUE
# return the lements of col.um that have a value of "FALSE"
col.num <- which(col.num == FALSE)

# how to use information from one object to select stuff from another:
# Here we use the names of the values in "col.num" in a selection statement
# See ?match or ?'%in%'
# Value matching via %in% returns a logical vector "returns a logical vector indicating if there is a match or not for its left operand" (from ?'%in').
aggregate(x = iris[, names(iris) %in% names(col.num)],
           by = list(iris$Species),
           FUN = mean)


# Adding a variable to the data
# Recoding exisiting data into a new element in the dataframe
# example with an ifelse statement
iris$my.factor <- ifelse(iris$Petal.Width > 1.5,
                        "Large Petal",
                        "Small Petal")

# check the modified dataframe						
summary(iris)

# recode the characters to factor
iris$my.factor <- as.factor(iris$my.factor)

# check again
summary(iris)

# aggregate over two factors
aggregate(x   = iris[, names(iris) %in% names(col.num)],
          by  = list(iris$Species, iris$my.factor),
          FUN = mean)

# Using another function: 
aggregate(x   = iris[, names(iris) %in% names(col.num)],
          by  = list(iris$Species, iris$my.factor),
          FUN = sd)

# wait - how to do standard error?
# se = sd / sqrt(n)
# from http://cran.r-project.org/doc/manuals/R-intro.html
# [...] Suppose further we needed to calculate the standard errors of the state income means. To do this we need to write an R function to calculate the standard error for any given vector. Since there is an builtin function var() to calculate the sample variance, such a function is a very simple one liner, specified by the assignment:
#     > stderr <- function(x) sqrt(var(x)/length(x))


# But have to account for potential missing values!
# btw var is square of sd (see ?var)
stderr <- function(x) {
              sqrt(var(x[!is.na(x)]) / length(x[!is.na(x)]))
              }

# the same utilising "sd". The previous function is the recommended one in the R FAQ.              
stde.2 <-  function(x) {
              sd(x[!is.na(x)]) / sqrt(length(x[!is.na(x)]))
              }

# use the self-defined functions
aggregate(x   = iris[, names(iris) %in% names(col.num)],
          by  = list(iris$Species, iris$my.factor),
          FUN = stderr)
           
aggregate(x   = iris[, names(iris) %in% names(col.num)],
          by  = list(iris$Species, iris$my.factor),
          FUN = stde.2)

		   
# TO DO
# Find out how to store the results of the stderr aggregation in a new object.
		   
# Find out how to rename the generic names "Group.1" etc to something more meaningful in the new object.

# Find out how to do an anova on Species and Petal size category for the original iris data.

