
*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file generating "analytic file" dataset btc_analytic_file, 
%include '.\STAT6863-01_s18-team-4_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: What is the top 5 market cap of Bitcoin BTC from April 2016 to April 2018?.'
;

title2 justify=left
'Rationale: This will help identify the market cap  of Bitcoin as compared to other cryptocurrency.'
;


footnote1 justify=left
"Top High Market Cap of Bitcoin were seen in Dec 2017 between Dec 15 and Dec 20."
;

*
Note: This compares the column the column "MarketCap" from btcusd16 to the same
name column from btcusd17 and btcusd18

Limitations: This methodology does not account for datasets with missing 
data neither does it attempt to validate data in any way.
;

proc sql;
    create table Market_Cap_top5 as
        select
            Date
            ,MarketCap format=dollar12.2
        from
            btc_analytic_file
        order by
            MarketCap descending
        ;
    create table MarketCap_top5_print as
        select
            *
        from
            Market_Cap_top5(obs=5)
        ;
quit;


proc print
    data=MarketCap_top5_print
    noobs style(header)={just=c}
    ;
    id
        Date
    ;
    var
        MarketCap
    ;
   
run;
title;
footnote;

title1 justify=left
'ScatterPlot Metrics'
;

footnote1 justify=left
"ScatterPlot of Bitcoin MarketCap by year."
;


proc sgplot data=MarketCap_top5_print;
    scatter
        x=Date
        y=MarketCap
    ;
	
run;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: What are the top 5 highest prices between this time period?.'
;

title2 justify=left
'Rationale: This would help provide more insight into how cryptocurrency fared.'
;

footnote1 justify=left
"Top High Bitcoin prices are seen in Dec 2017."
;

*
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
             btc_analytic_file
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
run;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: What are the top 5 lowest prices between this time period?.'
;

title2 justify=left
'Rationale: This would provide help identify the time and market conditions leading to it.'
;

footnote1 justify=left
"Bottom lowest Bitcoin prices were seen between April and June 2015."
;

*
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
            btc_analytic_file
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

run;
title;
footnote;
