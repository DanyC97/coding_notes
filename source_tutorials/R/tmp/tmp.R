#https://www.r-bloggers.com/fivethirtyeights-polling-data-for-the-us-presidential-election/

library(dplyr)
library(tidyr)
library(ggplot2)
library(viridis)
library(ggthemes)

#https://www.r-bloggers.com/fivethirtyeights-polling-data-for-the-us-presidential-election/
# this next code will need to be adapted if you don't have a ../data/ folder...
# alternatively, if that link stops working, there's a static copy at http://ellisp.github.io/data/polls.csv
www <- "http://projects.fivethirtyeight.com/general-model/president_general_polls_2016.csv"
download.file(www, destfile = "polls.csv")

# download data
polls_orig <- read.csv("polls.csv", stringsAsFactors = FALSE)

table(table(polls_orig$poll_id))
##    3 
## 3067 

table(polls_orig$type)
##  now-cast polls-only polls-plus 
##      3067       3067       3067 

