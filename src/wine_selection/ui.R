shinyUI(fluidPage(

  # Application title
  titlePanel("Wine Selection Tool"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    
    sidebarPanel(
      width = 3,
      p(
        "Welcome to the Wine Selection Tool for the ",
        a(href = "https://www.kaggle.com/zynicide/wine-reviews/data", "Wine Ratings"), "dataset.",
        "Filter the dataset using the selection tools below:"
      ),
      hr(),
      sliderInput(
        "priceInput",
        "Price Range ($):", #Title
        min = min(wine_list$price),
        max = max(wine_list$price),
        step = 1,
        value = c(min(wine_list$price), max(wine_list$price))
      ),
      sliderInput(
        "pointInput",
        "Rating (points):", #Title
        min = min(wine_list$points),
        max = max(wine_list$points),
        step = 1,
        value = c(min(wine_list$points), max(wine_list$points))
      ),
      selectInput(
        "varietyInput", 
        "Variety:",
        multiple = TRUE,
        choices = sort(wines_include),
        selected = "Pinot Noir"
      )
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("wordCloud"),
      br(), br(),
      tableOutput("wineTable")
    )
  )
))
