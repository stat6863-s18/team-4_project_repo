
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
Question: What is the marcket cap of Bitcoin BTC from April 2016 to April 2018?

Rationale: This will help identify the market cap  of Bitcoin as compared to 
other cryptocurrency

Note: This compares the column the column "MarketCap" from btcusd16 to the same
name column from btcusd17 and btcusd18

Limitations: This methodology does not account for datasets with missing 
data neither does it attempt to validate data in any way.
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What are the top 5 highest prices between this time period?

Rationale: This would help provide more insight into how cryptocurrency fared

Note: This compares the column "High"  from btcusd16 to the same name columns 
from btcusd17 and btcusd18.

Limitations: This methodology does not account for datasets with missing 
data neither does it attempt to validate data in any way.
;

proc sort
    data=btcusd161718_v2
    out=btcusd161718_v2_print1
    ;
    by descending High;
run;

proc print
    noobs
    data=btcusd161718_v2_print1(obs=5)
    ;
    id
        Date
    ;
    var
        High
    ;
run;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What are the top 5 lowest prices between this time period?

Rationale: This would provide help identify the time and market conditions 
leading to it.

Note: This compares the column the column "Low" from btcusd16 to the same 
name columns from btcusd17 and btcusd18.

Limitations: This methodology does not account for datasets with missing 
data neither does it attempt to validate data in any way.
;

proc sort
    data=btcusd161718_v2
    out=btcusd161718_v2_print2
    ;
    by Low;
run;

proc print
    noobs
    data=btcusd161718_v2_print2(obs=5)
    ;
    id
        Date
    ;
    var
        Low
    ;
run;
