/**************************************************************************
 Program:  MRIS_Month_webtable.sas
 Library:  MRIS
 Project:  NeighborhoodInfo DC
 Author:   K. Pettit
 Created:  04/25/09
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  This program prepares the MONTHLY MRIS data for the metro area by 
 subarea and county to output to web tables

 Modifications: 1-22-2010
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

%dcdata_lib( MRIS )

/*
*kpettit libnames;
libname hnc 'd:\hnc2009\mris';
%let dir = k:\metro\lhendey\fannie mae 2010\data\mris;

%include 'k:\metro\kpettit\hnc2009\programs\hncformats.sas';
%include 'K:\Metro\KPettit\HNC2009\programs\mris\Dollar_convert_month.sas'; *for some reason this isn't working. ;

*/

options nocenter;
title;

*dropping "oldyear" vars so as not to overwrite earlier years;                   
%macro dropcalc;

proc sort data=mris.mriscnty&year.m&month.;
by uiorder;

proc summary data=mris.mriscnty&year.m&month.;
id ui_div;
class uiorder;
var numsale&year.m&month;
output out = sum&year.m&month (drop= _freq_) sum=divnum&year.m&month;
run;

data newyear&year.m&month (drop=_type_);
 	merge mris.mriscnty&year.m&month. (drop = pdays120p_&year.m&month. pdays30_&year.m&month. pdays60_&year.m&month. 
											 pdays90_&year.m&month. avgsale&year.m&month. avgdays&year.m&month.  
 											 aggsale&oldyear.m&month. avgdays&oldyear.m&month. avglist&oldyear.m&month. 
											 avgsale&oldyear.m&month. medsale&oldyear.m&month. numsale&oldyear.m&month.      
 											 saletolist&oldyear.m&month. totdays&oldyear.m&month.)
		  sum&year.m&month (where=(_type_ ne 0));
	by uiorder;

if _n_=1 then set sum&year.m&month (where = (_type_ = 0) 
keep= divnum&year.m&month _type_ rename = (divnum&year.m&month=regnum&year.m&month) );

 rwgtnum&year.m&month = numsale&year.m&month/regnum&year.m&month ; 
 rwgtsale&year.m&month = rwgtnum&year.m&month*medsale&year.m&month ;
 wgtnum&year.m&month = numsale&year.m&month/divnum&year.m&month ; 
 wgtsale&year.m&month = wgtnum&year.m&month*medsale&year.m&month ;
 run;

 proc sort data=newyear&year.m&month ;
 by ucounty;
 run;
 
 ***sales by category***;
 
 data catyear&year.m&month (drop = pricecat);
 set mris.mriscat30_500_cnty&year.m&month (where = (pricecat = "Totals")
	keep = ucounty pricecat sales_tot sales_sf sales_condor list_tot list_sf list_condor
	rename = (sales_tot = sales_tot&year.m&month. sales_sf=sales_sf&year.m&month. sales_condor=sales_condor&year.m&month.
	list_tot = list_tot&year.m&month. list_sf=list_sf&year.m&month. list_condor=list_condor&year.m&month.));
 run; 

 proc sort data=catyear&year.m&month. ;
 by ucounty;
 run;
 %mend;

%macro mrisdrop;

%do i = 1997 %to 2008;
 %let oldyear = %eval(&i. - 1);
 %let year = &i.;
 /*cycle through months*/
   %do j = 1 %to 12;
 	%if &j<10 %then %let month = 0&j.;
 	%else %let month = &j. ;

 %dropcalc;

%end;
%end;

 %let oldyear = 2008;
 %let year = 2009;
 /*cycle through months*/
   %do j = 1 %to 12;
 	%if &j<10 %then %let month = 0&j.;
 	%else %let month = &j. ;

 %dropcalc;
%end;

 %mend;

%mrisdrop;

%macro mergemris;
data mris199701_200912;
*keeping 1997 and 1998, even though many counties are missing, 
and 1999 jan and feb even though clarke and warren are missing;
merge 

%do i=	1997 %to 2008;
	%do j = 1 %to 12;
		%if &j<10 %then %let month = 0&j.;
		%else %let month = &j. ;
		catyear&i.m&month.
		newyear&i.m&month.
	%end;
%end;

%do j = 1 %to 12;
 	%if &j<10 %then %let month = 0&j.;
 	%else %let month = &j. ;
	catyear2009m&month.
	newyear2009m&month.
%end;
;

by ucounty;
*not sure how DC settings get overwritten, but hard coding fix here;
if ucounty='11001' then do;
	ui_div = 'District of Columbia';
	uiorder=1;
end;
run;

%mend;
%mergemris;


proc sort data=mris199701_200912;
by uiorder;
run;


