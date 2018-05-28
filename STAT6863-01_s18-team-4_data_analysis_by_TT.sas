
*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file generating "analytic file" dataset btc_analytic_file,
from which all data analyses below begin;
%include '.\STAT6863-01_s18-team-4_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Research Question 1: What is a rate of return (ROR) of Bitcoin BTC if one decided to invest one U.S. dollar in April 2015?'
;

title2 justify=left
'Rationale: This should help identify the gain or loss on an investment over a specified time period.'
;

footnote1 justify=left
"Based on our analysis and the output of the HIGH-MARKET CAP FROM 2015 TO 2018 table, we can see there is a huge difference in Bitcoin price which is about $19,865.17 USD between the MIN ($223.83 in Obs 9) and MAX ($20089.00 in Obs 986) of the High Variable."
;

footnote2 justify=left
"In other words, Bitcoin price has been increasing approximately 8,975% or the Rate-of-Return (ROR) on the investment over a specified time period is 8,975%. Assuming if one invested $1 on April 15, 2015 and decided to cash out on December 17, 2017, then he/she would have earned almost $8,975."
;

*
Note: This compares the column "High" from btcusd16 to the same
name column from btcusd17 and btcusd18.

Limitations: This methodology does not account for any datasets with missing 
data nor does it attempt to validate data in any way.
;

* summarize the data distribution;
proc univariate
    data=btc_analytic_file;
    var High;
    histogram High;
run;
quit;

* create analysis1 to analyze a rate or return for research question 1;
* use means procedure and create btc_analytic_file_temp table to calculate 
  descriptive statistics;
proc means
        min max mean std
        noprint 
        data=btc_analytic_file
    ;
    var
        High
        MarketCap
    ;
    output
        out=btc_analytic_file_temp(drop=_type_ _freq_
                                  rename=(_stat_ = STAT)
                                  )
    ;
run;

* remove ($) sign from N which is the sample size;
data analysis1;
    set btc_analytic_file_temp;
        array nValue[2] High MarketCap;      
        /* numerical variables */
        array cValue[2] $20.2;                      
        /* cValue[i] is formatted version of nValue[i] */
        label cValue1="High" cValue2="MarketCap";
    do i = 1 to dim(nValue);
        select (STAT);
            when ('N')    cValue[i] = put(nvalue[i], 8.0);
            otherwise     cValue[i] = vvalue(nvalue[i]);
        end;
    end;
run;

* print out analysis1 to address the research question;
title 'HIGH - MARKET CAP FROM APRIL, 2015 TO APRIL, 2018';
proc print
    data=analysis1
    noobs label
    style(header)={just=c};
    label MarketCap='Market Cap';
    var STAT
        cValue:
        /style(data)={just=r}
    ;
run;

* clear titles/footnotes;
title;
footnote;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1 justify=left
'Research Question 2: What are the top 10 highest prices and top 10 lowest prices during these years?'
;

title2 justify=left
'Rationale: This would provide more BTC behaviors, movements and how importance of High and Low price affect a rate of return.'

footnote1 justify=left
"From the analysis in research question 1, we see that if that investor put $1 in at the highest price and could earn $8,975. Feel luckly enough? But what if he/she followed the golden rule of buy low sell high and put $1 in at the lowest price of $199.57, instead of at the highest price of $223.83? The answer is he/she could earn $10,066 or gain 10,066%."
;

footnote2 justify=left
"As we can see, the rate of return of this scenario is even higher. The differece between these two scenarios is $1,091, with just one dollar investment. In other words, that crypto investor could earn $1,091 or 12.15% extra on top of their $8,975. Say that he put in $10, the number could be $10,091, so can we imagine what the return is if the intial invesment was $100 or $1,000?"
;

footnote3 justify=left
"This analysis addresses the importance of High and Low price that crypto enthusiasts and long-term speculators would consider and how that afftect the rate of return."
;

*
Note: This compares the column the column "High" and "Low" from btcusd16 to the 
same name columns from btcusd17 and btcusd18.

Limitations: This methodology does not account for any datasets with missing 
data nor does it attempt to validate data in any way.
;

* sort by descending High with 10 obs only;
proc sql outobs=10;
    create table high_top10 as
        select
             Date
            ,High format=dollar12.2
        from
            btc_analytic_file
        order by
            High descending
        ;
quit;

* output the first 10 rows from high_top10 to display the top 10 High's only;
title "Top 10 High's";
proc print
    data=high_top10
    noobs style(header)={just=c}
    ;
    id
        Date
    ;
    var
        High
    ;
run;

* sort by Low with 10 obs only;
proc sql outobs=10;
    create table low_bottom10 as
        select
             Date
            ,Low format=dollar12.2
        from
            btc_analytic_file
        order by
            Low
        ;
quit;

* output the first 10 rows from low_bottom10 to display the bottom 10 Low's only;
title "Bottom 10 Low's";
proc print
    data=low_bottom10
    noobs style(header)={just=c}
    ;
    id
        Date
    ;
    var
        Low
    ;
run;

* create analysis2 to analyze 'buy low, sell high' for research question 2;
proc sql;
    create table analysis2 as
        select
            Low AS Buy_Low
	     label "Buying at Low Price"
           ,High AS Sell_High
	     label "Selling at High Price" 
           ,High - Low AS Difference format=dollar12.2
	     label "Price Difference"
           ,High / Low AS RateOfReturn format=percent12.2
	     label "Rate of Return"
        from
            high_top10
           ,low_bottom10
        ;
