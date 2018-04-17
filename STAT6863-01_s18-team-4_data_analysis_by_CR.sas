
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
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What is the relationship between date and volume?

'Rationale: This would provide details that, how volume is related to the date. we can explore this by using weekday and weekend also.'
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Which model is good to predict Bitcoin closing price?

Rationale: This would provide, prediction capability.'
;
