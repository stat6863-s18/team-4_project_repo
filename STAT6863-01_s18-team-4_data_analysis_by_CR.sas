
*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* load external file generating "analytic file" dataset btc_analytic_file, from
which all data analyses below begin;
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that will generate final analytic file; 
%include '.\STAT6863-01_s18-team-4_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;


title1 justify=left
"Question: What is the relationship between the open and closed price for Bitcoin?"
;

title2 justify=left
"Rationale: This will help us to understand the behavior of Bitcoin for a day.We can see the maximum increase or decrease in Bitcoin in a day"
;

*
Note: This comparison can be answered by comparing column open and column close
from table btcusd16, btcusd17 and from btcusd18.

limitations: Value of zero on in any column should exclude for comparison.
otherwise it will be misleading value for open or close.

Methodology: Use proc Report to print first 10 rows of data. Then
use proc means to get summary of closing and opening price by year.

Followup Steps: Then plotted closing and opening price to see the trend of price. 
followed by the correlation coefficient of closing and opening price.
;

*Summary of Data for years;
title3 justify=left
"summary of data" 
;

footnote1 justify=left
"In 2015, the 1unit  difference in standard deviation and Range can be observed."
;

footnote2 justify=left
"In 2016, the 1 unit difference in mean, min and Range can be observed. and 2 unit in standard deviation." 
;

footnote3 justify=left
"In 2017, 28 units difference in standard deviation. which means closing price and opening price is more scattered." 
;

footnote4 justify=left
"In 2018, 5 unit difference in standard deviation because we don't have enough data." 
;

proc means 
    data = btc_analytic_file_data1 n mean max min range std
    ;
    class
        Year
    ;
    var
	Open
	Close
    ;
run;

title;
* Scatter plot of open and closed price of Bitcoin by year,addressing research question;
footnote1 justify=left
"Opening price and the closing price has the linear relationship.Generally, both price varies together."
;

footnote2 justify=left
"There is some fluctuation when the price is more than $11000." 
;

footnote3 justify=left
"plot of close and open price is very dense.Price is more than 9000$ after 2018." 
;

footnote4 justify=left
"Closing price and opening price is positively correlated." 
;

proc sgplot data = btc_analytic_file_data1;
    scatter x = Open y = Close / group = Year;
run;

*correlation between open and close price,addressing research question.;
title3 justify=left
"correlation between open and close price" 
;

footnote3 justify=left
"Open and Close are normally distributed."
;

footnote3 justify=left
"As p-value is significant, we can conclude that open and close price is highly positively correlated."
;

proc corr data = btc_analytic_file_data1;
    var Open Close;
run;
title:
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;


title1 justify=left
'Question: How volume change from the year 2015 to 2018??'
;

title2 justify=left
'Rationale: This would provide details that, how volume is related to the date.we can explore this by using weekday and weekend also.'
;

*
Note: This can be answered by plotting Date_ID column on one axis and volume on 
another axis of table btcusd16, btcusd17 and from btcusd18.

Limitations: Zeros in the volume column should be excluded for plot.

Methodology: Use proc sql to create total volume columne for analysis, followed
by ploting of volume.

Followup Steps: A possible follow-up to this approach could use a more formal
inferential technique like time seiers model.
;

*Select total volume for year 2016,2017 and 2018 with respect to month;
proc sql;
    create table btc_analytic_file_table02 as
        select 
	    Date
	    ,Year
	    ,Month
	    ,sum(Volumn) as Total_volume
	from 
	    btc_analytic_file_data1
	group by
	    Month
	    ,Year
        ;
quit;

title3 justify=left
'Time series plot of Volumne'
;

footnote1 justify=left
"Total volume in the year 2015 was around $10 millions.In 2016, the Total volume went around $20 millions."
;

footnote2 justify=left
"In 2017, the Total volume went around $400000 million.In 2018, the Total volume went around $450000 millions."
;

proc sgplot data=btc_analytic_file_table02;
    styleattrs datacolors=(red green purple orange cyan) backcolor=vpav wallcolor=pwh;
    vbox Total_volume / category=Year group=Year;
run;
title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;


title1 justify=left
'Question: Which model is good to predict Bitcoin closing price?'
;

title2 justify=left
"Rationale: This would provide, prediction capability."
;

*
Note: The time series linear model can be helpful for this analysis, for training, 
I will merge table  btcusd16, btcusd17 and from btcusd18 and use 80% random data 
for training and 20% random data for test.Responce column is Date_Id and predictors 
are close, open, High, Low, volume, Market cap column.

Limitations: Model assumptions should be valid for prediction.

Methodology: Use proc sort to create a temporary table with relevant data. Then
use sgplot to create plot of closing price with respect to date and days. After that 
I ran ARIMA(1,1,1) model.

Followup Steps: We can try other time series model. I am using this model. As this
is doing reasonable job for me.
;

* Creating time series plot;
title3 justify=left
"Time series plot of close price."
;

footnote1 justify=left
"In 2018, the closing price was started around 8000$ and In 2017, was around 2000$."
;

footnote2 justify=left
"The plot is not stationary. it has trend component which suggests differencing of series."
;

proc sgplot data=btc_analytic_file_data1;
    scatter x = Date y = Close;
    symbol1 v=star c=blue;
run;

title1 justify=left
"Closing price of bitcoin and days"
;

footnote1 justify=left
"highly active market for bitcoin is on sunday, monday and saturday."
;
proc sgplot data=btc_analytic_file_data1;
    scatter x = Day y = Close;
    symbol1 v=star c=blue;
run;

*Timeseries data;
proc timeseries data = btc_analytic_file_data1 
			 out = timeseries;
   id Date interval = day;
   var Close;
run;

*ACF and PACF plots to identify AR and MA order;
footnote1 justify=left
"ACF has decreasing trend and PACF has ups and downs."
;

footnote1 justify=left
"We should us AR and MA order to generate the good model."
;
proc ARIMA data = btc_analytic_file_data1;
    identify var = Close nlag = 24;
run;

*Timeseries model;
title1 justify=left
"ARIMA(1,1,1) model for closing price prediction"
;

footnote1 justify=left
"95% Confidence interval of prediction."
;

proc arima data=timeseries;
   identify var = Close(1) Noprint;
   estimate p=1 q=1 outest=estimates noprint;
   forecast id=Date out=forecasts;
quit;
title;
footnote;
