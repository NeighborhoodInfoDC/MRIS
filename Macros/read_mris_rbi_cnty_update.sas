/************************************************************************
 Program:  Read_mris_rbi_cnty_update.sas
 Library:  MRIS
 Project:  DC Data Warehouse
 Author:   L. Hendey
 Created:  7/12/2011
 Version:  SAS 9.1
 Environment:  Local Windows Session
 
 Description:  Read data received from RBI (based on 7/11 files). 
			   http://www.rbintel.com/statistics

 Modifications: 09/02/11 LH: Modified to fit DCDATA protocols. Upload to alpha at end & register metadata;
 		11/18/11 LH: Updated creator process to have file date.
 		3/4/14 SZ: Updated for SAS1 Server
************************************************************************/

%macro read_mris_rbi_cnty_update(year=, file_date=,raw_month=,finalize=Y, revisions1=New file.,revisions2= );
options mprint ; 

/*%let raw_path = D:\DCDATA\Libraries\MRIS\Raw\;*/
%let raw_path = L:\Libraries\MRIS\Raw\;

%let cntycodes  = 11001 51510 51013 24031 24033 51059 51600 51610 24009 24017 24021
				51107 51153 51179 51683 51685 51043 51061 51177 51187 51630 54037 ;
				
%let finalize = %upcase( &finalize ); 

	  %if &finalize = Y %then %do;
	    %note_mput( macro=Read_mris_rbi_cnty_update, msg=Finalize=&finalize - MRIS.rbi_cnty_&file_date. and MRIS.rbi_cnty_all_data.);
	    %let out1 = MRIS.rbi_cnty_&file_date.;
	    %let out1_nolib = rbi_cnty_&file_date.;
	    %let out2 = MRIS.rbi_cnty_all_data;
	    %let out2_nolib = rbi_cnty_all_data;
	  %end;
	  %else %do;
	    %warn_mput( macro=Read_mris_rbi_cnty_update, msg=Finalize=&finalize - MRIS.rbi_cnty_&file_date. and MRIS.cnty_all_data will NOT be replaced. );
	    %let out1 = rbi_cnty_&file_date.;
	    %let out1_nolib = rbi_cnty_&file_date.;
	    %let out2 = rbi_cnty_all_data;
	    %let out2_nolib = rbi_cnty_all_data;
	  %end;
	/*
	  %syslput out1=&out1;
	  %syslput out1_nolib=&out1_nolib;
	  %syslput out2=&out2;
	  %syslput out2_nolib=&out2_nolib;
	  %syslput finalize=&finalize;
	  %syslput revisions1=&revisions1;
	  %syslput revisions2=&revisions2;
          %syslput raw_month=&raw_month;
	  %syslput file_date=&file_date;
          %syslput year=&year;
          */


filename inf "&raw_path.Urban Institute - County Aggregate - &raw_month..csv" lrecl=1000 ;

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
filename inf "&raw_path.\Urban Institute - County DOM - &raw_month..csv" lrecl=1000 ;

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
filename inf "&raw_path.\Urban Institute - County Financing - &raw_month..csv" lrecl=1000 ;

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
data mris_all_month (drop=_name_);
merge geograph wide_aggsale wide_avgdays wide_avgsale wide_list_tot wide_medsale wide_newconting wide_newcontract wide_newlist
	 wide_newpend wide_numsale wide_pend_tot wide_days30 wide_days60 wide_days90 wide_days120 wide_days120p wide_days_total
	 wide_assumption wide_cash wide_conventional wide_fha wide_fin_total wide_other wide_owner_finance wide_va;
by ucounty;

if ucounty=" " then delete;
run;

proc summary data=mris_all_month;
id ui_div;
class uiorder;
var numsale: ;
output out = sum_sales (drop= _freq_) sum=divsale_&file_date.;

run;
proc sort data=mris_all_month;
by uiorder;