*summarize by divisions;
proc summary data= mris199701_200912;
	id ui_div;
	class uiorder;
	var _numeric_;
	output out = divfile (drop = _freq_  
		saletolist1997m01- saletolist1997m12 medsale1997m01 - medsale1997m12
		saletolist1998m01- saletolist1998m12 medsale1998m01 - medsale1998m12
		saletolist1999m01- saletolist1999m12 medsale1999m01 - medsale1999m12
		saletolist2000m01- saletolist2000m12 medsale2000m01 - medsale2000m12
		saletolist2001m01- saletolist2001m12 medsale2001m01 - medsale2001m12
		saletolist2002m01- saletolist2002m12 medsale2002m01 - medsale2002m12
		saletolist2003m01- saletolist2003m12 medsale2003m01 - medsale2003m12
		saletolist2004m01- saletolist2004m12 medsale2004m01 - medsale2004m12
		saletolist2005m01- saletolist2005m12 medsale2005m01 - medsale2005m12
		saletolist2006m01- saletolist2006m12 medsale2006m01 - medsale2006m12
		saletolist2007m01- saletolist2007m12 medsale2007m01 - medsale2007m12
		saletolist2008m01- saletolist2008m12 medsale2008m01 - medsale2008m12
		saletolist2009m01- saletolist2009m12 medsale2009m01 - medsale2009m12) sum= ;
	run;

%macro fincalc;
 pdays30_&year.m&month. = days30_&year.m&month./numsale&year.m&month.*100;
 pdays60_&year.m&month. = days60_&year.m&month./numsale&year.m&month.*100;
 pdays90_&year.m&month. = days90_&year.m&month./numsale&year.m&month.*100;
 pdays120_&year.m&month. = days120_&year.m&month./numsale&year.m&month.*100;
 pdays120p_&year.m&month. = days120p_&year.m&month./numsale&year.m&month.*100;
 avgdays&year.m&month. = totdays&year.m&month./numsale&year.m&month.;
 avgsale&year.m&month. = aggsale&year.m&month./numsale&year.m&month.;
 psales_sf&year.m&month. = sales_sf&year.m&month./sales_tot&year.m&month. * 100;
 inv&year.m&month. = list_tot&year.m&month./sales_tot&year.m&month.;
 if ucounty ne '00000' then wgtsale&year.m&month.=medsale&year.m&month.;
 if uiorder=0 then  wgtsale&year.m&month.=  rwgtsale&year.m&month.;

*insert percent change calc here - check report for time period used;
%if ucounty ~= '00000' %then %do;
	%let chglist = medsale&year.m&month avgsale&year.m&month wgtsale&year.m&month;
	%let chglistR = medsaleR&year.m&month. avgsaleR&year.m&month. wgtsaleR&year.m&month.;
	%do c = 1 %to 3;
		%let clist=%scan(&chglist.,&c.,' ');
		%let clistR=%scan(&chglistR.,&c.,' ');
	 %dollar_convert_month( &clist. , &clistR., &mwd&year., _Dec2009, quiet=Y, mprint=N, series=CUUR0000SA0L2 );
	%end;
%end;

%if uiorder=0 %then %do;
	%let chglist = avgsale&year.m&month wgtsale&year.m&month;
	%let chglistR = avgsale&yearR.m&month. wgtsaleR&year.m&month.;
	%do c = 1 %to 2;
		%let clist=%scan(&chglist.,&c.,' ');
		%let clistR=%scan(&chglistR.,&c.,' ');
	 %dollar_convert_month( &clist. , &clistR., &mwd&year., _Dec2009, quiet=Y, mprint=N, series=CUUR0000SA0L2 );
	%end;
%end;
%mend;

%macro mrisfinish;
*append together and recode where needed, n=51;
data mris.mris199701_200912(drop  =_type_);
	set divfile
		mris199701_200912;

	if _type_ = 0 then do;
			ui_div = 'Total Region';
			uiorder= 0;
	end;
	if _type_ = 1 and ui_div = "District of Columbia" then delete;
	if ucounty = '' then ucounty = '00000';
	cntyname = put (ucounty, $cntynm.);
	
%**have not read in earlier years, should do so;

%do j = 1997 %to 2009;
 %let year = &j.;
 %let oldyear = %eval(&j.-1);
	 %let moword = _Jan _Feb _Mar _Apr _May _Jun _Jul _Aug _Sep _Oct _Nov _Dec;
 /*cycle through months*/
	 %do m = 1 %to 12;
	 	%if &m<10 %then %let month = 0&m.;
	 	%else %let month = &m. ;

	 %let mwd=%scan(&moword.,&m.,' ');
	 
	%fincalc;
	%end;
%end;

