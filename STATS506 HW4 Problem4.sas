%let in_path = ~/sasuser.v94/homework/;

FILENAME REFFILE '/home/u63650570/sasuser.v94/homework/public2022.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=public2022;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

PROC SQL;
 SELECT B3, ND2, B7_b, GH1, ppeducat, race_5cat
 FROM public2022;
QUIT;