/**************************************************************************
 Program:  Read_MRIS_region_old_format.sas
 Project:  HNC
 Author:   K Pettit
 Created:  5/5/07
 Version:  SAS 9.1
 Environment:  Windows
 
Previous programs:  mris pg2000.sas
 Description:  Read annual MRIS data using old format capped at $500K for DC region
	after downloading html and converting to excel workbook:
  
 Workbook must be open before program is run.

 Modifications: 7-15-07 KP added in 2000-2004, PG 2000 correction; only reran readmris2
8-5-07 - moved pg to different program;
**************************************************************************/

*libname hnc 'd:\HNC2007\mris2007\';
libname hnc 'c:\work\hnc2007\mris2007';
libname hnc2 'c:\work\hnc2007\';

options nomprint nosymbolgen;

%let cities  =dc?alex?arl?mont?pg?fairfax?fairfax city?falls church?
			calvert?charles?frederick?loudoun county?prince william?stafford?manassas city?man park?
			clarke?fauquier?spots?warren?fred city?jeff?;

%let cities2  =dc?alex?arl?mont?pg?fairfax county?fairfax city?fc city?
			calvert?charles?fred?loudoun county?prince william?stafford?manassas city?man park?
			clarke?fauquier?spots?warren?fred city?jeff?;

%let cnties  = 11001 51510 51013 24031 24033 51059 51600 51610
			   24009 24017 24021 51107 51153 51179 51683 51685
				51043 51061 51177 51187 51630 54037
;

*%let path = C:\work\HNC2007\hnc2007d\mris2007\newformat&year.\;
%let path = d:\hnc2007\mris2007\ ;
%let path = c:\work\hnc2007\mris2007\ ;

%macro readmris1(year,suff);
title "&year.";

%let oldyear = %eval(&year.-1);

proc datasets lib=hnc;
	delete mris&year.;
	run;
proc datasets lib=work;
	delete mris&year.;
	run;

%do i = 1 %to 22;
%let cnty = %scan(&cnties., &i.); 
%if &year ge 2003 %then %do;
%let wbook = %scan(&cities., &i., ?); 
%end;
%else %do;
%let wbook = %scan(&cities2., &i., ?); 
%end;

%if &year. ge 2003 %then %do;
filename xlsFileA dde "excel|&path.&year.\[&wbook. &year.&suff..xls]&wbook. &year.!R56C2:R56C3" notab lrecl=1000;/*Total Sold Dollar Volume*/
filename xlsFileb dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R57C2:R57C3" notab lrecl=1000;/*Average Sold Price:  */
filename xlsFilec dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R58C2:R58C3" notab lrecl=1000;/*Median Sold Price: */
filename xlsFiled dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R59C2:R59C3" notab lrecl=1000;/*Total Units Sold:  */
filename xlsFilee dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R60C2:R60C3" notab lrecl=1000;/*Average Days on Market::  */
filename xlsFilef dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R61C2:R61C3" notab lrecl=1000;/* Average List Price: */
filename xlsFileg dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R62C2:R62C3" notab lrecl=1000;/*Avg Sale Price as a pct of list  */

filename xlsd1 dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R14C10:R14C10" notab lrecl=1000;/*1 -30 Days    */             
filename xlsd2 dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R16C10:R16C10" notab lrecl=1000;/*31-61 Days    */ 
filename xlsd3 dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R18C10:R18C10" notab lrecl=1000;/*61 - 91 Days  */  
filename xlsd4 dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R20C10:R20C10" notab lrecl=1000;/*91-120 Days   */  
filename xlsd5 dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R22C10:R22C10" notab lrecl=1000;/*Over 120 Days */  
             
filename xlsm1 dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R33c10:R33c10" notab lrecl=1000;/*conventional*/  
filename xlsm2 dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R35c10:R35c10" notab lrecl=1000;/*fha*/  
filename xlsm3 dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R37c10:R37c10" notab lrecl=1000;/*VA                        */
filename xlsm4 dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R39c10:R39c10" notab lrecl=1000;/*Assumption               */ 
filename xlsm5 dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R41c10:R41c10" notab lrecl=1000;/*Cash                      */
filename xlsm6 dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R43c10:R43c10" notab lrecl=1000;/*Owner Finance          */
filename xlsm7 dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R45c10:R45c10" notab lrecl=1000;/*All Other        */
filename xlsm8 dde "excel|&path.&year.\[&wbook &year.&suff..xls]&wbook. &year.!R47c10:R47c10" notab lrecl=1000;/*Unreported               */ 
%end;

