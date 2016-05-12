/**************************************************************************
 Program:  Read_MRIS_month_zip.sas
 Project:  HNC
 Author:   K Pettit
 Created:  3/9/2009
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read monthly MRIS data for zip codes
	after downloading html and converting to excel workbook;  
 Workbook must be open before program is run.
Source files scraped by Visual studio program

 Modifications: 5/1/09 
**************************************************************************/

*kathy's libnames;
*libname hnc 'd:\HNC2009\mris';
*libname hnc2 'd:\HNC2009\';

*leah's libnames;
libname hnc "D:\Data Sets\MRIS\Data";
libname hnc2 "D:\Data Sets\MRIS\Data";

options nomprint nosymbolgen;

%include 'k:\metro\kpettit\hnc2009\programs\mris\read_mris_month_macros.sas';
%include 'k:\metro\kpettit\hnc2009\programs\mris\mris_zip_list.sas';


*****BEFORE RUNNING AGAIN, ADD IN READING TOTAL LISTINGS INTO MAIN FILE****;

options noxwait noxsync;                                                        
                                                                            
                                                                                

*using geog as macro var is holdover from trying to combine cnty/zip programming;
%macro readmrism2 (year,geog,sep1);
/*attempts to put sep on main macro failed = try to fix later
%global sep ;

data _null_;
	call symput("sep","&sep1.");
	run;
*/

%let oldyear = %eval(&year.-1);
%let ext = &geog.;

%let path = D:\Data Sets\MRIS\Raw\;
%*let path = D:\hnc2009\mris\source data\KathyZipCodeData\KathyZipCodeData\combined runs\;

/*cycle through months*/
	%do j = 3 %to 6;
		%if &j<10 %then %let month = 0&j.;
		%else %let month = &j. ;
	title "&year.m&month.";

*clear old files;
proc datasets lib=hnc;
	delete mris&ext.&year.m&month. mriscat100_5m_&ext.&year.m&month. ;
	run;
proc datasets lib=work;
	delete mris&ext.&year.m&month. mriscat100_5m_&ext.&year.m&month. ;
	run;

	%*cycle through geographies;
		%do i = 1 %to 532;
		%let filecode = %scan(&ziplist., &i.); 

		%*this statement is used when a dash is used in the file;
		%if &sep1. = d %then 
			%let statement ="'[open("&path.&filecode.-&month.-01-&year..xls")]'" ;

		%*this statement is used when an underscore is used in the file;
		%else %if &sep1. = u %then 
			%let statement ="'[open("&path.&filecode._&month._01_&year..xls")]'" ;
			
		%let statement2 ="&statement." ;

    
/* open and start excel */                                                      
%*x "C:\Program Files\Microsoft Office\OFFICE11\Excel";   %*not sure where excel is located.  V drive?;                                                  

                              
/* wait for a few seconds to allow excel to come up     */                      
data _null_;                                                                    
x=sleep(5);                                                                     
run;        
 
/* pass to excel the following MACRO commands open zip sales file */     
filename cmds dde 'Excel|system';                                               
data _null_;                                                                    
file cmds;                 
put &statement2.;  /* open the file we need */     
put '[select("R1:R65536")]' ;
put '[activate()]';

run; 

  
/*%let excname = excel|&path[&filecode._&month._01_&year..xls]&filecode._&month._01_&year.;*/

/*filename statements for all indicators;*/
%if &sep1. = u %then %filenmz(_);
%if &sep1. = d %then %filenmz(-);

%*readin in summary indicators;
data sum&filecode.;
	zip = "&filecode";

	/*infile statements for summary indicators;*/
	%inf_sum;
run;
proc append data=sum&filecode. out  = mris&ext&year.m&month.;
run;

%*read in sales indicators;
data sale&filecode.;
	length pricecat $25.;
		zip = "&filecode";

	%inf_salez;
run;

proc append data=sale&filecode. out  = mriscat100_5m_&ext.&year.m&month.;
run;
		%let statementc ="'[close("&path.&filecode._&month._01_&year..xls")]'" ;
		%let statement2c ="&statementc." ;

/* pass to excel the following MACRO commands closes zip sales file */                                  
filename cmds dde 'Excel|system';                                               
data _null_;                                                                    
file cmds;                                                                      
put &statement2c.;  /* close the file we need */    
run; 

FILENAME _ALL_ CLEAR; 
%end;  /*end cycling through geographies*/

%*process main file;
%*merge on county-zip crosswalk;

proc sort data=mris&ext&year.m&month.;
by zip;
run;

