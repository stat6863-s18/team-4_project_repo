
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
'Question: What is the difference between the open and closed price for Bitcoin?'
;

title2 justify=left
'Rationale: This will help us to understand the behavior of Bitcoin for a day.We can see the maximum increase or decrease in Bitcoin in a day'
;

footnote1 justify=left
"Opening price and the closing price has the linear relationship.Generally, both price varies together."
;

footnote2 justify=left
"There is some fluctuation when the price is more than $11000.Below $11000." 
;

footnote3 justify=left
"plot of close and open price is very dense.Price is more than 9000$ after 2018." 
;

*
Note: This comparison can be answered by comparing column open and column close
from table btcusd16, btcusd17 and from btcusd18.

limitations: Value of zero on in any column should exclude for comparison.
otherwise it will be misleading value for open or close.
;

* Scatter plot of open and closed price of Bitcoin by year;
proc sgplot data = btc_analytic_file_data1;
    scatter x = Open y = Close / group = Year;
run;

*Printing 10 observations;
proc print data= btc_analytic_file_data1(obs = 10);
run;

*Summary of Data for years;
proc means 
    data = btc_analytic_file_data1 n mean max min range std
    ;
    class
        Year
    ;
    var
        Diff_open_Close
	Open
	Close
    ;
run;

*correlation between open and close price.;
footnote3 justify=left
"Open and Close price is 99% correlated."
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
'Question: What is the relationship between date and volume?'
;

title2 justify=left
'Rationale: This would provide details that, how volume is related to the date.we can explore this by using weekday and weekend also.'
;

*
Note: This can be answered by plotting Date_ID column on one axis and volume on 
another axis of table btcusd16, btcusd17 and from btcusd18.

Limitations: Zeros in the volume column should be excluded for plot.
;

*Select total volume for year 2016,2017 and 2018 with respect to month;
proc sql;
    create table btc_analytic_file_table02 as
        select 
	    Year
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
"Total volume in the year 2015 was around 1 crores.In 2016, the Total volume went around 2 crores."
;

footnote2 justify=left
"In 2017, the Total volume went around 40000 crores.In 2018, the Total volume went around 45000 crores."
;

proc sgplot data=btc_analytic_file_table02;
    scatter x = Year y = Total_volume;
    symbol1 v=star c=blue;
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
;

*Creating SQL data table for model preparation;
proc sql;
    create table btc_analytic_file_table03 as
        select 
	    Date
	    ,Day
	    ,Close 
	from 
	    btc_analytic_file_data1
        ;
quit;

* Creating time series plot;
footnote1 justify=left
"In 2018, the closing price was started around 8000$ and In 2017, was around 2000$."
;

title3 justify=left
"Time series plot of close price."
;
proc sgplot data=btc_analytic_file_table03;
    scatter x = Date y = Close;
    symbol1 v=star c=blue;
run;

title3 justify=left
"Closing price of bitcoin and days"
;

footnote1 justify=left
"highly active market for bitcoin is on sunday, monday and saturday."
;
proc sgplot data=btc_analytic_file_table03;
    scatter x = Day y = Close;
    symbol1 v=star c=blue;
run;
title;
footnote;
