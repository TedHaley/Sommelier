
shinyServer(function(input, output) {

  # Filter with all inputs
  filteredTable <- reactive({
    
      wine_list %>%
      select("winery", "designation", "variety", "country", "province", "points", "price") %>% 
      filter(price >= input$priceInput[1],
            price <= input$priceInput[2],
            points >= input$pointInput[1],
            points <= input$pointInput[2],
            variety %in% input$varietyInput) %>%
      arrange(desc(points)) %>% 
      top_n(n = 10)
  
    })
  
  # Filter only for wine type
  filteredCloud <- reactive({
    
    # Filter gapminder by the years chosen from the sliderInput and the continents chosen from the checkboxGroupInput
    wine_list %>%
      filter(variety %in% input$varietyInput) %>%
      arrange(desc(points))
    
  })
  
    # Render the word cloud
    output$wordCloud <- renderPlot({
      
      if (is.null(filteredCloud())) {
        return()
      }
      
      wineCloud <- filteredCloud()  
      
      # Plot the chart
      wordCloud <- makeWordCloud(wineCloud[["description"]][1:100])

    })
    
    output$wineTable <- renderTable({
      filteredTable()
    })

})
