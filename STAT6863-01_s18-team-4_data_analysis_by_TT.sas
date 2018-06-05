
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
"Based on the output, we can see the minimum price is $223.83 (in Obs=9) and the maximum price is $20089.00 (in Obs=986) of the High Variable. The difference between these 2 values is $19.865.17 from April 2015 to December 2017 which pretty tell there is a huge increase in Bitcoin in 2.5 years."
;

footnote2 justify=left
"To have a better understanding of this, we're going to compute a rate of return by using a formula of ROR = ((current value - original value) / original value) * 100%"
;
footnote3 justify=left
"As we can see, it turns out that the Bitcoin price has been tremendously increased at very high levels and the Rate-of-Return (ROR) on the investment over a specified time period from 04/15/2015 until 12/17/2017 is 8,875.12%."
;

footnote4 justify=left
"Assuming if one invested $1 on April 15, 2015 and decided to cash out on December 17, 2017, then he or she would have earned almost $88.75 for each dollar invested."
;

*
Note: This compares the column "High" and "Low" from btcusd16 to the same
name column from btcusd17 and btcusd18.

Limitations: This methodology does not account for any datasets with missing 
data nor does it attempt to validate data in any way. We investigate and
analyze BTC values from April 7, 2015 to April 6, 2018 only.

Methodology: use proc report to output the minimum, median, and maximum of the 
sorted table, and compute a price difference between the min and max value, 
as well as a rate or return.

Follow-up Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data...
;

* use proc report to output the minimum, median, and maximum of the sorted
  table, and compute a price difference between the min and max value, as 
  well as a rate or return ROR = (current value - original value) / original
  value);
proc report data=btc_analytic_file out=analytic_file;
    columns
        High = High_Min
        High = High_Median
        High = High_Max
        Diff
        ROR
    ;  
    define High_Min / min "Minimum Price";
    define High_Median / mean "Median Price";
    define High_Max / max "Maximum Price";

    /* define and compute a price difference between max and min value */ 
    define Diff / display format=dollar12.2;
    define Diff / computed "Min-Max Difference";
    compute Diff;
        Diff = High_Max - High_Min;
    endcomp;
   
    /* define and compute a rate of return */ 
    define ROR / display format=percent10.2;
    define ROR / computed "Rate of Return";
    compute ROR;
        ROR = ((High_Max - High_Min)/High_Min);
    endcomp;
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
;

*
Note: This compares the column the column "High" and "Low" from btcusd16 to the 
same name columns from btcusd17 and btcusd18.

Limitations: This methodology does not account for any datasets with missing 
data nor does it attempt to validate data in any way.

Methodology: 
(1) use proc sql to create 2 temporary sorted tables: 'high_top10' is ordered
by High descending, and 'low_bottom10' is order by Low ascending. Both sorted
tables are limited by 10 oberservations.

(2) use proc sql to combine 2 sorted tables above as an 'analytic_file2' and
then analyze benefits of 'buy low, sell high'.

(3) use proc print to display the first twenty rows of the 'analytic_file2'
dataset. This dataset has 100 rows in total. 

Follow-up Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data...
;

* (1a) use proc sql to create a sorted tables 'high_top10' order by High
  descending, output with 10 obs only;

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

proc print
    data=high_top10
    style(header)={just=c}
    ;
run;


* (1b) use proc sql to create a sorted tables 'low_bottom10' order by Low
  ascending, output with 10 obs only;

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

proc print
    data=low_bottom10
    style(header)={just=c}
    ;
run;



* (2) use proc sql to combine 2 sorted tables above,
  create a sorted table 'analytic_file2' to analyze 'buy low, sell high';

proc sql;
    create table analytic_file2 as
        select
            Low AS Buy_Low
            label "Buying at Low Price"
           ,High AS Sell_High
            label "Selling at High Price" 
           ,High - Low AS Difference format=dollar12.2
            label "Price Difference"
           ,(High - Low)/Low AS RateOfReturn format=percent12.2
            label "Rate of Return"
        from
            high_top10
           ,low_bottom10
        ;
quit;



* (3) use proc print to display the first twenty rows of the 'analytic_file2'
dataset to answer research question. This dataset originally has 100 rows;

footnote1 justify=left
"From the analysis in research question 1, we know that if that investor put $1 in at the highest price and he could earn $88.75"
;

