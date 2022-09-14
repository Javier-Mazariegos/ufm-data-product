library(shiny)
library(ggplot2)
library(dplyr)

puntosx <<- reactiveVal(0)
puntosy <<- reactiveVal(0)
tipo_interaccion <<- reactiveVal("")
ejjjl <<- NULL

glob <<- reactiveValues()

shinyServer(function(input, output) {
  
  graficar <- function(data_puntos){
    return(points(data_puntos$wt, data_puntos$mpg, pch = 19, col=data_puntos$interaccion))
  }
  

  ingresar <- function(indice){
    ejjjl <<- as.data.frame(brush_puntos[indice,])
    diferencia <- toString(ejjjl[1]-ejjjl[6])
    ejjjl <- ejjjl %>% mutate(interaccion="green")
    glob[[diferencia]] = ejjjl
  }
  
  output$click_data <- renderPrint({
    clk_msg <- NULL
    dclk_msg<- NULL
    mhover_msg <- NULL
    mbrush_msg <- NULL
    
    if(!is.null(input$clk$x) ){
      punto <- nearPoints(mtcars,input$clk,xvar='wt',yvar='mpg')
      
      puntosy(punto$mpg)
      puntosx(punto$wt)
      tipo_interaccion("green")
      
      if(nrow(punto) != 0){
        diferencia <- toString(punto$mpg-punto$wt)
        punto <- punto %>% mutate(interaccion="green")
        glob[[diferencia]] = punto
      }
      
      
      
      clk_msg<-
        paste0("click cordenada x= ", round(input$clk$x,2),
               " click coordenada y= ", round(input$clk$y,2))

      
      
    }
    if(!is.null(input$dclk$x) ){
      punto <- nearPoints(mtcars,input$dclk,xvar='wt',yvar='mpg')
      puntosy(punto$mpg)
      puntosx(punto$wt)
      tipo_interaccion("doble_click")
      dclk_msg<-paste0("doble click cordenada x= ", round(input$dclk$x,2),
                       " doble click coordenada y= ", round(input$dclk$y,2))
      
      
      if(nrow(punto) != 0){
        diferencia <- toString(punto$mpg-punto$wt)
        glob[[diferencia]] = NULL
      }
      
      
    }
    if(!is.null(input$mhover$x) ){
      punto <- nearPoints(mtcars,input$mhover,xvar='wt',yvar='mpg')
      puntosy(punto$mpg)
      puntosx(punto$wt)
      tipo_interaccion("hover")
      
      
      if(nrow(punto) != 0){
        diferencia <- toString(punto$mpg-punto$wt)
        punto <- punto %>% mutate(interaccion="gray")
        glob[[diferencia]] = punto
      }
      
      
      mhover_msg<-paste0("hover cordenada x= ", round(input$mhover$x,2),
                         " hover coordenada y= ", round(input$mhover$y,2))
    
      
      
      
    }
    
    
    if(!is.null(input$mbrush$xmin)){
      brush_puntos <<- brushedPoints(mtcars,input$mbrush,xvar='wt',yvar='mpg')
      brush_puntos_x = brush_puntos[6]
      brush_puntos_y = brush_puntos[1]
      puntosy(brush_puntos_y)
      puntosx(brush_puntos_x)
      tipo_interaccion("brush")
      
      
      if(nrow(brush_puntos) != 0){
        lapply(1:length(brush_puntos), ingresar)
      }
      
      

      brushx <- paste0(c('(',round(input$mbrush$xmin,2),',',round(input$mbrush$xmax,2),')'),collapse = '')
      brushy <- paste0(c('(',round(input$mbrush$ymin,2),',',round(input$mbrush$ymax,2),')'),collapse = '')
      mbrush_msg <- cat('\t rango en x: ', brushx,'\n','\t rango en y: ', brushy)
      
    }
    
    
  
    cat(clk_msg,dclk_msg,mhover_msg,mbrush_msg,sep = '\n' )
   
    
  })
  
  
  
  output$mtcars_tbl <- renderTable({
    df <- nearPoints(mtcars,input$clk,xvar='wt',yvar='mpg')
    brush_puntos <- brushedPoints(mtcars,input$mbrush,xvar='wt',yvar='mpg')
    ##df <- brushedPoints(mtcars,input$mbrush,xvar='wt',yvar='mpg')
    if(nrow(df)!=0){
      df
    } 
    
    if(nrow(brush_puntos)!=0){
      brush_puntos
    }
    
  })
  

  
  output$plot_click_options <- renderPlot({
    plot(mtcars$wt,mtcars$mpg, xlab = "wt", ylab="millas por galon")
    puntos_lista = reactiveValuesToList(glob)
    lapply(puntos_lista, graficar)
    
  })
  
  
})
