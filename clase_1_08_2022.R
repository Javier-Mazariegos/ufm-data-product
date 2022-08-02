install.packages('rnaturalearth')
library(rnaturalearth)
library(sp)
library(wbstats)
library(DT)
library(leaflet)

map <- ne_countries()
plot(map)