/*
*copied programming b/c conditional proramming was not working to end at March for 2009;
 %let year = 2009;
 %let oldyear = 2008;
 %let moword = _Jan _Feb _Mar _Apr _May _Jun _Jul _Aug _Sep _Oct _Nov _Dec;

 /*cycle through months
	 %do m = 1 %to 12;
	 	%if &m<10 %then %let month = 0&m.;
	 	%else %let month = &m. ;
	 %let mwd=%scan(&moword.,&m.,' ');
	%fincalc;
	%end;*/

run;

%mend;
%mrisfinish;
proc contents data=mris.mris199701_200912;
run;
proc sort data=mris.mris199701_200912;
	by uiorder ucounty;
	run;

%macro outmris(var);
filename outexc dde "Excel|&dir.\[mris_county_month.xls]&var.!R7c3:R38C160" ;
data _null_ ;
	file outexc lrecl=65000;
	set mris.mris199701_200912; ;
	put ucounty    &var.1997m01 - &var.1997m12  &var.1998m01 - &var.1998m12
				 &var.1999m01 - &var.1999m12
				 &var.2000m01 - &var.2000m12
				&var.2001m01 - &var.2001m12
				&var.2002m01 - &var.2002m12
				 &var.2003m01 - &var.2003m12
				&var.2004m01 - &var.2004m12
				&var.2005m01 - &var.2005m12
				 &var.2006m01 - &var.2006m12
				&var.2007m01 - &var.2007m12
				&var.2008m01 - &var.2008m12
				&var.2009m01 - &var.2009m12;
	if _n_ in (1,2,5,11,20,30) then put;  
	run;
%mend;
%outmris(numsale);
%outmris(inv);
%outmris(medsale);
%outmris(wgtsale);
%outmris(list_tot);
%outmris(list_sf);
%outmris(list_condor);
%outmris(avgsale);
%outmris(newlist);
%outmris(sales_sf);
%outmris(sales_condor);
%outmris(saletolist);
%outmris(avgdays);



/**SKIP FOR NOW - NOT UPDATED
filename outexc dde "Excel|&dir.\[mris_County_monthly.xls]e4!R7c3:R38C160" ; 

data _null_ ;
	file outexc lrecl=65000;
	set mris.mris199701_200903; ;
	put ucounty 
	medsale1996 - medsale2008 
	medsale_adj1996-medsale_adj2008 
	pchmedsale_adj1996_1997 pchmedsale_adj1997_1998 pchmedsale_adj1998_1999 
	pchmedsale_adj1999_2000 pchmedsale_adj2000_2001 pchmedsale_adj2001_2002 pchmedsale_adj2002_2003
	pchmedsale_adj2003_2004	pchmedsale_adj2004_2005 pchmedsale_adj2005_2006 
	pchmedsale_adj2006_2007 pchmedsale_adj2007_2008

	avgsale1996-avgsale2008 
	avgsale_adj1996-avgsale_adj2008
	pchavgsale_adj1996_1997 pchavgsale_adj1997_1998 pchavgsale_adj1998_1999 
	pchavgsale_adj1999_2000 pchavgsale_adj2000_2001 pchavgsale_adj2001_2002 pchavgsale_adj2002_2003
	pchavgsale_adj2003_2004	pchavgsale_adj2004_2005 pchavgsale_adj2005_2006 
	pchavgsale_adj2006_2007 pchavgsale_adj2007_2008;
	if _n_ in (1,2,5,11,20,30) then put;  
	run;

	

filename outexc dde "Excel|&dir.\[mris_County_monthly.xls]e6!R8c3:R39C180" ; 

data _null_ ;
	file outexc lrecl=65000;
	set mris.mris199701_200903; ;
	put ucounty avgdays1999-avgdays2008
	pdays30_1999-pdays30_2008 	pdays60_1999-pdays60_2008 
	pdays90_1999-pdays90_2008 	pdays120_1999-pdays120_2008 
	pdays120p_1999-pdays120p_2008 	;
	if _n_ in (1,2,5,11,20,30) then put;  
	run;


filename extot dde "Excel|&dir.\[mris_County_monthly.xls]e5!R7C2:R27C12";
filename exsf dde "Excel|&dir.\[mris_County_monthly.xls]e5!R7C13:R27C22";
filename excondor dde "Excel|&dir.\[mris_County_monthly.xls]e5!R7C23:R27C33";
	
%macro outexc(type);

proc sort data=mris.mriscat30_500_1999_2008;
by salesorder;
run;

data _null_;
file ex&type. lrecl  =20000;
set mris.mriscat30_500_1999_2008;
put %if &type. = tot %then %do;
	salesorder 
%end;
	sales_&type.1999- sales_&type.2008 ;
if _n_ in (1,10) then put;  
run;
%mend;

*%outexc(tot);
*%outexc(sf);
*%outexc(condor);

***/
