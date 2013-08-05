# Session 8
#
# advanced functions
# extracting information from summaries
# converting objects (lists to data frames, etc)
# and more ggplot2 goodness

# extracting elements from summary functions

# load the iris data
data(iris)

# does Species change Sepal width?
# using a one-way Anova
my.aov <- aov(Sepal.Width ~ Species, data = iris)

# print the summary of the analysis
summary(my.aov)

# as in many R objects, summaries object allow to access their components by name
# check the available elements of an object with "str()".

str(summary(my.aov))

# or put the summary into a new object and work with the new object
my.aov.summary <- summary(my.aov)
str(my.aov.summary)

# summary provides "Df", "Sum Sq", "Mean Sq", "F value", and "Pr(>F)" values for an anova.

# to grab the p-value from our "my.aov" object:
# from the structure of the summary, we know that we have a list of 1 element with 2 observations and five variables
# the bracket notation has a specific operator to select single elements from a list: "[[]]"
# this is not very helpful for data frames, it is very handy for lists
# see the help for ?'[['

# get the first element of the list 
summary(my.aov)[[1]] # which is not different from "summary(my.aov)" or "summary(my.aov)[1]"

# The first object in the list are the "degrees of freedom Df". See str(my.aov)
summary(my.aov)[[1]][1]

# this can be seen as grabbing the first column from the summary table

# the double square brackets will drop the names of the extracted objects, which can be very handy.
# compare this code with the last:
summary(my.aov)[[1]][[1]]

# from this, we can further select the first or second degrees of freedom value
summary(my.aov)[[1]][[1]][1] # returns the first degrees of freedom values
summary(my.aov)[[1]][[1]][2] # returns the second df value

summary(my.aov)[[1]][[1]][2]

# so basically we are extracting the second element from the first list of the first element of the summary of my.aov.

# it is possible to use the names of the elements as well.
summary(my.aov)[[1]][["Df"]]
summary(my.aov)[[1]][["Df"]][2]

# now the p-value
summary(my.aov)[[1]][["Pr(>F)"]]
summary(my.aov)[[1]][["Pr(>F)"]][1]

# now for an nls object
# using Loblolly data
data(Loblolly)

# re-doing a non-linear lest squares fit
# see session 02!

# do the curve fit
nls.fit <- nls(height ~ (a * age) / (b + age),
              data = Loblolly,
              start = c(a = 10, b = 15))
summary(nls.fit)


# check the structure of the summary of the curve fit
str(summary(nls.fit))

# the summary returns a list of eleven elements
# the object "coefficients" in the summary(nls.fit) is s list of two rows with four elements
# the names are given as well as a list of 2 (two names for teh rows, four names for the columns)

# We want the standard error of the estimates.
# a starting point is to use the names of the object
summary(nls.fit)$coefficients

# then we break it down further:
# using the square brackets notation.
summary(nls.fit)$coefficients[, "t value"] # returns both values and their names
summary(nls.fit)$coefficients[, "t value"][2] # returns only the second one with names
summary(nls.fit)$coefficients[, "t value"][[2]] # returns only the second one without names

# now we are only selecting the row for parameter "a" and the column with the "Std. Error"
summary(nls.fit)$coefficients[["a", "Std. Error"]]

# and so on:
summary(nls.fit)$coefficients[["b", "Std. Error"]]

# curve fit in a loop over all Loblolly seed types
data(Loblolly)

# creating a function that does a nls fit for each unique treatment
# see the "nls.fit" code as reference
nls.fit <- nls(height ~ (a * age) / (b + age),
              data = Loblolly,
              start = c(a = 10, b = 15))
summary(nls.fit)

# Now we make it more generic:
# a function for nls curve fit
# includes the code to calculate a "fake R2" for nls-fits that Nina found.

FitHyperbel <- function(x, y) {
        nlsfit <- nls(y ~ (a * x) / (b + x),
                      start = c(a = 10, b = 15))
        
        # within the function we extract everything we are interested in:
        # i.e. coefficients and their standard error and the R2 of the fit. 
        # to make it look beautiful, we provide names to our results.
        coefs        <- coef(nlsfit)
        coef.error.a <- summary(nlsfit)$coefficients[["a", "Std. Error"]]
        coef.error.b <- summary(nlsfit)$coefficients[["b", "Std. Error"]]
        r2           <- 1 - (var(residuals(nlsfit)) / var(y))

        # functions can only return one object
        # therefore we stuff everything we want in one object
        out <- c(coefs, coef.error.a, coef.error.b, r2)
        # we give each element in our "out"-object a name
        names(out) <- c("a", "b", "Std_Error_a", "Std_Error_b", "R2")
        return(out)
}