footnote2 justify=left
"Feel lucky enough? But what if he or she applied the golden rule of 'buy low sell high' and put $1 in at the lowest price of $199.57 in an exchange of 1 Bitcoin (obs=1), instead of at the high price? The answer is the rate of return that he or she could gain would be 9,966.14%."
;

footnote3 justify=left
"What that means is if he put $1 in at the position of 'buy-low' where obs=1, he could gain $10.91 more, on top of $88.75. But if he put $1 in at obs=2, this time he would earn a bit less since the rate of return was 9,446.19%. The difference between obs=1 and 2 is ~520%. The higher price he bought, the less he could earn." 
;

footnote4 justify=left
"This was one dollar investment. Say that he put in $10, the return would be $100.91, so can we imagine what the return is if the intial invesment was $100 or $1,000?"
;

footnote5 justify=left
"This analysis addresses the importance of High and Low price that crypto enthusiasts and long-term speculators would consider and how that afftect the rate of return."
;

proc print
    data=analytic_file2(obs=20)
    style(header)={just=c}
    ;
run;

* clear titles/footnotes;
title;
footnote;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Research Question 3: From the analysis above, it is very important to determine and predict the low price position to buy-in as lowest as possible.
Can we use Fibnonacci Retracement ratios of 38.2% (support level) and 61.8% (resistant level) to predict Bitcoin Low prices?'
;

title2 justify=left
'Rationale: This would provide more true understanding of Bitcoin behaviors and movements to forecast or predict the BTC price in the future.'
;

*
Note: This compares the column "Low" from btc_analytic_file to 
the "ResistantLevel" and "SupportLevel" columns in the same table.

Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on Fibonacci Retracement ratios of
38.2% and 61.8%. Fibonacci retracement is a method of technical analysis for 
determining support and resistance levels. These ratios often used by stock 
analysts approximates to the "golden ratio". 

Methodology: 
(1) use proc sql to create a sorted table 'analytic_file3' and then compute
support levels and resistant levels based on Fibonacci Retracement ratios.

(2) use proc corr to compute coefficients and perform a correlation analysis,
then use proc sgplot to display stats graphics.

(3) use proc reg to develop and formulate a linear regression model for 
predicted prices based on resistant levels. Using a regression equation of 
Y = a + bX, where Y is a dependent variable (Low variable) and X is an
indenpendent variable (ResistantLevel variable). Then use proc sgplot to
display the slope and intercept of the predicted line.

(4) use proc reg to develop and formulate a linear regression model for 
predicted prices based on support levels. Using a regression equation of 
Y = a + bX, where Y is a dependent variable (Low variable) and X is an
indenpendent variable (SupportLevel variable). Then use proc sgplot to
display the slope and intercept of the predicted line.

(5) use proc report to display a test.

Follow-up Steps: A possible follow-up to this approach is to monitor real-time
Bitcoin price in a few days and use other formal inferential techniques,
possibly use proc timeseries or a sine function y=sinx (a sine wave that 
oscillates, moves up, down or side-to-side periodically) to determine and 
formulate a new formula.
;


* (1) use proc sql to create a sorted table 'analytic_file3' and compute
  support levels and resistant levels based on Fibonacci Retracement ratios;

proc sql;
    create table analytic_file3 as
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



* (2a) use proc corr to compute coefficients;

footnote1 justify=left
"Based on the Pearson correlation coefficient output, we see both Resistant Level and Support Level have a positive linear relationship of 0.999 and both levels have the p-value of 0.001"
;

footnote2 justify=left
"In this case, p-value is smaller than alpha of 0.05 or 5% so Low shows significant correlation with Resistant Level and Support Level. For that reason, we can conclude that Resistant Level and Support Level can be used to predict Bitcoin prices."
;

proc corr 
    data=analytic_file3 nosimple;
    var Low;
    with ResistantLevel;
    with SupportLevel;
run;
footnote;



* (2b) use proc sgplot to display stats graphics;

footnote justify=left
"The graph of Price Prediction is based on Resistant and Support Level illustrates how these variables are correlated. Date is limited from April 2018."
;

proc sgplot data=analytic_file3;
    series x=Date y=High / legendlabel="High";
    series x=Date y=Low / legendlabel="Low";
    series x=Date y=ResistantLevel / legendlabel="Resistant Level";
    series x=Date y=SupportLevel / legendlabel="Support Level";
    yaxis label="BTC Movements";
    where Date > 20180400;
    title "Price Prediction based on Resistant and Support Level From April 2018";
