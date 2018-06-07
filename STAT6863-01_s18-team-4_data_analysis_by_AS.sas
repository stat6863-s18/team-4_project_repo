
*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file generating "analytic file" dataset btc_analytic_file;
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

footnote2 justify=left
"Highest Market Cap was seen on Dec 17,2017 when the market cap seen was 326141000000.Given the spike in magnitude of market cap in these couple of days it suggests the market sentiment towards bitcoin"
;

footnote3 justify=left
"Highest Market Cap were seen 3 days between Dec 17 and Dec 20,2017"
;

*
Note: This compares the column the column "MarketCap" from btcusd16 to the same
name column from btcusd17 and btcusd18

Limitations: This methodology does not account for datasets with missing 
data neither does it attempt to validate data in any way.

Methodology: The procedure PROC SQL is used to process the SQL statements.
This procedure can not only give back the result of an SQL query, it can 
also create SAS tables & variables. We will select Date and MarketCap 
from btc_analytic file and then use proc print to print the values

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data.
;

proc sql outobs=5;
    create table Market_Cap_top5 as
        select
             Date
            ,MarketCap format=dollar12.2
        from
            btc_analytic_file
        order by
            MarketCap descending
        ;
quit;

* Print the top 5 Market Cap's  between April 2016- April 2018;
proc report data=Market_Cap_top5(obs=5);
     define Date / display;
     define MarketCap / display;
run;
title;
footnote;

title1 justify=left
'ScatterPlot Metrics'
;

footnote1 justify=left
"ScatterPlot of Bitcoin MarketCap by year."
;

footnote1 justify=left
"As seen in the scatterplot merics we can conclude that market interest in crytopcurrency was due to panic in stock market and other global news that triggered the event."
;

proc sgplot data=Market_Cap_top5;
    scatter
        x=Date
        y=MarketCap
    ;
	
run;
title1;
footnote1;

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
"Top High Bitcoin prices are seen in Dec 2017. Bitcoin saw its peak in 2017 December wherin the highest price seen was $20,089"
;

footnote2 justify=left
"Top 5 highest prices in Dec 2017 were in excess of $18,500. If compared with other crypto currencies we can conclude that this was due to global panic and investors gloabally investing in crypto currency vs stocks and bonds";
*
Note: This compares the column "High"  from btcusd16 to the same name columns 
from btcusd17 and btcusd18.

Limitations: This methodology does not account for datasets with missing 
data neither does it attempt to validate data in any way.

Methodology: The procedure PROC SQL is used to process the SQL statements.
This procedure can not only give back the result of an SQL query, it can 
also create SAS tables & variables. We will select Date and High 
from btc_analytic file and then use proc print to print the values

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data.
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

proc univariate data=btc_analytic_file noprint;
 histogram High;
run;

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

footnote2 justify=left
"Lowest Bitcoin price was seen on Aug 25,2015 when the price touched $199.57"
;

footnote3 justify=left
"Lowest Bitcoin prices were seen between April and Auguest 2015 where the prices varied between $199 to $216"
;

footnote4 justify=left
"This was the time as Bitcoin just started picking up.However people were skeptical as seen from data and that justifies the price fluctation during the same period"
;

*
Note: This compares the column the column "Low" from btcusd16 to the same 
name columns from btcusd17 and btcusd18.

Limitations: This methodology does not account for datasets with missing 
data neither does it attempt to validate data in any way.

Methodology: The procedure PROC SQL is used to process the SQL statements.
This procedure can not only give back the result of an SQL query, it can 
also create SAS tables & variables. We will select Date and Low 
from btc_analytic file and then use proc print to print the values

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data.
;

proc sql;
    create table low_bottom5 as
        select
            Date
            ,Low format=dollar12.2
        from
            btc_analytic_file
        order by
            Low
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
        Low
    ;

run;
title;
footnote;

*******************************************************************************;
* Research Analysis;
*******************************************************************************;

title1 justify=left
'Question: What is the ROI on investing low and selling high?.'
;

title2 justify=left
'Rationale: This would provide help identify the ROI of investing in Bitcoin.'
;

footnote1 justify=left
"For the variable Buy_Lowest mean observed is 2387,std deviation is 3604, sum is 286735568 ,Minimum is 199.57 and maximum is 18974. This is been calculated using Simple Statistsics"
;

footnote2 justify=left
"For the variable Sell_Highest mean observed is 2587,std deviation is 3995, sum is 3107905499 ,Minimum is 223.83 and maximum is 20089. This is been calculated using Simple Statistsics"
;

footnote3 justify=left
"Using Pearson correlation coefficients, ROI for Sell_Highest equates to 0.74251 which is significant and this justifies that investing in Bitcoin could have yielded individual with highest return"
;

*
Note: This takes a diff between top 5 high and low prices.

Limitations: This methodology does not account for datasets with missing 
data neither does it attempt to validate data in any way.

Methodology: SAS provides the procedure PROC CORR to find the correlation 
coefficients between a pair of variables in a dataset.

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data.
;


* print Low and High Analysis;
proc corr data=btc_analytic_file ;
run;
title;
footnote;
