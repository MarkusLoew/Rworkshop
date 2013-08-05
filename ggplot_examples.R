# ggplot_examples.R

setwd("/home/loewi/Prac/R_demo")

library(ggplot2)

data(Loblolly)


p <- ggplot(Loblolly, aes(x = age, y = height))
        p <- p + theme_bw()
        # p <- p + facet_wrap(~ Seed, nrow = 7)
        p <- p + facet_grid(. ~ Seed)
        p <- p + geom_smooth(colour = "black", 
                method="nls", 
                formula = y ~ (a * x) / (b + x), se = FALSE, 
                start = list(a = 10, b = 15) )
        p <- p + geom_point()
p
# one facet with errors from curve fit: singular gradient
