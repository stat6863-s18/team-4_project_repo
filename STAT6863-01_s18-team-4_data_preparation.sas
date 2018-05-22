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
%let inputDataset1DSN = btcusd16_raw;
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
%let inputDataset2DSN = btcusd17_raw;
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
%let inputDataset3DSN = btcusd18_raw;
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


* check btcusd16_raw for bad unique id values;
proc sql;
    /* check for duplicate unique id values; after executing this query, we
       see that btcusd16_raw_dups only has zero duplicated row */
    create table btcusd16_raw_dups as
        select
             Date_ID
            ,Open
            ,High
	    ,Low
	    ,Close
	    ,Volume
	    ,MarketCap
            ,count(*) as row_count_for_unique_id_value
        from
            btcusd16_raw
        group by
             Date_ID
        having
            row_count_for_unique_id_value > 1
    ;
    /* remove rows with missing unique id components, or with unique ids that
       do not correspond; after executing this query, the new
       dataset btcusd16 will have no duplicate/repeated unique id values */
    create table btcusd16 as
        select
            *
        from
            btcusd16_raw
        where
            /* remove rows with missing unique id value components */
            not(missing(Date_ID))
            and
            not(missing(MarketCap))
	order by 
	    Date_ID
    ;
quit;

* check btcusd17_raw for bad unique id values;
proc sql;
    /* check for duplicate unique id values; after executing this query, we
       see that btcusd17_raw_dups only has zero duplicated row */
    create table btcusd17_raw_dups as
        select
             Date_ID
            ,Open
            ,High
	    ,Low
	    ,Close
	    ,Volume
	    ,MarketCap
            ,count(*) as row_count_for_unique_id_value
        from
            btcusd17_raw
        group by
             Date_ID
        having
            row_count_for_unique_id_value > 1
    ;
    /* remove rows with missing unique id components, or with unique ids that
       do not correspond; after executing this query, the new
       dataset btcusd17 will have no duplicate/repeated unique id values */
    create table btcusd17 as
        select
            *
        from
            btcusd17_raw
        where
            /* remove rows with missing unique id value components */
            not(missing(Date_ID))
            and
            not(missing(MarketCap))
	order by 
	    Date_ID
    ;
quit;

* check btcusd18_raw for bad unique id values;
proc sql;
    /* check for duplicate unique id values; after executing this query, we
       see that btcusd18_raw_dups only has zero duplicated row */
    create table btcusd18_raw_dups as
        select
             Date_ID
            ,Open
            ,High
	    ,Low
	    ,Close
	    ,Volume
	    ,MarketCap
            ,count(*) as row_count_for_unique_id_value
        from
            btcusd18_raw
        group by
             Date_ID
        having
            row_count_for_unique_id_value > 1
    ;
    /* remove rows with missing unique id components, or with unique ids that
       do not correspond; after executing this query, the new
       dataset btcusd18 will have no duplicate/repeated unique id values */
    create table btcusd18 as
        select
            *
        from
            btcusd18_raw
        where
            /* remove rows with missing unique id value components */
            not(missing(Date_ID))
            and
            not(missing(MarketCap))
	order by 
	    Date_ID
    ;
quit;

* inspect columns of interest in cleaned versions of datasets;
    /*
	    title "Inspect Market Cap in btcusd16";
	    proc sql;
		select
		    min(put(marketcap,dollar16.)) as min
		   ,max(put(marketcap,dollar16.)) as max
		   ,mean(marketcap) as mean
		   ,median(marketcap) as median
		   ,nmiss(put(marketcap,dollar16.)) as missing
		from
		    btcusd16
		;
	quit;
	title;

	title "Inspect Market Cap in btcusd17";
	proc sql;
	    select
		 min(put(marketcap,dollar16.)) as min
		,max(put(marketcap,dollar16.)) as max
		,mean(marketcap) as mean
		,median(marketcap) as median
		,nmiss(put(marketcap,dollar16.)) as missing
	    from
		btcusd17
	    ;
	quit;
	title;

	title "Inspect Market Cap in btcusd18";
	proc sql;
	    select
		 min(put(marketcap,dollar16.)) as min
		,max(put(marketcap,dollar16.)) as max
		,mean(marketcap) as mean
		,median(marketcap) as median
		,nmiss(put(marketcap,dollar16.)) as missing
	    from
		btcusd18
	    ;
	quit;
	title;
*/

