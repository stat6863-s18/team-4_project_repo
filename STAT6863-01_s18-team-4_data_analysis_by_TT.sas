
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
Question: What is the distribution of Bitcoin BTC from April 2016 to present?

Rationale: This should help identify the specific distribution of BTC'

Note: This compares the column the column "Close" from btcusd16 to the same
name column from btcusd17 and btcusd18.

Limitations: This methodology does not account for any datasets with missing 
data nor does it attempt to validate data in any way.
;

/** distribution **/;
ods graphics on;
proc univariate
    data=btcusd161718_v2;
    var High;
    histogram High;
run;
quit;

proc means
        min max mean std
        noprint 
        data=btcusd161718_v2
    ;
    var
        High
        Close
        MarketCap
    ;
    output
        out=btcusd161718_v2_temp(drop=_type_ _freq_
                                rename=(_stat_ = STAT)
                                )
    ;
run;


/** remove $ sign from N which is the sample size **/;
data analysis;
    set btcusd161718_v2_temp;
        array nValue[3] High Close MarketCap;      /* numerical variables */
        array cValue[3] $16.;                      /* cValue[i] is formatted version of nValue[i] */
		label cValue1="High" cValue2="Close" cValue3="MarketCap";
 
do i = 1 to dim(nValue);
    select (STAT);
        when ('N')    cValue[i] = put(nvalue[i], 8.0);
        otherwise     cValue[i] = vvalue(nvalue[i]);
   end;
end;
run;


proc print
    data=analysis
    noobs label
    style(header)={just=c};
    label MarketCap='Market Cap';
    var STAT
        cValue:
        /style(data)={just=r}
	;
	title 'INSPECT HIGH-CLOSE-MARKET CAP FROM 2016 TO 2018';
run;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What are the top 10 highest prices and top 10 lowest prices during 
these years?

Rationale: This would provide more BTC behaviors, movements and have a better 
insights why there are such changes.

Note: This compares the column the column "High" and "Low" from btcusd16 to the 
same name columns from btcusd17 and btcusd18.

Limitations: This methodology does not account for any datasets with missing 
data nor does it attempt to validate data in any way.
;

proc sql;
    create table high_top10 as
        select
            Date
            ,High format=dollar12.2
        from
            btcusd161718_v2
        order by
            High descending
        ;
    create table high_top10_print as
        select
            *
        from
            high_top10(obs=10)
        ;
quit;


proc print
    data=high_top10_print
    noobs style(header)={just=c}
    ;
    id
        Date
    ;
    var
        High
    ;
    title "Top 10 High's"
    ;
run;



proc sql;
    create table high_bottom10 as
        select
            Date
            ,High format=dollar12.2
        from
            btcusd161718_v2
        order by
            High
        ;
    create table high_top10_print as
        select
            *
        from
            high_bottom10(obs=10)
        ;
quit;


proc print
    data=high_bottom10_print
    noobs style(header)={just=c}
    ;
    id
        Date
    ;
    var
        High
    ;
    title "Bottom 10 High's"
    ;
run;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What are major corrections in Bitcoin history?

Rationale: This would provide more true understanding of a few major corrections 
in the past and use those outputs to forecast or predict the BTC price for the 
year of 2018.

Note: This compares the column the column "Date_ID" and "Low" from btcusd16 to 
the same name columns from btcusd17 and btcusd18 to find a reverse movement 
which is usually negative, and any resistance and support levels.

Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at a trend line and linear regression.
;

/** Fibnonacci Retracement and golden ratio **/;
proc sql;
	create table pred_highfromlow as
		select
			Date
			,High
			,Low
			,HighvsLow
			,HighvsLow * 0.618 + Low as ResistantLevel format=dollar12.2
			,HighvsLow * 0.382 + Low as SupportLevel format=dollar12.2
		from
			btcusd161718_v2
		;
quit;

proc print 
    data=pred_highfromlow;
run;

ods graphics on;
proc gplot 
    data=pred_highfromlow;
    plot High;
run;
quit;


/** display the slope and intercept of a regression line **/;
ods graphics off;
proc reg 
    data=pred_highfromlow;
    model high = highvslow;
    ods output ParameterEstimates=PE;
run;

data _null_;
   set PE;
   if _n_ = 1 then call symput('Int', put(estimate, BEST6.));    
   else            call symput('Slope', put(estimate, BEST6.));  
run;

proc sgplot 
    data=pred_highfromlow noautolegend;
    title "Regression Line with Slope and Intercept";
    reg y=high x=highvslow;
    inset "Intercept = &Int" "Slope = &Slope" / 
         border title="Parameter Estimates" position=topleft;
run;

/** Based on the Analysis of Variance table output,
    we see R-Sqquare=0.7474 for example, it means that 74% of...
    will affect the other variable.
    Based on the Parameter Estimates table output
    we see the Intercept and HighvsLow, the value will be interpreted as
    High=1086.7 + 7.4933*(HighvsLow)
    P-value=0.0001 is less than 5% hence it is significant **/;

proc reg 
    data=pred_highfromlow;
    model High=HighvsLow;
    plot High*HighvsLow/pred;
run;
quit;

proc reg 
    data=pred_highfromlow;
    model High=HighvsLow;
    plot residual. * predicted.;
run;
quit;

