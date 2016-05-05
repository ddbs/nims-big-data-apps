
#install.packages("quantmod")
#install.packages("tseries")
#install.packages("timeDate")

library(quantmod)
library(tseries)
library(timeDate)
library(chron)

## download OHLC 
#get.hist.quote(instrument = "TSLA", retclass = "zoo", quiet = T)

## download adjusted close
x <- get.hist.quote(instrument = "TSLA", quote = "AdjClose", start="2016-05-01", retclass = "zoo", quiet = T)
x <- as.data.frame(x)
write.csv(x, "TSLA")
tdates <- read.csv("TSLA")
tdates <- tdates[,1]

## bulk download
symbols <- read.csv("dow.csv", header = F, stringsAsFactors = F)
nrStocks = length(symbols[,1])

for (i in 1:nrStocks) {
  cat("\nDownloading ", i, " out of ", nrStocks)
  x <- get.hist.quote(instrument = symbols[i,], start = "2016-01-01", retclass = "zoo", quiet = T)
  #z <- merge(z, x)
  file_name <- paste0("./series/", toString(symbols[i,]),".csv")
  x <- as.data.frame(x)
  write.csv(x, file_name)
}

## get dates -- DEPRECATED
# https://www.nyse.com/markets/hours-calendars
#hlist <- c("2016-01-01","2016-01-18", "2016-02-15", "2016-03-25", "2016-05-30", "2016-05-05")
#hlist <- strptime(hlist, "%Y-%M-%d")
#file.remove("dates.txt")
#t <- Sys.Date()
#d <- as.Date("2016-05-01")
#while (d <= t) {
#  if (!is.weekend(d) | !(toString(d) %in% hlist)) {
#    write.table(d, file = "dates.txt", append=T, sep="\t", quote = FALSE, eol="\r\n", row.names = F, col.names=F) 
#  }
#  d <- d + 1
#}
  

## download tabular data
dates <- as.data.frame(tdates)
nrDates = length(dates[,1])

for (j in 1:nrDates) {
  file_name <- paste0("./sessions/", toString(dates[i,]),".txt")
  for (i in 1:nrStocks) {
    cat("\nDownloading ", i, " out of ", nrStocks)
    x <- get.hist.quote(instrument = symbols[i,], start = dates[i,], end = dates[i,], retclass = "zoo", quiet = T)
    x <- as.data.frame(x)
    s <- as.data.frame(symbols[i,])
    m <- cbind(x,s)
    write.table(m, file = file_name, append=T, sep="\t", quote = F, eol="\r\n", row.names = T, col.names = F)
  }
}