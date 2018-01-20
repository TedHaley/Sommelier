
shinyServer(function(input, output) {

  filtered <- reactive({
    
    # Filter gapminder by the years chosen from the sliderInput and the continents chosen from the checkboxGroupInput
    wine_list %>%
    filter(price >= input$priceInput[1],
            price <= input$priceInput[2],
            points >= input$pointInput[1],
            points <= input$pointInput[2],
            variety %in% input$varietyInput) %>%
    arrange(desc(points))
  
    })
  
    # Render the desired plot
    output$wordCloud <- renderPlot({
      
      wine_list_reduced <- filtered()  
      
      # Plot the chart
      wordCloud <- makeWordCloud(wine_list_reduced[["description"]][1:50])

    })

})
