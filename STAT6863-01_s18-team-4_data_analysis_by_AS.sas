
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
Question: What is the marcket cap of Bitcoin BTC from April 2015 to April 2016?

Rationale: This will help identify the market cap  of Bitcoin as compared to 
other cryptocurrency
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What are the top 5 highest prices and  lowest prices between this time 
period?

Rationale: This would help provide more insight into how cryptocurrency fared
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What are the top 5 lowest prices between this time period?

Rationale: This would provide help identify the time and market conditions 
leading to it.
;

