# import Excel files

# available R packages are:
# RODBC
# gdata
# xlsx (recommended, see bottom)


# set working directory
setwd("c:/path/to/your/workfolder")


# from http://cran.r-project.org/doc/manuals/R-data.html#Reading-Excel-spreadsheets

# "The first piece of advice is to avoid doing so if possible! If you have access to Excel, export the data you want from Excel in tab-delimited or comma-separated form, and use read.dim or read.csv to import it into R."

# RODBC
# for 32bit windows
# Windows users (of 32-bit R) can use odbcConnectExcel in package RODBC.
# install.packages("RODBC")
library(RODBC)
?odbcConnectExcel

# Gdata
# The "gdata" package can import Excel files
# Perl users have contributed a module OLE::SpreadSheet::ParseExcel and a program xls2csv.pl to convert Excel 95–2003 spreadsheets to CSV files. Package gdata provides a basic wrapper in its read.xls function. With suitable Perl modules installed this function can also read Excel 2007 spreadsheets.

# in case you did not install the gdata package yet, do so:
install.packages("gdata", dep = TRUE)

# load the gdata package
library(gdata)

# import your data into the object "df"
df <- read.xls("your_file.xls", sheet = 1)

# do the usual checks to make sure data was imported correctly
summary(df)
head(df)
tail(df)
str(df)


# To import xlsx files:
# "xlsx" package
# http://cran.r-project.org/web/packages/xlsx/index.html
# it is very slow with large files as it tries to determine the class of each column
# be patient
# requires Java environment 
install.packages("xlsx", dep = TRUE)

library(xlsx)
df <- read.xlsx("X:/path/to/my/file.xlsx", sheetName = "Sheet1")

# Try to stay away from the "read.xlsx2" import option, as you have to define the class for each column manually! It is much faster, but rather inconvenient if many columns are needed.

# in any case:
# check he help file and documentation
?read.xlsx


# other import options:
# The "xlsReadWrite" package has been removed from CRAN. Don't use the old versions from the archives.


# Remember:
# The first piece of advice is to avoid Excel if possible!
