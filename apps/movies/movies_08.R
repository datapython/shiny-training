#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(DT)
library(stringr)
library(tools)
library(dplyr)
load("movies.Rdata")

# Define UI for application that plots features of movies ---------------------
ui <- fluidPage(
  
  # Application title ---------------------------------------------------------
  titlePanel("Movie browser"),
  
  # Sidebar layout with a input and output definitions ------------------------
  sidebarLayout(
    
    # Inputs: Select variables to plot ----------------------------------------
    sidebarPanel(
      
      # Select variable for y-axis --------------------------------------------
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "audience_score"),
      
      # Select variable for x-axis --------------------------------------------
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "critics_score"),
      
      # Select variable for color ---------------------------------------------
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("Title Type" = "title_type", 
                              "Genre" = "genre", 
                              "MPAA Rating" = "mpaa_rating", 
                              "Critics Rating" = "critics_rating", 
                              "Audience Rating" = "audience_rating"),
                  selected = "mpaa_rating"),
      
      # Set alpha level -------------------------------------------------------
      sliderInput(inputId = "alpha", 
                  label = "Alpha:", 
                  min = 0, max = 1, 
                  value = 0.5),
      
      # Set point size --------------------------------------------------------
      sliderInput(inputId = "size", 
                  label = "Size:", 
                  min = 0, max = 5, 
                  value = 2),
      
      # Show data table -------------------------------------------------------
      checkboxInput(inputId = "show_data",
                    label = "Show data table",
                    value = TRUE),
      
      # Horizontal line for visual separation ---------------------------------
      hr(),
      
      # Select which types of movies to plot ----------------------------------
      checkboxGroupInput(inputId = "selected_type",
                         label = "Select movie type(s):",
                         choice = c("Documentary", "Feature Film", "TV Movie"),
                         selected = "Feature Film")
    ),
    
    # Output: -----------------------------------------------------------------
    mainPanel(
      
      # Show scatterplot ------------------------------------------------------
      plotOutput(outputId = "scatterplot"),
      HTML("<br>"),        # a little bit of visual separation
      
      # Print number of obs plotted -------------------------------------------
      textOutput(outputId = "n"),
      HTML("<br><br>"),    # a little bit of visual separation

      # Show data table -------------------------------------------------------
      dataTableOutput(outputId = "moviestable")
    )
  )
)

# Define server function required to create the scatterplot -------------------
server <- function(input, output) {
  
  # Create a subset of data filtering for selected title types ------------------
  movies_subset <- reactive({
    movies %>%
      filter(title_type %in% input$selected_type)
  })
  
  # Create the scatterplot object the plotOutput function is expecting --------
  output$scatterplot <- renderPlot({
    ggplot(data = movies_subset(), aes_string(x = input$x, y = input$y,
                                     color = input$z)) +
      geom_point(alpha = input$alpha, size = input$size) +
      labs(x = toTitleCase(str_replace_all(input$x, "_", " ")),
           y = toTitleCase(str_replace_all(input$y, "_", " ")),
           color = toTitleCase(str_replace_all(input$z, "_", " "))
           )
  })
  
  # Print number of movies plotted --------------------------------------------
  output$n <- renderText({
      counts <- movies_subset() %>%
        group_by(title_type) %>%
        summarise(count = n()) %>%
        select(count) %>%
        unlist()
      paste("There are", counts, input$selected_type, "movies in this dataset.")
  })
  
  # Print data table if checked -----------------------------------------------
  output$moviestable <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data = movies_subset()[, 1:7], 
                    options = list(pageLength = 10), 
                    rownames = FALSE)
    }
  )
}

# Run the application ---------------------------------------------------------
shinyApp(ui = ui, server = server)

