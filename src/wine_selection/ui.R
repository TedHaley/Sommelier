# ui.R

shinyUI(fluidPage(

  # Application title
  titlePanel("Wine Selection Tool"),

  # Sidebar
  sidebarLayout(
    
    # Panel with description
    sidebarPanel(
      width = 3,
      p(
        "Welcome to the Wine Selection Tool for the ",
        a(href = "https://www.kaggle.com/zynicide/wine-reviews/data", "Wine Ratings"), "dataset.",
        "Filter the dataset using the selection tools below:"
      ),
      hr(),
      
      # Price range slider
      sliderInput(
        "priceInput",
        "Price Range ($):", #Title
        min = min(wine_list$price),
        max = max(wine_list$price),
        step = 1,
        value = c(min(wine_list$price), max(wine_list$price))
      ),
      
      # Point range slider
      sliderInput(
        "pointInput",
        "Rating (points):", #Title
        min = min(wine_list$points),
        max = max(wine_list$points),
        step = 1,
        value = c(min(wine_list$points), max(wine_list$points))
      ),
      
      # Wine variety selector (dropdown)
      selectInput(
        "varietyInput", 
        "Variety:",
        multiple = TRUE,
        choices = sort(wines_include),
        selected = c("Pinot Noir", "Merlot", "Shiraz")
      ),
      
      # Country selector (dropdown)
      selectInput(
        "countryInput", 
        "Country of Origin:",
        multiple = TRUE,
        choices = sort(unique(wine_list$country)),
        selected = c("Italy", "US", "France", "Germany")
      ),
      
      # Number of points to include in linear regression model
      numericInput(
        "numberInput", 
        "Value Chart Wines:",
        value = 10, min = 5)
    ),

    # Main panel area
    mainPanel(
      
      # Tab selection in main panel
      tabsetPanel(
        
        # First tab panel
        tabPanel("Flavour Profile", plotOutput("wordCloud")),
        
        # Second tab panel
        tabPanel("Value Chart", plotOutput("scatterPlot"))
      ),
      
      # Spaces (padding)
      br(), 
      br(),
      
      # output the rendered data table
      DT::dataTableOutput("wineTable")
    )
  )
))
