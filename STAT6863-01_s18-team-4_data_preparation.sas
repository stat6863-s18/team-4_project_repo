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
https://github.com/stat6863/team-4_project_repo/blob/master/data/btcusd17.xlsx?raw=true;
%let inputDataset2Type = XLSX;


*
[Dataset 3 Name] btcusd18

[Dataset Description] Historical data for Bitcoin BTC from April 7, 2017 to 
April 6, 2018

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
https://github.com/stat6863/team-4_project_repo/blob/master/data/btcusd18.xlsx?raw=true;
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

