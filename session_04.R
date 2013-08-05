# Session 04

setwd("/home/loewi/Prac/R_demo")

# load the iris data
data(iris)

plot(Sepal.Length ~ Petal.Width, data = iris)

# create a custom graph
# allow additional space on the left for a secondary axis
par(mar=c(5.1, 6.1, 4.1, 6.1))

plot(Sepal.Length ~ Petal.Width, 
     data = iris,
     axes = FALSE,            # no axes at all (as usual, axes = F is a shorthand)
     ylab = "",               # no y-axis label
     xlab = "My label",       # a custom x-axis label
     cex  = 1.5)                 # change size of the symbols

# adding the x-axis
axis(side = 1,                     # bottom side of plot
     at   = c(0, 0.6, 1, 2, 2.5),  # custom tick positions
     font = 3)                     # The font "face" (1=plain, 2=bold, 3=italic, 4=bold-italic)

# adding a secondary y-axis with inward facing ticks
axis(side = 4,                  # right hand side
     tck  = 0.1,                # tick length and direction, play with different numbers!
     col  = "blue",             # blue lines
     col.ticks = "grey",        # grey ticks
     lwd  = 5,                  # line width
     lwd.ticks = 1.4)
     
# right hand side axis label
mtext("Fun axis label", 
       side   = 4, 
       padj   = 2.5, 
       family = "serif", 
       font   = 2, 
       cex    = 1,           # Magnification of the axis annotation relative to "cex"
       col    = 611)         # see colors()[611]

# To change the orientation of the label relative to the axis 
# use "las = " with one number of 0 - 3. # see ?par 

# now adding a second plot to the graph
par(new = TRUE)
plot(Sepal.Width ~ Petal.Width,
     data = iris,
     col  = "orange",
     pch  = 2,
     axes = F,
     xlab = "",
     ylab = "")


# fonts vary by device! Normally, R does not embed the fonts in the file!
# that means that the fonts need to be available on each computer to be displayed correctly.
# There are universally available fonts:
# see names(pdfFonts()) for a list of fonts available in pdf

axis(side = 2,
     tck  = -0.03)

mtext("Courier font",
      side = 2,
      family = "Courier",
      padj = -4.5)

mtext("Schoolbook font",
      family = "NewCenturySchoolbook")

# add some text labels:
text(0.2, 4.2,               # position in plot coordinates, refers to the last plot!!
     "(õö)",                 # Umlauts can be used 
     cex    = 1.66,          # magnification
     font   = 2,             # font face 2 = bold
     family = "AvantGarde")

# for Windows-specific fonts, have a look at the brand-new "extrafont" package
# just released July 8, 2012! see:
# http://cran.r-project.org/web/packages/extrafont/index.html

# barplot
# the height of the bar has to be provided as a vector, a data frame does not suffice by itself
# but referencing a single column from the data frame works:

# calculate the means
iris.mean <- aggregate(x = iris, by = list(iris$Species), FUN = mean)

# create a simple barplot
barplot(iris.mean$Sepal.Length)

# with some customisation
barplot(iris.mean$Sepal.Length,
        axisnames = TRUE,
        names.arg = iris.mean$Group.1,           # use names from specific column  
        # names.arg = c("one", "two", "three"),  # to specify any names
        ylim = c(0, 8),                          # y-axis limits
        xlab = "Species",
        ylab = "Mean Sepal length [cm]")

# with error bars:
iris.sd <- aggregate(x = iris, by = list(iris$Species), FUN = sd)

# put the plot in an object, so we can use it in the next step.
my.plot <- barplot(iris.mean$Sepal.Length,
        axisnames = TRUE,
        names.arg = iris.mean$Group.1,
        ylim = c(0, 8),
        xlab = "Species",
        ylab = "Mean Sepal length [cm]")


# using "arrows" to draw error bars
arrows(my.plot,
       iris.mean$Sepal.Length - iris.sd$Sepal.Length,
       my.plot,
       iris.mean$Sepal.Length + iris.sd$Sepal.Length,
       length = 0.2,
       angle  = 90,
       code   = 3)

# however, there are heaps of options available to draw error bars. See 
# http://cran.r-project.org/doc/FAQ/R-FAQ.html#How-can-I-put-error-bars-or-confidence-bands-on-my-plot_003f


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# "Beautiful, hassle-free plots:"
# the ggplot2 package implementing the Grammar of Graphics in R.
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# install.packages("ggplot2")
library(ggplot2)


# from the abstract of the ggplot book:
# ggplot2 is an R package for producing statistical, or data, graphics, but it is unlike most other graphics packages because it has a deep underlying grammar. This grammar, based on the Grammar of Graphics (Wilkinson, 2005), is composed of a set of independent components that can be composed in many different ways. This makes ggplot2 very powerful, because you are not limited to a set of pre-specified graphics, but you can create new graphics that are precisely tailored for your problem. 

