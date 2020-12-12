# Forecast-Australian-Gas-Production
Analyze monthly Australian Gas production and build models to forecast next 12 months amounts. Time Series Forecasting


## Project Objectives:
The objective of this project is to analyse monthly Australian Gas production dataset “Gas” from thepackage “Forecast”. This dataset contains monthly gas production information from 1956 to 1995 as released by the Australian Bureau of Statistics which is in time series format. I will read the data, do various analysis on the same using reading, plotting, observing and conducting applicable tests. I will also build models to forecast for 12 months period using ARIMA and Auto ARIMA models.


## Assumptions:
1. The sample size is adequate to perform techniques applicable for time series dataset
2. Dataset file is available in the package “Forecast” to be used in R
3. Components of the Time Series is not unknown


## EDA Observations:
1. We have a dataset of 476 observations starting from January 1956 to August 1996.
2. This data contains monthly gas production in Australia per month in the time frame mentioned above.
3. Normal Plot shows 2 patterns:

a. Overall Positive Trend. Even though there wasn’t much growth for around 5-6 years in the beginning, it has been increasing from 1970 onwards.

b. Zig-Zag Seasonality. There is a drop per year, usually around the end of the year. We need to investigate that further.

4. Seasonal Plots allows for seasonal changes to be seen more clearly and is useful in identifying periods in which there is a change in the pattern. There is an increase in production from May to August every year. The highest production per year is usually in July.

5. Subseries Plot indicates the average per period over the years. This plot supports our conclusion above that the highest production every year happens in July.

6. The lag plot indicates that there is positive relationship in lag 12 which means the data is seasonal.

7. Auto-Correlation Plot shows:
a. All correlations are above the blue lines, which means correlation differs significantly from 0.
b. The slow decrease in ACF values indicates a positive trend. The ACF and Trend are inversely correlated.
c. When data is seasonal, the auto correlations will be larger for the seasonal lags, which accounts for the curvy scalloped ACF values. This indicates seasonality.


## Time Series Specific Observations:
1. The gas dataset has trend and seasonality components.
2. There is annual periodicity in the gas dataset.
3. The gas time series is not stationary


## Prediction For Next 12 Months:

Period__Production__Actual	Production- Forecasted

Sep95__57784__58535

Oct95__53231__54446

Nov95__50354__52113

Dec95__38410__45010

Jan96__41600__44635

Feb96__41471__44826

Mar96__46287__50460

Apr96__49013__51406

May96__56624__59661

Jun96__61739__63580

Jul96__66600__68443

Aug96__60054__65892


