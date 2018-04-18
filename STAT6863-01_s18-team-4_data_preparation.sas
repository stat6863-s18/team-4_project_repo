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
https://github.com/stat6863/team-4_project_repo/blob/master/data/btcusd16.xlsx?raw=true;
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
    %do i = 1 %to 4;
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
            btcusd16
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
     create table btcusd16_F as
        select
            *
        from
            btcusd16
        where
            /* remove rows with missing unique id value components */
            not(missing(Date_ID))
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
            btcusd17
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
     create table btcusd17_F as
        select
            *
        from
            btcusd17
        where
            /* remove rows with missing unique id value components */
            not(missing(Date_ID))
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
            btcusd18
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
     create table btcusd18_F as
        select
            *
        from
            btcusd18
        where
            /* remove rows with missing unique id value components */
            not(missing(Date_ID))
    ;
quit;

* inspect columns of interest in cleaned versions of datasets;

title "open in btcusd16_F ";
proc sql;
    select
         min(Open) as min
        ,max(Open) as max
        ,mean(Open) as max
        ,median(Open) as max
        ,nmiss(Open) as missing
    from
        btcusd16_F
    ;
quit;
title;

title "High in btcusd16_F ";
proc sql;
    select
         min(High) as min
        ,max(High) as max
        ,mean(High) as max
        ,median(High) as max
        ,nmiss(High) as missing
    from
        btcusd16_F
    ;
quit;
title;

title "High in btcusd16_F ";
proc sql;
    select
         min(Low) as min
        ,max(Low) as max
        ,mean(Low) as max
        ,median(Low) as max
        ,nmiss(Low) as missing
    from
        btcusd16_F
    ;
quit;
title;

title "High in btcusd16_F ";
proc sql;
    select
         min(Close) as min
        ,max(Close) as max
        ,mean(Close) as max
        ,median(Close) as max
        ,nmiss(Close) as missing
    from
        btcusd16_F
    ;
quit;
title;

title "High in btcusd16_F ";
proc sql;
    select
         min(Volume) as min
        ,max(Volume) as max
        ,mean(Volume) as max
        ,median(Volume) as max
        ,nmiss(Volume) as missing
    from
        btcusd16_F
    ;
quit;
title;


title "open in btcusd17_F ";
proc sql;
    select
         min(Open) as min
        ,max(Open) as max
        ,mean(Open) as max
        ,median(Open) as max
        ,nmiss(Open) as missing
    from
        btcusd17_F
    ;
quit;
title;

title "High in btcusd17_F ";
proc sql;
    select
         min(High) as min
        ,max(High) as max
        ,mean(High) as max
        ,median(High) as max
        ,nmiss(High) as missing
    from
        btcusd17_F
    ;
quit;
title;

title "High in btcusd17_F ";
proc sql;
    select
         min(Low) as min
        ,max(Low) as max
        ,mean(Low) as max
        ,median(Low) as max
        ,nmiss(Low) as missing
    from
        btcusd17_F
    ;
quit;
title;

title "High in btcusd17_F ";
proc sql;
    select
         min(Close) as min
        ,max(Close) as max
        ,mean(Close) as max
        ,median(Close) as max
        ,nmiss(Close) as missing
    from
        btcusd17_F
    ;
quit;
title;

title "High in btcusd17_F ";
proc sql;
    select
         min(Volume) as min
        ,max(Volume) as max
        ,mean(Volume) as max
        ,median(Volume) as max
        ,nmiss(Volume) as missing
    from
        btcusd17_F
    ;
quit;
title;

title "open in btcusd18_F ";
proc sql;
    select
         min(Open) as min
        ,max(Open) as max
        ,mean(Open) as max
        ,median(Open) as max
        ,nmiss(Open) as missing
    from
        btcusd18_F
    ;
quit;
title;

title "High in btcusd18_F ";
proc sql;
    select
         min(High) as min
        ,max(High) as max
        ,mean(High) as max
        ,median(High) as max
        ,nmiss(High) as missing
    from
        btcusd18_F
    ;
quit;
title;

title "High in btcusd18_F ";
proc sql;
    select
         min(Low) as min
        ,max(Low) as max
        ,mean(Low) as max
        ,median(Low) as max
        ,nmiss(Low) as missing
    from
        btcusd18_F
    ;
quit;
title;

title "High in btcusd18_F ";
proc sql;
    select
         min(Close) as min
        ,max(Close) as max
        ,mean(Close) as max
        ,median(Close) as max
        ,nmiss(Close) as missing
    from
        btcusd18_F
    ;
quit;
title;

title "High in btcusd18_F ";
proc sql;
    select
         min(Volume) as min
        ,max(Volume) as max
        ,mean(Volume) as max
        ,median(Volume) as max
        ,nmiss(Volume) as missing
    from
        btcusd18_F
    ;
quit;
title;