%macro calc_region;
data mris_all_month_new (drop=_type_);
 	merge mris_all_month
		  sum_sales (where=(_type_ ne 0));
	by uiorder;


if _n_=1 then set sum_sales (where = (_type_ = 0) keep= divsale:  _type_  rename=(divsale_&file_date.=regnum&file_date.));


 rwgtnum&file_date. = numsale&file_date./regnum&file_date.; *number of sales divided by total region sales;
 rwgtsale&file_date. = rwgtnum&file_date.*medsale&file_date. ; *share of sales in region * median sale price;
 wgtnum&file_date. = numsale&file_date./divsale_&file_date. ; *number of sales divided by total sales in division;
 wgtsale&file_date. = wgtnum&file_date.*medsale&file_date. ; *share of sales in division * median sale price;

 totdays&file_date. =avgdays&file_date.*numsale&file_date.;

 run;

 proc sort data=mris_all_month_new ;
 by uiorder;
 run;
 %mend;
 
 %calc_region;

proc summary data= mris_all_month_new;
	id ui_div;
	class uiorder;
	var _numeric_;
	output out = divfile (drop = _freq_  medsale&file_date.) sum= ;
	run;


%macro fincalc;
 pdays30_&file_date. = days30_&file_date./numsale&file_date.*100;
 pdays60_&file_date. = days60_&file_date./numsale&file_date.*100;
 pdays90_&file_date. = days90_&file_date./numsale&file_date.*100;
 pdays120_&file_date. = days120_&file_date./numsale&file_date.*100;
 pdays120p_&file_date. = days120p_&file_date./numsale&file_date.*100;
 avgdays&file_date. = totdays&file_date./numsale&file_date.;
 avgsale&file_date. = aggsale&file_date./numsale&file_date.;
 inv&file_date. = (list_tot&file_date. + pend_tot&file_date.) /numsale&file_date.;
 if ucounty ne '00000' then wgtsale&file_date.=medsale&file_date.;
 if uiorder=0 then  wgtsale&file_date.=  rwgtsale&file_date.;

%mend;
%macro label;
label 
aggsale&file_date. = "Total Sold Dollar Volume, &file_date."
avgsale&file_date. 	= "Average Sold Price, &file_date."
medsale&file_date. 	= "Median Sold Price, &file_date."
wgtsale&file_date.    ="Median Sold Price - Summary Geog. Calculated, &file_date."
numsale&file_date. 	= "Total Units Sold, &file_date."

avgdays&file_date. 	= "Average Days on Market, &file_date."
totdays&file_date. 	= "Aggregate Days on Market, &file_date."

list_tot&file_date.   	= "Active listings, &file_date."
newlist&file_date.    = "Total NEW listings, &file_date."
newcontract&file_date.   = "Total NEW Properties Marked Contract, &file_date."
newconting&file_date. = "Total NEW Properties Marked Contingent Contract, &file_date."
newpend&file_date.	 = "Total NEW pendings (Contracts + Contingents), &file_date."
pend_tot&file_date. = "Total Pending (All Contracts + Contingents), &file_date."

inv&file_date. ="Months of Inventory (Active Listings + Pending / Sales), &file_date."

days30_&file_date.   = "Time on Market for Sales: 1 - 30 Days, &file_date."
days60_&file_date.   = "Time on Market for Sales: 31-60 Days, &file_date."
days90_&file_date.   = "Time on Market for Sales: 61 - 90 Days, &file_date."
days120_&file_date.  = "Time on Market for Sales: 91-120 Days, &file_date."
days120p_&file_date.	= "Time on Market for Sales: Over 120 Days, &file_date."
days_total_&file_date. ="Total Sales with Time on Market, &file_date."

pdays30_&file_date.   = "Pct of sales with time on market: 1 - 30 days, &file_date."
pdays60_&file_date.   = "Pct of sales with time on market: 31-60 days, &file_date."
pdays90_&file_date.   = "Pct of sales with time on market: 61 - 90 days, &file_date."
pdays120_&file_date.  = "Pct of sales with time on market: 91-120 days, &file_date."
pdays120p_&file_date.	= "Pct of sales with time on market: Over 120 days, &file_date."

