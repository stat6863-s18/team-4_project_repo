*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding bitcoin (BTC).

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that will generate final analytic file; 
%include '.\STAT6863-01_s18-team-4_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question 1: What is the distribution of Bitcoin BTC from April 2016 to present?'
;

title2
'Rationale: This should help identify the specific distribution of BTC'
;


title1
'Research Question 2: What are the top 10 highest prices and top 10 lowest prices during these years?'
;

title2
'Rationale: This would provide more BTC behaviors, movements and have a better insights why there are such changes'
;


title1
'Research Question 3: What are major corrections in Bitcoin history?'
;

title2
'Rationale: This would provide more true understanding of a few major corrections in the past and use those outputs to forecast or predict the BTC price for the year of 2018.'
;
