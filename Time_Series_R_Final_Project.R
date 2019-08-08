#Installing packages and calling out the libraries
install.packages("summarytools")
install.packages("tseries")
install.packages("forecast")
library(forecast)
library(ggplot2)
library(tseries)
library(summarytools)
library(readr)

#Read in csv, use all rows but only column 7 for volume_sold_liters
Farah_Agg_Clean <- read.csv("C:/Users/axj2722/OneDrive - The Home Depot/Desktop/Final_Project_Iowa_Liquor/Farah_Agg_Clean_NoDate.csv")
Farah_Agg_Clean <- Farah_Agg_Clean[,7]
#View(Farah_Agg_Clean)

#this dataset has records MONTHLY from 2012 to 2018
liquortime <- ts(Farah_Agg_Clean,frequency = 12,start = c(2012))

liquortime

plot.ts(liquortime)

#Decompose Seasonal Data
#A seasonal time series consists of a trend component, a seasonal component and an irregular component.
#Decomposing the time series means separating the time series into these three components: that is, estimating these three components.
liquortimecomponents <- decompose(liquortime)
plot(liquortimecomponents)


#Simple Exponential Smoothing
#If you have a time series that can be described using an additive model with constant level and no seasonality,
#you can use simple exponential smoothing to make short-term forecasts.

#The simple exponential smoothing method provides a way of estimating the level at the current time point.
#Smoothing is controlled by the parameter alpha; for the estimate of the level at the current time point.
#The value of alpha; lies between 0 and 1. 
#Values of alpha that are close to 0 mean that little weight is placed on the most recent observations 
#when making forecasts of future values.

#.077 alpha
liquorforecast <- HoltWinters(liquortime, beta = FALSE, gamma = FALSE)

#Data has been smoothed with Holt-Winters
liquorforecast
plot(liquorforecast)


liquorforecast2 <- forecast(liquorforecast)
liquorforecast2

plot(liquorforecast2)


# Try using seasonal component
liquorforecast3 <- HoltWinters(liquortime, beta = FALSE, gamma = NULL, seasonal = c("additive"))
plot(liquorforecast3)

liquorforecast4 <- forecast(liquorforecast3)
plot(liquorforecast4)
liquorforecast4
