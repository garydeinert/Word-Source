library(tm)                   ## text management package
library(wordcloud)            ## word cloud addendum
library(plyr)                 ## data manipulation
library(ggplot2)              ## plotting
library(RColorBrewer)         ## plot colors used in wordcloud
library(SnowballC)            ## needed for wordcloud
library(syuzhet)              ## new package available for sentiment analysis
library(reshape2)             ## matrix management
## library(mpa)                  ## co-words process analysis

filelist <- list.files("C:/wordanalysis")
f = length(filelist)
words <- NULL
bigrams <- NULL

for (i in 1:f) {
      x <- scan(filelist[i],character(0),quote=NULL)
      words <- c(words,x)
}

words <- removePunctuation(words)
words <- tolower(words)
words <- removeWords(words,stopwords("english"))
words <- removeNumbers(words)
## x <- stemDocument(x)
words <- words[!words==""]

z <- length(words)
for (b in 1:z) {
      bigrams <- c(bigrams,paste(words[b],words[b+1], sep="-"))
}

dualfreq = count(bigrams)
dualfreq = dualfreq[with(dualfreq,order(-freq)),]

freq = count(words)
freq <- freq[with(freq,order(-freq)),]

wordsForCloud <- freq[freq$freq>=10,]
bigramsForCloud <- dualfreq[dualfreq$freq>=5,]

finalwords <- words[words %in% wordsForCloud$x]
finalwords <- c(finalwords, bigrams[bigrams %in% bigramsForCloud$x])


png(filename = "wordclouds.png", width=480, height=480)
wordcloud(finalwords,
          scale=c(5,0.5), 
          max.words=250,
          random.order=FALSE,
          rot.per=0.35,
          use.r.layout=FALSE,
          colors=brewer.pal(8,"Dark2"))

dev.off()

png(filename = "bigramclouds.png", width=480, height=480)
wordcloud(bigrams,
          scale=c(5,0.5),
          max.words = 100,
          random.order = FALSE,
          rot.per = 0.35,
          use.r.layout = FALSE,
          colors=brewer.pal(8,"Dark2"))
dev.off()

##  Move toward sentiment analysis

sentmt <- get_nrc_sentiment(finalwords)
n <- colSums(sentmt)

png(filename = "sentiments.png", width=480, height=480)
barplot(n,
        col=brewer.pal(8,"Dark2"),
        cex.names = 0.80,
        horiz = TRUE,
        main = "Sentiment Analysis",
        mar = c(6,4,4,2) + 0.1,
        las = 1)

dev.off()