proc sort data=HNC2.HNC_COUNTY_ZIP;
	by zip;
 	run;

data mris&ext&year.m&month.;
	merge mris&ext&year.m&month. (in=a)
		HNC2.HNC_COUNTY_ZIP ;
	by zip;
	if a;
	run;

proc sort data=mris&ext&year.m&month.;
by ucounty;
run;

proc sort data=mris&ext&year.m&month.;
by ucounty;
run;

proc sort data=hnc2.geograph;
by ucounty;
run;

data hnc.mris&ext&year.m&month.;
	merge mris&ext&year.m&month. (in=a)
		hnc2.geograph (in=b);
	by ucounty;
	if a and b;
	if numsale&year.m&month.  gt 0 then do;
 		pdays30_&year.m&month. = days30_&year.m&month./numsale&year.m&month.*100;
 		pdays60_&year.m&month. = days60_&year.m&month./numsale&year.m&month.*100;
 		pdays90_&year.m&month. = days90_&year.m&month./numsale&year.m&month.*100;
 		pdays120_&year.m&month. = days120_&year.m&month./numsale&year.m&month.*100;
 		pdays120p_&year.m&month. = days120p_&year.m&month./numsale&year.m&month.*100;
 		totdays&year.m&month.=avgdays&year.m&month.*numsale&year.m&month.;
 	end;

  if numsale&oldyear.m&month. >0 then 
	totdays&oldyear.m&month.=avgdays&oldyear.m&month.*numsale&oldyear.m&month.;
	%labelsum;
	run;

***process sales cat file;
data hnc.mriscat100_5m_&ext.&year.m&month.;
	set mriscat100_5m_&ext.&year.m&month. ;
	sales_condor = sum(sales_condo,sales_grent);
	sales_tot= sum(sales_bed2,sales_bed3,sales_bed4,sales_condor);
	sales_sf = sum(sales_bed2,sales_bed3,sales_bed4);
	list_condor = sum(sales_condo,sales_grent);
	list_tot= sum(list_sf,list_condor);
	%labelcat;
run;

*data check;
proc sort data=hnc.mriscat100_5m_&ext.&year.m&month.;
by zip;
run;

proc summary data=hnc.mriscat100_5m_&ext.&year.m&month. (where= (pricecat ne "Totals"));
var sales_tot;
by zip;
output out=sales_sum&year.m&month. sum = sales_tot;
run;

proc sort data=hnc.mris&ext&year.m&month.;
by zip;
run;

data testing&year.m&month.;
merge sales_sum&year.m&month.
 hnc.mris&ext&year.m&month.;
 by zip;
 daystot = sum(of days30_&year.m&month.,days60_&year.m&month.,days90_&year.m&month.,days120_&year.m&month., days120p_&year.m&month.);
if daystot= numsale&year.m&month. then test1 = 'ok';
if sales_tot = numsale&year.m&month. then test2 = 'ok';
 morttot=  sum( of mortconv&year.m&month., mortfha&year.m&month., mortva&year.m&month., mortass&year.m&month., 
	mortcash&year.m&month., mortown&year.m&month., mortoth&year.m&month., mortunk&year.m&month. );
if morttot=  numsale&year.m&month. then test3 = 'ok';
if sales&year.m&month. = numsale&year.m&month. then test4 = 'ok';
 run;

proc freq data=testing&year.m&month.;
tables test1-test4;
run;

proc print data=testing&year.m&month.;
where test1 ne 'ok' or test2 ne 'ok' or test3 ne 'ok' or test4 ne 'ok'; 
title2 'records with consistency errors';
run;
title2;

proc means data = hnc.mris&ext.&year.m&month. sum;
var aggsale&oldyear.m&month. aggsale&year.m&month. numsale&oldyear.m&month. numsale&year.m&month.;
run;

proc print data = hnc.mris&ext.&year.m&month. (obs=22) ;
var aggsale&oldyear.m&month. aggsale&year.m&month. numsale&oldyear.m&month. numsale&year.m&month. avgdays&year.m&month.
pdays30_&year.m&month. pdays60_&year.m&month. pdays90_&year.m&month. pdays120_&year.m&month. pdays120p_&year.m&month.;
run;

title;



%end;

%mend;

%readmrism2(year=2009,geog=zip,sep1=u);

/*
proc contents data=hnc.mriszip2009m01;
run;
proc contents data=hnc.mriscat100_5m_cnty2009m01;
run;

*/
*Note for 2006m04 - Fairfax county has inconsistent total numbers so fails one of the tests:  only 1 off 1411/1412;
