/************************************************************************
 Program:  Read_mris_rbi_zip_update.sas
 Library:  MRIS
 Project:  DC Data Warehouse
 Author:   L. Hendey
 Created:  7/12/2011
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Read data received from RBI (based on 7/11 files). 
			   http://www.rbintel.com/statistics

 Modifications: 09/02/11 LH: Modified to fit DCDATA protocols. Upload to alpha at end & register metadata;
 		11/18/11 LH: Updated creator process to use file date.

************************************************************************/

%macro read_mris_rbi_zip_update(year=, file_date=,raw_month=,finalize=Y, revisions1=New file.,revisions2= );
options mprint ; 

%let raw_path = D:\DCDATA\Libraries\MRIS\Raw\;

%let finalize = %upcase( &finalize ); 

	  %if &finalize = Y %then %do;
	    %note_mput( macro=Read_mris_rbi_zip_update, msg=Finalize=&finalize - MRIS.rbi_zip_&file_date. and MRIS.rbi_zip_all_data.);
	    %let out1 = MRIS.rbi_zip_&file_date.;
	    %let out1_nolib = rbi_zip_&file_date.;
	    %let out2 = MRIS.rbi_zip_all_data;
	    %let out2_nolib = rbi_zip_all_data;
	  %end;
	  %else %do;
	    %warn_mput( macro=Read_mris_rbi_zip_update, msg=Finalize=&finalize - MRIS.rbi_zip_&file_date. and MRIS.zip_all_data will NOT be replaced. );
	    %let out1 = rbi_zip_&file_date.;
	    %let out1_nolib = rbi_zip_&file_date.;
	    %let out2 = rbi_zip_all_data;
	    %let out2_nolib = rbi_zip_all_data;
	  %end;

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
          

filename inf "&raw_path.Urban Institute - ZIP Aggregate - &raw_month..csv" lrecl=1000 ;

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

proc sort data=mris.zips_to_keep  nodups out=zips_to_keep;
by zip ucounty;
run;
proc sort data=zip_agg;
by zip ucounty;

data zip_agg2 drop_zip_agg;
merge zip_agg zips_to_keep;
by zip ucounty;

if yr_mo=" " then yr_mo="&file_date."; 

if keep=1 then output  zip_agg2;
else output drop_zip_agg;

run;
proc print data=drop_zip_agg;
run;

filename inf "&raw_path.Urban Institute - ZIP DOM - &raw_month..csv" lrecl=1000 ;

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
data zip_dom2 drop_zip_dom;
merge zip_dom zips_to_keep;
by zip ucounty;

if yr_mo=" " then yr_mo="&file_date."; 
if keep=1 then output  zip_dom2;
else output drop_zip_dom;

run;
proc print data=drop_zip_dom;
run;

filename inf "&raw_path.Urban Institute - ZIP Financing - &raw_month..csv" lrecl=1000 ;

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

data zip_fin2 drop_zip_fin;
merge zip_fin zips_to_keep;
by zip ucounty;

if yr_mo=" " then yr_mo="&file_date."; 
if keep=1 then output zip_fin2;
else output drop_zip_fin;

run;
proc print data=drop_zip_fin;
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
aggsale&file_date. = "Total Sold Dollar Volume, &file_date."
avgsale&file_date. 	= "Average Sold Price, &file_date."
medsale&file_date. 	= "Median Sold Price, &file_date."
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

ucounty="County FIPS, SSCCC"
z="Code classifying the ZIP code (as military, post office box, unique or standard)"
zip="ZIP Code (5 Characters)"
zipname="Name of ZIP Code"
;
%mend;
%macro fincalc;
totdays&file_date. =avgdays&file_date.*numsale&file_date.;
 pdays30_&file_date. = days30_&file_date./numsale&file_date.*100;
 pdays60_&file_date. = days60_&file_date./numsale&file_date.*100;
 pdays90_&file_date. = days90_&file_date./numsale&file_date.*100;
 pdays120_&file_date. = days120_&file_date./numsale&file_date.*100;
 pdays120p_&file_date. = days120p_&file_date./numsale&file_date.*100;
 avgdays&file_date. = totdays&file_date./numsale&file_date.;
 avgsale&file_date. = aggsale&file_date./numsale&file_date.;
 inv&file_date. = (list_tot&file_date. + pend_tot&file_date.) /numsale&file_date.;
%mend;
proc sort data=zips_to_keep nodup out=zipnames;
by zip;

%macro finish;
data rbi_zip_&file_date. (drop=_name_ );
merge  wide_aggsale wide_avgdays wide_avgsale wide_list_tot wide_medsale wide_newconting wide_newcontract wide_newlist
	 wide_newpend wide_numsale wide_pend_tot wide_days30 wide_days60 wide_days90 wide_days120 wide_days120p wide_days_total
	 wide_assumption wide_cash wide_conventional wide_fha wide_fin_total wide_other wide_owner_finance wide_va 
	 zipnames (keep=zip zipname ucounty z);
by zip;

if zip=" " then delete;


	%fincalc;
		%label;

run;

%mend;
%finish;

proc sort data=rbi_zip_&file_date. out=&out1.  (label=RBI ZIP Code Sales Data, &file_date.);
	by ucounty zip;
	run;


 ** Start submitting commands to remote server **;
	rsubmit;
  
 	 ** Upload data to Alpha **;
  
  	proc upload status=no
	    data=&out1.
	    out=&out1. (compress=no);

	 	run;
	 
	 options spool;
	%File_info( data=&out1., printobs=30);

	  %if &finalize = Y %then %do;

	    ** Register metadata **;

	    %Dc_update_meta_file(
	      ds_lib=MRIS,
	      ds_name=&out1_nolib,
	      creator_process=MRIS_RBI_ZIP_&year..sas,
	      restrictions=None,
	      revisions=%str(&revisions1)
	    );
			    
	 run;
	  %end;	    
		    
****ADD TO DATA SET WITH ALL YEARS****;
proc sort data=mris.rbi_zip_all_data out=all_years;
by ucounty zip;

data &out2. (label=RBI ZIP Code Sales Data, 1999_01 to &file_date.);
merge all_years &out1. (drop=zipname z);
by ucounty zip;

run;

 x "purge [DCDATA.MRIS.DATA]&out2_nolib..*";

%File_info( data=&out2., printobs=30, contents=N, stats=, printvars=zip zipname medsale1999_01 medsale2005_01 medsale&file_date.);

	  %if &finalize = Y %then %do;

	    ** Register metadata **;

	%Dc_update_meta_file(
	      ds_lib=MRIS,
	      ds_name=&out2_nolib,
	      creator_process=MRIS_RBI_zip_&file_date..sas,
	      restrictions=None,
	      revisions=%str(&revisions2)
	    );

	 run;
     %end;	   
	    
endrsubmit;
** End submitting commands to remote server**;


%mend;

