# Server.R

shinyServer(function(input, output) {

  # Filter for the scatter plot
  filteredScatter <- reactive({
    wine_list <- wine_list %>%
      select("winery", "designation", "variety", "country", "province", "points", "price") %>% 
      filter(price >= input$priceInput[1],
             price <= input$priceInput[2],
             points >= input$pointInput[1],
             points <= input$pointInput[2],
             variety %in% input$varietyInput,
             country %in% input$countryInput) %>% 
      arrange(desc(points))
    wine_list <- wine_list[1:input$numberInput,]
  })
  
  # Filter for the table
  filteredTable <- reactive({
      wine_list %>%
        select("winery", "designation", "variety", "country", "province", "points", "price") %>% 
        filter(price >= input$priceInput[1],
            price <= input$priceInput[2],
            points >= input$pointInput[1],
            points <= input$pointInput[2],
            variety %in% input$varietyInput,
            country %in% input$countryInput) %>% 
        arrange(desc(points))
  })
  
  # Filter only for wine type for the word cloud
  filteredCloud <- reactive({
    
    wine_list %>%
      filter(variety %in% input$varietyInput,
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
      makeWordCloud(wineCloud[["description"]][1:100])

    })
    
    # Render scatter plot
    output$scatterPlot <- renderPlot({
      
      # transfer changes to new name of table
      scatterPoints <- filteredScatter()
      
      # Scatter plot labels
      scatterPoints <- scatterPoints %>% 
        mutate(name <- paste(abbreviate(winery, minlength = 10),sep = "\n", (abbreviate(designation, minlength = 10))))
      
      fit <- lm(price ~ points, data = scatterPoints)
      
      scatterPoints$predicted <- predict(fit)   # Save the predicted values
      scatterPoints$residuals <- residuals(fit) # Save the residual values
      
      # plot for above/below linear model. Adapted from https://drsimonj.svbtle.com/visualising-residuals
      ggplot(scatterPoints, aes(x = points, y = price)) +
        geom_smooth(method = "lm", se = FALSE, color = "lightgrey") +
        geom_segment(aes(xend = points, yend = predicted), alpha = .2) +
        geom_point(aes(color = residuals, size = 4)) +
        scale_color_distiller(palette="Spectral", guide = "colourbar", name = "Value Meter") +
        scale_size(guide=FALSE) +
        geom_point(aes(y = predicted), shape = 1) +
        geom_label(label = scatterPoints$name, fontface = "bold", hjust = 0, nudge_x = 0.05, size = 3) +
        ggtitle("Blue : Good Value || Red : Poor Value") +
        xlab("Points") +
        scale_y_continuous(labels=scales::dollar_format())+
        ylab("Price") +
        theme_bw() + 
        scale_x_continuous(limits = c(min(scatterPoints$points)-0.5, max(scatterPoints$points)+0.5))
        
    })
    
    #plot the rendered data table
    output$wineTable <- DT::renderDataTable({
      filteredTable()
    })

})
