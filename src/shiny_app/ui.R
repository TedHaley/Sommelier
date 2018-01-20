shinyUI(fluidPage(

  # Application title
  titlePanel("Lab 1 Solutions"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      width = 3,
      p(
        "Welcome to an exploration of the ",
        a(href = "https://github.com/jennybc/gapminder", "Gapminder"), "dataset.",
        "To get started exploring the dataset, pick from some options below."
      ),
      hr(),
      sliderInput(
        "pointSize",
        "Point Size/Line Thickness",
        min = 0,
        max = 5,
        step = 0.2,
        value = 2
      ),
      numericInput(
        "alpha", "Transparency",
        min = 0, max = 1,
        value = 0.5, step = 0.1
      ),
      colourInput("pointColor", "Point Color", value = "#000"),
      sliderInput("years", label = "Year range", min = 1952, max = 2007, step = 1, value = c(1952, 2007), sep = ""),
      selectInput(
        "y_axis", "Y-Axis Variable",
        choices = yAxisVars, # Pulled from my definition in global.R
        selected = "lifeExp", selectize = TRUE
      ),
      radioButtons(
        "geom", "Geom",
        choices = geomsToChoose, # Pulled from my definition in global.R
        selected = "geom_point"
      ),
      textInput(
        "title", "Plot Title",
        value = "Gapminder Data"
      )
    ),

    # Show a plot of the generated distribution
    mainPanel(
      width = 9,
      plotOutput("gapminderPlot"),
      checkboxGroupInput(
        "continents", "Continents",
        choices = unique(gapminder$continent),
        inline = TRUE, selected = "Asia"
      )
    )
  )
))
