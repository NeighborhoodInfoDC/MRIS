/************************************************************************
 Program:  RBI Prep for Monthly Tables.sas
 Library:  MRIS
 Project:  DC Data Warehouse
 Author:   L. Hendey
 Created:  9/08/2011
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Read data received from RBI (based on 7/11 files). First file will be 2011_07.
			   http://www.rbintel.com/statistics
	       Revisions1 is for the month file and revisions2 is for the file with all years & months.

 Modifications: 09/02/11 LH: Updated with 2011_07. 
				12/02/11 RAG: Updated with 2011_09. 
				12/02/11 RAG: Updated with 2011_10. 
				01/31/12 RAG: Updated with 2011_11. 
				01/31/12 RAG: Updated with 2011_12. 
				03/21/12 RAG: Updated with 2012_01. 
				03/30/12 RAG: Updated with 2012_02. 
				05/08/12 RAG: Updated with complete 2012_02 data. 
				05/08/12 RAG: Updated with 2012_03. 
				05/16/12 RAG: Updated with 2012_04. 
				05/22/12 RAG: Updated with new financing percent variables.  Rerun with 2012_04. 
				08/03/12 RAG: Updated with 2012_05 
				08/03/12 RAG: Updated with 2012_06
				08/21/12 RAG: Updated with 2012_07
				03/08/13 RAG: Updated with 2012_08
				03/08/13 RAG: Updated with 2012_09
				03/08/13 RAG: Updated with 2012_10
				03/13/13 RAG: Updated with 2012_11
				03/14/13 RAG: Updated with 2012_12
				03/14/13 RAG: Updated with 2013_01
				08/07/13 RAG: Updated with 2013_02
				08/07/13 RAG: Updated with 2013_03
				08/07/13 RAG: Updated with 2013_04
				08/07/13 RAG: Updated with 2013_05
				08/07/13 RAG: Updated with 2013_06
				10/10/13 RAG: Updated with 2013_07
				03/04/14 SXZ: Updated with 2013_08
				03/04/14 SXZ: Updated with 2013_09
				03/04/14 SXZ: Updated with 2013_10
				03/04/14 SXZ: Updated with 2013_11
				03/04/14 SXZ: Updated with 2013_12
				03/04/14 SXZ: Updated with 2014_01

************************************************************************/


%include "L:\SAS\Inc\Stdlocal.sas";
/*%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;*/


%dcdata_lib( MRIS )


%let to_month=01;
%let to_year=2014;
%let months=1; *how many months of the last year are present;
%let months0=01; *when zero is needed;


/*rsubmit;*/
/*
proc download data=mris.rbi_cnty_all_data out=mris.rbi_cnty_all_data;

run;

endrsubmit;
*/
%macro inflate_cnty;
data mris.rbi_cnty_alldata_tables;
	set mris.rbi_cnty_all_data;

%do y = 1999 %to 2013;
%do m = 1 %to 12;
		%if &m<10 %then %let month = 0&m.;
		%else %let month = &m. ;
			*other indicators;
		pct_days_90plus&y._&month=pdays120p_&y._&month +pdays120_&y._&month;
		pct_cash&y._&month=cash_&y._&month/fin_total_&y._&month*100; 
		pct_fha_va&y._&month=(fha_&y._&month + va_&y._&month)/fin_total_&y._&month*100; 
		pct_conv&y._&month=conventional_&y._&month/fin_total_&y._&month*100; 
		pct_all_other&y._&month=(other_&y._&month + owner_finance_&y._&month + Assumption_&y._&month)/fin_total_&y._&month*100; 

		*code to inflate prices;
		%if ucounty ~= '00000' %then %do;
			%let chglist = medsale&y._&month avgsale&y._&month wgtsale&y._&month;
			%let chglistR = medsaleR&y._&month. avgsaleR&y._&month. wgtsaleR&y._&month.;
			%do c = 1 %to 3;
				%let clist=%scan(&chglist.,&c.,' ');
				%let clistR=%scan(&chglistR.,&c.,' ');
			 %dollar_convert_month( &clist. , &clistR., &m., &y., &to_month., &to_year., quiet=Y, mprint=N, series=CUUR0000SA0L2 );
			%end;
		%end;

		%if uiorder=0 %then %do;
			%let chglist = avgsale&y._&month wgtsale&y._&month;
			%let chglistR = avgsaleR&y._&month. wgtsaleR&y._&month.;
			%do c = 1 %to 2;
				%let clist=%scan(&chglist.,&c.,' ');
				%let clistR=%scan(&chglistR.,&c.,' ');
			 %dollar_convert_month( &clist. , &clistR., &m., &y., &to_month., &to_year., quiet=Y, mprint=N, series=CUUR0000SA0L2 );
			%end;
		%end;

	label medsaleR&y._&month. ="Adjusted Median Sold Price &y._&month (&to_month.-&to_year. $)"
		  avgsaleR&y._&month. ="Adjusted Average Sold Price &y._&month (&to_month.-&to_year. $)"
		  wgtsaleR&y._&month. ="Adjusted Median Sold Price - Summary Geog. Calc. &y._&month (&to_month.-&to_year. $)"
		  pct_days_90plus&y._&month. = "Percent of Sales on Market for More than 90 Days &y._&month (&to_month.-&to_year. $)"
		  pct_cash&y._&month. = "Percent of Sales that were Cash Sales &y._&month (&to_month.-&to_year. $)" 
		  pct_fha_va&y._&month. = "Percent of Sales with Conventional Financing &y._&month (&to_month.-&to_year. $)" 
		  pct_conv&y._&month. = "Percent of Sales with FHA or VA Financing &y._&month (&to_month.-&to_year. $)" 
		  pct_all_other&y._&month. = "Percent of Sales with Assumption, Other, or Owner Financing &y._&month (&to_month.-&to_year. $)" 
		  ;
