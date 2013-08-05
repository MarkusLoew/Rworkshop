# Session 1
# working with dataframes
# getting information on data
# selecting data

File is also available at:
# http://rpubs.com/MarkusLoew/

# open the "iris" dataset provided with R
data(iris)

# Display the data
iris

# That is too much information on the screen
# Now, let's have a look at the start of the data.
# display the first six rows of the data
# have a look at the start of the data.
# display the first six rows of the data
head(iris)

# display the end of the data
tail(iris)

# get information on the structure of the data
str(iris)

# dimensions of the data (# rows, # columns)
dim(iris)

# number of rows
nrow(iris)

# number of columns
ncol(iris)

# what kind of an object is the iris data?
class(iris)

# get a summary for the data
summary(iris)

# what names do the individual elements have?
names(iris)

# get a summary for a named element
# the exact name of an element is given by its parent
# object and its name separated by "$"
summary(iris$Petal.Width)

# calling just the name of an element prints it on
iris$Petal.Width 
iris # print the complete data set
iris$Species # prints the Species column of the iris data

# names are case sensitive!!
# the following returns an empty result
summary(iris$Petal.width)


# select parts of the data
# selecting data is based on rows and columns
# criteria for rows and columns are separated by a single ","
# iris[rows, columns]

# select the element in the first row of the first column
iris[1, 1]

# select the element in the second row of the first column
iris[2, 1]

# select the element in the first row of the third column
iris[1, 3]

# select the first three rows of the first column
iris[1:3, 1]

# select the first four columns in the first row
iris[1, 1:4]

# select the first three rows and first four columns
iris[1:3, 1:4]

# try out the following examples
iris[2, 3]
iris[2, 2:4]
iris[50:67, 3]

# select by column name
iris[1, "Petal.Length"]

# select multiple columns by name via the concatenate "c" function
iris[1, c("Petal.Length", "Petal.Width")]

# select multiple rows by number and multiple columsn by name.
iris[3:5, c("Petal.Length", "Petal.Width")]

# select only specific rows and all columns
# note the empty element after the comma! That means no selection regarding columns is made.
# second row, all columns
iris[2, ]

iris[12, ]
iris[1:5, ]
iris[, 2:3] # empty before the comma!

# select specific, non-neighbouring elements
iris[2, c(1, 3, 5)]

# the "c" (concatenate) combines several values into a vector (see above)
iris[1:3, c(1, 3, 5)]
iris[c(1, 2, 3), c(1, 3, 5)] # the same as previous!
iris[c(1, 8, 10), c(1, 3, 5)]
iris[c(2:5, 79, 101), c(1, 3, 5)]


# select elements via expressions

# show all rows with Sepal.Length elements above 5.5
# no selection of columns: empty after comma!
iris[iris$Sepal.Length > 5.5, ]
iris[iris$Sepal.Length >= 4.9, ]
iris[iris$Sepal.Width  <= 3.1, ]
# "=" must be given as "==" for relational parameters
#  for an exact match
iris[iris$Sepal.Width  == 3.1, ]

# two expressions
iris[iris$Sepal.Width  <= 3.1 & iris$Petal.Length > 6, ]

# selecting rows and columns
iris[iris$Sepal.Width  <= 3.1 & iris$Petal.Length > 6, 4]

# index applies to the found elements
# the following results in a "NULL" result. There is not any 
# element that matches the criterium! There is no column 
# with the number 100!
iris[iris$Sepal.Width  <= 3.1 & iris$Petal.Length > 6, 100]

# put the elements of iris that match my criteria to a new data frame called "good.result"
good.result <- iris[iris$Sepal.Width  <= 3.1 & iris$Petal.Length > 6, 2]


# select elements by matching characters
# note the "==" for a relational parameter
iris[iris$Sepal.Width  <= 5 & iris$Species == "virginica", ]


# "!=" indicates "is not"
iris[iris$Sepal.Width  <= 2.5 & iris$Species != "virginica", ]


# import your own data
# it is recommended to start with a comma seperated text file
# "*.csv" for this.
# Try a small data set first to testing

# import of a csv-file is done via "read.csv"
# we import the file into an object named "df"
# Imported csv tables are internally stored as data frame.

# For easy import, your data should have a single header line 
# in the first line.
# The columns in the file should be separated by ","

df <- read.csv("/location/to/the/file/your_data.csv", header = TRUE, sep = ",")
# even on windows computers, the "/" should be used
df <- read.csv("C:/very/long/path/your_data.csv", header = TRUE)

# depending on your platform, "file.choose()" might work
# to open the file via a graphical file-selection dialog
df <- read.csv(file.choose(), header=TRUE)

# now try the above summaries and selections on your own data
# start with a summary
summary(df) 

# Enjoy!
# Markus


