/**************************************************************************
 Program:  Read_MRIS_month_county.sas
 Project:  HNC
 Author:   K Pettit
 Created:  3/9/2009
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read monthly MRIS data for zip codes and counties
	after downloading html and converting to excel workbook;  
 Workbook must be open before program is run.
Source files scraped by Visual studio program

 Modifications: 7/16/2009, ran for April - June 2009; 7/21/09, ran for 1997-1998
**************************************************************************/
*Leah's Libnames;
libname hnc "D:\Data Sets\MRIS\Data";
libname hnc2 "D:\Data Sets\MRIS\Data";

*Kathy's libnames;
libname hnc 'd:\HNC2009\mris';
libname hnc2 'd:\HNC2009\';

options nomprint nosymbolgen;

%include 'k:\metro\kpettit\hnc2009\programs\mris\read_mris_month_macros.sas';

**need to rename dc for now to take out periods of workbook and worksheet;
%let cntycodes  = 11001 51510 51013 24031 24033 51059 51600 51610
			   24009 24017 24021 51107 51153 51179 51683 51685
				51043 51061 51177 51187 51630 54037 ;

*using geog as macro var is holdover from trying to combine cnty/zip programming;
%macro readmrism2 (year,geog);

%let oldyear = %eval(&year.-1);
%let ext = &geog.;

		%let path = D:\hnc2009\mris\source data\monthly_county\;
				%*let path = D:\Data Sets\MRIS\Raw\;

	/*cycle through months*/
	%do j = 8 %to 12;
		%if &j<10 %then %let month = 0&j.;
		%else %let month = &j. ;
	title "&year.m&month.";

*clear old files;
proc datasets lib=hnc;
	delete mris&ext.&year.m&month. mriscat30_500_&ext.&year.m&month. ;
	run;
proc datasets lib=work;
	delete mris&ext.&year.m&month. mriscat30_500_&ext.&year.m&month. ;
	run;

	%*cycle through geographies;
		%do i = 1 %to 22;
		%let filecode = %scan(&files., &i.); 
		%let fips = %scan(&cntycodes., &i.);

/*%let excname = excel|&path[&filecode._&month._01_&year..xls]&filecode._&month._01_&year.;*/
%let excname = excel|&path[&filecode._&month._01_&year..xls];

*program results in max 32-char worksheet names, & some of the county file names are longer;
*get error when file <32 - could get fancy and determine length of field first;
%let excsheet = %substr(&filecode._&month._01_&year.,1,31);

/*filename statements for all indicators;*/
%filenm1;

%*readin in summary indicators;
data sum&fips.;
	ucounty = "&fips";
	/*infile statements for summary indicators;*/
	%inf_sum;
run;
proc append data=sum&fips. out  = mris&ext&year.m&month.;
run;

%*read in sales indicators;
data sale&fips.;
	length pricecat $25.;
	ucounty = "&fips";
	%inf_sales;
run;

proc append data=sale&fips. out  = mriscat30_500_&ext.&year.m&month.;
run;

%end;  /*end cycling through geographies*/

%*process main file;

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
data hnc.mriscat30_500_&ext.&year.m&month.;
	set mriscat30_500_&ext.&year.m&month. ;
	sales_tot= sum(sales_bed2,sales_bed3,sales_bed4,sales_condor);
	sales_sf = sum(sales_bed2,sales_bed3,sales_bed4);
	list_tot= sum(list_sf,list_condor);
	%labelcat;
run;

*data check;
proc sort data=hnc.mriscat30_500_&ext.&year.m&month.;
by ucounty;
run;

proc summary data=hnc.mriscat30_500_&ext.&year.m&month. (where= (pricecat ne "Totals"));
var sales_tot;
by ucounty;
output out=sales_sum&year.m&month. sum = sales_tot;
run;

proc sort data=hnc.mris&ext&year.m&month.;
by ucounty;
run;

data testing&year.m&month.;
merge sales_sum&year.m&month.
 hnc.mris&ext&year.m&month.;
 by ucounty;
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

*%readmrism2(year=2009,geog=cnty);
%readmrism2(year=2009,geog=cnty);

/*proc contents data=hnc.mriscnty2009m01;
run;
proc contents data=hnc.mriscat30_500_cnty2009m01;
run;
*/
*Note for 2009m10 - In the sales by financing type, PG lists the unreported as "-1", so is failing test1.  I left it as is.
*Note for 2006m04 - Fairfax county has inconsistent total numbers so fails one of the tests:  only 1 off 1411/1412;
*Note for 2003m06 - DC has inconsistent total numbers so fails one of the tests:  only 1 off 816/817;
*Note for 2000m09 - Mont has inconsistent total numbers so fails one of the tests:  only 1 off 1175/1176;
*Note for 1999m01 and 1999m02 - 51043 (Clarke County, VA), 51187 (Warren County, VA);
*Note for 1999m07 - 51630 (fred city, va) has inconsistent total numbers so fails one of the tests:  only 1 off 25/26;
*Note for 1997m12 - Mont has inconsistent total numbers so fails one of the tests:  only 1 off 855/854;
*Note for 1998m10 - DC has inconsistent total numbers so fails one of the tests:  only 1 off 620/621;
*Note for 1997/1998 - missing many counties;


proc print data=testing2009m10;
where test1 ne 'ok';
run;