Assumption_&file_date. ="Financing for Sales: Assumption, &file_date."
Cash_&file_date.  ="Financing for Sales: Cash, &file_date."
Conventional_&file_date.  ="Financing for Sales: Conventional, &file_date."
FHA_&file_date.  ="Financing for Sales: FHA, &file_date."
VA_&file_date.  ="Financing for Sales: VA, &file_date."
Owner_Finance_&file_date.  ="Financing for Sales: Owner Financed, &file_date."
Other_&file_date. ="Financing for Sales: Other, &file_date." 
fin_total_&file_date.  ="Total Sales with Financing, &file_date."

rwgtnum&file_date. = "Jurisdiction's Share of Sales in Metro Area, &file_date."
divsale_&file_date. = "Total Sales in Regional Division, &file_date."
regnum&file_date. = "Total Number of Sales in Metro Area, &file_date."
rwgtsale&file_date. ="Jurisdiction's Share of Sales in Metro * Median Sale Price, &file_date."
wgtnum&file_date.="Jurisdiction's Share of Sales in Regional Division, &file_date."

ucounty="County FIPS, SSCCC"
uiorder="Order of Jurisdictions for Regional Data Tables"
ui_div="Categorization of Jurisdictions"
stusab="State Abbreviation"
cntyname="County Name"
;
%mend;

%macro mrisfinish;
*append together and recode where needed, n=51;
data rbi_cnty_&file_date.(drop  =_type_);
	set divfile
		mris_all_month_new;


	if _type_ = 0 then do;
			ui_div = 'Total Region';
			uiorder= 0;
	end;
	if _type_ = 1 and ui_div = "District of Columbia" then delete;
	if ucounty = '' then ucounty = '00000';
	cntyname = put (ucounty, $cntynm.);


		%fincalc;
		%label;

run;

%mend;
%mrisfinish;

proc sort data=rbi_cnty_&file_date. out=mris.rbi_cnty_&file_date.  (label=RBI County Sales Data, &file_date.);
	by uiorder ucounty;
	run;


 ** Start submitting commands to remote server **;
/*	rsubmit;
  
 	 ** Upload data to Alpha **;
  
  	proc upload status=no
	    data=&out1.
	    out=&out1. (compress=no);

	 	run;
*/	 
	 options spool;
	%File_info( data=&out1., printobs=27);

	  %if &finalize = Y %then %do;

	    ** Register metadata **;

	    %Dc_update_meta_file(
	      ds_lib=MRIS,
	      ds_name=&out1_nolib,
	      creator_process=MRIS_RBI_&year..sas,
	      restrictions=None,
	      revisions=%str(&revisions1)
	    );
			    
	 run;
	  %end;	    
		    
****ADD TO DATA SET WITH ALL YEARS****;
proc sort data=mris.rbi_cnty_all_data out=all_years;
by uiorder ucounty;

data &out2. (label=RBI County Sales Data, 1999_01 to &file_date.);
merge all_years mris.rbi_cnty_&file_date. (drop=cntyname stusab ui_div);
by uiorder ucounty;

run;

 /*x "purge [DCDATA.MRIS.DATA]&out2_nolib..*";*/
 
%File_info( data=&out2., printobs=27, contents=N, stats=, printvars=cntyname wgtsale1999_01 wgtsale2005_01 wgtsale&file_date.);

	  %if &finalize = Y %then %do;

	    ** Register metadata **;

	%Dc_update_meta_file(
	      ds_lib=MRIS,
	      ds_name=&out2_nolib,
	      creator_process=MRIS_RBI_&file_date..sas,
	      restrictions=None,
	      revisions=%str(&revisions2)
	    );

	 run;
     %end;	   
	    
/*endrsubmit;*/
** End submitting commands to remote server**;

%mend;

