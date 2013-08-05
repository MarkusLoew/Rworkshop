# Session 6
#
# New RStudio version available: 0.96.304
#
# Comparing means and distributions

data(iris)

# get an overview of the iris data
# Sepal.Length only

# using another member of the apply family
by(iris$Sepal.Length, iris$Species, mean)

# Hypothesis: We assume that the Sepal.Length of setosa is statistically significantly shorter than the Sepal.Length of versicolor.

# grab the mean of versicolor
vers.mean <- as.numeric(by(iris$Sepal.Length, iris$Species, mean)[2])
vers.mean

iris.setosa <- iris[iris$Species == "setosa", ]
iris.versic <- iris[iris$Species == "versicolor", ]

# Hypothesis: Sepal.Length of setosa is equal to the mean of versicolor
# One-sample t-test, the mean of a normally distributed population has a value specified in a null hypothesis.
t.test(iris.setosa$Sepal.Length, mu = vers.mean)

# i.e. null-hypothesis rejected, as p < 0.05, alternative hypothesis applies.

# or hypothesis: Sepal.Length or setosa is 5 mm:
t.test(iris.setosa$Sepal.Length, mu = 5)

# or testing the two samples directly
# Welch-Test, Two sample t-test
t.test(iris.setosa$Sepal.Length, iris.versic$Sepal.Length)

# t.test does not assume equal variances!
# see ?t.test
# to use equal variances, specify it via var.equal = TRUE
# Student's t-test
t.test(iris.setosa$Sepal.Length, iris.versic$Sepal.Length, 
        var.equal = TRUE)

# Assuming setosa and versicolor are observations on the same subject, a paired t-test can be applied.
# I.e. to investigate values before and after an experiment
# Paired t-test
t.test(iris.setosa$Sepal.Length, iris.versic$Sepal.Length, 
        paired = TRUE)


# Is data normally distributed?
# Testing normality is controversial.
# quite often, statistical procedures are quite robust.
# In some cases tests for normality are required, in other cases a visual test is sufficient.
# histogram
hist(iris.setosa$Sepal.Length)

# In general, relying on any p-value can be misleading. Unfortunately, p-values are currently still mandatory in many science areas.
# In many cases, tests for normality are a waste of time as many statistical procedure are quite robust against violations as long as the design is balanced. However, reviewers or supervisors might have a different opinion regarding normality and heterogeneity of variances!
# For small sample sizes, these tests are not reliable, and might not detect huge deviations from normally distributed data.
# But have a look at the following video on p-values
# http://www.youtube.com/watch?v=ez4DgdurRPg
# by Geoff Cumming, "The New Statistics"
# and how misleading they can be.

# create a normal distribution around a mean with specific standard deviation
# and see the probability for a randomly selected value from the distribution is to be equal or less than 5 or 8.5
pnorm(5, mean = 9, sd = 2)
pnorm(8.5, mean = 9, sd = 2)
pnorm(9, mean = 9, sd = 2) # remember it is equal or less than!

# plot the distribution
plot(dnorm, -4.5, 4.5)

# visual method: check for linearity in the relationship of sample versus normal distribution
# qq-plots
qqnorm(iris$Sepal.Length)
qqline(iris$Sepal.Length)

# Testing for normality if you need a p-value
shapiro.test(iris$Sepal.Length) # it is quite likely that the data is normally distributed


# Test if data came from a the same distribution
# Two-sample Kolmogorov-Smirnov test
ks.test(iris.setosa$Sepal.Length, iris.versic$Sepal.Length) # complains about ties
# but it is likely that the data came from the same distribution

# Test for homogeneity of variances across groups
library(car)
leveneTest(iris$Sepal.Length, iris$Species) 



# significant, i.e. homogeneity of variances is not probable: The difference in variance is statistically significant

# alternative: bartletts test
bartlett.test(iris$Sepal.Length, iris$Species) # similar result, variance is not the same.

# In cases when normality can not be assumed and when the variance is not homogeneous (and when the design is not perfectly balanced), check the qqplots and potentially consider transforming the data (see above).

# Transforming data
# typical transformations are
# square root sqrt(), logarithmic log(), inverse 1/x, arcsine asin(), ...
# or see the following paper on Box-Cox transformation (power transformations)
# See Osborne J. 2010. Improving your data transformations: Applying the Box-Cox transformation. Practical Assessment, Research & Evaluation 15: 1-7.
# implemented in R via ?bcPower (and yjPower). Box-Cox transformation allows a wide range of transformations in a self-written function that combines bcPower and shapiro.wilk to optimise the "lambda" factor of the power transformations.


# For non-normal data use non-paramteric tests.
# replacement for t-test:
# Wilcoxon
wilcox.test(iris.setosa$Sepal.Length, iris.versic$Sepal.Length)

# replacement for ANOVA:
# Kruskall-Wallis rank sum test
kruskal.test(iris$Sepal.Length ~ iris$Species)


# Repeated measurement ANOVA, i.e. linear mixed model.
# Block design, mixed model

# example from ?aov
# block design
data(npk)
?npk
summary(npk)

my.aov <- aov(yield ~  N * P * K + Error(block), data = npk)
summary(my.aov)

# Gives results for the subject "block" (repetitions) and
# gives results for the within block treatments

# for example sampling designs see ebook
# Doncaster, C. Patrick. "Analysis of variance and covariance [electronic resource] : how to choose and construct models for the life sciences"
# from the library.
# 
