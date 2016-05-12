/**************************************************************************
 Program:  Read_MRIS_region.sas
 Project:  HNC
 Author:   K Pettit
 Created:  5/5/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read annual MRIS data for DC region
	after downloading html and converting to excel workbook:
  
 Workbook must be open before program is run.

 Modifications:
**************************************************************************/

libname hnc 'C:\work\HNC2007';
options nomprint nosymbolgen;

%let cities  =?dc?alex?arl?mont?pg?fairfax?fairfax city?falls church?
			calvert?charles?frederick?loudoun county?prince william?stafford?manassas city?man park?
			clarke?fauquier?spots?warren?fred city?jeff?;

%let cnties  = 11001 51013 51510 24031 24033 51059 51600 51610
			   24009 24017 24021 51107 51153 51179 51683 51685
				51043 51061 51177 51187 51630 54037
;


%macro readmris1(year);

%let oldyear = %eval(&year.-1);

%let path = C:\work\HNC2007\hnc2007d\mris2007\newformat&year.\;

proc datasets lib=hnc;
	delete mris&year. mriscat&year.;
	run;
%do i = 1 %to 22;
%let wbook = %scan(&cities., &i., ?); 
%let cnty = %scan(&cnties., &i.); 

filename xlsFilei dde "excel|&path[&wbook. &year..xls]&wbook. &year.!R50C2:R50C2" notab lrecl=1000;
filename xlsFileA dde "excel|&path[&wbook. &year..xls]&wbook. &year.!R54C2:R54C3" notab lrecl=1000;/*Total Sold Dollar Volume*/
filename xlsFileb dde "excel|&path[&wbook &year..xls]&wbook. &year.!R55C2:R55C3" notab lrecl=1000;/*Average Sold Price:  */
filename xlsFilec dde "excel|&path[&wbook &year..xls]&wbook. &year.!R56C2:R56C3" notab lrecl=1000;/*Median Sold Price:  */
filename xlsFiled dde "excel|&path[&wbook &year..xls]&wbook. &year.!R57C2:R57C3" notab lrecl=1000;/*Total Units Sold:  */
filename xlsFilee dde "excel|&path[&wbook &year..xls]&wbook. &year.!R58C2:R58C3" notab lrecl=1000;/*Average Days on Market:  */
filename xlsFilef dde "excel|&path[&wbook &year..xls]&wbook. &year.!R59C2:R59C3" notab lrecl=1000;/*Average List Price:  */

filename xlsFilej dde "excel|&path[&wbook &year..xls]&wbook. &year.!R13C11:R13C11" notab lrecl=1000;/*Average List Price:  */
filename xlsFilek dde "excel|&path[&wbook &year..xls]&wbook. &year.!R15C11:R15C11" notab lrecl=1000;/*Average List Price:  */
filename xlsFilel dde "excel|&path[&wbook &year..xls]&wbook. &year.!R17C11:R17C11" notab lrecl=1000;/*Average List Price:  */
filename xlsFilem dde "excel|&path[&wbook &year..xls]&wbook. &year.!R19C11:R19C11" notab lrecl=1000;/*Average List Price:  */
filename xlsFilen dde "excel|&path[&wbook &year..xls]&wbook. &year.!R21C11:R21C11" notab lrecl=1000;/*Average List Price:  */

filename xlsFileO dde "excel|&path[&wbook &year..xls]&wbook. &year.!R32C11:R32C11" notab lrecl=1000;/*Average List Price:  */
filename xlsFileP dde "excel|&path[&wbook &year..xls]&wbook. &year.!R34C11:R34C11" notab lrecl=1000;/*Average List Price:  */
filename xlsFileQ dde "excel|&path[&wbook &year..xls]&wbook. &year.!R36C11:R36C11" notab lrecl=1000;/*Average List Price:  */
filename xlsFileR dde "excel|&path[&wbook &year..xls]&wbook. &year.!R38C11:R38C11" notab lrecl=1000;/*Average List Price:  */
filename xlsFileS dde "excel|&path[&wbook &year..xls]&wbook. &year.!R40C11:R40C11" notab lrecl=1000;/*Average List Price:  */
filename xlsFileT dde "excel|&path[&wbook &year..xls]&wbook. &year.!R42C11:R42C11" notab lrecl=1000;/*Average List Price:  */
filename xlsFileU dde "excel|&path[&wbook &year..xls]&wbook. &year.!R44C11:R44C11" notab lrecl=1000;/*Average List Price:  */
filename xlsFileV dde "excel|&path[&wbook &year..xls]&wbook. &year.!R46C11:R46C11" notab lrecl=1000;/*Average List Price:  */


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

