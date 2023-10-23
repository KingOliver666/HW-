%let in_path = ~/sasuser.v94/homework/;
RUN;
FILENAME REFFILE '/home/u63650570/sasuser.v94/homework/recs2020_public_v5.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=recs;
	GETNAMES=YES;
RUN;



/* Part(a) */
PROC SUMMARY DATA = recs;
 CLASS state_name;
 OUTPUT OUT = state_grouped
 SUM(nweight) = sum_weight;
RUN;

DATA recs_grouped;
 SET state_grouped;
 WHERE _type_ = 1;
RUN;

PROC SQL;
 SELECT state_name, sum_weight / SUM(sum_weight) AS percentage
 FROM recs_grouped
 ORDER BY percentage DESC;
QUIT;


/*Answer: Thus, California has the highest percentage(10.6%) of records, and Michigan has about 3.17 percent(3.17%) of all records by looking at the table.




/* Part(b) */

DATA elec;
 SET recs;
 WHERE DOLLAREL > 0;
 KEEP DOLLAREL;
RUN;



PROC UNIVARIATE DATA = elec;
 HISTOGRAM DOLLAREL;
RUN;

/* Thus, we get a histogram as we desired.




/* Part(c) */

DATA logelec; /*Do log transformation*/
 SET elec;
 LOGDOLLAREL = log(DOLLAREL);
RUN;

/* Draw the histogram for log cost of electricity*/
PROC UNIVARIATE DATA = logelec;
 HISTOGRAM LOGDOLLAREL;
RUN;




/* Part(d) */
/* We only focus on those observations that have positive cost*/

/* We first get those observations that garage = 0 or garage = 1*/
DATA elec_gara;
 SET recs;
 WHERE DOLLAREL > 0 AND PRKGPLC1 >= 0;
 KEEP DOLLAREL PRKGPLC1 TOTROOMS NWEIGHT;
RUN;

DATA logelec_gara;
 SET elec_gara;
 log_DOLLAREL = log(DOLLAREL);
RUN;

PROC REG DATA = logelec_gara;
 MODEL log_DOLLAREL = TOTROOMS PRKGPLC1;
RUN;



/* Part(e) */
/* Run the linear regression model */
PROC REG DATA = logelec_gara; 
 MODEL log_DOLLAREL = TOTROOMS PRKGPLC1; 
 OUTPUT OUT=fitted_dataset PREDICTED=fitted_values;
RUN;

/* find exponentials of those fitted values */
DATA exp_gara;
 SET fitted_dataset;
 fitted_value = exp(fitted_values);
RUN;
 
/* Draw the scatterplot*/
PROC SGPLOT DATA = exp_gara;
 SCATTER x=DOLLAREL y=fitted_value;
RUN;