# see the many examples at
# http://had.co.nz/ggplot2/ and http://had.co.nz/ggplot2/docs/
# or book Wickham (2009) ggplot2 : elegant graphics for data analysis. Springer, available as electronic resource from the library catalogue.

# A simple x-y scatter plot
# "aesthetics" describe how variables in the data are mapped to aesthetic properties.
# Variables are mapped to aesthetics via "aes".
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)) + geom_point()

# barplot from pre-calculated values
p <- ggplot(iris.mean, aes(x = Group.1, y = Sepal.Length))
        p <- p + geom_bar()
p

# errorbars:
my.limits <- aes(ymax = iris.mean$Sepal.Length + iris.sd$Sepal.Length, 
                 ymin = iris.mean$Sepal.Length - iris.sd$Sepal.Length)
                 
# barplot with error bars
# ggplot works with layers. Two layers in this plot: the bars, and the error bars.
p <- ggplot(iris.mean, aes(x = Group.1, y = Sepal.Length))
        p <- p + geom_bar()
        p <- p + geom_errorbar(my.limits, width = 0.33)
p

# additional formatting
p <- ggplot(iris.mean, aes(x = Group.1, y = Sepal.Length))
        p <- p + geom_bar(fill = "white", colour = "black")
        p <- p + geom_errorbar(my.limits, width = 0.33, colour = "orange")
        p <- p + labs(x = "Species", y = "Sepal length [cm]")
        p <- p + theme_bw()
p

# plot with error bars without calculating means manually
# and another way of writing the code
p <- ggplot(iris, aes(x = Species, y = Sepal.Length))
        p <- p + stat_summary(fun.data = mean_sdl, mult = 1)
p

# adding bars from another data frame
p <- ggplot(iris, aes(x = Species, y = Sepal.Length))
        p <- p + geom_bar(data = iris.mean, 
                        aes(x = Group.1, y = Sepal.Length, fill = Group.1))
        p <- p + stat_summary(fun.data = mean_sdl, mult = 1)
p

# changing the name of colour fill legend
# again several layers, now referencing two data frames
p <- ggplot(iris, aes(x = Species, y = Sepal.Length))
        p <- p + geom_bar(data = iris.mean, 
                        aes(x = Group.1, y = Sepal.Length, fill = Group.1))
        p <- p + stat_summary(fun.data = mean_sdl, mult = 1)
        p <- p + scale_fill_discrete(name = "My Legend")
p

# manually defined colours
p <- ggplot(iris, aes(x = Species, y = Sepal.Length))
        p <- p + geom_bar(data = iris.mean, 
                         aes(x = Group.1, y = Sepal.Length, fill = Group.1))
        p <- p + stat_summary(fun.data  = mean_sdl, mult = 1)
        p <- p + scale_fill_manual(name = "My Legend", 
                                 values = c("orange", "yellow", "blue"))
p

# or just the lines
p <- ggplot(iris, aes(x = Species,y = Sepal.Length))
        p <- p + geom_bar(data = iris.mean, 
                         aes(x = Group.1, y = Sepal.Length), fill = "white")
        p <- p + stat_summary(fun.data = mean_sdl, mult = 1, geom = "linerange")
p

# example from Loblolly data set
data(Loblolly)
p <- ggplot(Loblolly, aes(x = age, y = height))
        p <- p + theme_bw()
        p <- p + geom_point(aes(colour = Seed))
p

# separate panels per Seed type
p <- ggplot(Loblolly, aes(x = age, y = height))
        p <- p + theme_bw()
        p <- p + facet_grid(. ~ Seed)
        p <- p + geom_point()
p

# adding the fitted line for each facet
# for one Seed group, the fit fails...
p <- ggplot(Loblolly, aes(x = age, y = height))
        p <- p + theme_bw()
        p <- p + facet_grid(. ~ Seed)
        p <- p + geom_smooth(aes(linetype = Seed), colour = "black", 
                method="nls", 
                formula = y ~ (a * x) / (b + x), se = F, 
                start = list(a = 10, b = 15) )
        p <- p + geom_point(aes(colour = Seed))
p

# adding the fitted line for each facet
p <- ggplot(Loblolly, aes(x = age, y = height))
        p <- p + theme_bw()
        p <- p + geom_smooth(aes(colour = Seed), method = "lm")
        p <- p + geom_point( aes(colour = Seed))
p

# panels and some customisation
p <- ggplot(Loblolly, aes(x = age, y = height))
        p <- p + theme_bw()
        p <- p + facet_grid(. ~ Seed)
        p <- p + geom_point()
        p <- p + geom_smooth(aes(colour = Seed), method = "lm")
        p <- p + guides(col = guide_legend(ncol = 2))
        p <- p + opts(panel.grid.major = theme_blank(), 
                      panel.grid.minor = theme_blank())
        p <- p + opts(title = "Loblolly pine growth")
        p <- p + opts(plot.title = theme_text(size = 20))
