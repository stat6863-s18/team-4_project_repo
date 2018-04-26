*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset 1 Name] btcusd16

[Dataset Description] Historical data for Bitcoin BTC from April 7, 2015 to 
April 6, 2016

[Experimental Unit Description] Details of historical data for Bitcoin BTC from 
April 7, 2015 to April 6, 2016 such as open, close, high, low prices, plus some 
basic calculations to measure the differences and percentage changes in a day.

[Number of Observations] 367
                    
[Number of Features] 13

[Data Source] https://coinmarketcap.com/currencies/bitcoin/historical-data/
?start=20150407&end=20160406 was downloaded and edited to produce file btcusd16

[Data Dictionary] https://coinmarketcap.com/currencies/bitcoin/historical-data/

[Unique ID Schema] The column Date_ID is the primary, unique ID.
;
%let inputDataset1DSN = btcusd16;
%let inputDataset1URL =
https://github.com/stat6863/team-4_project_repo/blob/master/data/btcusd16.xlsx?raw=true
;
%let inputDataset1Type = XLSX;


*
[Dataset 2 Name] btcusd17

[Dataset Description] Historical data for Bitcoin BTC from April 7, 2016 to 
April 6, 2017

[Experimental Unit Description] Details of historical data for Bitcoin BTC from 
April 7, 2015 to April 6, 2016 such as open, close, high, low prices, plus some 
basic calculations to measure the differences and percentage changes in a day.

[Number of Observations] 367
                    
[Number of Features] 13

[Data Source] https://coinmarketcap.com/currencies/bitcoin/historical-data/
?start=20160407&end=20170406 was downloaded and edited to produce file btcusd17

[Data Dictionary] https://coinmarketcap.com/currencies/bitcoin/historical-data/

[Unique ID Schema] The column Date_ID is the primary, unique ID.
;
%let inputDataset2DSN = btcusd17;
%let inputDataset2URL =
https://github.com/stat6863/team-4_project_repo/blob/master/data/btcusd17.xlsx?raw=true
;
%let inputDataset2Type = XLSX;


*
[Dataset 3 Name] btcusd18

[Dataset Description] Historical data for Bitcoin BTC from April 7, 2017 to April 6, 2018

[Experimental Unit Description] Details of historical data for Bitcoin BTC from 
April 7, 2015 to April 6, 2016 such as open, close, high, low prices, plus some 
basic calculations to measure the differences and percentage changes in a day.

[Number of Observations] 367
                    
[Number of Features] 13

[Data Source] https://coinmarketcap.com/currencies/bitcoin/historical-data/
?start=20170407&end=20180406 was downloaded and edited to produce file btcusd18

[Data Dictionary] https://coinmarketcap.com/currencies/bitcoin/historical-data/

[Unique ID Schema] The column Date_ID is the primary, unique ID.
;
%let inputDataset3DSN = btcusd18;
%let inputDataset3URL =
https://github.com/stat6863/team-4_project_repo/blob/master/data/btcusd18.xlsx?raw=true
;
%let inputDataset3Type = XLSX;


* set global system options;
options fullstimer;


* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename 
                tempfile 
                "%sysfunc(getoption(work))/tempfile.xlsx"
            ;
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%macro loadDatasets;
    %do i = 1 %to 3;
        %loadDataIfNotAlreadyAvailable(
            &&inputDataset&i.DSN.,
            &&inputDataset&i.URL.,
            &&inputDataset&i.Type.
        )
    %end;
%mend;
%loadDatasets

* check btcusd16 for bad unique id values, where the columns Date_ID;
proc sql;
	/*check for duplicate unique id values; after executing this query, we
       see that btcusd16.xlsx has zero rows which are repeated,we will deal with missing unique id component
       in the next query */
	create table btcusd16_dups as
        select
             Date_ID
            ,count(*) as row_count_for_unique_id_value
        from
            btcusd16_raw
        group by
             Date_ID
        having
            row_count_for_unique_id_value > 1
    ;


	/* remove rows with missing unique id components, or with unique ids that
       does not have corresponding values; after executing this query, the new
       dataset final_btcusd16 will have no duplicate/repeated unique id values,
       and all unique id values will correspond to our experimenal units of
       interest, which are the Dates;*/
     create table btcusd16 as
        select
            *
        from
            btcusd16_raw
        where
            /* remove rows with missing unique id value components */
            not(missing(Date_ID))
	order by
	    Date_ID
    ;
