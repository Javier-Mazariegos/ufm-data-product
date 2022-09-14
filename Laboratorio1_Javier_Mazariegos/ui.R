#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Graficas y mas"),
  
  # Sidebar with a slider input for number of bins
  shiny::tabsetPanel(
    tabPanel("Plot Interactions",
             plotOutput("plot_click_options",
                        click = "clk",
                        dblclick = "dclk",
                        hover = 'mhover',
                        brush = 'mbrush' ),
             verbatimTextOutput("click_data"),
             tableOutput("mtcars_tbl"),
             tableOutput("tablaInteraccion")
    )
    
  )
))
