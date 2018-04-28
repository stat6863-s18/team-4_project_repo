
*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that will generate final analytic file; 
%include '.\STAT6863-01_s18-team-4_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What is the difference between the open and closed price for Bitcoin?

Rationale: This will help us to understand the behavior of Bitcoin for a day. 
We can see the maximum increase or decrease in Bitcoin in a day.

Note: This comparison can be answered by comparing column open and column close
from table btcusd16, btcusd17 and from btcusd18.

limitations: Value of zero on in any column should exclude for comparison.
otherwise it will be misleading value for open or close.
;

*Calculating difference of open and close;
proc sql;
	create table btcusd161718_v3 as
		select 
			Date
			,Open
			,Close
			,Open-Close as diff_open_Close
		from 
			btcusd161718_v2

	;
quit;

*Formatting Date;

DATA 
	btcusd161718_v4;
	SET btcusd161718_v3;
	Date = INPUT(PUT(Date,8.),YYMMDD8.);
	year = YEAR(Date);
	FORMAT Date yymmdd10.;
RUN;

*Contents of data;
proc contents 
	data= btcusd161718_v4;
run;

*Summary of Data for years;
proc means 
	data = btcusd161718_v4 n mean max min range std
	;
	class
		year
	;
	var
		diff_open_Close
		Open
		Close
	;
		
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What is the relationship between date and volume?

Rationale: This would provide details that, how volume is related to the date. 
we can explore this by using weekday and weekend also.

Note: This can be answered by plotting Date_ID column on one axis and volume on 
another axis of table btcusd16, btcusd17 and from btcusd18.

Limitations: Zeros in the volume column should be excluded for plot.
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Which model is good to predict Bitcoin closing price?

Rationale: This would provide, prediction capability.

Note: The time series linear model can be helpful for this analysis, for training, 
I will merge table  btcusd16, btcusd17 and from btcusd18 and use 80% random data 
for training and 20% random data for test.Responce column is Date_Id and predictors 
are close, open, High, Low, volume, Market cap column.

Limitations: Model assumptions should be valid for prediction.
;