quit;

* check btcusd17 for bad unique id values, where the columns Date_ID;
proc sql;
	/*check for duplicate unique id values; after executing this query, we
       see that btcusd17.xlsx has zero rows which are repeated,we will deal with missing unique id component
       in the next query */
	create table btcusd17_dups as
        select
             Date_ID
            ,count(*) as row_count_for_unique_id_value
        from
            btcusd17_raw
        group by
             Date_ID
        having
            row_count_for_unique_id_value > 1
    ;


	/* remove rows with missing unique id components, or with unique ids that
       does not have corresponding values; after executing this query, the new
       dataset final_btcusd17 will have no duplicate/repeated unique id values,
       and all unique id values will correspond to our experimenal units of
       interest, which are the Dates;*/
     create table btcusd17 as
        select
            *
        from
            btcusd17_raw
        where
            /* remove rows with missing unique id value components */
            not(missing(Date_ID))
	order by
	    Date_ID
    ;
quit;

* check btcusd16 for bad unique id values, where the columns Date_ID;
proc sql;
	/*check for duplicate unique id values; after executing this query, we
       see that btcusd18.xlsx has zero rows which are repeated,we will deal with missing unique id component
       in the next query */
	create table btcusd18_dups as
        select
             Date_ID
            ,count(*) as row_count_for_unique_id_value
        from
            btcusd18_raw
        group by
             Date_ID
        having
            row_count_for_unique_id_value > 1
    ;


	/* remove rows with missing unique id components, or with unique ids that
       does not have corresponding values; after executing this query, the new
       dataset final_btcusd18 will have no duplicate/repeated unique id values,
       and all unique id values will correspond to our experimenal units of
       interest, which are the Dates;*/
     create table btcusd18 as
        select
            *
        from
            btcusd18_raw
        where
            /* remove rows with missing unique id value components */
            not(missing(Date_ID))
	order by
	    Date_ID
    ;
quit;

* inspect columns of interest in cleaned versions of datasets;

title "open in btcusd16";
proc sql;
    select
         min(Open) as min
        ,max(Open) as max
        ,mean(Open) as mean
        ,median(Open) as median
        ,nmiss(Open) as missing
    from
        btcusd16
    ;
quit;
title;

title "High in btcusd16";
proc sql;
    select
         min(High) as min
        ,max(High) as max
        ,mean(High) as mean
        ,median(High) as median
        ,nmiss(High) as missing
    from
        btcusd16
    ;
quit;
title;

title "Low in btcusd16";
proc sql;
    select
         min(Low) as min
        ,max(Low) as max
        ,mean(Low) as mean
        ,median(Low) as median
        ,nmiss(Low) as missing
    from
        btcusd16
    ;
quit;
title;

title "close in btcusd16";
proc sql;
    select
         min(Close) as min
        ,max(Close) as max
        ,mean(Close) as mean
        ,median(Close) as median
        ,nmiss(Close) as missing
    from
        btcusd16
    ;
quit;
title;

title "volume in btcusd16";
proc sql;
    select
         min(Volume) as min
        ,max(Volume) as max
        ,mean(Volume) as mean
        ,median(Volume) as median
        ,nmiss(Volume) as missing
    from
        btcusd16
    ;
quit;
title;


title "open in btcusd17";
proc sql;
    select
         min(Open) as min
        ,max(Open) as max
        ,mean(Open) as mean
        ,median(Open) as median
        ,nmiss(Open) as missing
    from
        btcusd17
    ;
quit;
title;

title "High in btcusd17";
proc sql;
    select
         min(High) as min
        ,max(High) as max
        ,mean(High) as mean
        ,median(High) as median
        ,nmiss(High) as missing
    from
        btcusd17
    ;
quit;
title;

title "Low in btcusd17";
proc sql;
    select
         min(Low) as min
        ,max(Low) as max
        ,mean(Low) as mean
        ,median(Low) as median
        ,nmiss(Low) as missing
    from
        btcusd17
    ;
quit;
title;

