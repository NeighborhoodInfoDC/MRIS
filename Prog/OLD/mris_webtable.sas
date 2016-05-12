** program name:mris_webtable.sas
** previous program name: none
** following program name:
** project name: HNC
** Description:  This program prepares the MRIS data for the metro area by subarea and county
to output to web tables**
** Date Created: 8-26-2007
** Updated:  3-9-09 adding 2007-2008
** ksp
***********************************************;


libname hnc 'd:\hnc2009\mris';
%let dir = k:\metro\maturner\hnc2009\tables\housing\;

%include 'k:\metro\kpettit\hnc2009\programs\hncformats.sas';

filename uiautos "K:\Metro\PTatian\UISUG\Uiautos";
options sasautos=(uiautos sasautos);


options mprint nocenter;
title;

                   
%macro mrisdrop;

%do i = 1999 %to 2008;
 %let oldyear = %eval(&i. - 1);
 %let year = &i.;
 
 data newyear&year.;
 set hnc.mris&year.
 (drop = pdays120p_&year. pdays30_&year.      
 pdays60_&year.      pdays90_&year.    
 avgsale&year. avgdays&year.  
 aggsale&oldyear. avgdays&oldyear.      
 avglist&oldyear. avgsale&oldyear. medsale&oldyear. numsale&oldyear.      
 saletolist&oldyear. totdays&oldyear.);
 run;

 proc sort data=newyear&year. ;
 by ucounty;
 run;
 
 data catyear&year. (drop = salescat);
 set hnc.mriscat30_500_&year. (where = (salescat = "Totals")
	keep = ucounty salescat sales_tot sales_sf sales_condor
	rename = (sales_tot = sales_tot&year. sales_sf=sales_sf&year. sales_condor=sales_condor&year.));
 run; 

 proc sort data=catyear&year. ;
 by ucounty;
 run;

%end;
 	%mend;

%mrisdrop;

data mris1999_2008;
merge catyear1999
	catyear2000 catyear2001
	catyear2002 catyear2003
	catyear2004 catyear2005
	catyear2006 catyear2007 catyear2008
	newyear1999
	newyear2000 newyear2001
	newyear2002 newyear2003
	newyear2004 newyear2005
	newyear2006 newyear2007 newyear2008
;
by ucounty;
run;

proc sort data=mris1999_2008;
		by uiorder;
run;


*summarize by divisions;
proc summary data= mris1999_2008;
	id ui_div;
	class uiorder;
	var _numeric_;
	output out = divfile (drop = _freq_  saletolist1999- saletolist2008
								medsale1999 - medsale2008) sum= ;
	run;
	

%macro mrisfinish;
*append together and recode where needed, n=51;
data hnc.mris1999_2008 (drop  =_type_);
	set divfile
		mris1999_2008;

	if _type_ = 0 then do;
			ui_div = 'Total Region';
			uiorder= 0;
	end;
	if _type_ = 1 and ui_div = "District of Columbia" then delete;
	if ucounty = '' then ucounty = '00000';
	cntyname = put (ucounty, $cntynm.);
	
 *have not read in earlier years, should do so;

%do k = 1996 %to 1998;
	%let yr = &k.;
numsale&yr. = .;
aggsale&yr. = .;
avgsale&yr. = .;
avgsale_adj&yr. = .;
medsale&yr. = .;
medsale_adj&yr. = .;
sales_tot&yr. = .;
sales_sf&yr. = .;
sales_condor&yr. = .;
psales_sf&yr. = .;
%end;

%do j = 1999 %to 2008;
 %let year = &j.;
 %let oldyear = %eval(&j.-1);

 pdays30_&year. = days30_&year./numsale&year.*100;
 pdays60_&year. = days60_&year./numsale&year.*100;
 pdays90_&year. = days90_&year./numsale&year.*100;
 pdays120_&year. = days120_&year./numsale&year.*100;
 pdays120p_&year. = days120p_&year./numsale&year.*100;
 avgdays&year. = totdays&year./numsale&year.;
 avgsale&year. = aggsale&year./numsale&year.;
 psales_sf&year. = sales_sf&year./sales_tot&year. * 100;

	*add in Peter real change macro;
	%Dollar_convert(  avgsale&year.,  avgsale_adj&year., &year., 2008 , quiet=Y );
	%Dollar_convert(  medsale&year.,  medsale_adj&year., &year., 2008 , quiet=Y );

%if &year. ne 1999 %then %do;
	pchnumsale_&year. = (numsale&year.- numsale&oldyear.)/numsale&oldyear.*100;
	pchavgsale_adj&oldyear._&year. = (avgsale_adj&year.- avgsale_adj&oldyear.)/avgsale_adj&oldyear.*100;
	pchmedsale_adj&oldyear._&year. = (medsale_adj&year.- medsale_adj&oldyear.)/medsale_adj&oldyear.*100;

	*example: %Dollar_convert( wages1, wages2, 1995, 2005 );
%end;

%end;

pchavgsale_adj1996_1997 = .;
pchavgsale_adj1997_1998 = .;
pchavgsale_adj1998_1999 = .;

pchmedsale_adj1996_1997 = .;
pchmedsale_adj1997_1998 = .;
pchmedsale_adj1998_1999 = .;

	run;

%mend;
%mrisfinish;

proc sort data=hnc.mris1999_2008;
	by uiorder ucounty;
	run;
	
*extracted web tables from 2007 into a separate workbook for now;
filename outexc dde "Excel|&dir.\[mris1999_2008.xls]e3!R7c3:R38C60" ;
data _null_ ;
	file outexc lrecl=65000;
	set hnc.mris1999_2008; ;
	put ucounty numsale1996 - numsale2008 sales_sf1996 - sales_sf2008 sales_condor1996 - sales_condor2008
	 psales_sf1996 - psales_sf2008;
	if _n_ in (1,2,5,11,20,30) then put;  
	run;


filename outexc dde "Excel|&dir.\[mris1999_2008.xls]e4!R7c3:R38C160" ; 

data _null_ ;
	file outexc lrecl=65000;
	set hnc.mris1999_2008; ;
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

	

filename outexc dde "Excel|&dir.\[mris1999_2008.xls]e6!R8c3:R39C180" ; 

data _null_ ;
	file outexc lrecl=65000;
	set hnc.mris1999_2008; ;
	put ucounty avgdays1999-avgdays2008
	pdays30_1999-pdays30_2008 	pdays60_1999-pdays60_2008 
	pdays90_1999-pdays90_2008 	pdays120_1999-pdays120_2008 
	pdays120p_1999-pdays120p_2008 	;
	if _n_ in (1,2,5,11,20,30) then put;  
	run;

*created in  mris cat sum.sas;
filename extot dde "Excel|&dir.\[mris1999_2008.xls]e5!R7C2:R27C12";
filename exsf dde "Excel|&dir.\[mris1999_2008.xls]e5!R7C13:R27C22";
filename excondor dde "Excel|&dir.\[mris1999_2008.xls]e5!R7C23:R27C33";
	
%macro outexc(type);

proc sort data=hnc.mriscat30_500_1999_2008;
by salesorder;
run;

data _null_;
file ex&type. lrecl  =20000;
set hnc.mriscat30_500_1999_2008;
put %if &type. = tot %then %do;
	salesorder 
%end;
	sales_&type.1999- sales_&type.2008 ;
if _n_ in (1,10) then put;  
run;
%mend;

%outexc(tot);
%outexc(sf);
%outexc(condor);
