/************************************************************************
 Program:  Read_rbi_zip_1999_062011.sas
 Library:  MRIS
 Project:  DC Data Warehouse
 Author:   L. Hendey
 Created:  7/12/2011
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Read data received from RBI (based on 7/11 files). 
			   http://www.rbintel.com/statistics

 Modifications:

************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

%dcdata_lib( MRIS )
%dcdata_lib( LPS )
**** User parameters ****;

%let raw_path = D:\DCDATA\Libraries\MRIS\Raw;

filename inf "&raw_path.\Urban Institute - Zip Aggregate.csv" lrecl=1000 ;

  data zip_agg;
  	
	length year $4. month $2. yr_mo $7. ;

    infile inf dsd stopover firstobs=2;
	input zipname:$30. zip:$5. ucounty: $5. date: $6. aggsale:comma12. avgsale:comma12. medsale:comma12. numsale:comma12. avgdays:comma12. 
		 list_tot:comma12. newlist:comma12. newcontract:comma12. newconting:comma12. newpend:comma12. pend_tot:comma12.;
	
	year=substr(date,1,4);
	month=substr(date,5,2);

	yr_mo=year||"_"||month;

	  if missing( zipname ) then stop;

	  if zip="20110" and ucounty~="51683" then delete;
	  	if zip="20111" and ucounty~="51153" then delete;
run;
filename inf clear;

*create file to decide which zipcodes to keep - some zips are coded to mulitple counties and data is repeated for those;

data zipcodes;
	set lps.hnc_county_zip;

	hnc=1;
	run;

proc sort data=zipcodes;
by zip ucounty;

proc sort data=zip_agg;
by zip ucounty;
data testZip ;
merge zip_agg (in=a) zipcodes (keep=zip ucounty hnc z);
by zip ucounty;
if a;

count=1;
run;
proc summary data=testZip;
by zip;
var count;
output out=test_sum sum=count_sum;
run;
data mris.zips_to_keep (keep=zip ucounty keep z zipname )dropzips;
merge testZip test_sum;
by zip;

keep=.;
if (hnc=1 | count_sum le 150) then keep=1;
if (hnc=1 | count_sum le 150) then output mris.zips_to_keep;
else output dropzips;
run;
proc sort data=mris.zips_to_keep out=zips_to_keep;
by zip ucounty;
proc sort data=zip_agg;
by zip ucounty;

data zip_agg2;
merge zip_agg zips_to_keep;
by zip ucounty;

if keep~=1 then delete;

run;
filename inf "&raw_path.\Urban Institute - Zip - DOM.csv" lrecl=1000 ;

  data zip_dom;
  	
	length year $4. month $2. yr_mo $7. ;

    infile inf dsd stopover firstobs=2;
	input zipname:$30. zip: $5. ucounty:$5. date: $6. desc:$15. sold:comma12.;
	
	year=substr(date,1,4);
	month=substr(date,5,2);

	yr_mo=year||"_"||month;

	  if missing( zipname ) then stop;

	    if zip="20110" and ucounty~="51683" then delete;
		if zip="20111" and ucounty~="51153" then delete;
run;
filename inf clear;
proc sort data=zip_dom;
by zip ucounty;

data zip_dom2;
merge zip_dom zips_to_keep;
by zip ucounty;

if keep~=1 then delete;

run;
filename inf "&raw_path.\Urban Institute - Zip Financing.csv" lrecl=1000 ;

  data zip_fin;
  	
	length year $4. month $2. yr_mo $7. ;

    infile inf dsd stopover firstobs=2;
	input zipname:$30. zip: $5. ucounty:$5. date: $6. desc:$15. sold:comma12.;
	
	year=substr(date,1,4);
	month=substr(date,5,2);

	yr_mo=year||"_"||month;

	  if missing( zipname ) then stop;

	run;
filename inf clear;
proc sort data=zip_fin;
by zip ucounty;

data zip_fin2;
merge zip_fin zips_to_keep;
by zip ucounty;

if keep~=1 then delete;

run;


proc sort data=zip_agg2;
by zip;

%let varlist=aggsale avgsale medsale numsale avgdays list_tot
		  newlist newcontract newconting newpend pend_tot;

%macro transpose;
	%do i=1 %to 11;
%let var=%scan(&varlist.,&i.," ");
	proc transpose data=zip_agg2 out=wide_&var. prefix=&var.;
	by zip;
	id yr_mo;
	var &var.;
	run;

	proc sort data=wide_&var.;
	by zip;
%end;
%mend;
%transpose;
proc sort data=zip_dom2 nodup out=zip_dom3;
by zip yr_mo desc;

proc transpose data=zip_dom3 out=wide_dom prefix=desc;
by zip yr_mo;
id  desc;
var sold;
run;

data wide_dom2;
	set wide_dom (rename=(desc31_to_60_days=days60 desc61_to_90_days=days90 desc91_to_120_days=days120));

days30= sum(desc0_days, desc1_to_10_days, desc11_to_20_days, desc21_to_30_days);
days120p= sum(desc121_to_180_days, desc181_to_360_days, desc361_to_720_days, desc721__days);

days_total=sum( days120p , days120 , days90 , days60 , days30 );

run;
proc sort data=zip_fin2 nodup out=zip_fin3;
by zip yr_mo desc;
proc transpose data=zip_fin3 out=wide_fin ;
by zip yr_mo;
id  desc;
var sold;
run;

proc sort data=wide_dom2;
by zip;
proc sort data=wide_fin;
by zip;
data wide_DF (drop=_name_);
merge wide_dom2 wide_fin;
by zip;

fin_total= sum(Assumption, Cash, Conventional, FHA, VA, Owner_Finance, Other);

run;

%let varlist=days30 days60 days90 days120 days120p days_total Assumption Cash Conventional FHA VA Owner_Finance Other fin_total; 
%macro transpose2;
	%do i=1 %to 14;
%let var=%scan(&varlist.,&i.," ");
proc transpose data=wide_DF  out=wide_&var. prefix=&var._;
by zip;
id yr_mo;
var &var.;
run;
%end;
%mend;
%transpose2;

%macro label;
label 
aggsale&year._&month. = "Total Sold Dollar Volume, &year._&month."
avgsale&year._&month. 	= "Average Sold Price, &year._&month."
medsale&year._&month. 	= "Median Sold Price, &year._&month."
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

ucounty="County FIPS, SSCCC"
z="Code classifying the ZIP code (as military, post office box, unique or standard)"
zip="ZIP Code (5 Characters)"
zipname="Name of ZIP Code"
;
%mend;
%macro fincalc;
totdays&year._&month =avgdays&year._&month*numsale&year._&month;
 pdays30_&year._&month. = days30_&year._&month./numsale&year._&month.*100;
 pdays60_&year._&month. = days60_&year._&month./numsale&year._&month.*100;
 pdays90_&year._&month. = days90_&year._&month./numsale&year._&month.*100;
 pdays120_&year._&month. = days120_&year._&month./numsale&year._&month.*100;
 pdays120p_&year._&month. = days120p_&year._&month./numsale&year._&month.*100;
 avgdays&year._&month. = totdays&year._&month./numsale&year._&month.;
 avgsale&year._&month. = aggsale&year._&month./numsale&year._&month.;
 inv&year._&month. = (list_tot&year._&month. + pend_tot&year._&month.) /numsale&year._&month.;
%mend;
proc sort data=zips_to_keep nodup out=zipnames;
by zip;

%macro finish;
data rbi_zip_all_data (drop=_name_ );
merge  wide_aggsale wide_avgdays wide_avgsale wide_list_tot wide_medsale wide_newconting wide_newcontract wide_newlist
	 wide_newpend wide_numsale wide_pend_tot wide_days30 wide_days60 wide_days90 wide_days120 wide_days120p wide_days_total
	 wide_assumption wide_cash wide_conventional wide_fha wide_fin_total wide_other wide_owner_finance wide_va 
	 zipnames (keep=zip zipname ucounty z);
by zip;

if zip=" " then delete;


%do j = 1999 %to 2010;
 %let year = &j.;
 /*cycle through months*/
	 %do m = 1 %to 12;
	 	%if &m<10 %then %let month = 0&m.;
	 	%else %let month = &m. ;
	%fincalc;
   %label;
