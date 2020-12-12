getwd()
setwd("C:/Users/keshavaa/Documents/R_Working_Apoorva")

rm(list = ls())

# Libraries Used #
library(forecast)
library(imputeTS)
library(TSstudio)
library(TSA)
library(fpp2)
library(readxl)
library(ggplot2)
library(tseries)
library(tidyverse)
library(rio)
library(dplyr)
library(reshape2)
library(chron)
library(pear)
library(StatMeasures)
library(vars)
library(MLmetrics)

# Get Dataset #

data(gas)
View(gas)
str(gas)
class(gas)
head(cycle(gas),24)
start(gas)
end(gas)
summary(gas)

# Outliers #
tsoutliers(gas)
plotNA.distribution(gas)

gas = tsclean(gas, replace.missing = TRUE)

##    Plots   ##

# Normal Plot #
plot(gas)
autoplot(gas)
plot.ts(gas)

# Seasonal Plot #
seasonplot(gas, col = rainbow(12))
ggseasonplot(gas)
ggseasonplot(gas, polar = TRUE)

# Subseries Plot #
ggsubseriesplot(gas)

# Lag plot #
gglagplot(gas)

# Auto-Correlation Plot #
tsdisplay(gas)


##   Determining Periodicity   ##

# DFT Method #
p = periodogram(gas)
p_data = data.frame(freq = p$freq, spec = p$spec)
p_highest = p_data[order(-p_data$spec),]
head(p_highest,2)
# Converting freq into time # 
p_time = 1/ (head(p_highest,2))$f
p_time

# Auto Correlation Method #
ggAcf(gas)
acf(gas)


##  Determining if TS is Stationary  ##

# Visual Method #
plot(gas)

# Summary Statistics # 
split1 = window(gas, start = c(1956,1), end = c(1966, 12), frequency = 12)
split2 = window(gas, start = c(1967,1), end = c(1975, 12), frequency = 12)
split3 = window(gas, start = c(1976,1), end = c(1996, 1), frequency = 12)

mean(split1)
var(split1)
mean(split2)
var(split2)
mean(split3)
var(split3)

# Dickey- Fuller Test #
adf.test(gas)


##  Decomposing Gas Dataset  ## 

ts_decompose(gas)
ts_seasonal(gas, type = "all")

# Remove Trend element and replot #
ts_seasonal(gas - decompose(gas)$trend, type = "all",
            title = "Seasonal Plot - Gas (De-Trend)")


##   De- Seasonalize Time Series  ##

# Constant Seasonality #
gas_constant = stl(gas, s.window = "p")
plot(gas_constant)
gas_constant

# Non - Constant Seasonality #
gas_nonconstant = stl(gas, s.window = 7)
plot(gas_nonconstant)
gas_nonconstant

Deseason_gas = (gas_constant$time.series[,2] + gas_constant$time.series[,3])
ts.plot(Deseason_gas, gas, col = c("blue", "orange"),
        main = "Comparison of Gas & De-seasonalized Gas")

# Difference to make data stationary #

adf.test(diff(gas))
gasdiff = diff(gas)

# q value #
acf(gas, lag =50, main = "Auto Correlation (q)")

# p value #
pacf(gas, lag = 50, main = "Partial Auto Correlation (p)")

##      ARIMA Model     ##

# ARIMA (p,d,q) #
gas.arima.fit = arima(gas, c(2,1,2))
summary(gas.arima.fit)
hist(gas.arima.fit$residuals, col = "blue")

# Testing with Original # 
ts.plot(gas, fitted(gas.arima.fit), col = "green", "blue")

# ACF Test #
acf(gas.arima.fit$residuals)

# Ljung Box Test #
Box.test(gas.arima.fit$residuals, lag = 50, type = "Ljung-Box")

# Redoing ARIMA with Seasonal Component #
gas.arima.fit.s = arima(gas, c(2,1,2),
                        seasonal = list(order = c(1,1,2),
                        period = 12))
summary(gas.arima.fit.s)                                                               
hist(gas.arima.fit.s$residuals, col = "blue")

# Testing with Original # 
ts.plot(gas, fitted(gas.arima.fit.s), col = "green", "blue")

# ACF Test #
acf(gas.arima.fit.s$residuals)

# Ljung Box Test #
Box.test(gas.arima.fit.s$residuals, lag = 50, type = "Ljung-Box")


## AUTO ARIMA ##

fitauto = auto.arima(gas, seasonal = TRUE, trace = T)
hist(fitauto$residuals, col = "blue")
summary(fitauto)

# Testing with Original # 
ts.plot(gas, fitted(fitauto), col = "green", "blue")

# ACF Test #
acf(fitauto$residuals)

# Ljung Box Test #
Box.test(fitauto$residuals, lag = 50, type = "Ljung-Box")

checkresiduals(fitauto)


#### Changing Data Set   ####

gassub = window(gas, start = c(1990, 1), frequency = 12)
plot(gassub)

adf.test(gassub)
pacf(gassub, lag = 50)
plot(gassub)

# ARIMA MODEL #
gas.arima.fit = arima(gassub, c(0,0,2))
summary(gas.arima.fit)
hist(gas.arima.fit$residuals)

ts.plot(gassub, fitted(gas.arima.fit), col = c("blue", "red"))
acf(gas.arima.fit$residuals)
Box.test(gas.arima.fit$residuals, lag = 50, type = "Ljung-Box")

# ARIMA MODEL with seasonality #
gas.arima.fit.s = arima(gassub, c(0,0,2),
                        seasonal = list(order= c(1,1,0),
                                        period = 12))
summary(gas.arima.fit.s)
hist(gas.arima.fit.s$residuals)

ts.plot(gassub, fitted(gas.arima.fit.s), col = c("blue", "red"))
acf(gas.arima.fit.s$residuals)
Box.test(gas.arima.fit.s$residuals, lag = 50, type = "Ljung-Box")

## AUTO ARIMA ##

fitauto = auto.arima(gassub, seasonal = TRUE, trace = T)
hist(fitauto$residuals, col = "blue")
summary(fitauto)

ts.plot(gassub, fitted(fitauto), col = c("blue", "red"))
acf(fitauto$residuals)
Box.test(fitauto$residuals, lag = 50, type = "Ljung-Box")
checkresiduals(fitauto)

# Forecast #
forecasting = forecast(gas.arima.fit.s, h = 12)
forecasting$mean
plot(forecast(gas.arima.fit.s), h= 12)

tail(gas, 12)
