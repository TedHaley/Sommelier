# Global.R
# Code that runs in this file is available to both ui.R and server.R

suppressMessages({
  library(shiny)
  library(tidyverse)
  library(magrittr)
  library(dplyr)
  library(stringr)
  library(gapminder)
  library(scales)
  # library(tidyr)
  # library(plotly)
  # library(htmlwidgets)
  # library(ggvis)
  # library(gganimate) # library(devtools); install_github("dgrtwo/gganimate")
  library(colourpicker) # library(devtools); devtools::install_github("daattali/colourpicker")
  library(tm)
  library(wordcloud)
  library(RColorBrewer)
})

# import wine list
wine_list <- read.csv(file = ("../../data/winemag-data_first150k.csv"))

# select columns to keep
wine_list <- wine_list %>% 
  select("country", "description", "points", "price", "province", "variety", "winery")

# remove rows with missing information
wine_list[wine_list==""]<-NA
wine_list<-wine_list[complete.cases(wine_list),]

# Words not to include in word cloud
no_include = c("wine", "drink", "flavors", "nose", "palate", "bottling", "notes", "now", "cellar")

# Word cloud function
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
            min.freq=sort(freq, decreasing=TRUE)[[50]],
            max.words=200, random.order=FALSE, rot.per=0.35, 
            colors=brewer.pal(8, "Dark2")) 
}  


makeWordCloud(wine_list[["description"]][1:50])