%end; 
%end; 


%do y = &to_year. %to &to_year.;
%do m = 1 %to &months.;
		%if &m<10 %then %let month = 0&m.;
		%else %let month = &m. ;
	*other indicators;
		pct_days_90plus&y._&month=pdays120p_&y._&month +pdays120_&y._&month;
		pct_cash&y._&month=cash_&y._&month/fin_total_&y._&month*100; 
		pct_fha_va&y._&month=(fha_&y._&month + va_&y._&month)/fin_total_&y._&month*100; 
		pct_conv&y._&month=conventional_&y._&month/fin_total_&y._&month*100; 
		pct_all_other&y._&month=(other_&y._&month + owner_finance_&y._&month + Assumption_&y._&month)/fin_total_&y._&month*100; 

		*code to inflate prices;
		%if ucounty ~= '00000' %then %do;
			%let chglist = medsale&y._&month avgsale&y._&month wgtsale&y._&month;
			%let chglistR = medsaleR&y._&month. avgsaleR&y._&month. wgtsaleR&y._&month.;
			%do c = 1 %to 3;
				%let clist=%scan(&chglist.,&c.,' ');
				%let clistR=%scan(&chglistR.,&c.,' ');
			 %dollar_convert_month( &clist. , &clistR., &m., &y., &to_month., &to_year., quiet=Y, mprint=N, series=CUUR0000SA0L2 );
			%end;
		%end;

		%if uiorder=0 %then %do;
			%let chglist = avgsale&y._&month wgtsale&y._&month;
			%let chglistR = avgsaleR&y._&month. wgtsaleR&y._&month.;
			%do c = 1 %to 2;
				%let clist=%scan(&chglist.,&c.,' ');
				%let clistR=%scan(&chglistR.,&c.,' ');
			 %dollar_convert_month( &clist. , &clistR., &m., &y., &to_month., &to_year., quiet=Y, mprint=N, series=CUUR0000SA0L2 );
			%end;
		%end;

	label medsaleR&y._&month. ="Adjusted Median Sold Price &y._&month (&to_month.-&to_year. $)"
		  avgsaleR&y._&month. ="Adjusted Average Sold Price &y._&month(&to_month.-&to_year. $)"
		  wgtsaleR&y._&month. ="Adjusted Median Sold Price - Summary Geog. Calc. &y._&month (&to_month.-&to_year. $)"
		  pct_days_90plus&y._&month. = "Percent of Sales on Market for More than 90 Days &y._&month (&to_month.-&to_year. $)"
		  pct_cash&y._&month. = "Percent of Sales that were Cash Sales &y._&month (&to_month.-&to_year. $)" 
		  pct_fha_va&y._&month. = "Percent of Sales with Conventional Financing &y._&month (&to_month.-&to_year. $)" 
		  pct_conv&y._&month. = "Percent of Sales with FHA or VA Financing &y._&month (&to_month.-&to_year. $)" 
		  pct_all_other&y._&month. = "Percent of Sales with Assumption, Other, or Owner Financing &y._&month (&to_month.-&to_year. $)" 
		  ;
%end; 
%end; 

Run;
%mend;

%inflate_cnty;

data pg_tables_cnty;
	set mris.rbi_cnty_alldata_tables (where=(ucounty="24033"));

run;

%macro outmris(var);
filename outexc dde "Excel|&_dcdata_path\MRIS\Data\[RBI_county_month.xls]&var.!R7c4:R38C300" ;
data _null_ ;
	file outexc lrecl=65000;
	set mris.rbi_cnty_alldata_tables;
	put 	 &var.1999_01 - &var.1999_12
				 &var.2000_01 - &var.2000_12
				&var.2001_01 - &var.2001_12
				&var.2002_01 - &var.2002_12
				 &var.2003_01 - &var.2003_12
				&var.2004_01 - &var.2004_12
				&var.2005_01 - &var.2005_12
				 &var.2006_01 - &var.2006_12
				&var.2007_01 - &var.2007_12
				&var.2008_01 - &var.2008_12
				&var.2009_01 - &var.2009_12
				&var.2010_01 - &var.2010_12
				&var.2011_01 - &var.2011_12
				&var.2012_01 - &var.2012_12
				&var.2013_01 - &var.2013_12
				&var.2014_01 /*- &var.2014_&to_month.*/;
	if _n_ in (1,2,5,11,20,30) then put;  
	run;
%mend;
%outmris(avgdays);
%outmris(medsale);
%outmris(inv);
%outmris(numsale);
%outmris(pend_tot);
%outmris(list_tot);
%outmris(newlist);
%outmris(pct_days_90plus);
%outmris(pct_cash);
%outmris(pct_conv);
%outmris(pct_fha_va);
%outmris(avgsale);
%outmris(avgsaleR);
%outmris(medsaleR);
%outmris(wgtsaleR);

