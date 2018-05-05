
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

proc sql;
    create table high_top5 as
        select
            Date
            ,High format=dollar12.2
        from
            btcusd161718_v2
        order by
            High descending
        ;
    create table high_top5_print as
        select
            *
        from
            high_top5(obs=5)
        ;
quit;


proc print
    data=high_top5_print
    noobs style(header)={just=c}
    ;
    id
        Date
    ;
    var
        High
    ;
    title "Top 5 High's"
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

proc sql;
    create table low_bottom5 as
        select
            Date
            ,High format=dollar12.2
        from
            btcusd161718_v2
        order by
            High
        ;
    create table low_bottom5_print as
        select
            *
        from
            low_bottom5(obs=5)
        ;
quit;


proc print
    data=low_bottom5_print
    noobs style(header)={just=c}
    ;
    id
        Date
    ;
    var
        High
    ;
    title "Bottom 5 Low's"
    ;
run;
