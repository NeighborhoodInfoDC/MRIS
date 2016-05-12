/**************************************************************************
 Program:  mris cat sum.sas
 Project:  HNC
 Author:   K Pettit
 Created:  7/15/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Sum MRIS sales file (which is by county/category) for region
  
 Workbook must be open before program is run.
 
 Modifications:  edited 3/9/09 to add 2007-2008 kp
**************************************************************************/

libname hnc 'd:\HNC2009\mris\';

/*
*create reference file to sort the categories;
filename catnum dde "Excel|C:\work\hnc2007\mris2007\[cat30_500num.xls]Sheet1!R1C1:R19C2" notab  lrecl=1000;;;

data hnc.cat30_500num;
length salescat $25.;
infile catnum   dsd dlm = '09'x ;
input salescat: 
salesorder :10.;
run;

proc sort data=hnc.cat30_500num;
by salescat;
run;*/


%macro sumyr;
%do i = 1999 %to 2008;

%let year = &i.;
proc sort data=hnc.mriscat30_500_&year.;
by salescat;
run;

proc summary data=hnc.mriscat30_500_&year.;
var sales_tot sales_sf sales_condor;
by salescat;
output out = salescat&year sum=sales_tot&year. sales_sf&year. sales_condor&year.;
run;
%end;
%mend;
%sumyr;

data hnc.mriscat30_500_1999_2008;
merge hnc.cat30_500num
salescat1999
salescat2000
salescat2001
salescat2002
salescat2003
salescat2004
salescat2005
salescat2006
salescat2007
salescat2008;

by salescat;

/*
*limit for soc services -  207,120 
*limit for medical /health mgr -  261,339 ;

diff1 =  (249999-207,120)/50000;
diff2 = (299999-261,339)/50000;
*/
run;
proc sort;
by salesorder;
run;

proc print;
var salescat sales_tot2000- sales_tot2008 ;
run;


/*
%macro outexc(type);
filename outcat dde "Excel|C:\work\hnc2009\mris2007\[regioncat.xls]sales_&type.!R7C3:R25C10";

data _null_;
file outcat lrecl  =10000;
set hnc.mriscat30_500;
put salesorder sales_&type.2000- sales_&type.2008 ;
run;
%mend;
%outexc(tot);
%outexc(sf);
%outexc(condor);*/


