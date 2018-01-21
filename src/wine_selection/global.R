# Global.R
# Code that runs in this file is available to both ui.R and server.R

suppressMessages({
  library(shiny)
  library(tidyverse)
  library(dplyr)
  library(stringr)
  library(gapminder)
  library(scales)
  library(colourpicker) 
  library(tm)
  library(wordcloud)
  library(RColorBrewer)
  library(DT)
  library(ngram)
})

# import wine list
wine_list <- read.csv(file = ("data/winemag-data_first150k.csv"))

# Wine varieties to be included
wines_include <- c("Riesling", "Malbec", "Shiraz", "Chardonnay", "Cabernet Sauvignon", "Merlot","Sauvignon Blanc", "Rosé", "Pinot Grigio","Pinot Noir", "Moscato")

# select columns to keep
wine_list <- wine_list %>% 
  select("country", "description", "designation", "points", "price", "province", "variety", "winery") %>% 
  filter(price<500) %>% 
  filter(variety %in% wines_include)

# remove rows with missing information
wine_list[wine_list==""]<-NA
wine_list<-wine_list[complete.cases(wine_list),]

# Words not to include in word cloud
no_include = c("riesling", "malbec", "shiraz", "chardonnay", "cabernet sauvignon", "merlot","sauvignon blanc", "rosé", "pinot grigio","pinot noir", "pinot", "noir", "moscato","merlot","wine", "drink", "flavors", "nose", "palate", "bottling", "notes", "now", "cellar", "made", "2007", "will", "long", "ever","shows","vineyard", "vineyards","expression")

# Word cloud function: Adapted from https://www.kaggle.com/hiteshp/weekend-which-wine-wins
makeWordCloud <- function(documents) {
  corpus = Corpus(VectorSource(tolower(documents)))
  corpus = tm_map(corpus, removePunctuation)
  corpus = tm_map(corpus, removeWords, stopwords("english"))
  corpus = tm_map(corpus, removeWords, no_include)
  
  frequencies = DocumentTermMatrix(corpus)
  word_frequencies = as.data.frame(as.matrix(frequencies))
  
  words <- colnames(word_frequencies)
  freq <- colSums(word_frequencies)
  wordcloud(words, freq,
            min.freq=sort(freq, decreasing=TRUE)[[100]],
            max.words=200, random.order=FALSE, rot.per=0.35, 
            colors=brewer.pal(8, "YlOrRd")) 
}  


