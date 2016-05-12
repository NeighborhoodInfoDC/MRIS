** PROGRAM NAME: mriszipanal.sas
**
** PROJECT:  HNC2009, 08358-000-00
** DESCRIPTION :  

** ASSISTING PROGRAMS:
** PREVIOUS PROGRAM:
** FOLLOWING PROGRAM:
**
** AUTHOR      :  
**
** CREATED     : 
** MODIFICATIONS:
**   
**
*******************************************************************************;

%include 'k:\metro\kpettit\hnc2009\programs\hncformats.sas';
libname hnc 'd:\HNC2009\mris';

*signon;  /*any alpha logon will work*/
/*
rsubmit;

*replace HMDA with directory for data source of interest;

libname dplace 'DISK$USER05:[DPLACE]'; 

*one can download the whole file;
proc download data=dplace.dplex_census2000noblkgrp (where = (geoscaleid = '7') keep =zcta500 geoscaleid NumHsgUnits NumOwnerHsgUnits
NumHsgUnitsSingleFamilyAttached
NumHsgUnitsSingleFamilyDetached
NumHsgUnits2to4UnitStructures
NumHsgUnits5To9UnitStructures
NumHsgUnits10to19UnitStructures
NumHsgUnits20plusUnitStructures
NumHsgUnitsOtherStructure) out = hnc.censuszcta ;
run;

endrsubmit;
*/

proc sort data=hnc.censuszcta ;
by zcta500;
run;


data hnc.mriszipanal;
merge 
hnc.mriszip2007m01
hnc.mriszip2007m02
hnc.mriszip2007m03
hnc.mriszip2007m04
hnc.mriszip2007m05
hnc.mriszip2007m06
hnc.mriszip2009m01
hnc.mriszip2009m02 (in=b)
hnc.mriszip2009m03

hnc.mriscat100_5m_zip2007m01 (where = (pricecat = "Totals") 
	keep = zip pricecat sales_tot sales_sf sales_condor list_tot list_sf list_condor
	rename = (sales_tot = sales_tot2007m01 sales_sf=sales_sf2007m01 sales_condor=sales_condor2007m01
	list_tot = list_tot2007m01 list_sf=list_sf2007m01 list_condor=list_condor2007m01))


hnc.mriscat100_5m_zip2007m02 (where = (pricecat = "Totals") 
	keep = zip pricecat sales_tot sales_sf sales_condor list_tot list_sf list_condor
	rename = (sales_tot = sales_tot2007m02 sales_sf=sales_sf2007m02 sales_condor=sales_condor2007m02
	list_tot = list_tot2007m02 list_sf=list_sf2007m02 list_condor=list_condor2007m02))

hnc.mriscat100_5m_zip2007m03 (where = (pricecat = "Totals") 
	keep = zip pricecat sales_tot sales_sf sales_condor list_tot list_sf list_condor
	rename = (sales_tot = sales_tot2007m03 sales_sf=sales_sf2007m03 sales_condor=sales_condor2007m03
	list_tot = list_tot2007m03 list_sf=list_sf2007m03 list_condor=list_condor2007m03))

hnc.mriscat100_5m_zip2009m01 (where = (pricecat = "Totals") 
	keep = zip pricecat sales_tot sales_sf sales_condor list_tot list_sf list_condor
	rename = (sales_tot = sales_tot2009m01 sales_sf=sales_sf2009m01 sales_condor=sales_condor2009m01
	list_tot = list_tot2009m01 list_sf=list_sf2009m01 list_condor=list_condor2009m01))
hnc.mriscat100_5m_zip2009m02 (in=b where = (pricecat = "Totals") 
	keep = zip pricecat sales_tot sales_sf sales_condor list_tot list_sf list_condor
	rename = (sales_tot = sales_tot2009m02 sales_sf=sales_sf2009m02 sales_condor=sales_condor2009m02
	list_tot = list_tot2009m02 list_sf=list_sf2009m02 list_condor=list_condor2009m02))

