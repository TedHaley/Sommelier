library(tidyverse)
library(dplyr)
library(tm)
library(wordcloud)
library(RColorBrewer)

wine_list <- read.csv(file = ("../../data/winemag-data_first150k.csv"))
wine_list[wine_list==""]<-NA
wine_list<-wine_list[complete.cases(wine_list),]

#wine_list_reduced <- wine_list %>% 
  

View(wine_list)


# # Filter gapminder by the years chosen from the sliderInput and the continents chosen from the checkboxGroupInput
# gapminderFiltYear <- gapminder %>%
#   dplyr::filter(year >= min(input$years) & year <= max(input$years)) %>%
#   dplyr::filter(continent %in% input$continents)

no_include = c("wine", "drink", "flavors", "nose", "palate", "bottling", "notes", "now", "cellar")
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
warnings()
