# NICAR 2018 Intro to R and RStudio
# Sharon Machlis

# Try some simple things in the console
21 * 3

x <- 21
y <- 3

x * y

# Now we're going to see some of the considerably more powerful things R can do.
# This is the "eye candy" part of the session, which shows you some of R's capabilities so you don't leave thinking "Why would I want to learn R? I can do everything she showed me in Excel."
# Unfortunately there's not enough time to explain in detail what's going on.
# The next portion of the session will include explanations :-)


# Getting and visualizing financial information in a few lines of code

library(quantmod)
boeing <- getSymbols("BA", auto.assign = FALSE)

barChart(boeing)
barChart(boeing['2018'])
barChart(boeing['2017:2018'])
barChart(boeing, theme = "white")


library(tidyquant)
dow <- tq_index("DOW")
sp500 <- tq_index("SP500")


# How to get help for a package
help(package = "tidyquant")

boeing_historical <- tq_get("BA", get = "stock.prices", from = "1997-01-01")


# Getting and visualizing Chicago unemployment data

chicago_unemployment <- getSymbols("CHIC917URN", src="FRED", auto.assign = FALSE) 

names(chicago_unemployment) = "rate" 

library("dygraphs") 
dygraph(chicago_unemployment, main="Chicago unemployment")




# Mapping points in a few lines of code. Again, sorry I don't have time to explain, just to see a bit of what else R can do

# data from https://opendata.socrata.com/Business/USA-Starbucks/e3xz-8cw7
# Warning: While this data set was posted to Socrata in 2016, the "about" file says
# it was scraped in 2012. Location info may be out of date!


starbucks <- rio::import("data/USA_Starbucks.csv")
library("leaflet") 

leaflet() %>%  
  addProviderTiles(providers$Esri.WorldStreetMap) %>% 
  setView(-87.62514, 41.89213, zoom = 16) %>%
  addMarkers(data = starbucks, lat = ~ Latitude, lng = ~ Longitude, popup = starbucks$Name) %>%
  addPopups(lng = -87.62514, lat = 41.89213, popup = "NICAR 2018")

# Find coordinates in R
library(ggmap)
library(dplyr)
geocode("Chicago Marriott Downtown Magnificent Mile")

# Works elsewhere besides Chicago
geocode("Empire State Building")

leaflet() %>%  addProviderTiles(providers$Esri.WorldStreetMap) %>% setView(-73.98566, 40.74844, zoom = 15) %>%
  addMarkers(data = starbucks, lat = ~ Latitude, lng = ~ Longitude, popup = starbucks$Name) %>%
  addPopups(lng = -73.98566, lat = 40.74844, popup = "Empire State Building")


## FYI Updated Starbucks for local area:
chi_starbucks <- rio::import("data/chi_starbucks_ggmap_geocoded.csv")

leaflet() %>%  
  addProviderTiles(providers$Esri.WorldStreetMap) %>% setView(-87.62514, 41.89213, zoom = 16) %>%
  addMarkers(data = chi_starbucks, popup = chi_starbucks$Name) %>%
  addPopups(lng = -87.62514, lat = 41.89213, popup = "NICAR 2018")



# Get a satic Google Map of Chicago: (occasional problems with "over query limit" - just try again)
get_googlemap("chicago illinois", zoom = 13, maptype = "roadmap") %>% ggmap()

chicago_starbucks <- filter(starbucks, City == "Chicago")

qmplot(Longitude, Latitude, data = chicago_starbucks, color = I("red"))

qmplot(Longitude, Latitude, data = chicago_starbucks, maptype = "watercolor", color = I("red"))
  