hnc.mriscat100_5m_zip2009m03(where = (pricecat = "Totals") 
	keep = zip pricecat sales_tot sales_sf sales_condor list_tot list_sf list_condor
	rename = (sales_tot = sales_tot2009m03 sales_sf=sales_sf2009m03 sales_condor=sales_condor2009m03
	list_tot = list_tot2009m03 list_sf=list_sf2009m03 list_condor=list_condor2009m03))

hnc.censuszcta (in=a rename = (zcta500=zip))
;
by zip;
if b;
if a then in_cen='yes';

inv2009Q1 = sum(of list_tot2009m01-list_tot2009m03)/sum(of sales_tot2009m01-sales_tot2009m03);

numsale2007Q2 = mean(of numsale2007m04-numsale2007m06);
numsale2009Q1 = mean(of numsale2009m01-numsale2009m03);
numsale2007Q1 = mean(of numsale2007m01-numsale2007m03);

sumsale2007Q2 = sum(of numsale2007m04-numsale2007m06);
sumsale2009Q1 = sum(of numsale2009m01-numsale2009m03);
sumsale2007Q1 = sum(of numsale2007m01-numsale2007m03);


if sumsale2007Q1>=5 then medsale2007Q1 = sum(  
	(medsale2007m01* (numsale2007m01 /sumsale2007Q1) ), 
	(medsale2007m02* (numsale2007m02 /sumsale2007Q1) ) ,
	(medsale2007m03* (numsale2007m03 /sumsale2007Q1) )  
	) ; 

if sumsale2009Q1 >=5 then  medsale2009Q1 = sum(
			(medsale2009m01* (numsale2009m01/sumsale2009Q1)), 
			(medsale2009m02* (numsale2009m02/sumsale2009Q1)),
			(medsale2009m03* (numsale2009m03/sumsale2009Q1))
			); 
 
if sumsale2007Q1>=5 and sumsale2009Q1 >=5 then 
	pmedsale07Q1_09Q1 = (medsale2009Q1 - medsale2007Q1)/medsale2007Q1 * 100;

	label sumsale2007Q2 = 'Number of sales in 2007Q2'
			/*medsale2007q2 = 'Median sales price, 2007Q2'*/
			sumsale2009Q1 = 'Number of sales in 2009Q1'
			medsale2009q1 = 'Median sales price, 2009Q1'
			sumsale2007Q1 = 'Number of sales in 2007Q1'
			medsale2007q1 = 'Median sales price, 2007Q1'
			pmedsale07Q1_09Q1 = 'Pct change in median sales price, 2007Q1 to 2009Q1'
;
run;

proc freq data=hnc.mriszipanal;
tables in_cen;
run;

proc univariate data=hnc.mriszipanal;
where in_cen='yes';
var numhsgunits;
run;

proc univariate data=hnc.mriszipanal;
where in_cen ne 'yes';
var sumsale2009Q1;
run;

proc univariate data=hnc.mriszipanal;
where in_cen eq 'yes' and sumsale2009Q1 <5 ;
var numhsgunits  NumOwnerHsgUnits;
run;



***create mapping file;
data hnc.mrisziptomap ; 
set hnc.mriszipanal (keep= zip NumHsgUnits sumsale2007Q1 sumsale2009Q1 
					medsale2007Q1 medsale2009Q1 medsale2009m03 numsale2009m03 
					pmedsale07Q1_09Q1 inv2009Q1
				rename = (sumsale2007Q1 =num07Q1 sumsale2009Q1 =num09Q1
					medsale2007Q1 =med07Q1 medsale2009Q1=med09Q1 
					medsale2009m03 =med09m3 numsale2009m03 =num09m3
					pmedsale07Q1_09Q1 =c07Q109q1 
					inv2009Q1=inv09q1)); 
run ;

proc contents data=hnc.mrisziptomap;
run;