%end;
%end;

%do j=2011 %to 2011;
	%let year=&j;
%do m = 1 %to 6;
	 	%if &m<10 %then %let month = 0&m.;
	 	%else %let month = &m. ;
	%fincalc;
   %label;
%end;
%end;

run;

%mend;
%finish;

proc sort data=rbi_zip_all_data out=mris.rbi_zip_all_data (label="RBI ZIP Code Sales Data, 1999_01 to 2011_06");
by ucounty zip;
run;

****SPLIT INTO MONTHLY DATA SETS****;

%macro split;

%do j = 1999 %to 2010;
 %let year = &j.;
	 %do m = 1 %to 12;
		 	%if &m<10 %then %let month = 0&m.;
		 	%else %let month = &m. ;

data mris.rbi_zip_&year._&month. (label=RBI ZIP Code Sales Data, &year._&month.);
	set mris.rbi_zip_all_data;

keep ucounty z zip zipname 
Assumption_&year._&month. Cash_&year._&month. Conventional_&year._&month. FHA_&year._&month. Other_&year._&month. 
Owner_Finance_&year._&month. VA_&year._&month. aggsale&year._&month. avgdays&year._&month. avgsale&year._&month. 
days120_&year._&month. days120p_&year._&month. days30_&year._&month. days60_&year._&month. days90_&year._&month.
days_total_&year._&month. fin_total_&year._&month. inv&year._&month. list_tot&year._&month. 
medsale&year._&month. newconting&year._&month. newcontract&year._&month. newlist&year._&month.
newpend&year._&month. numsale&year._&month. pdays120_&year._&month. pdays120p_&year._&month. pdays30_&year._&month. 
pdays60_&year._&month. pdays90_&year._&month. pend_tot&year._&month.  totdays&year._&month.  ;