title "Close in btcusd17";
proc sql;
    select
         min(Close) as min
        ,max(Close) as max
        ,mean(Close) as mean
        ,median(Close) as median
        ,nmiss(Close) as missing
    from
        btcusd17
    ;
quit;
title;

title "Volume in btcusd17";
proc sql;
    select
         min(Volume) as min
        ,max(Volume) as max
        ,mean(Volume) as mean
        ,median(Volume) as median
        ,nmiss(Volume) as missing
    from
        btcusd17
    ;
quit;
title;

title "open in btcusd18";
proc sql;
    select
         min(Open) as min
        ,max(Open) as max
        ,mean(Open) as mean
        ,median(Open) as median
        ,nmiss(Open) as missing
    from
        btcusd18
    ;
quit;
title;

title "High in btcusd18";
proc sql;
    select
         min(High) as min
        ,max(High) as max
        ,mean(High) as mean
        ,median(High) as median
        ,nmiss(High) as missing
    from
        btcusd18
    ;
quit;
title;

title "Low in btcusd18";
proc sql;
    select
         min(Low) as min
        ,max(Low) as max
        ,mean(Low) as mean
        ,median(Low) as median
        ,nmiss(Low) as missing
    from
        btcusd18
    ;
quit;
title;

title "Close in btcusd18";
proc sql;
    select
         min(Close) as min
        ,max(Close) as max
        ,mean(Close) as mean
        ,median(Close) as median
        ,nmiss(Close) as missing
    from
        btcusd18
    ;
quit;
title;

title "Volume in btcusd18";
proc sql;
    select
         min(Volume) as min
        ,max(Volume) as max
        ,mean(Volume) as mean
        ,median(Volume) as median
        ,nmiss(Volume) as missing
    from
        btcusd18
    ;
quit;
title;


* combine btcusd16, btcusd17 and btcusd18 horizontally using a data-step 
match-merge;
* note: After running the data step and proc sort step below several times
  and averaging the fullstimer output in the system log, they tend to take
  about 0.04 seconds of combined real time to execute and a maximum of
  about 1.8 MB of memory (1100 KB for the data step vs. 1800 KB for the
  proc sort step) on the computer they were tested on;
data btcusd161718_v1;
    retain
        Date_ID
        Open
        High
        Low
        Close
        Volume
        MarketCap
    ;
    keep
        Date_ID
        Open
        High
        Low
        Close
        Volume
        MarketCap
    ;
    merge
        btcusd16
        btcusd17
        btcusd18
    ;
    by Date_ID
    ;
run;
proc sort data=btcusd161718_v1;
    by Date_ID;
run;


* combine btcusd16, btcusd17 and btcusd18 horizontally using proc sql;
* note: After running the proc sql step below several times and averaging
  the fullstimer output in the system log, they tend to take about 0.04
  seconds of real time to execute and about 9 MB of memory on the computer
  they were tested on. Consequently, the proc sql step appears to take roughly
  the same amount of time to execute as the combined data step and proc sort
  steps above, but to use roughly five times as much memory;
* note to learners: Based upon these results, the proc sql step is preferable
  if memory performance is not critical. This is because less code is required,
  so it is faster to write and verify correct output has been obtained;
proc sql;
    create table btcusd161718_v2 as
        select
             coalesce(A.Date_ID,B.Date_ID,C.Date_ID) as Date_ID
            ,coalesce(A.Open,B.Open,C.Open) as Open
            ,coalesce(A.High,B.High,C.High) as High
            ,coalesce(A.Low,B.Low,C.Low) as Low
            ,coalesce(A.Close,B.Close,C.Close) as Close
            ,coalesce(A.Volume,B.Volume,C.Volume) as Volumn
            ,coalesce(A.MarketCap,B.MarketCap,C.MarketCap) as MarketCap
        from
            btcusd16 as A
            full join
            btcusd17 as B
            on A.Date_ID=B.Date_ID
            full join
            btcusd18 as C
            on B.Date_ID=C.Date_ID
        order by
            Date_ID
    ;
quit;


* verify that btcusd161718_v1 and btcusd161718_v2 are identical;
proc compare
        base=btcusd161718_v1
        compare=btcusd161718_v2
        novalues
    ;
run;


