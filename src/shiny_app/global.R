# Global.R
# Code that runs in this file is available to both ui.R and server.R

suppressMessages({
  library(shiny)
  library(tidyverse)
  library(magrittr)
  # library(rprojroot)
  # library(ggthemes)
  library(stringr)
  library(gapminder)
  library(scales)
  # library(tidyr)
  # library(plotly)
  # library(htmlwidgets)
  # library(ggvis)
  # library(gganimate) # library(devtools); install_github("dgrtwo/gganimate")
  library(colourpicker) # library(devtools); devtools::install_github("daattali/colourpicker")
  library(here)
})

# Directories are not necessary in this app, but I am leaving the code in, as
# you may want to know how to handle directories for apps hosted on shinyapps.io
# in future assignments.
rootDir <- here::here()

# If this leaves us in the shiny app dir, then we're good. Otherwise, we're in
# the DSCI_instructors repo, and we should navigate to the appropriate
# subdirectory.

# shinyapps.io server prints the following dir:
# "/srv/connect/apps/lab1solutions"
# Insert your shinyapps.io app name here (the '$' is regex for 'end of string'):
if (str_detect("lab1solutions$", rootDir)) {
  # Taking advantage of R's lack of block scope
  # appDir will be a global variable
  appDir <- rootDir
} else {
  lab1Dir <- file.path(rootDir, "solutions", "lab1")
  appDir <- file.path(lab1Dir, "shiny_app")
}

# construct named vector of possible y-axis variables. This will go into a selectInput
yAxisVars <- c("Life Expectancy" = "lifeExp", "Population" = "pop", "GDP Per Capita" = "gdpPercap")
# construct the inverse of the vector to allow R to grab the selectInput result
# and use the pretty name as an axis label. Unfortunately you must select from a
# vector by the name, and not the actual string value
yAxisNames <- c("lifeExp" = "Life Expectancy", "pop" = "Population", "gdpPercap" = "GDP Per Capita")

# construct possible geoms to display on the graph with pretty names for selectInput
geomsToChoose <- c(
  "Point" = "geom_point",
  "Boxplot" = "geom_boxplot",
  "Violin" = "geom_violin"
)