%else %do; *do not have original individual files for 1999-2002*; 
filename xlsFileA dde "excel|&path[reg&year..xls]&wbook. &year.!R57c3:R57c4" notab lrecl=1000;/*Total Sold Dollar Volume*/
filename xlsFileb dde "excel|&path[reg&year..xls]&wbook. &year.!R58c3:R58c4" notab lrecl=1000;/*Average Sold Price:  */
filename xlsFilec dde "excel|&path[reg&year..xls]&wbook. &year.!R59c3:R59c4" notab lrecl=1000;/*Median Sold Price: */
filename xlsFiled dde "excel|&path[reg&year..xls]&wbook. &year.!R60c3:R60c4" notab lrecl=1000;/*Total Units Sold:  */
filename xlsFilee dde "excel|&path[reg&year..xls]&wbook. &year.!R61c3:R61c4" notab lrecl=1000;/*Average Days on Market::  */
filename xlsFilef dde "excel|&path[reg&year..xls]&wbook. &year.!R62c3:R62c4" notab lrecl=1000;/* Average List Price: */
filename xlsFileg dde "excel|&path[reg&year..xls]&wbook. &year.!R63c3:R63c4" notab lrecl=1000;/*Avg Sale Price as a pct of list  */

filename xlsd1 dde "excel|&path[reg&year..xls]&wbook. &year.!R14c11:R14c11" notab lrecl=1000;/*1 -30 Days    */             
filename xlsd2 dde "excel|&path[reg&year..xls]&wbook. &year.!R16c11:R16c11" notab lrecl=1000;/*31-61 Days    */ 
filename xlsd3 dde "excel|&path[reg&year..xls]&wbook. &year.!R18c11:R18c11" notab lrecl=1000;/*61 - 91 Days  */  
filename xlsd4 dde "excel|&path[reg&year..xls]&wbook. &year.!R20c11:R20c11" notab lrecl=1000;/*91-120 Days   */  
filename xlsd5 dde "excel|&path[reg&year..xls]&wbook. &year.!R22c11:R22c11" notab lrecl=1000;/*Over 120 Days */  
             
filename xlsm1 dde "excel|&path[reg&year..xls]&wbook. &year.!R34c11:R34c11" notab lrecl=1000;/*conventional*/  
filename xlsm2 dde "excel|&path[reg&year..xls]&wbook. &year.!R36c11:R36c11" notab lrecl=1000;/*fha*/  
filename xlsm3 dde "excel|&path[reg&year..xls]&wbook. &year.!R38c11:R38c11" notab lrecl=1000;/*VA                        */
filename xlsm4 dde "excel|&path[reg&year..xls]&wbook. &year.!R40c11:R40c11" notab lrecl=1000;/*Assumption               */ 
filename xlsm5 dde "excel|&path[reg&year..xls]&wbook. &year.!R42c11:R42c11" notab lrecl=1000;/*Cash                      */
filename xlsm6 dde "excel|&path[reg&year..xls]&wbook. &year.!R44c11:R44c11" notab lrecl=1000;/*Owner Finance          */
filename xlsm7 dde "excel|&path[reg&year..xls]&wbook. &year.!R46c11:R46c11" notab lrecl=1000;/*All Other        */
filename xlsm8 dde "excel|&path[reg&year..xls]&wbook. &year.!R48c11:R48c11" notab lrecl=1000;/*Unreported               */ 
%end;

data test&cnty.;
ucounty = "&cnty";
infile xlsFileA missover dsd dlm = '09'x  ;
input aggsale&year.:comma12.
		aggsale&oldyear.:comma12.  ;

infile xlsFileB missover dsd dlm = '09'x ;
input avgsale&year.:comma12.
		avgsale&oldyear.:comma12.  ;

infile xlsFilec missover dsd dlm = '09'x ;
input medsale&year.:comma12.
		medsale&oldyear.:comma12.  ;

infile xlsFiled missover dsd dlm = '09'x ;
input numsale&year.:comma12.
		numsale&oldyear.:comma12.  ;

infile xlsFilee missover dsd dlm = '09'x ;
input avgdays&year.:comma12.
		avgdays&oldyear.:comma12.  ;

infile  xlsFilef missover dsd dlm = '09'x ;
input avglist&year.:comma12.
		avglist&oldyear.:comma12.  ;

infile xlsFileg missover dsd dlm = '09'x ;
input saletolist&year.:comma12.
		saletolist&oldyear.:comma12.  ;
		

infile xlsd1 missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input days30_&year.:comma12.;
infile xlsd2 missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input days60_&year.:comma12.;
infile xlsd3 missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input days90_&year.:comma12.;
infile xlsd4 missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input days120_&year.:comma12.;
infile xlsd5 missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input days120p_&year.:comma12.;


infile xlsm1 missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortconv&year.:comma12.;
infile xlsm2 missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortfha&year.:comma12.;
infile xlsm3 missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortva&year.:comma12.;
infile xlsm4 missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortass&year.:comma12.;
infile xlsm5 missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortcash&year.:comma12.;
infile xlsm6 missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortown&year.:comma12.;
infile xlsm7 missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortoth&year.:comma12.;
infile xlsm8 missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortunk&year.:comma12.;