p

# ?opts allows plenty of options...
# see http://had.co.nz/ggplot2/docs/opts.html


# Create a ggplot graph for each column
# Introducing the "for" loop:
# for each item in a range of items do something

MultPlot <- function () {
   # This function plots all "iris" columns in a loop
   # x-axis is always column 1, i.e. "Sepal.Length"
   # it is a function without options, everything is hardcoded
   
   for (i in 1:4) { 
        y.label    <- names(iris)[i]
        x.label    <- names(iris)[1]
        plot.title <- paste("Using column #", i, sep = " ")

        # creating a temporary data frame on the fly
        # in a loop, handling the calls to columns in the ggplot call can be tricky
        # therefore, we create the data frame as needed beforehand
        tmp <- data.frame(x = iris[, 1], y = iris[, i])
               
        p <- ggplot(tmp, aes(x = x, y = y))
             p <- p + geom_point()
             p <- p + labs(x = x.label, y = y.label)
             p <- p + opts(title = plot.title)
        # we have to specify "print", as we want to print to a graphic device
        print(p)
   }
}

# As we defined the graphs as a function we can easily create different output formats
# first a pdf file that will have each figure on one page
pdf("iris_plots.pdf")
        MultPlot()             # executing the function in the pdf device
dev.off()                      # don't forget to turn off the pdf device!!
 
# Now creating one png file per figure
# "%03d" is replaced by a three-digit number (padded with zeroes)
# Works with any file format
png("iris_plots_%03d.png")
        MultPlot()
dev.off()                       # don't forget to turn off the png device!!




# Currently, the MultPlot function is hard-coded for the iris data frame.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Question:
# How to modify the "MultPlot" function in a way that it accepts any data 
# frame (like "Loblolly"), not just "iris"?
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Expected result:
# After modifying the above function
# the following code should result in graphs for Loblolly
pdf("out.pdf")
        MultPlot(Loblolly)
dev.off()

# and this should result in graphs for iris
pdf("out.pdf")
        MultPlot(iris)
dev.off()

# Questions for session 5:
# How to separate elements out of one original element.
# I.e. deconcatenate


# PS:
# Some shortcomings in ggplot:
# most of them can be worked around outside of ggplot2
# 
# * No axis breaks allowed: H. Wickham, 2010, ggplot2 mailing list:
# "[..]  I'm not a big fan of this type of display because I think it is visually
# distorting.  I think it's much more appropriate to show two plots - one of all 
# the data, and one of just the small values. That way you can see how much the 
# large values dominate the smaller ones."

# * No secondary y-axis allowed: H. Wickham, 2010, Stackoverflow:
# "It's not possible in ggplot2 because plots with multiple y scales are fundamentally flawed." "And it will never be possible to add a secondary scale, just an secondary axes that is a transformation of the primary." H. Wickham, 2010 ggplot mailing list.

# * No inward facing tick marks: H. Wickham, 2009 ggplot2 mailing list:
# "I'm a pretty strong believer that tick marks should go outside the
# plot - otherwise it's very easy for them to overlap with data elements
# - and so there's no way to put them on the inside for ggplot2 (it also
# seems a little redundant given that there are already grid lines on
# the plot).  However, you can work around the lack by using geom_rug.
# Hadley Wickham, 2009 ggplot2 mailing list.



# Questions that were raised after session 3, but we did not have time
# to conquer in session 4:

# +++++++++++++++++++++++++++++++++++++++++++++++++
# time series with gaps
# align the existing data with a complete time sequence
# +++++++++++++++++++++++++++++++++++++++++++++++++

# create some example data
dates <- c("03.05.1992", 
           "08.02.1991", 
           "28.08.1998", 
           "09.12.2002", 
           "12.09.2005")
           
values <- c(25, 38, 45, 53, 66)

# put the data in a data frame
df <- data.frame(dates, values)
df$Date <- as.POSIXct(df$dates, 
                      format = "%d.%m.%Y", 
                      tz     = "EST")

# create a "perfect" time series
gapless <- seq(from = as.POSIXct("1991-02-08", tz = "EST"),
               to   = as.POSIXct("2005-09-12", tz = "EST"),
               by   = "1 days")

gapless <- as.data.frame(gapless)
names(gapless) <- "full_date"

# merge two data frames

out <- merge(gapless, df,
             by.x  = c("full_date"),
             by.y  = c("Date"),
             all.x = TRUE)
             
# beyond this simple merge procedure:
# check out the specialised and comprehensive time series package "zoo"
# install.packages("zoo")
# see http://cran.r-project.org/web/packages/zoo/index.html for manuals and details!
# This package provides many options regardng handling/filling gaps in the data.