quit;

* print out analysis2 to address 'buy low, sell high' for research question;
title "Buy Low Sell High Analysis";
proc print
    data=analysis2
    noobs style(header)={just=c}
    ;
run;

* clear titles/footnotes;
title;
footnote;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Research Question 3: Can we use Fibnonacci Retracement, which is created by taking two extreme points usually a major peak and trough on a financial chart and dividing the vertical distance by the key Fibonacci ratios of 38.2% (support level) and 61.8% (resistant level), to predict High prices?'
;

title2 justify=left
'Rationale: This would provide more true understanding of Bitcoin behaviors and movements to forecast or predict the BTC price for the year of 2018.'

footnote1 justify=left
"Based on the Pearson correlation coefficient output, we see both Resistant Level and Support Level have a positive linear relationship of 0.999 and both levels have the p-value of 0.0001."
;

footnote2 justify=left
"In this case, p-value is smaller than alpha of 0.05 or 5% so High shows significant correlation with Resistant Level and Support Level. For that reason, we can conclude that Resistant Level and Support Level can be used to predict Bitcoin High prices. The graph of Price Prediction based on Resistant and Support Level where Date_ID is from April 2018 illustrates how these variables are correlated"
;

footnote3 justify=left
"Based on the Parameter Estimates outputs, we're able to develop the linear regression line that has an equation of Y = a + bX, where X is the explanatory variable and Y is the dependent variable (High variable in this case). The slope of the line is b and a is the intercept. The High values can be interpreted as High = -21.57 + 1.0391 * (ResistantLevel) or High = -34.24 + 1.0641 * (SupportLevel)"
;

*
Note: This compares the column "High" from pred_highfromlow to 
the "ResistantLevel" and "SupportLevel" columns in the same table.

Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at a trend line and linear regression.
;

* create analysis3 that uses to predict BTC High from Low price for
  research question 3;
proc sql;
    create table analysis3 as
        select
            Date
           ,High
           ,Low
           ,High - Low AS HighvsLow format=dollar12.2
	     label "Difference between High and Low"
           ,(High - Low) * 0.618 + Low AS ResistantLevel format=dollar12.2
	     label "Price at Resistant Level"
           ,(High - Low) * 0.382 + Low AS SupportLevel format=dollar12.2
	     label "Price at Support Level"
        from
            btc_analytic_file
        order by
            Date descending
        ;
quit;

* use proc corr to compute coefficients;
proc corr
    data=analysis3;
    var High;
    with ResistantLevel;
    with SupportLevel;
run;

* use proc sgplot to display stat graphics;
proc sgplot data=analysis3;
    series x=Date y=High / legendlabel="High";
    series x=Date y=Low / legendlabel="Low";
    series x=Date y=ResistantLevel / legendlabel="Resistant Level";
    series x=Date y=SupportLevel / legendlabel="Support Level";
    yaxis label="BTC Movements";
    where Date > 20180400;
    title "Price Prediction based on Resistant and Support Level From April 2018";
run;

* RESISTANT LEVEL - develop a predicted regression model for High based on
  Resistant Levels;
* use proc reg to develop regression model (high = resistantlevel) that has an 
  equation of Y = a + bX, where Y is a dependent variable (High variable) and
  X is an indenpendent variable (ResistantLevel variable);
proc reg
    data=analysis3;
    /* noprint option can be used to suppress the output */
    model High = ResistantLevel;
    ods output ParameterEstimates=PE1;
run;

* set PE1 to display the intercept and slope in the graph;
data _null_;
    set PE1;
    if _n_ = 1 then call symput('Int', put(estimate, BEST6.));    
    else            call symput('Slope', put(estimate, BEST6.));  
run;

* display the slope and intercept of a regression line - resistant level;
proc sgplot
    data=analysis3 noautolegend;
    title "Regression Line with Slope and Intercept - Resistant Level";
    reg y=High x=ResistantLevel;
    inset "Intercept = &Int" "Slope = &Slope" /
        border title="Parameter Estimates" position=topleft;
run;                                                                                                                


* SUPPORT LEVEL -develop a predicted regression model for High based on
  Support Levels;
* use proc reg to develop regression model (high = supportlevel) that has an 
  equation of Y = a + bX, where Y is dependent variable (High Variable) and
  X is indenpendent variable (SuppportLevel Variable);
proc reg
    data=analysis3;
    /* noprint option can be used to suppress the output */
    model High = SupportLevel;
    ods output ParameterEstimates=PE2;
run;

* set PE2 to display the intercept and slope in the graph;
data _null_;
    set PE2;
    if _n_ = 1 then call symput('Int', put(estimate, BEST6.));    
    else            call symput('Slope', put(estimate, BEST6.));  
run;

* display the slope and intercept of a regression line - support level;
proc sgplot
    data=analysis3 noautolegend;
    title "Regression Line with Slope and Intercept - Support Level";
    reg y=High x=SupportLevel;
    inset "Intercept = &Int" "Slope = &Slope" /
        border title="Parameter Estimates" position=topleft;
run;

* clear titles/footnotes;
title;
footnote;