*hard code fix for fairfax county 2006;
if &year. = 2006 and ucounty eq "51059" then do;
days30_&year. = days30_&year.-1;
mortconv&year. = mortconv&year.-1;
mortunk&year. = 0;
end;
*hard code fix for mont county 2000;
if &year. = 2000 and ucounty = "24031" then do;
days30_&year. = days30_&year.-1;
end;
*hard code fix for dc 2003;
if &year. = 2003 and ucounty = "11001" then do;
days30_&year. = days30_&year.-1;
end;

if sum(days30_&year.,days60_&year.,days90_&year.,days120_&year.,days120p_&year.) = numsale&year.
	then testdays = 'ok';

if sum(mortconv&year.,mortfha&year.,mortva&year.,mortass&year.,mortcash&year., mortown&year.,mortoth&year., mortunk&year.) = numsale&year.
		then testmort = 'ok';

run;
proc append data=test&cnty. out  = mris&year.;
run;
%end;



%if &year eq 2000 %then %do;
	data pg2000;
	merge mris2001 (keep=ucounty aggsale2000  
		avgdays2000 avglist2000
		avgsale2000 medsale2000
		numsale2000 saletolist2000
	where = (ucounty = '24033') )

	mris1999 (keep=ucounty aggsale1999  
		avgdays1999 avglist1999
		avgsale1999 medsale1999
		numsale1999 saletolist1999
	where = (ucounty = '24033') )

	hnc.pg2000mnthsum (keep = ucounty 
		mortconv2000 mortfha2000 mortva2000 mortass2000
		mortcash2000  mortown2000 mortoth2000 
		mortunk2000
		days30_2000 days60_2000 days90_2000
		days120_2000 days120p_2000 );
	run;
		

	data mris2000;
	set mris2000 (where = (ucounty ne '24033'))
	pg2000;
	run;
%end;

proc sort data=mris&year.;
by ucounty;
run;

data hnc.mris&year;
	merge mris&year.
	hnc2.geograph06;
	by ucounty;

 pdays30_&year. = days30_&year./numsale&year.*100;
 pdays60_&year. = days60_&year./numsale&year.*100;
 pdays90_&year. = days90_&year./numsale&year.*100;
 pdays120_&year. = days120_&year./numsale&year.*100;
 pdays120p_&year. = days120p_&year./numsale&year.*100;
 totdays&year.=avgdays&year.*numsale&year.;
 totdays&oldyear.=avgdays&oldyear.*numsale&oldyear.;

run;

proc freq data = hnc.mris&year. ;
tables testmort testdays;
run;

proc means data = hnc.mris&year. sum;
var aggsale&oldyear. aggsale&year. numsale&oldyear. numsale&year.;
run;

proc print data = hnc.mris&year. ;
var ucounty aggsale&oldyear. aggsale&year. numsale&oldyear. numsale&year. avgdays&year.
pdays30_&year. pdays60_&year. pdays90_&year. pdays120_&year. pdays120p_&year.;
run;
%mend;



/*read in price categories*/
%macro readmris2(year,suff);

%let oldyear = %eval(&year.-1);

proc datasets lib=hnc;
	delete mriscat30_500_&year. ;
	run;

%do i = 1 %to 22;
	%if &year ge 2003 %then %do;
		%let wbook = %scan(&cities., &i., ?); 
	%end;
	%else %do;
		%let wbook = %scan(&cities2., &i., ?); 
	%end;
%let cnty = %scan(&cnties., &i.); 
%if &year ge 2003 %then %do;
	filename xlscat dde "excel|&path.&year\[&wbook. &year.&suff..xls]&wbook. &year.!R13C1:R51C5" notab lrecl=1000;
%end;
%else %do;
	filename xlscat dde "Excel|&path[reg&year..xls]&wbook. &year.!R14C2:R52C6" notab  lrecl=1000;;
%end;

data test2&Cnty.;
length salescat $25.;
ucounty = "&cnty";
infile xlscat   dsd dlm = '09'x ;

input salescat:
sales_bed2 :comma12.
sales_bed3 :comma12.
sales_bed4 :comma12.
sales_condor :comma12.;

sales_tot= sum(sales_bed2,sales_bed3,sales_bed4,sales_condor);
sales_sf = sum(sales_bed2,sales_bed3,sales_bed4);

label
    sales_sf    = "Sales, s.f. homes"
    sales_tot   = "Sales, total";

if salescat = '' then delete;
run;

proc append data=test2&cnty. out  = hnc.mriscat30_500_&year.;
run;

%end;
%if &year. = 2000 %then %do;
		
	data hnc.mriscat30_500_2000;
	set hnc.mriscat30_500_2000 (where = (ucounty ne '24033'))
	hnc.pgcat2000mnthsum ;
	run;

%end;

%mend;
/*
%readmris1(1999,);
%readmris1(2001,);
%readmris1(2002,);
%readmris1(2000,);

%readmris2(1999,);
%readmris2(2000,);
%readmris2(2001,);
%readmris2(2002,);


%readmris1(2003);
%readmris1(2004);
%readmris2(2003,);
%readmris2(2004,);*/

%readmris1(2005,old);
%readmris1(2006,old);
%readmris2(2005,old);
%readmris2(2006,old);
