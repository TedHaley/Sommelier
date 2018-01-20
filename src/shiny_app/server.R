
shinyServer(function(input, output) {

  # Render the desired plot
  output$gapminderPlot <- renderPlot({

    # Filter gapminder by the years chosen from the sliderInput and the continents chosen from the checkboxGroupInput
    gapminderFiltYear <- gapminder %>%
      dplyr::filter(year >= min(input$years) & year <= max(input$years)) %>%
      dplyr::filter(continent %in% input$continents)

    # Plot the chart
    gapminderPlot <- ggplot(gapminderFiltYear, aes_string(x = "year", y = input$y_axis, group = "year")) +
      ggtitle(input$title, subtitle = paste0(yAxisNames[input$y_axis], ' vs. Year for Selected Continents')) +
      xlab("Year") + ylab(yAxisNames[input$y_axis])

    # Display the plot with the desired/selected aesthetic mapping
    if (input$geom == "geom_point") {
      displayPlot <- gapminderPlot + geom_point(size = input$pointSize, alpha = input$alpha, color = input$pointColor)
    } else if (input$geom == "geom_boxplot") {
      displayPlot <- gapminderPlot + geom_boxplot(size = input$pointSize, alpha = input$alpha, color = input$pointColor)
    } else if (input$geom == "geom_violin") {
      displayPlot <- gapminderPlot + geom_violin(size = input$pointSize, alpha = input$alpha, color = input$pointColor)
    }

    # Return the plot object along with a scale that best reflect the data represented on the y-axis
    if (input$y_axis == "lifeExp") {
      displayPlot + scale_y_continuous()
    } else if (input$y_axis == "pop") {
      displayPlot + scale_y_log10(label = scales::comma)
    } else if (input$y_axis == "gdpPercap") {
      displayPlot + scale_y_log10(labels = scales::dollar_format())
    }
  })
})
