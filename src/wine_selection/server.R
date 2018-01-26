# Server.R

shinyServer(function(input, output, session) {

  # Filter for the scatter plot
  filteredScatter <- reactive({
    
    #Filter wineset
    wine_list1 <- wine_list %>%
      select("winery", "designation", "variety", "country", "province", "points", "price")
    wine_list1 <- unique( wine_list1[ , 1:7 ] )
    
    wine_list2 <- wine_list1 %>%
      filter(price >= input$priceInput[1],
             price <= input$priceInput[2],
             points >= input$pointInput[1],
             points <= input$pointInput[2],
             variety %in% input$varietyInput,
             country %in% input$countryInput) %>% 
      arrange(desc(points))
    
  })
  
  # Filter for the word cloud
  filteredCloud <- reactive({
    
    wine_list %>%
      filter(variety %in% input$varietyInput,
             country %in% input$countryInput,
             price >= input$priceInput[1],
             price <= input$priceInput[2],
             points >= input$pointInput[1],
             points <= input$pointInput[2]) %>%
      arrange(desc(points))
    
    })
  
    # Render the word cloud
    output$wordCloud <- renderPlot({
      
      if (is.null(filteredCloud())) {
        return()
      }
      
      # transfer changes to new name of table
      wineCloud <- filteredCloud()  
      
      # Plot the word cloud
      makeWordCloud(wineCloud[["description"]][1:length(wineCloud)])

    })
    
    #plot the rendered data table
    output$wineTable <- DT::renderDataTable(
      filteredScatter(),
      server = F
    )
    
    # Render scatter plot
    output$scatterPlot <- renderPlot({
      
      if (is.null(filteredScatter)) {
        return()
      }
      
      # transfer changes to new name of table
      scatterPoints <- filteredScatter()
      
      if (length(scatterPoints$price)<input$numberInput){
        scatterPoints <- scatterPoints[1:length(scatterPoints$price),]
        
      }else {
        scatterPoints <- scatterPoints[1:input$numberInput,]
      }
      
      # Table input
      s = input$wineTable_rows_selected
      scatter2 <- scatterPoints[c(s),]
      
      # Scatter plot labels
      scatterPoints <- scatterPoints %>% 
        mutate(name <- paste(abbreviate(winery, minlength = 10),sep = "\n", (abbreviate(designation, minlength = 10))))
      
      fit <- lm(price ~ points, data = scatterPoints)
      
      scatterPoints$predicted <- predict(fit)   # Save the predicted values
      scatterPoints$residuals <- residuals(fit) # Save the residual values
      
      # plot for above/below linear model. Adapted from https://drsimonj.svbtle.com/visualising-residuals
      value_plt <- ggplot(scatterPoints, aes(x = points, y = price)) +
        theme_bw() + 
        scale_x_continuous(limits = c(min(scatterPoints$points)-1, max(scatterPoints$points)+1)) +
        scale_y_continuous(labels=scales::dollar_format()) +
        ggtitle("Blue : Good Value\nRed : Poor Value") +
        xlab("Points") +
        ylab("Price")
      
      if (is.null(s)){
        value_plt +
          geom_point(aes(color = residuals, size = 4)) +
          scale_color_distiller(palette="Spectral", guide = "colourbar", name = "Value Meter:") +
          scale_size(guide=FALSE) +
          geom_label(label = scatterPoints$name, fontface = "bold", hjust = 0, nudge_x = 0.05, size = 3)
        
      } else if (length(s)>0){
        value_plt +
          geom_point(aes(color = residuals, size = 4)) +
          scale_color_distiller(palette="Spectral", guide = "colourbar", name = "Value Meter:") +
          geom_point(data = scatter2 ,aes(x = points, y = price, size = 4)) +
          scale_size(guide=FALSE) +
          geom_label(label = scatterPoints$name, fontface = "bold", hjust = 0, nudge_x = 0.05, size = 3)
        
      }else{
        return()
      }

    })
    
})
