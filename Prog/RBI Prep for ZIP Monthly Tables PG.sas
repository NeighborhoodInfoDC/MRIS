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
				01/31/12 RG: Updated with 2011_11
				01/01/12 RG: Updated with 2011_12				
				01/01/12 RG: Updated with 2011_12
				03/30/12 RG: Updated with 2012_01
				03/30/12 RG: Updated with 2012_02

************************************************************************/


%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


%dcdata_lib( MRIS )


%let to_month=02;
%let to_year=2012;
%let months=2; *how many months of the last year are present;
%let months0=02; *when zero is needed;


rsubmit;

proc download data=mris.rbi_zip_all_data out=mris.rbi_zip_all_data;

run;

endrsubmit;

%macro inflate;
data mris.rbi_zip_alldata_tables;
	set mris.rbi_zip_all_data;

%do y = 1999 %to 2011;
	%do m = 1 %to 12;
		%if &m<10 %then %let month = 0&m.;
		%else %let month = &m. ;

	*other indicators;
		pct_days_90plus&y._&month=pdays120p_&y._&month +pdays120_&y._&month;
		pct_cash&y._&month=cash_&y._&month/fin_total_&y._&month*100; 
		*code to inflate prices;
				%let chglist = medsale&y._&month avgsale&y._&month ;
			%let chglistR = medsaleR&y._&month. avgsaleR&y._&month. ;
			%do c = 1 %to 2;
				%let clist=%scan(&chglist.,&c.,' ');
				%let clistR=%scan(&chglistR.,&c.,' ');
			 %dollar_convert_month( &clist. , &clistR., &m., &y., &to_month., &to_year., quiet=Y, mprint=N, series=CUUR0000SA0L2 );
			
		%end;

	label medsaleR&y._&month. ="Adjusted Median Sold Price &y._&month (&to_month.-&to_year. $)"
		  avgsaleR&y._&month. ="Adjusted Average Sold Price &y._&month (&to_month.-&to_year. $)"
		
		  ;
%end; 
%end; 

%do y = 2012 %to 2012;
%do m = 1 %to &months.;
		%if &m<10 %then %let month = 0&m.;
		%else %let month = &m. ;
*other indicators;
		pct_days_90plus&y._&month=pdays120p_&y._&month +pdays120_&y._&month;
		pct_cash&y._&month=cash_&y._&month/fin_total_&y._&month*100; 

		*code to inflate prices;
			%let chglist = medsale&y._&month avgsale&y._&month ;
			%let chglistR = medsaleR&y._&month. avgsaleR&y._&month. ;
			%do c = 1 %to 2;
				%let clist=%scan(&chglist.,&c.,' ');
				%let clistR=%scan(&chglistR.,&c.,' ');
			 %dollar_convert_month( &clist. , &clistR., &m., &y., &to_month., &to_year., quiet=Y, mprint=N, series=CUUR0000SA0L2 );
			
		%end;

	label medsaleR&y._&month. ="Adjusted Median Sold Price &y._&month (&to_month.-&to_year. $)"
		  avgsaleR&y._&month. ="Adjusted Average Sold Price &y._&month (&to_month.-&to_year. $)"
		
		  ;
%end; 
%end; 
Run;
%mend;

%inflate;

data pg_tables;
	set mris.rbi_zip_alldata_tables (where=(ucounty="24033"));

run;
proc sort data=pg_tables;
by zip;
run;
%macro outmris(var);
filename outexc dde "Excel|&_dcdata_path\MRIS\Prog\[RBI_24033_ZIP_months.xls]&var.!R7c3:R60C200" ;
data _null_ ;
	file outexc lrecl=65000;
	set pg_tables ;
	put 	 zip &var.1999_01 - &var.1999_12
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
				&var.2012_01 - &var.2012_&months0.;

	run;
%mend;
%outmris(avgdays);
%outmris(medsale);
%outmris(inv);
%outmris(numsale);
%outmris(pend_tot);
%outmris(list_tot);
%outmris(newlist);
%outmris(avgsaleR);
%outmris(medsaleR);
%outmris(pct_days_90plus);
%outmris(pct_cash);



rsubmit;

proc download data=mris.rbi_cnty_all_data out=mris.rbi_cnty_all_data;

run;

endrsubmit;
%macro inflate_cnty;
data mris.rbi_cnty_alldata_tables;
	set mris.rbi_cnty_all_data;

%do y = 1999 %to 2011;
%do m = 1 %to 12;
		%if &m<10 %then %let month = 0&m.;
		%else %let month = &m. ;
			*other indicators;
		pct_days_90plus&y._&month=pdays120p_&y._&month +pdays120_&y._&month;
		pct_cash&y._&month=cash_&y._&month/fin_total_&y._&month*100; 

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
		  ;
%end; 
%end; 

%do y = 2012 %to 2012;
%do m = 1 %to &months.;
		%if &m<10 %then %let month = 0&m.;
		%else %let month = &m. ;
	*other indicators;
		pct_days_90plus&y._&month=pdays120p_&y._&month +pdays120_&y._&month;
		pct_cash&y._&month=cash_&y._&month/fin_total_&y._&month*100; 
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
filename outexc dde "Excel|&_dcdata_path\MRIS\Prog\[RBI_24033_ZIP_months.xls]&var.!R45C4:R45C200" ;
data _null_ ;
	file outexc lrecl=65000;
	set pg_tables_cnty ;
	put 	  &var.1999_01 - &var.1999_12
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
				&var.2012_01 - &var.2012_&months0.;

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
%outmris(avgsale);
%outmris(avgsaleR);
%outmris(medsaleR);