run;

%syslput year=&year;
%syslput month=&month;

* Start submitting commands to remote server **;
rsubmit;

	
proc upload data=mris.rbi_zip_&year._&month. out=mris.rbi_zip_&year._&month.;
run;

	
%Dc_update_meta_file(
  ds_lib=MRIS,
  ds_name=rbi_zip_&year._&month.,
  creator_process=Read_rbi_zip_1999_062011.sas,
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

data mris.rbi_zip_&year._&month. (label=RBI ZIP Code Sales Data, &year._&month.);
	set mris.rbi_zip_all_data;

keep ucounty z zip zipname 
Assumption_&year._&month. Cash_&year._&month. Conventional_&year._&month. FHA_&year._&month. Other_&year._&month. 
Owner_Finance_&year._&month. VA_&year._&month. aggsale&year._&month. avgdays&year._&month. avgsale&year._&month. 
days120_&year._&month. days120p_&year._&month. days30_&year._&month. days60_&year._&month. days90_&year._&month.
days_total_&year._&month. fin_total_&year._&month. inv&year._&month. list_tot&year._&month. 
medsale&year._&month. newconting&year._&month. newcontract&year._&month. newlist&year._&month.
newpend&year._&month. numsale&year._&month. pdays120_&year._&month. pdays120p_&year._&month. pdays30_&year._&month. 
pdays60_&year._&month. pdays90_&year._&month. pend_tot&year._&month.  totdays&year._&month.  ;


run;

%syslput year=&year;
%syslput month=&month;

** Start submitting commands to remote server **;
rsubmit;

	
proc upload data=mris.rbi_zip_&year._&month. out=mris.rbi_zip_&year._&month.;
run;

	
%Dc_update_meta_file(
  ds_lib=MRIS,
  ds_name=rbi_zip_&year._&month.,
  creator_process=Read_rbi_zip_1999_062011.sas,
  restrictions=None,
  revisions=%str(New file.) 
)  

run;

endrsubmit;
** End submitting commands to remote server **;
		
%end;

rsubmit;
proc upload data=mris.rbi_zip_all_data out=mris.rbi_zip_all_data;
run;


%Dc_update_meta_file(
  ds_lib=MRIS,
  ds_name=rbi_zip_all_data,
  creator_process=Read_rbi_zip_1999_062011.sas,
  restrictions=None,
  revisions=%str(New file.) 
)  

run;

%File_info( data=MRIS.rbi_zip_all_data, printobs=30, contents=N, stats=, printvars=zip zipname medsale1999_01 medsale2005_01 medsale2011_06);


endrsubmit;

%mend;



%split;