/*

	* combine btcusd16, btcusd17 and btcusd18 horizontally using a data-step 
	  match-merge;
	* note: After running the data step and proc sort step below several times
	  and averaging the fullstimer output in the system log, it takes about
	  0.02 seconds of combined real time to execute the codes and a maximum of
	  about 1.1 MB of memory (1168 KB for the data step vs. 269 KB for the
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

	proc sort 
	    data=btcusd161718_v1;
	    by Date_ID;
	run;


	* combine btcusd16, btcusd17 and btcusd18 horizontally using proc sql;
	* note: After running the proc sql step below several times and averaging
	  the fullstimer output in the system log, it takes about 0.04 seconds
	  of combined real time to execute the codes and a maximum of about 
	  9 MB of memory on the computer they were tested on. It turns out that 
	  the proc sql step appears to take roughly the same amount of time 
	  to execute as the combined data step and proc sort steps above, but to 
	  use roughly five times as much memory;
	* note: Based upon these results, the proc sql step is preferable
	  if memory performance isn't critical. This is because less code is 
	  required, so it's faster to write and verify correct output has been 
	  obtained;

	proc sql;
	    create table btcusd161718_v2 as
		select
		     coalesce(A.Date_ID,B.Date_ID,C.Date_ID) as Date
		    ,coalesce(A.Open,B.Open,C.Open) as Open format=dollar12.
		    ,coalesce(A.High,B.High,C.High) as High format=dollar12.
		    ,coalesce(A.Low,B.Low,C.Low) as Low format=dollar12.
		    ,coalesce(A.Close,B.Close,C.Close) as Close format=dollar12.
		    ,coalesce(A.Volume,B.Volume,C.Volume) as Volumn
		    ,coalesce(A.MarketCap,B.MarketCap,C.MarketCap) as MarketCap format=dollar16.
		from
		    btcusd16 as A
		    full join
		    btcusd17 as B
		    on A.Date_ID=B.Date_ID
		    full join
		    btcusd18 as C
		    on B.Date_ID=C.Date_ID
		order by
		    Date
	    ;
	quit;


	* verify that btcusd161718_v1 and btcusd161718_v2 are identical;
	proc compare
		base=btcusd161718_v1
		compare=btcusd161718_v2
		novalues
	    ;
	run;


	* combine btcusd16, btcusd17 and btcusd18 vertically using a data-step interweave,
	  combining composite key values into a single primary key value;
	* note: After running the data step and proc sort step below several times
	  and averaging the fullstimer output in the system log, they tend to take
	  about 0.05 seconds of combined "real time" to execute and a maximum of
	  about 1 MB of memory (1223 KB for the data step vs. 800 KB for the
	  proc sort step) on the computer they were tested on;
	data btcusd16_17_18_v1;
	    retain
		data_source
		Date_ID
		Open
		High
		Low
		Close
		Volume
		MarketCap
	    ;
	    keep
		data_source
		Date_ID
		Open
		High
		Low
		Close
		Volume
		MarketCap	   
	    ;
	    set
		btcusd16(in=ay2016_data_row)
		btcusd17(in=ay2017_data_row)
		btcusd18(in=ay2018_data_row)
	    ;
	    if
		ay2016_data_row=1
	    then
		do;
		    data_source="2016";
		end;
	    if  
		ay2017_data_row=1
	    then
		do;
		    data_source="2017";
		end;
	    if 
		   ay2018_data_row=1
	    then
		   do;
		      data_source="2018";
		   end;
	run;
	proc sort data=btcusd16_17_18_v1;
	    by Date_ID;
	run;


	* combine btcusd16, btcusd17 and btcusd18 vertically using proc sql;
	* note: After running the proc sql step below several times and averaging
	  the fullstimer output in the system log, they tend to take about 0.09
	  seconds of "real time" to execute and about 5 MB of memory on the computer
	  they were tested on. Consequently, the proc sql step appears to take roughly
	  half as much time to execute as the combined data step and proc sort steps
	  above, but to use slightly more memory;
	* note to learners: Based upon these results, the proc sql step is preferable
	  if memory performance isn't critical. This is because less code is required,
	  so it's faster to write and verify correct output has been obtained. In
	  addition, because proc sql doesn't create a PDV with the length of each
	  column determined by the column's first appearance, less care is needed for
	  issues like columns lengths being different in the input datasets;
	proc sql;
	    create table btcusd16_17_18_v2 as
		(
		    select
			 "2016"
			  AS
			  data_source
			 ,Date_ID
			 ,Open
			 ,High
			 ,Low
			 ,Close
			 ,Volume
			 ,MarketCap
		    from
			btcusd16
		)
		outer union corr
		(
		    select
			 "2017"
			  AS
			  data_source
			 ,Date_ID
			 ,Open
			 ,High
			 ,Low
			 ,Close
			 ,Volume
			 ,MarketCap
		    from
			btcusd17
		)
		   outer union corr
		(
		    select
			 "2018"
			  AS
			  data_source
			 ,Date_ID
			 ,Open
			 ,High
			 ,Low
			 ,Close
			 ,Volume
			 ,MarketCap
		    from
			btcusd18
		)
		order by
		     Date_ID
	    ;
	quit;


	* verify that btcusd16_17_18_v1 and btcusd16_17_18_v2 are
	  identical;
	proc compare
		base=btcusd16_17_18_v1
		compare=btcusd16_17_18_v2
		novalues
	    ;
	run;

*/

