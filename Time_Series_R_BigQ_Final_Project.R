#Installing packages and calling out the libraries
install.packages("summarytools")
install.packages("tseries")
install.packages("forecast")
install.packages("bigrquery")
library(forecast)
library(ggplot2)
library(tseries)
library(summarytools)
library(readr)

### Data Cleaning ###

#Read in csv, use all rows but only column 7 for volume_sold_liters
# or #
#Retrieve data from iowa liquor sales which is a GCP public dataset

#Three years is better than two for forecasting
#FY2017 has 53 weeks, the last week of February has been removed to improve forecast

#The final week of FY2018 started on Sunday Dec 30, the next day would be a Monday/Holiday so stores closed early
#Data WILL NOT be altered but this outlier will be discussed during presentation

#working_directory <- getwd()

IowaData <- read_csv("C:/Users/axj2722/OneDrive - The Home Depot/Desktop/Final_Project_Iowa_Liquor/Iowa_Liquor_Weekly_2016_2018_NoDate.csv")
IowaData <- IowaData[,7]
#View(IowaData)

#this dataset has records WEEKLY from 2016 to 2018
liquortime <- ts(IowaData,frequency = 52,start = c(2016))

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
#Warning message: In HoltWinters(liquortime, beta = FALSE, gamma = NULL, seasonal = c("additive")) :
#optimization difficulties: ERROR: ABNORMAL_TERMINATION_IN_LNSRCH

liquorforecast3 <- HoltWinters(liquortime, beta = FALSE, gamma = NULL, seasonal = c("additive"))
plot(liquorforecast3)

liquorforecast4 <- forecast(liquorforecast3)
plot(liquorforecast4)

point_fc <- liquorforecast4$mean
lo_80 <- liquorforecast4$lower
hi_95 <- liquorforecast4$upper

liquorforecast4


#IowaForecast <- as.data.frame(liquorforecast4)
#write.table(IowaForecast, file="C:/Users/axj2722/OneDrive - The Home Depot/Desktop/Final_Project_Iowa_Liquor/Iowa_Liquor_Weekly_Forecast.csv", quote=F, sep=";", dec=",", na="", row.names=T, col.names=T)















