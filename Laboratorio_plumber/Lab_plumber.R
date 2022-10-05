#Javier Alejandro Mazariegos Godoy

library(plumber)
library(dplyr)
library(rpart)
library(readxl)
library(lubridate)
library(jsonlite)
library(SPlit)

df <- read.csv("s&p.csv")
df <- df %>% mutate(Fecha = dmy(Fecha))
fit <- readRDS("modelo_final.rds")

#* @apiTitle Modelo del Titanic
#* @apiDescription Este api nos servira para predicir
#* si un pasajero del titanic sobrevive o no

#* Log some information about the incoming request
#* @filter logger
function(req){
  wd <- getwd()
  fecha <- Sys.time()
  if(length(req$args) != 0){
    dir <- paste0(wd,'/',strsplit(req$PATH_INFO,split= "/")[[1]][2],'/','year=',year(fecha),'/','month=',month(fecha),'/','day=',day(fecha))
    if (file.exists(dir)){
      cat("The folder already exists")
    }
    else{
      dir.create(dir, recursive = TRUE)
    }
    json = toJSON(list(' reg' =req$args,
                       'query'=req$QUERY_STRING, 'user_agent'
                       
                       =req$HTTP_USER_AGENT))
    write(json,file=paste0(dir,"/",as.integer(Sys.time()),'.json')) 
  }

  plumber::forward()
}

#* Prediccion de sobrevivencia de un pasajero
#* @param Pclass clase en el que viajabe el pasajero
#* @param Sex Sexo del pasajero
#* @param Age edad del pasajero
#* @param SibSp numero de hermanos
#* @param Parch numero de parientes
#* @param Fare precio del boleto
#* @param Embarked puerto del que embarco
#* @post /titanic

function(Pclass, Sex, Age, SibSp, Parch, Fare, Embarked){
  features <- data_frame(Pclass = as.integer(Pclass),
                         Sex,
                         Age=as.integer(Age),
                         SibSp= as.integer(SibSp),
                         Parch = as.integer(Parch),
                         Fare = as.numeric(Fare),
                         Embarked)
  out <- predict(fit,features,type = "class")
  as.character(out)
  
}


users <- data.frame(
  uid=c(12,13),
  username=c("kim", "john")
)

#* Lookup a user
#* @get /users/<id>
function(id){
  subset(users, uid %in% id)
}


#* Buscar por fechas
#* @get /user/<from>/connect/<to>
function(from, to){
  from <- ymd(from)
  to <- ymd(to)
  resultado <- subset(df,Fecha >= from & Fecha <= to)
  resultado
  # Do something with the `from` and `to` variables...
}

#* @get /int/<id:int>
function(id){
  list(
    id = id,
    type = typeof(id)
  )
}

#* @get /bool/<id:bool>
function(id){
  list(
    id = id,
    type = typeof(id)
  )
}

#* @get /logical/<id:logical>
function(id){
  list(
    id = id,
    type = typeof(id)
  )
}

#* @get /double/<id:double>
function(id){
  list(
    id = id,
    type = typeof(id)
  )
}

#* @get /numeric/<id:numeric>
function(id){
  list(
    id = id,
    type = typeof(id)
  )
}