* build analytic dataset from raw datasets imported above, including only the
  columns and minimal data-cleaning/transformation needed to address each
  research questions/objectives in data-analysis files;
proc sql;
    create table btc_analytic_file_raw as
        select
             coalesce(A.Date_ID,B.Date_ID,C.Date_ID)
 	      AS Date 
            ,coalesce(A.Open,B.Open,C.Open)
             AS Open format=dollar12.2
            ,coalesce(A.High,B.High,C.High)
             AS High format=dollar12.2
            ,coalesce(A.Low,B.Low,C.Low)
             AS Low format=dollar12.2
            ,coalesce(A.Close,B.Close,C.Close)
             AS Close format=dollar12.2
            ,coalesce(A.Volume,B.Volume,C.Volume)
             AS Volumn
            ,coalesce(A.MarketCap,B.MarketCap,C.MarketCap)
             AS MarketCap format=dollar16.2
        from
            btcusd16 as A
            full join
            btcusd17 as B
            on A.Date_ID=B.Date_ID
            full join
            btcusd18 as C
            on B.Date_ID=C.Date_ID
        order by
            Date
    ;
quit;

* check btc_analytic_file_raw for rows whose unique id values are repeated,
  missing where the column Date_ID is intended to be a primary key;
* after executing this data step, we see that the full joins used above
  introduced duplicates in btc_analytic_file_raw, which need to be mitigated
  before proceeding;
* notes:
    (1) even though the data-integrity check and mitigation steps below could
        be performed with SQL queries, as was used earlier in this file, it's
        often faster and less code to use data steps and proc sort steps to
        check for and remove duplicates. In particular, by-group processing
        is much more convenient when checking for duplicates than the SQL row
        aggregation and in-line view tricks used above. In practice, though,
        you should use whatever methodology you're most comfortable with
    (2) when determining what type of join to use to combine tables, it's
        common to designate one of the table as the "master" table, and to use
        left (outer) joins to add columns from the other "auxiliary" tables
    (3) however, if this isn't the case, an inner joins typically makes sense
        whenever we're only interested in rows whose unique id values match up
        in the tables to be joined
    (4) similarly, full (outer) joins tend to make sense whenever we want all
        possible combinations of all rows with respect to unique id values to
        be included in the output dataset, such as in this example, where not
        every dataset will necessarily have every possible of Date_ID in it
    (5) unfortunately, though, full joins of more than two tables can also
        introduce duplicates with respect to unique id values, even if unique
        id values are not duplicated in the original input datasets 
*/
;
data btc_analytic_file_raw_bad_ids;
    set btc_analytic_file_raw;
    by Date;
    if
        first.Date*last.Date = 0
        or
        missing(Date)
    then
        do;
            output;
        end;
run;

* remove duplicates from btc_analytic_file_raw with respect to Date_ID;
* after inspecting the rows in btc_analytic_file_raw_bad_ids, we see that
  either of the rows in duplicate-row pairs can be removed without losing
  values for analysis, so we use proc sort to indiscriminately remove
  duplicates, after which column Date_ID is guaranteed to form a primary key;
proc sort
        nodupkey
        data=btc_analytic_file_raw
        out=btc_analytic_file
    ;
    by
        Date
    ;
run;
