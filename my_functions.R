# my collection of functions
# to use the functions defined in this file,  
# put "source("/full/path/to/my_functions.R")" in your R code.

# Standard error function
stderr <- function(x) {
              sqrt(var(x[!is.na(x)]) / length(x[!is.na(x)]))
              }

# split extract
x <- c("Blake.01.y", "Burnt.4.z")
strsplit(x, "\\.")
sapply(strsplit(x, "\\."), "[", 3) # number varies the element to be extracted
sapply(strsplit(x, "\\."), `[`, 2) # number varies the element to be extracted
sapply(strsplit(x, "\\."), '[', 1) # number varies the element to be extracted


# function to plot all columns for a data frame
mult.plot <- function(data) {
   # This function plots all columns from "data" in a loop
   # x-axis is always column 1
   for (i in 1:(ncol(data))) { 
        y.label    <- names(data)[i]
        x.label    <- names(data)[1]
        plot.title <- paste("Using column #", i, sep = " ")

        # Creating a temporary data frame on the fly.
        # In a loop, handling the calls to columns in ggplot can be tricky.
        # Therefore, we create the data frame dynamically as needed beforehand
        tmp <- data.frame(x = data[, 1], y = data[, i])
               
        p <- ggplot(tmp, aes(x = x, y = y))
             p <- p + geom_point()
             p <- p + labs(x = x.label, y = y.label)
             p <- p + opts(title = plot.title)
        # we have to specify "print", as we want to print to a graphic device
        print(p)
   }
}


# plot diameter data for each tree
plot.tree <- function(data) {
                tree_name <- paste(unique(data$Tree_No))
                adjr2 <- allfits$AdjR2[allfits$Tree_No == as.integer(tree_name)]
                adjr2 <- round(adjr2, digits = 2)
                
                inter <- allfits$Intercept[allfits$Tree_No == as.integer(tree_name)]
                inter <- round(inter, digits = 2)
                
                slope <- allfits$Slope_per_year[allfits$Tree_No == as.integer(tree_name)]
                slope <- round(slope, digits = 2)
                
                combi <- paste(adjr2, inter, sep = ", ")
                combi <- paste(combi, slope, sep = ", ")
                
                text <- paste("AdjR2, Intercept, Slope =", combi, sep=" ")
                #print(text)
                                
                p <- ggplot(data, aes(x = as.factor(Date), y = DBHUB_mm))
                p <- p + geom_text(
                        aes(as.factor(Date), min(DBHUB_mm, na.rm = TRUE)), 
                        label = text, colour = "red", size = 3, hjust = 0)
                
                if (nrow(data) > 2) {
                p <- ggplot(data, aes(x = Date, y = DBHUB_mm))
                }
                
                p <- p + theme_bw()
                p <- p + facet_grid(Species_name ~ FESA_name)
                p <- p + geom_point()
                p <- p + opts(title = tree_name)
                p <- p + geom_smooth(method = "lm")
                if (nrow(data) > 2) {
                p <- p + geom_text(
                        aes(median(Date), min(DBHUB_mm, na.rm = TRUE)), 
                        label = text, colour = "grey", size = 3, hjust = 0)
                        }
                if (exists(as.character(substitute(mean.inc))) == TRUE) {
                        anninc <- mean.inc$Mean_annu_inc[mean.inc$Tree_No == as.integer(tree_name)]
                        anninc <- round(anninc, digits = 3)
                        inclabel <- paste("Mean annual increment:", anninc, sep = " ")
                        p <- p + geom_text(
                        aes(median(Date), max(DBHUB_mm, na.rm = TRUE)),
                        label = inclabel, colour = "grey", size = 3, hjust = 0)
                        }
                return(p)
                }
