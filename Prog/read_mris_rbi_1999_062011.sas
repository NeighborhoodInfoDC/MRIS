/************************************************************************
 Program:  Read_mris_rbi_1999_062011.sas
 Library:  MRIS
 Project:  DC Data Warehouse
 Author:   L. Hendey
 Created:  7/12/2011
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Read data received from RBI (based on 7/11 files). 
			   http://www.rbintel.com/statistics

 Modifications: 09/02/11 LH: Modified to fit DCDATA protocols. Upload to alpha at end & register metadata;

************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


%dcdata_lib( MRIS )

**** User parameters ****;

%let raw_path = D:\DCDATA\Libraries\MRIS\Raw\;


%let cntycodes  = 11001 51510 51013 24031 24033 51059 51600 51610 24009 24017 24021
				51107 51153 51179 51683 51685 51043 51061 51177 51187 51630 54037 ;

filename inf "&raw_path.Urban Institute - County Aggregate 2011_07_07.csv" lrecl=1000 ;

  data county_agg;
  	
	length year $4. month $2. yr_mo $7. ;

    infile inf dsd stopover firstobs=2;
	input countyname:$30. ucounty:$5. date: $6. aggsale:comma12. avgsale:comma12. medsale:comma12. numsale:comma12. avgdays:comma12. 
		 list_tot:comma12. newlist:comma12. newcontract:comma12. newconting:comma12. newpend:comma12. pend_tot:comma12.;
	
	year=substr(date,1,4);
	month=substr(date,5,2);

	yr_mo=year||"_"||month;

	  if missing( countyname ) then stop;
run;
filename inf clear;
filename inf "&raw_path.\Urban Institute - County DOM.csv" lrecl=1000 ;

  data county_dom;
  	
	length year $4. month $2. yr_mo $7. ;

    infile inf dsd stopover firstobs=2;
	input countyname:$30. ucounty:$5. date: $6. desc:$15. sold:comma12.;
	
	year=substr(date,1,4);
	month=substr(date,5,2);

	yr_mo=year||"_"||month;

	  if missing( countyname ) then stop;
run;
filename inf clear;
filename inf "&raw_path.\Urban Institute - County Financing.csv" lrecl=1000 ;

  data county_fin;
  	
	length year $4. month $2. yr_mo $7. ;

    infile inf dsd stopover firstobs=2;
	input countyname:$30. ucounty:$5. date: $6. desc:$15. sold:comma12.;
	
	year=substr(date,1,4);
	month=substr(date,5,2);

	yr_mo=year||"_"||month;

	  if missing( countyname ) then stop;
run;
filename inf clear;
proc sort data=county_agg;
by ucounty;

%let varlist=aggsale avgsale medsale numsale avgdays list_tot
		  newlist newcontract newconting newpend pend_tot;

%macro transpose;
	%do i=1 %to 11;
%let var=%scan(&varlist.,&i.," ");
	proc transpose data=county_agg out=wide_&var. prefix=&var.;
	by ucounty;
	id yr_mo;
	var &var.;
	run;

	proc sort data=wide_&var.;
	by ucounty;
%end;
%mend;
%transpose;
proc sort data=county_dom;
by ucounty  yr_mo;

proc transpose data=county_dom out=wide_dom prefix=desc;
by ucounty yr_mo;
id  desc;
var sold;
run;

data wide_dom2;
	set wide_dom (rename=(desc31_to_60_days=days60 desc61_to_90_days=days90 desc91_to_120_days=days120));

days30= sum(desc0_days, desc1_to_10_days, desc11_to_20_days, desc21_to_30_days);
days120p= sum(desc121_to_180_days, desc181_to_360_days, desc361_to_720_days, desc721__days);

days_total=sum( days120p , days120 , days90 , days60 , days30 );

run;
proc sort data=county_fin;
by ucounty yr_mo;
proc transpose data=county_fin out=wide_fin ;
by ucounty yr_mo;
id  desc;
var sold;
run;

proc sort data=wide_dom2;
by ucounty;
proc sort data=wide_fin;
by ucounty;
data wide_DF (drop=_name_);
merge wide_dom2 wide_fin;
by ucounty;

fin_total= sum(Assumption, Cash, Conventional, FHA, VA, Owner_Finance, Other);

run;

%let varlist=days30 days60 days90 days120 days120p days_total Assumption Cash Conventional FHA VA Owner_Finance Other fin_total; 
%macro transpose2;
	%do i=1 %to 14;
%let var=%scan(&varlist.,&i.," ");
proc transpose data=wide_DF  out=wide_&var. prefix=&var._;
by ucounty;
id yr_mo;
var &var.;
run;
%end;
%mend;
%transpose2;

proc sort data=mris.geograph out=geograph;
by ucounty;
data mris_all_years (drop=_name_);
merge geograph wide_aggsale wide_avgdays wide_avgsale wide_list_tot wide_medsale wide_newconting wide_newcontract wide_newlist
	 wide_newpend wide_numsale wide_pend_tot wide_days30 wide_days60 wide_days90 wide_days120 wide_days120p wide_days_total
	 wide_assumption wide_cash wide_conventional wide_fha wide_fin_total wide_other wide_owner_finance wide_va;
by ucounty;

if ucounty=" " then delete;
run;

proc summary data=mris_all_years;
id ui_div;
class uiorder;
var numsale: ;
output out = sum_sales (drop= _freq_) sum=divsale_1999_01-divsale_1999_12 
										  divsale_2000_01-divsale_2000_12 
										  divsale_2001_01-divsale_2001_12 
										  divsale_2002_01-divsale_2002_12
										  divsale_2003_01-divsale_2003_12
										  divsale_2004_01-divsale_2004_12
										  divsale_2005_01-divsale_2005_12 
										  divsale_2006_01-divsale_2006_12
										  divsale_2007_01-divsale_2007_12
										  divsale_2008_01-divsale_2008_12
										  divsale_2009_01-divsale_2009_12
										  divsale_2010_01-divsale_2010_12 
										  divsale_2011_01-divsale_2011_06;

run;
proc sort data=mris_all_years;
by uiorder;
%macro calc_region;
data mris_all_years_new (drop=_type_);
 	merge mris_all_years
		  sum_sales (where=(_type_ ne 0));
	by uiorder;


if _n_=1 then set sum_sales (where = (_type_ = 0) keep= divsale:  _type_  rename=(

%do i = 1999 %to 2010;
%do j = 1 %to 12;
		%if &j<10 %then %let month = 0&j.;
		%else %let month = &j. ;

  divsale_&i._&month=regnum&i._&month
%end; %end; 

%do i = 2011 %to 2011;
%do j = 1 %to 6;
		%if &j<10 %then %let month = 0&j.;
		%else %let month = &j. ;

  divsale_&i._&month=regnum&i._&month
%end; %end; ));

%do i = 1999 %to 2010;
%do j = 1 %to 12;
		%if &j<10 %then %let month = 0&j.;
		%else %let month = &j. ;

 rwgtnum&i._&month = numsale&i._&month/regnum&i._&month ; *number of sales divided by total region sales;
 rwgtsale&i._&month = rwgtnum&i._&month*medsale&i._&month ; *share of sales in region * median sale price;
 wgtnum&i._&month = numsale&i._&month/divsale_&i._&month ; *number of sales divided by total sales in division;
 wgtsale&i._&month = wgtnum&i._&month*medsale&i._&month ; *share of sale		s in division * median sale price;

 totdays&i._&month =avgdays&i._&month*numsale&i._&month;

 %end; 
%end;

%do i = 2011 %to 2011;
%do j = 1 %to 6;
		%if &j<10 %then %let month = 0&j.;
		%else %let month = &j. ;
 rwgtnum&i._&month = numsale&i._&month/regnum&i._&month ; *number of sales divided by total region sales;
 rwgtsale&i._&month = rwgtnum&i._&month*medsale&i._&month ; *share of sales in region * median sale price;
 wgtnum&i._&month = numsale&i._&month/divsale_&i._&month ; *number of sales divided by total sales in division;
 wgtsale&i._&month = wgtnum&i._&month*medsale&i._&month ; *share of sales in division * median sale price;

 totdays&i._&month =avgdays&i._&month*numsale&i._&month;

 %end; 
%end;
 run;

 proc sort data=mris_all_years_new ;
 by uiorder;
 run;
 %mend;
 %calc_region;
	proc summary data=   mris_all_years_new;
	id ui_div;
	class uiorder;
	var _numeric_;
	output out = divfile (drop = _freq_  
		 medsale1999_01 - medsale1999_12
	 medsale2000_01 - medsale2000_12
		 medsale2001_01 - medsale2001_12
		 medsale2002_01 - medsale2002_12
		 medsale2003_01 - medsale2003_12
	 medsale2004_01 - medsale2004_12
		 medsale2005_01 - medsale2005_12
	 medsale2006_01 - medsale2006_12
	medsale2007_01 - medsale2007_12
	 medsale2008_01 - medsale2008_12
	 medsale2009_01 - medsale2009_12
		medsale2010_01 - medsale2010_12
		medsale2011_01-medsale2011_06) sum= ;
	run;


%macro fincalc;
 pdays30_&year._&month. = days30_&year._&month./numsale&year._&month.*100;
 pdays60_&year._&month. = days60_&year._&month./numsale&year._&month.*100;
 pdays90_&year._&month. = days90_&year._&month./numsale&year._&month.*100;
 pdays120_&year._&month. = days120_&year._&month./numsale&year._&month.*100;
 pdays120p_&year._&month. = days120p_&year._&month./numsale&year._&month.*100;
 avgdays&year._&month. = totdays&year._&month./numsale&year._&month.;
 avgsale&year._&month. = aggsale&year._&month./numsale&year._&month.;
 inv&year._&month. = (list_tot&year._&month. + pend_tot&year._&month.) /numsale&year._&month.;
 if ucounty ne '00000' then wgtsale&year._&month.=medsale&year._&month.;
 if uiorder=0 then  wgtsale&year._&month.=  rwgtsale&year._&month.;

%mend;
%macro label;
label 
aggsale&year._&month. = "Total Sold Dollar Volume, &year._&month."
avgsale&year._&month. 	= "Average Sold Price, &year._&month."
medsale&year._&month. 	= "Median Sold Price, &year._&month."
wgtsale&year._&month.    ="Median Sold Price - Summary Geog. Calculated, &year._&month."
numsale&year._&month. 	= "Total Units Sold, &year._&month."

avgdays&year._&month. 	= "Average Days on Market, &year._&month."
totdays&year._&month. 	= "Aggregate Days on Market, &year._&month."

list_tot&year._&month.   	= "Active listings, &year._&month."
newlist&year._&month.    = "Total NEW listings, &year._&month."
newcontract&year._&month.   = "Total NEW Properties Marked Contract, &year._&month."
newconting&year._&month. = "Total NEW Properties Marked Contingent Contract, &year._&month."
newpend&year._&month.	 = "Total NEW pendings (Contracts + Contingents), &year._&month."
pend_tot&year._&month. = "Total Pending (All Contracts + Contingents), &year._&month."

inv&year._&month. ="Months of Inventory (Active Listings + Pending / Sales), &year._&month."

days30_&year._&month.   = "Time on Market for Sales: 1 - 30 Days, &year._&month."
days60_&year._&month.   = "Time on Market for Sales: 31-60 Days, &year._&month."
days90_&year._&month.   = "Time on Market for Sales: 61 - 90 Days, &year._&month."
days120_&year._&month.  = "Time on Market for Sales: 91-120 Days, &year._&month."
days120p_&year._&month.	= "Time on Market for Sales: Over 120 Days, &year._&month."
days_total_&year._&month. ="Total Sales with Time on Market, &year._&month."

pdays30_&year._&month.   = "Pct of sales with time on market: 1 - 30 days, &year._&month."
pdays60_&year._&month.   = "Pct of sales with time on market: 31-60 days, &year._&month."
pdays90_&year._&month.   = "Pct of sales with time on market: 61 - 90 days, &year._&month."
pdays120_&year._&month.  = "Pct of sales with time on market: 91-120 days, &year._&month."
pdays120p_&year._&month.	= "Pct of sales with time on market: Over 120 days, &year._&month."

Assumption_&year._&month. ="Financing for Sales: Assumption, &year._&month."
Cash_&year._&month.  ="Financing for Sales: Cash, &year._&month."
Conventional_&year._&month.  ="Financing for Sales: Conventional, &year._&month."
FHA_&year._&month.  ="Financing for Sales: FHA, &year._&month."
VA_&year._&month.  ="Financing for Sales: VA, &year._&month."
Owner_Finance_&year._&month.  ="Financing for Sales: Owner Financed, &year._&month."
Other_&year._&month. ="Financing for Sales: Other, &year._&month." 
fin_total_&year._&month.  ="Total Sales with Financing, &year._&month."

rwgtnum&year._&month. = "Jurisdiction's Share of Sales in Metro Area"
divsale_&year._&month. = "Total Sales in Regional Division"
regnum&year._&month. = "Total Number of Sales in Metro Area"
rwgtsale&year._&month. ="Jurisdiction's Share of Sales in Metro * Median Sale Price"
wgtnum&year._&month.="Jurisdiction's Share of Sales in Regional Division"

ucounty="County FIPS, SSCCC"
uiorder="Order of Jurisdictions for Regional Data Tables"
ui_div="Categorization of Jurisdictions"
stusab="State Abbreviation"
cntyname="County Name"
;
%mend;

%macro mrisfinish;
*append together and recode where needed, n=51;
data rbi_1999_01_2011_06_a(drop  =_type_);
	set divfile
		mris_all_years_new;

length cntyname $37.;

	if _type_ = 0 then do;
			ui_div = 'Total Region';
			uiorder= 0;
	end;
	if _type_ = 1 and ui_div = "District of Columbia" then delete;
	if ucounty = '' then ucounty = '00000';
	cntyname = put (ucounty, $cntynm.);

%do j = 1999 %to 2010;
 %let year = &j.;
	 %let moword = _Jan _Feb _Mar _Apr _May _Jun _Jul _Aug _Sep _Oct _Nov _Dec;

	 *cycle through months;
	 %do m = 1 %to 12;
	 	%if &m<10 %then %let month = 0&m.;
	 	%else %let month = &m. ;
	 %let mwd=%scan(&moword.,&m.,' ');
	%fincalc;
		%label;
	%end;
%end;

 %let year = 2011;
 %let moword = _Jan _Feb _Mar _Apr _May _Jun _Jul _Aug _Sep _Oct _Nov _Dec;

 *cycle through months;
	 %do m = 1 %to 6;
	 	%if &m<10 %then %let month = 0&m.;
	 	%else %let month = &m. ;
	 %let mwd=%scan(&moword.,&m.,' ');
	%fincalc;
		%label;
	%end;

run;

%mend;
%mrisfinish;

proc sort data=rbi_1999_01_2011_06_a out=mris.rbi_cnty_all_data (label=RBI County Sales Data, 1999_01 to 2011_06);
	by uiorder ucounty;
	run;

****SPLIT INTO MONTHLY DATA SETS****;

%macro split;
/*%do j = 1999 %to 2010;
 %let year = &j.;
	 %do m = 1 %to 12;
		 	%if &m<10 %then %let month = 0&m.;
		 	%else %let month = &m. ;

data mris.rbi_cnty_&year._&month. (label=RBI County Sales Data, &year._&month.);
	set mris.rbi_1999_01_2011_06;

keep cntyname stusab ucounty ui_div uiorder 
Assumption_&year._&month. Cash_&year._&month. Conventional_&year._&month. FHA_&year._&month. Other_&year._&month. 
Owner_Finance_&year._&month. VA_&year._&month. aggsale&year._&month. avgdays&year._&month. avgsale&year._&month. 
days120_&year._&month. days120p_&year._&month. days30_&year._&month. days60_&year._&month. days90_&year._&month.
days_total_&year._&month. divsale_&year._&month. fin_total_&year._&month. inv&year._&month. list_tot&year._&month. 
medsale&year._&month. newconting&year._&month. newcontract&year._&month. newlist&year._&month.
newpend&year._&month. numsale&year._&month. pdays120_&year._&month. pdays120p_&year._&month. pdays30_&year._&month. 
pdays60_&year._&month. pdays90_&year._&month. pend_tot&year._&month. regnum&year._&month. rwgtnum&year._&month.
rwgtsale&year._&month. totdays&year._&month. wgtnum&year._&month. wgtsale&year._&month. ;


run;

%syslput year=&year;
%syslput month=&month;

* Start submitting commands to remote server **;
rsubmit;

	
proc upload data=mris.rbi_cnty_&year._&month. out=mris.rbi_cnty_&year._&month.;
run;

	
%Dc_update_meta_file(
  ds_lib=MRIS,
  ds_name=rbi_cnty_&year._&month.,
  creator_process=Read_mris_rbi_1999_062011.sas,
  restrictions=None,
  revisions=%str(New file.) 
)  

run;

endrsubmit;
** End submitting commands to remote server**;

	%end;
%end;

 %let year = 2011;
	 %do m = 1 %to 6;
		 	%let month = 0&m.;

data mris.rbi_cnty_&year._&month. (label=RBI County Sales Data, &year._&month.);
	set mris.rbi_1999_01_2011_06;

keep cntyname stusab ucounty ui_div uiorder 
Assumption_&year._&month. Cash_&year._&month. Conventional_&year._&month. FHA_&year._&month. Other_&year._&month. 
Owner_Finance_&year._&month. VA_&year._&month. aggsale&year._&month. avgdays&year._&month. avgsale&year._&month. 
days120_&year._&month. days120p_&year._&month. days30_&year._&month. days60_&year._&month. days90_&year._&month.
days_total_&year._&month. divsale_&year._&month. fin_total_&year._&month. inv&year._&month. list_tot&year._&month. 
medsale&year._&month. newconting&year._&month. newcontract&year._&month. newlist&year._&month.
newpend&year._&month. numsale&year._&month. pdays120_&year._&month. pdays120p_&year._&month. pdays30_&year._&month. 
pdays60_&year._&month. pdays90_&year._&month. pend_tot&year._&month. regnum&year._&month. rwgtnum&year._&month.
rwgtsale&year._&month. totdays&year._&month. wgtnum&year._&month. wgtsale&year._&month. ;


run;

%syslput year=&year;
%syslput month=&month;

** Start submitting commands to remote server **;
rsubmit;

	
proc upload data=mris.rbi_cnty_&year._&month. out=mris.rbi_cnty_&year._&month.;
run;

	
%Dc_update_meta_file(
  ds_lib=MRIS,
  ds_name=rbi_cnty_&year._&month.,
  creator_process=Read_mris_rbi_1999_062011.sas,
  restrictions=None,
  revisions=%str(New file.) 
)  

run;

endrsubmit;
** End submitting commands to remote server **;
		
%end;*/

rsubmit;
proc upload data=mris.rbi_cnty_all_data out=mris.rbi_cnty_all_data;
run;


%Dc_update_meta_file(
  ds_lib=MRIS,
  ds_name=rbi_cnty_all_data,
  creator_process=Read_mris_rbi_1999_062011.sas,
  restrictions=None,
  revisions=%str(New file.) 
)  

run;

%File_info( data=MRIS.rbi_cnty_all_data, printobs=27, contents=N, stats=, printvars=cntyname wgtsale1999_01 wgtsale2005_01 wgtsale2011_06);


endrsubmit;
%mend;



%split;