run;
footnote;


* (3a) use proc reg to develop and formulate a linear regression model for 
  predicted prices based on resistant levels' values;
* regression model (low = resistantlevel) that has an 
  equation of Y = a + bX, where Y is a dependent variable (Low variable) and
  X is an indenpendent variable (ResistantLevel variable);

title 
"Develop a predicted regression model for Low based on Resistant Levels"
;

footnote1 justify=left
"Based on the Parameter Estimates outputs, we're able to develop the linear regression line that has an equation of Y = a + bX, where X is the explanatory variable and Y is the dependent variable (Low variable in this case)"
;

footnote2 justify=left
"a is the intercept, and b is the slope of the line. The Low values can be interpreted as Low = 34.89092 + 0.93681 * (ResistantLevel)"
;

proc reg
    data=analytic_file3 noprint;
    /* remove simple stats table with noprint option */
    model Low = ResistantLevel;
run;



* (3b) display the slope and intercept of a regression line - resistant level;

proc sgplot
    data=analytic_file3 noautolegend;
    title "Regression Line with Slope and Intercept - Resistant Level";
    reg y=Low x=ResistantLevel;
    /* intercept and slope value are computed from proc reg */
    inset "Intercept = 34.89092" "Slope = 0.93681" /
        border title="Parameter Estimates" position=topleft;
run;

* clear titles/footnotes;
title;
footnote;



* (4a) use proc reg to develop and formulate a linear regression model for 
  predicted prices based on support levels's values;
* regression model (low = resistantlevel) that has an 
  equation of Y = a + bX, where Y is a dependent variable (Low variable) and
  X is an indenpendent variable (SupportLevel variable);

title 
"Develop a predicted regression model for Low based on Support Levels"
;

footnote1 justify=left
"Based on the Parameter Estimates outputs, we're able to develop the linear regression line that has an equation of Y = a + bX, where X is the explanatory variable and Y is the dependent variable (Low variable in this case)"
;

footnote2 justify=left
"a is the intercept, and b is the slope of the line. The Low values can be interpreted as Low = 21.16265 + 0.96036 * (SupportLevel)"
;

proc reg
    data=analytic_file3 noprint;
    /* remove simple stats table with noprint option*/
    model Low = SupportLevel;
run;



* (4b) display the slope and intercept of a regression line - support level;

proc sgplot
    data=analytic_file3 noautolegend;
    title "Regression Line with Slope and Intercept - Support Level";
    reg y=Low x=SupportLevel;
    /* intercept and slope value are computed from proc reg */
    inset "Intercept = 21.16265" "Slope = 0.96036" /
        border title="Parameter Estimates" position=topleft;
run;

* clear titles/footnotes;
title;
footnote;



* (5a) please input x1 and x2 as an estimated resistant and support level;

data low_prediction;
	
    x1 = 10000;
    x2 = 9000;

    /* Low = 34.89092 + 0.93681 * (ResistantLevel)
       Low = 21.16265 + 0.96036 * (SupportLevel) */
    y1 = 34.89092 + 0.93681 * (x1);
    y2 = 21.16265 + 0.96036 * (x2);
     
	put "The predicted low is in the range of : " y1 y2;
run;



* (5b) use proc report to define and print out the testing;
title 
"Buy Low Prediction"
;

footnote justify=left
"By developing a predicted regression model and applying Fibonacci Retracement Ratios, assuming the price is at $9,000, we're able to conclude that the predicted price that would be in the range from $8,664.40 to $9,402.99 where $8,664.40 is represented a predicted low price at support level and $9,402.99 is represented a predicted low price at resistant level.
"
;

proc report data=low_prediction;
    columns    
        x1
        x2
        y1
        y2
    ;  
    define x1 / "X1, Estimated Price at Resistant Level";
    define x1 / display format=dollar12.2;

    define x2 / "X2, Estimated Price at Support Level";
    define x2 / display format=dollar12.2;

    define y1 / "Predicted Low Price at Resistant Level";
    define y1 / display format=dollar12.2;

    define y2 / "Predicted Low Price at Support Level";
    define y2 / display format=dollar12.2;
run;

* clear titles/footnotes;
title;
footnote;



