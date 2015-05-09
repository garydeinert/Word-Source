
library(tm)
library(wordcloud)
##library(sentiment)
library(plyr)
library(ggplot2)
library(RColorBrewer)
library(SnowballC)
library(syuzhet)
library(reshape2)

##DirSource(directory="C:/Users/Gary/Documents/Contract/R Word Cloud etc")

mydata <- Corpus(DirSource("C:/Users/Gary/Documents/Contract/R Word Cloud etc"))
mydata <- tm_map(mydata,stripWhitespace)
mydata <- tm_map(mydata, tolower)         ## note: tolower doesn't return a Text Doc
mydata <- tm_map(mydata,removeWords,stopwords("english"))
mydata <- tm_map(mydata,stemDocument)
mydata <- tm_map(mydata, PlainTextDocument)     ## need to do this before process

wordcloud(mydata, scale=c(5,0.5), 
          max.words=100,
          random.order=FALSE,
          rot.per=0.35,
          use.r.layout=FALSE,
          colors=brewer.pal(8,"Dark2"))

mycharv <- as.character(mydata)
mysent <- get_nrc_sentiment(mycharv)
x <- mysent[1,]
plotdf <- melt(x)
barplot(plotdf$value, 
        col=brewer.pal(8,"Dark2"),
        names.arg = plotdf$variable,
        cex.names = 0.50)
