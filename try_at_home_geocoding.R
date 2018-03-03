# NICAR 2018 Intro to R and RStudio
# Sharon Machlis

# script to geocode spreadsheet of Chicago Starbucks
# Without API key. May need a few tries because of over query limit msg

library(dplyr)
library(ggmap)

chi_starbucks <- rio::import("data/chicago_starbucks.xlsx") %>%
  mutate(
    Full_Address = paste(Address, City, State, sep = ", ")
  )

chi_starbucks <- chi_starbucks %>%
  ggmap::mutate_geocode(Full_Address)

# That's it!
rio::export(chi_starbucks, "data/chi_starbucks_ggmap_geocoded.csv")


