# session_02.R

# set working directory
# setwd("x:/path/to/your/folder")
setwd("/home/loewi/Prac/R_demo")

# load the iris data set
data(iris)

# From the previous session:
# Adding a variable to the data
# Recoding exisiting data into a new element in the dataframe
# example with an ifelse statement
iris$my.factor <- as.factor(
                        ifelse(iris$Petal.Width > 1.5,
                        "Large Petal",
                        "Small Petal"))
                                       
# Run an anova
my.anova <- aov(Sepal.Length ~ Species * my.factor, data = iris)

# the "data" option is for convenience. Of course you can use the statement below as well.
my.anova <- aov(iris$Sepal.Length ~ iris$Species * iris$my.factor)

# a standard anova result table is given via "summary"
summary(my.anova)

# investigate the results of the anova some more:
plot(my.anova)

# To create a plot window for 2 graphs in two rows
par(mfrow=c(2,2))
# investigate the results of the anova some again:
plot(my.anova)

# set it back to 1 graph in one row
par(mfrow=c(1,1))

# if there is no need to check for interactions between two factors,
# use "+" instead of "*"
my.anova <- aov(Sepal.Length ~ Species + my.factor, data = iris)
summary(my.anova)

# to test several parameters from a data frame
# create a function that does the anova
my.aov <- function(x) {
          out.aov <- summary(aov(x ~ iris$Species * iris$my.factor))
}

# using lapply (the columns that we want to test are given to lapply as a list)
my.aov.res <- lapply(iris[, 1:4], function(x) my.aov(x))


# to check a linear regression model:
my.lm <- lm(Sepal.Length ~ Petal.Width, data = iris)
summary(my.lm)
summary.lm(my.lm)

# to see the coefficients only
coef(my.lm)

# How to extract elements from such results?
# what are the elements that coef() returns?
names(coef(my.lm))

# put the coefficients in a new object
my.coef <- coef(my.lm)

# grab the value of the Intercept
my.coef["(Intercept)"]
# or slope
my.coef["Petal.Width"]


# visualise the data
# via plot from the "graphics" package of any base R installation
plot(Sepal.Length ~ Petal.Width, data = iris)

# plot is a very generic function with many applications
# i.e. it is possible to plot a (small) dataframe
# this gives a quick visualisation of all data, potential correlations...
# don't try this with lots of data: it will not fail, but it can take a long time
# and the resulting figure might not have the resolution on screen to see much.
plot(iris)

# but back to the specific plot of two variables
plot(Sepal.Length ~ Petal.Width, data = iris)

# instead of point, it is possible to use lines:
plot(Sepal.Length ~ Petal.Width, data = iris, type = "l")

# but again back to the points plot
plot(Sepal.Length ~ Petal.Width, data = iris)

# add the regression line that we calculated earlier to the plot
abline(my.lm)

# add a line with slope "1" and intercept "4.5" for illustration purposes
# "col" specifies colour
# "lty" specifies linetype
# "lwd" specified line width
abline(a = 4.5, b = 1, col = "green", lty = "dashed", lwd = 5)

# check colours() for available colours
# see for example http://wiki.stdout.org/rcookbook/Graphs/Shapes%20and%20line%20types/
# for symbols, linetypes, etc...
# or check the lty section in ?par for linetype names

# use different symbols
# "pch" specify point characters
# check the above website, some of the symbols allow a background via "bg = colourname"

# A more complex graph
# extend standard margins to allow space for a nice y-axis label
# default margins are "par()$mar" of 5.1, 4.1, 4.1, 2.1 lines
par(mar=c(5.1, 6, 4.1, 2.1))
plot(Sepal.Length ~ Petal.Width, 
     xlim = c(0, 4),  # manually defined x-axis range
     ylim = c(0, 8),  # manually defined y-axis range
     data = iris,
     xlab = "Petal width [cm]", # axis label independent of name in data frame
     ylab = expression("Fancy function"~sqrt(x^2)~CO[2]%+-%~sd), # just for show
     pch  = 23,
     bg   = "green")
# check "demo(plotmath)" for writing expressions

# add more data to the plot
# this is done without calling "plot" again!
points(Sepal.Width ~ Petal.Width, 
        data = iris,
        pch  = 4,
        col  = "blue" )

# add the linear model to the plot
abline(my.lm, col = "red", lty = "dashed", lwd = 2)

# add a 1:1 line
abline(a = 0, b = 1, lty = "dotted")

# build a legend
legend(2.6, 2.5, 
        c("Sepal length", "Sepal width", "Abline length", "1:1"),
        pch = c(23, 4, NA, NA),
        lty = c(NA, NA, "dashed", "dotted"),
        cex = 0.8 # make the characters slightly smaller than standard text
        )

# regarding modifying tick labels (i.e. rotating...)
# it involves creating the labels manually: see 
# http://cran.r-project.org/doc/FAQ/R-FAQ.html#How-can-I-create-rotated-axis-labels_003f

