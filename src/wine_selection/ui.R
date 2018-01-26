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
        "\nFind your favourite flavours and then move onto the value chart to find the best selection for your money.",
        hr()
        #strong("ALLOW THE PLOT TO FULLY RENDER BEFORE NEXT SELECTION!")
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
        selected = c("Pinot Noir", "Merlot", "Shiraz", "Malbec","Moscato")
      ),
      
      # Country selector (dropdown)
      selectInput(
        "countryInput", 
        "Country of Origin:",
        multiple = TRUE,
        choices = sort(unique(wine_list$country)),
        selected = c("Italy", "US", "France", "Germany","Spain","Argentina")
      )
      
    ),

    # Main panel area
    mainPanel(
      
      # Tab selection in main panel
      tabsetPanel(
        
        # First tab panel
        tabPanel(title = h2("1. Flavour Profile"),
                 h4("Prominent flavours of your current selection", align = "center"),
                 hr(),
                 plotOutput("wordCloud")),
        
        # Second tab panel
        tabPanel(title = h2("2. Value Chart"), 
                 plotOutput("scatterPlot"),
                 
                 # Number of points to include in linear regression model
                 numericInput(
                   "numberInput", 
                   "Wines to compare in the chart:",
                   value = 10, min = 2, max = 20))
      ),
      
      # Spaces (padding)
      br(), 
      br(),
      
      # output the rendered data table
      DT::dataTableOutput("wineTable")
    )
  )
))
