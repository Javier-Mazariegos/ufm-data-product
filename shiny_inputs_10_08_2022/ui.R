#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate)

selection <- state.name[sample(1:length(state.name), size = 1)]

shinyUI(fluidPage(
  
  titlePanel("Shiny Inputs Glossary"),
  
  sidebarLayout(
    sidebarPanel(
      h1("Inputs"),
      numericInput("ninput", "Ingrese un numero:", 
                   value = 10, step = 10), 
      sliderInput('slinput', "Seleccion un porcentje:", 
                  min =0, max = 100, step =1, value = 0, 
                  post = '%'),
      sliderInput('slinputmulti', "Seleccion rango:", 
                  value = c(10000,30000),
                  min = 0,
                  max = 150000,
                  step = 1000,
                  pre = 'Q',
                  sep = ','),
      sliderInput('slinputanimate','Pasos:', value = 0, min = 0, max =100, step = 10, animate = TRUE),
      
      dateInput('date_input','Ingrese fecha:',
                value = Sys.Date(),
                language = 'es',
                weekstart = 1,
                format = 'dd-mm-yyyy'),
      dateRangeInput('date_range_input',
                     'Seleccione fechas',
                     start = today()-15,
                     end = today(),
                     max = today(),
                     min = today()-365,
                     language = 'es',
                     separator = 'hasta'),
      selectInput('select_input', 'Seleccione estado:',
                  choices = state.name,
                  selected = selection),
      selectInput('select_input_2','Seleccione letras:',
                  choices = letters, 
                  selected = 'a',
                  multiple = TRUE),
      checkboxInput('chkbox_input', 'Mostrar resumen',
                    value = FALSE),
      checkboxGroupInput('chkbox_group_input','Seleccione opcion:',
                         choices = letters[1:3],
                         selected = NULL,
                         inline = TRUE),
      radioButtons('radio_buttons', 'Seleccione nivel academico',
                   choices = c('primaria' = 1, 
                               'bachillerato' = 2,
                               'licenciatura' = 3,
                               'maestria' = 4,
                               'doctorado' = 5)),
      actionButton('action','correr',
                   icon = icon('database')),
      submitButton()
      
    ),
    
    mainPanel(
      h1("Outputs"),
      h2("numeric input"),
      verbatimTextOutput("out_numeric_input"),
      h2("slider input"),
      h3("slider input Simple"),
      verbatimTextOutput("out_slider_input"),
      h3("slider input Multiple"),
      verbatimTextOutput("out_slider_input_multi"),
      h3("slider input Animacion"),
      verbatimTextOutput("out_slider_input_ani"),
      h2('Date Input'),
      verbatimTextOutput("out_date_input"),
      h2('Range Date Input'),
      verbatimTextOutput('date_range_input'),
      h2('Select Input'),
      verbatimTextOutput('out_select_input'),
      h2('select input multiple'),
      verbatimTextOutput('multiple_select_input'),
      h2('Check Box Input'),
      verbatimTextOutput('checkbox_output'),
      h2('Check Box Group'),
      verbatimTextOutput('check_box_group_out'),
      h2('Radio Buttons'),
      verbatimTextOutput('radio_buttons_out'),
      h2('Action Button'),
      verbatimTextOutput('boton')
      
    )
  )
))