****;
proc format;
value mrischg
0='Bottom third price change (-70.5 to -33.5%, 2007Q2-2009Q1'
1 = 'Middle third of price change (-33.5 to -20.3%), 2007Q2-2009Q1'
2 = 'Top third of price change, (-20.3 to 113%) 2007Q2-2009Q1';
run;
proc format;
value mrisprice
0='Bottom third of price level (0-360K), 2007Q2'
1 = 'Middle third of price level (360-472K), 2007Q2'
2 = 'Top third of price level(472-1.2M, 2007Q2';
run;


proc rank data =hnc.mriszipanal out=mriszipanal2 
	(keep = zip ucounty pmedsale07Q1_09Q1  medsale2007Q1 medsale2009Q1
 		rmedsale07Q1_09Q1 rmedsale2007Q1) groups=3;
var pmedsale07Q1_09Q1  medsale2007Q1;
ranks rmedsale07Q1_09Q1 rmedsale2007Q1;
run;

proc freq data=mriszipanal2;
tables rmedsale07Q1_09Q1*rmedsale2007Q1/missing;
format rmedsale07Q1_09Q1 mrischg. rmedsale2007Q1 mrisprice.;
run;

proc freq data=mriszipanal2;
tables rmedsale07Q1_09Q1*rmedsale2007Q1;
format rmedsale07Q1_09Q1 mrischg. rmedsale2007Q1 mrisprice.;
run;

PROC EXPORT DATA=mriszipanal2
OUTFILE="d:\hnc2009\mris\mriszipanal2" dbms=dbf replace;
run;

***testing how many sales with 5 sale limit;

proc means data=mriszipanal2 sum;
var numsale2007Q1 sumsale2007Q1;
run;
proc means data=mriszipanal2 sum;
var numsale2007Q1 sumsale2007Q1;
where  rmedsale07Q1_09Q1 ne . and rmedsale2007Q1 ne .;
run; 

****explore****;

Proc univariate data=hnc.mriszipanal noprint;
 var   	pmedsale07Q1_09Q1  ; 
		output out = pct100  pctlpre=P_  pctlpts=0 to 100 by 1;
		run;

proc transpose data=pct100 out=pct100a (rename = (col1 = pmedsale07Q1_09Q1 ));
run;

Proc univariate data=hnc.mriszipanal noprint;
 var   	medsale2007Q1  ; 
		output out = pct100b  pctlpre=P_  pctlpts=0 to 100 by 1;
		run;

proc transpose data=pct100b out=pct100c (rename = (col1 = medsale2007Q1  ));
run;


Proc univariate data=hnc.mriszipanal noprint;
 var   	numsale2009Q1  ; 
		output out = num100  pctlpre=P_  pctlpts=0 to 100 by 1;
		run;

proc transpose data=num100 out=num100a (rename = (col1 = numsale2007Q1  ));
run;

proc sort data=pct100a;
by pmedsale07Q1_09Q1;
run;


proc sort data=pct100c;
by medsale2007Q1;
run;


filename zippct dde "Excel|K:\Metro\KPettit\HNC2009\tables\sales\[mriszip_pct.xls]chg!R2C2:R124C3" notab;

data _null_;
file zippct;
set pct100a;
put _name_ '09'x pmedsale07Q1_09Q1;
run;

filename zippct2 dde "Excel|K:\Metro\KPettit\HNC2009\tables\sales\[mriszip_pct.xls]med!R2C2:R124C3" notab;

data _null_;
file zippct2;
set pct100c;
put _name_ '09'x medsale2007Q1 ;
run;


filename zippct3 dde "Excel|K:\Metro\KPettit\HNC2009\tables\sales\[mriszip_pct.xls]num!R2C2:R124C3" notab;

data _null_;
file zippct3;
set num100a;
put _name_ '09'x numsale2007Q1 ;
run;

proc print data=hnc.mriszipanal (obs=20);
var medsale2007m01-medsale2007m03 medsale2007Q1;
run;