infile  xlsFilei missover dsd dlm = '09'x ;
input sales&oldyear.:comma12.;

infile xlsFilej missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input days30_&year.:comma12.;
infile xlsFilek missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input days60_&year.:comma12.;
infile xlsFilel missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input days90_&year.:comma12.;
infile xlsFilem missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input days120_&year.:comma12.;
infile xlsFilen missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input days120p_&year.:comma12.;

infile xlsFileo missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortconv&year.:comma12.;
infile xlsFilep missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortfha&year.:comma12.;
infile xlsFileq missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortva&year.:comma12.;
infile xlsFiler missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortass&year.:comma12.;
infile xlsFiles missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortcash&year.:comma12.;
infile xlsFilet missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortown&year.:comma12.;
infile xlsFileu missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortoth&year.:comma12.;
infile xlsFilev missover dsd dlm = '09'x missover dsd dlm = '09'x  ;
input mortunk&year.:comma12.;

/*infile missover dsd dlm = '09'x xlsFileg
input saletolist&year.:comma12.
		saletolist&oldyear.:comma12.:  ;*/

 pdays30_&year. = days30_&year./numsale&year.*100;
 pdays60_&year. = days60_&year./numsale&year.*100;
 pdays90_&year. = days90_&year./numsale&year.*100;
 pdays120_&year. = days120_&year./numsale&year.*100;
 pdays120p_&year. = days120p_&year./numsale&year.*100;
 totdays&year.=avgdays&year.*numsale&year.;
 totdays&oldyear.=avgdays&oldyear.*numsale&oldyear.;
run;
proc append data=test&cnty. out  = hnc.mris&year.;
run;

/*data hnc.mrisregion;
	merge mrisregion
		hnc.geograph;
	by ucounty;
	run;*/

/*read in price categories*/

filename xlsFileh dde "excel|&path[&wbook. &year..xls]&wbook. &year.!R13C1:R49C6" notab lrecl=1000;

data test2&Cnty.;
length salescat $25.;
ucounty = "&cnty";
infile xlsFileh   dsd dlm = '09'x ;

input salescat:
sales_bed2 :comma12.
sales_bed3 :comma12.
sales_bed4 :comma12.
sales_condo :comma12.
sales_grent :comma12.;

sales_tot= sum(sales_bed2,sales_bed3,sales_bed4,sales_condo,sales_grent);
sales_sf = sum(sales_bed2,sales_bed3,sales_bed4);
sales_condor = sum(sales_condo,sales_grent);

/* adjusted bad data for dc 2005*/

%if &year. = 2005 and &cnty. = 11001 %then %do;
	sales_condo = .;
	sales_grent = .;
%end;

  label
  	sales_grent = "Sales, ground rent"
    sales_condo = "Sales, condos/coops"
    sales_sf    = "Sales, s.f. homes"
    sales_tot   = "Sales, total";

if salescat = '' then delete;
run;

proc append data=test2&cnty. out  = hnc.mriscat&year.;
run;

%end;
/*
proc sort data= hnc.mrisregioncat;
by ucounty;
run;

data mrisregioncatA;
	merge mrisregioncat
		hnc.geograph;
	by ucounty;
	run;
*/

proc means data = hnc.mris&year. sum;
var aggsale&oldyear. aggsale&year. numsale&oldyear. numsale&year.;
run;

proc print data = hnc.mris&year. ;
var ucounty aggsale&oldyear. aggsale&year. numsale&oldyear. numsale&year. avgdays&year.
pdays30_&year. pdays60_&year. pdays90_&year. pdays120_&year. pdays120p_&year.;
run;

%mend;
%readmris1(2005);
*%readmris1(2006);
/*
proc print data = hnc.mris&year. ;
var pdays30_2005 pdays30_2006 pdays60_2005 pdays60_2006 pdays90_2005 pdays90_2006 pdays120_2005 pdays120_2005  pdays120_2006 pdays120p_2005  pdays120p_2006;
*/

proc means data=hnc.mris2005 sum;
var  totdays2005 numsale2005 days30_2005 days60_2005 days90_2005 days120_2005 days120p_2005;
run;


proc means data=hnc.mris2006 sum;
var  totdays2006 numsale2006 days30_2006 days60_2006 days90_2006 days120_2006 days120p_2006;
run;