# I'll introduce the Grammar of Graphics (ggplot2) later in the seminar
# this package allows to modify many elements of plots and offers options
# that are not available in the base plots.
# but for now we stick with base graphics.

# another very useful type of graph is a boxplot
# boxplot allows a quick overview on data, look for potential outliers, ...
boxplot(Petal.Length ~ Species, data = iris)

# show aggregation of two factors as boxplot
boxplot(Petal.Length ~ Species * my.factor, data = iris)

# --------------------------------------
# This is were we stopped at the end of the session on July 24
# --------------------------------------

# How to save a graph to a file
#
# R uses "Devices" for output.
# Standard device is the screen, but the output can always be redicrected to anover device.
# the principle is, that first a "device" is opened, then something is written to this device
# and then the device is closed.

# Example
plot(Sepal.Length ~ Petal.Width, data = iris)

# to get a png image of this graph in the current working directory
# open the png device
png("myplot.png")

# then create the plot
plot(Sepal.Length ~ Petal.Width, data = iris)

# and close the device
dev.off()

# default size of a picture device is 640x480 pixels
# to change that provide information on the desired size
png("myplot_1024.png", width=1024, height=768)
plot(Sepal.Length ~ Petal.Width, data = iris)
dev.off()

# change the resolution in dpi
png("myplot_1024_high_res.png", width=1024, height=768, res = 150)
plot(Sepal.Length ~ Petal.Width, data = iris)
dev.off()

# With resolution and width/height information, the image can be tweaked
# according to journal layout specifications (e.g. figure should be one 
# column wide in the printed paper or so), etc...

# it is much easier to use vector based image formats (svg, wmf, pdf) 
# compared to bitmap based ones (png, gif, tif, bmp, jpg)
# BTW never, ever use jpg for figures. It is a lossy format and will look bad.
# jpg was designed to be used with photos, not for images with few colours and clear lines!

# my preferred way to export figures is via the pdf
# pdf is based on postscript, which is vector based.
# vector based images do not have a fixed rsolution, they can be scaled without losing information
# also, vector based figures can easily be modified later if additional information has to be added outside of R.
pdf("myplot.pdf")
plot(Sepal.Length ~ Petal.Width, data = iris)
dev.off()

# change the size of the pdf (given in inches)
pdf("myplot_larger.pdf", width = 15, height = 8)
plot(Sepal.Length ~ Petal.Width, data = iris)
dev.off()

# create a scalable vector graphic
svg("myplot.svg")
plot(Sepal.Length ~ Petal.Width, data = iris)
dev.off()

# For further information on saving a graph see:
# http://wiki.stdout.org/rcookbook/Graphs/Output%20to%20a%20file/


# The "sink" device can be used to dump text into a file on the harddrive
# i.e. to store the previous anova results as a file redirect them to a text file
sink(file = "my_anova_results.txt")
print(my.aov.res)
sink()

# always remember to turn "sink" off via "sink()"!!



# Non-linear least squares
# curve fitting

# load the Loblolly pine example data set
data(Loblolly) 

# do the usual checks
summary(Loblolly)
dim(Loblolly)

# create simple overview graph
plot(height ~ age, 
        data = Loblolly)

# allow some space beyond the current x and y range
plot(height ~ age, 
        data = Loblolly,
        xlim = c(0,100),
        ylim = c(0,100))

# do a nls curve fit
nls.fit <- nls(height ~ (a * age) / (b + age),
              data = Loblolly,
              start = c(a = 10, b = 15))
summary(nls.fit)

# grab the coefficients

my.coef <- coef(nls.fit)
my.a <- my.coef[1] # or use my.coef["a"]
my.b <- my.coef[2] # or use my.coef["b"]

# add a curve based on the coefficients to the figure
curve( (my.a * x) / (my.b + x), 
        from = 0, 
        to   = 100, 
        add = TRUE)

# a second method to add the curve is available via "predict"
# see ?predict.nls
xValues <- seq(min(0), max(100), length.out = 100)  # create a sequence from 0 to the desired max x-value with 100 elements

# predict values from the nls.fit. 
# Predict expects a dataframe "in which to look for variables with which to predict". 
# Name has to match the nls model for the independent variable / predictor.
my.predicted <- predict(nls.fit, data.frame(age = xValues))

# use lines to connect the predicted values. 
lines(xValues, 
        my.predicted, 
        col = "red") 

# possible with the fucntion "plotfit" from package "nlstools" as well
# if the package is not installed do
# install.packages("nlstools", dep = TRUE)
# then load the package via "library()"
library(nlstools)

# create a plot with a fitted curve
# "smooth"" must be set to "TRUE" to request fitted values
plotfit(nls.fit, 
        smooth = TRUE)
        
# as other functions, plotfit allows to pass parameters to underlying functions
# this is (as usual) indicated by "..." in the helpfile ?plotfit
# we can adjust the plotted range via

plotfit(nls.fit, 
        smooth = TRUE,
        xlim   = c(0, 100),
        ylim   = c(0, 100))
        
