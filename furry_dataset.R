#This script creates the 'furry_dataset.csv' 

#devtools::install_github("ropenscilabs/charlatan")
library(charlatan)


#generate fake data using the charlatan ropensci pkg
#here we create names, colors, latitude and longitude
fdat <- ch_generate('name','color_name', n=600)

x <- fraudster()
fdat$latitude <- round(replicate(600, x$lat()),2)
fdat$longitude <- round(replicate(600, x$lon()),2)

#next create a set of furry animals and their career aspirations
fdat$animal <- rep(c("llama", "sloth", "capybara", "guinea pig", "wolverine", "quokka"), 100)
fdat$job <- sample(c("drummer", "scientist", "pilot", "customs officer", "singer"), 600, replace=TRUE)

#other metrics that will be tailored per animal
fdat$weight <- NA 
fdat$iq <- NA
fdat$fitbit <- NA

#creates a function to specify normal distributions for weight, iq, and fitbit steps based on the animal
furrydata <- function(fdat, furry, mean_weight, sd_weight, mean_iq, sd_iq, mean_steps, sd_steps) {
  #animal weight
  fdat[fdat$animal == furry, "weight"] <- sample(round(rnorm(n=1000, mean=mean_weight, sd=sd_weight),2), 100)
  #animal IQ
  fdat[fdat$animal == furry, "iq"] <- sample(round(rnorm(n=1000, mean=mean_iq, sd=sd_iq),0), 100)
  #animal fitbit
  fdat[fdat$animal == furry, "fitbit"] <- sample(round(rnorm(n=1000, mean=mean_steps, sd=sd_steps),0), 100)
  return(fdat)
}

#use the furrydata function to create animal specific distributions
fdat <- furrydata(fdat,"guinea pig", 1, 0.2, 30, 10, 1500, 200)
fdat <- furrydata(fdat,"llama", 350, 100, 70, 10, 10000, 500)
fdat <- furrydata(fdat,"capybara", 115, 40, 50, 5, 6000, 500)
fdat <- furrydata(fdat,"quokka", 8, 3, 35, 5, 4000, 250)
fdat <- furrydata(fdat,"wolverine", 40, 15, 95, 15, 50000, 20000)
fdat <- furrydata(fdat,"sloth", 13, 4, 20, 3, 20, 10)

#make sure there are no negative or zero elements
fdat$fitbit <- ifelse(fdat$fitbit <= 0, 1, fdat$fitbit)
fdat$weight <- ifelse(fdat$weight <= 0, 0.2, fdat$weight)
fdat$iq <- ifelse(fdat$iq <= 0, 1, fdat$iq)

write.csv(fdat, "furry_dataset.csv", row.names=FALSE)