# then we run our function
my.result <- FitHyperbel(Loblolly$age, Loblolly$height)

# show the my.result object
my.result

# the object "my.result" contains the data in the format and order that we specified in the function. Compare with the output from "summary(nls.fit)".

# Now we can run the function on each treatment in a loop via lapply.
# first, we get rid of the old "my.result" object.
rm(my.result)

# then apply the function to each unique element of "Seed"
my.result <- lapply(split(Loblolly, Loblolly$Seed), 
                    function(x) FitHyperbel(x = x$age, y = x$height))
my.result

# Problem right there: the nls fit fails for at least one Seed type!
# And the the fit_hyperbel function stops without returning any result!!!

# Check the data visually using the ggplot code from session 02:
library(ggplot2)
p <- ggplot(Loblolly, aes(x = age, y = height))
        p <- p + theme_bw()
        p <- p + facet_grid(. ~ Seed)
        p <- p + geom_smooth(colour = "black", 
                method  = "nls", 
                formula = y ~ (a * x) / (b + x), 
                se      = F, 
                start   = list(a = 10, b = 15))
        p <- p + geom_point(aes(colour = Seed))
p

# We can see from the figure, that the fit fails for the Seed type "321"

# With this information, we can apply the function only to the Seed types that can be fitted with our function. Or we can change the starting parameters for "a" and "b", etc...

# going down the easy road here and remove "321" from the data
# we have to jump thought some hoops here, as "Loblolly" is provided as "Grouped Data"
# and we have to make sure we remove the reference to the factor "321" by re-specifying the factor.

my.Loblolly      <- as.data.frame(Loblolly[Loblolly$Seed != "321", ])
my.Loblolly$Seed <- as.factor(as.character(my.Loblolly$Seed))

my.result <- lapply(split(my.Loblolly, my.Loblolly$Seed), 
                    function(x) FitHyperbel(x = x$age, y = x$height))
my.result
# Now the funtion returns results.

# Let's check what our "my.result" object is:
str(my.result)

# It consists of 13 lists (one for each Seed type in our reduced data) 
# and each list has a 5 named numerics.
# But it is compatible to a data frame, and it just a matter of some quick reformating
df.my.result <- as.data.frame(my.result)
df.my.result

# Probably easier to read after transposing:
tdf.my.result <- as.data.frame(t(df.my.result))

# The Seed information is given as rownames. We can pull the rownames back into a column of the data frame.
tdf.my.result$Seed <- rownames(tdf.my.result)
# Regarding the names: Please remember that names in R can not start with a number!

# Visualise the fit-results with ggplot
# as we have massive curve-fit errors, we show the errorbars in the graph:
limits <- aes(ymax = a + Std_Error_a,
              ymin = a - Std_Error_a)

p <- ggplot(tdf.my.result, aes(x = Seed, y = a))
        p <- p + theme_bw()
        p <- p + geom_bar()
        p <- p + geom_errorbar(limits, colour = "red")
p

# Relationship between a and b
p <- ggplot(tdf.my.result, aes(x = a, y = b))
        p <- p + geom_point(aes(colour = Seed))
p

# So we got the fitted values for each Seed group in one table.
# But it would be good to have a function that ignores the subset of data that it can not fit.
# The function needs a a subroutine to check 
# a) if a fit was successful
# b) return "NA" for the cases in which the fit fails

# function for nls curve fits
FitHyperbel <- function(x, y) {
        nlsfit <- try(nls( y ~ (a * x) / (b + x),
                      start = c(a = 10, b = 15)))
        # test to see if the fit was sucessful
        # if the fit failed, all results are set to NA                      
        if (inherits(nlsfit, "try-error")) {
             coefs        <- c(NA, NA)
             coef.error.a <- NA
             coef.error.b <- NA
             r2           <- NA
             }
        # in the case the fit was succesful, the actual results are used     
        else {coefs        <- coef(nlsfit)
              coef.error.a <- summary(nlsfit)$coefficients[["a", "Std. Error"]]
              coef.error.b <- summary(nlsfit)$coefficients[["b", "Std. Error"]]
              r2           <- 1 - (var(residuals(nlsfit))/var(y))
             }
             
        out <- c(coefs, coef.error.a, coef.error.b, r2)
        names(out) <- c("a", "b", "Std_Error_a", "Std_Error_b", "R2")
        return(out)
}

# apply the function to the original Loblolly data
my.result <- lapply(split(Loblolly, Loblolly$Seed), 
                    function(x) FitHyperbel(x = x$age, y = x$height))

my.result

# just for fun, the same via the "by" function:
# there are always multiple ways to do something.
by(Loblolly, Loblolly$Seed, function(x) FitHyperbel(x = x$age, y = x$height))
