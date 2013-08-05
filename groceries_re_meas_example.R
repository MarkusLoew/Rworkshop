# this is "just" another element of the standard anova function.
# following an example from
# http://ww2.coastal.edu/kingw/statistics/R-tutorials/repeated.html
# here.

groceries <- data.frame(
     c("lettuce","potatoes","milk","eggs","bread","cereal",
       "ground.beef","tomato.soup","laundry.detergent","aspirin"),
     c(1.17,1.77,1.49,0.65,1.58,3.13,2.09,0.62,5.89,4.46),
     c(1.78,1.98,1.69,0.99,1.70,3.15,1.88,0.65,5.99,4.84),
     c(1.29,1.99,1.79,0.69,1.89,2.99,2.09,0.65,5.99,4.99),
     c(1.29,1.99,1.59,1.09,1.89,3.09,2.49,0.69,6.99,5.15))
colnames(groceries) <- c("subject","storeA","storeB","storeC","storeD")
groceries

summary(groceries)

groceries2 <- stack(groceries)
subject <- rep(groceries$subject,4)        # create the "subject" variable
groceries2[3] <- subject                   # add it to the new data frame
rm(subject)                               # clean up your workspace
colnames(groceries2) <- c("price", "store", "subject")    # rename the columns
groceries2

with(groceries2, tapply(price, store, sum))

# The same subject was measured multiple times with the same method (price).
# I.e the same question was asked multiple times in repeated treatments.
# The response (a function of the treatment) is the price.

# With an anova we can compare within-subject and between subject effects:
# within: are there differences in price of the same subject?
# between: are there differences in price between the subjects?

# standard anova to test for the price as a function of the store.
aov.out <- aov(price ~ store, data = groceries2)
summary(aov.out)

# now adjusting the test to consider the nesting of stores for each subject.
aov.out <- aov(price ~ store + Error(subject/store), data = groceries2)
summary(aov.out)

# Dependend t-test (paired) for all "treatments"
pairwise.t.test(groceries2$price, groceries2$store, paired = TRUE)
