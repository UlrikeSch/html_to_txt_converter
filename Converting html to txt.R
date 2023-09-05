#============================================================================================
# Author: Ulrike Schneider


# R version 4.3.1 (2023-06-16)
# Platform. x86_64-apple-darwin17.0 (64-bit)
# Running under: MacOs Ventura 13.4

# Last updated: September 5th, 2023
#==================================================================================

# You have crawled/scraped websites and now have html files and would like to get rid of the code in the files?
# This script does it for you. Mind you, it's the quick and dirty method and may not solve all your issues or delete more than you are willing to part with.

# It uses...

# ...the htm2txt package
# Park, Sangchul. 2022. htm2txt. Package for R. Available at https://cran.r-project.org/web/packages/htm2txt/index.html

# ...the write_utf8 function
# Ushey, Kevin. 2018. String encoding and R. R and C++. Available at http://kevinushey.github.io/blog/2018/02/21/string-encoding-and-r/



#====================================================================================
## SETUP

# clear environment
rm(list = ls())


# load packages
install.packages("htm2txt") # only needed to install the package
library("htm2txt")


# load utf8 function
write_utf8 <- function(text, f = tempfile()) {
  
  # ensure text is UTF-8
  utf8 <- enc2utf8(text)
  
  # create connection with UTF-8 encoding
  con <- file(f, open = "w+", encoding = "UTF-8")
  writeLines(utf8, con = con)
  close(con)
  
  # read back from the file just to confirm
  # everything looks as expected
  readLines(f, encoding = "UTF-8")
  
}



#=======================================================================================
## LOAD AND CONVERT FILES

## Make a list of file names
html.files <- select.list(dir(scan(nmax=1, what="char")), multiple=T)
# A prompt (1:) will appear on screen.

# Enter the path where your files are saved after the prompt

# This path will look something like this on Mac:
# /Users/Ulrike/Documents/Veranstaltungen/Workshop Data Analysis in R

# or like this on Windows
# C:/Dokumente/Veranstaltungen/Workshop Data Analysis in R

# Press enter
# A window will appear
# In the window, highlight all files you want to convert


## Tell R where to find these files
setwd("") # paste your path between the quotation marks



## Convert the files

for (i in html.files) {
	current.file <- paste(readLines(i, encoding="UTF-8"), collapse="\n")
	current.file <- gsub("<style>.+</style>", " ", current.file)
	current.file <- gsub("<script>.+</script>", " ", current.file)
	current.file <- gsub("<li\\b.+?</li>", "", current.file)
	current.file <- gsub("<a\\b.+?</a>", "", current.file) # optional. Deletes anything with a hyperlink on it, as those will mostly be buttons. If you do not want to use this, place a hash in front of it
	current.file <- gsub("<.+?>", "", current.file)
	current.file <- gsub("\\\n *", "\\\n", current.file)
	current.file <- gsub("(\\\n)+", "\\\n", current.file)
	current.file <- strsplit(current.file, "\\\n")
	current.file <- htm2txt(current.file)
	write_utf8(current.file, paste(gsub(" *.html", "", i), ".txt", sep=""))
	}

# The txt files are saved in the same folder as the original html files.





















