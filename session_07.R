# Session 7
# open session, Q&A, questions from the participants

# a repetition regarding "selecting data"
x <- c("A", "B", "C")
y <- c(1, 2, 3)

df <- data.frame(x, y)

df[, 2]

# select elements, where x is either A or C
df[df$x == "A" | df$x == "C", ]

# Selection symbols and their meaning:
# & means AND
# | means OR
# != means NOT (to negsate the outcome of a function use "!" alone without the "="

# working with NA
x <- 1:10
x[4] <- NA

# assign something to the NA value
# chack all elements of for NA
is.na(x)

# show the number of the element that is NA
which(is.na(x))

# replace any NA from x with the value 15
x[which(is.na(x))] <- 15
x

# replace any NA within x with Hi there
x[which(is.na(x))] <- "Hi there"
x

# be very careful, as it is not possible to have characters and numbers in the same object
# check the class of the object.
class(x) # results to "character"
# that means that it is now impossible to do math with the elements of x, as they are nor just characters.
# do not mix numbers and characters!

# GEt a list of letters
# Capitals
LETTERS[1:5]
# small letters
letters[1:5]

# testing and selectiing with characters
x <- LETTERS[1:5]

# which element of C is C?
which(x == "C")

# replace all C in x with "Hi there"
x[which(x == "C")] <- "Hi there"


# manual boxplots, potential use for outlier classification
x <- c(2, 12, 4, 6, 15, 35)

# a distribution can be investigsated via its quantiles
quantile(x)

x <- c(1, 2, 5, 8, 9, 10, 21)
quantile(x)

# calculate the interquartile range
IQR(x)

# lower limit for potential outliers
quantile(x, names = F)[2]  - 1.5 * IQR(x)

# upper limit
quantile(x, names = F)[4]  + 1.5 * IQR(x)

# create a boxplot
boxplot(x)
