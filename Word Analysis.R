
library(tm)                   ## text management package
library(wordcloud)            ## word cloud addendum
library(plyr)                 ## data manipulation
library(ggplot2)              ## plotting
library(RColorBrewer)         ## plot colors used in wordcloud
library(SnowballC)            ## needed for wordcloud
library(syuzhet)              ## new package available for sentiment analysis
library(reshape2)             ## matrix management

mydata <- Corpus(DirSource("C:/wordanalysis"))
mydata <- tm_map(mydata,stripWhitespace)
mydata <- tm_map(mydata, tolower)         ## note: tolower doesn't return a Text Doc
mydata <- tm_map(mydata,removeWords,stopwords("english"))
mydata <- tm_map(mydata,stemDocument)
mydata <- tm_map(mydata, PlainTextDocument)     ## need to do this before process

setwd("C:/wordanalysis")
png(filename = "wordcloud.png", width=480, height=480)

wordcloud(mydata, scale=c(5,0.5), 
          max.words=100,
          random.order=FALSE,
          rot.per=0.35,
          use.r.layout=FALSE,
          colors=brewer.pal(8,"Dark2"))
dev.off()

mycharv <- as.character(mydata)
mysent <- get_nrc_sentiment(mycharv)
x <- mysent[1,]
plotdf <- melt(x)

png(filename = "sentiment.png", width=480, height=480)

barplot(plotdf$value, 
        col=brewer.pal(8,"Dark2"),
        names.arg = plotdf$variable,
        cex.names = 0.80,
        horiz = TRUE,
        main = "Sentiment Analysis",
        mar = c(6,4,4,2) + 0.1,
        las = 1)

dev.off()

