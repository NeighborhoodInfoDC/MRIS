/**************************************************************************
 Program:  Read_MRIS_month_county.sas
 Project:  MRIS
 Author:   K Pettit
 Created:  3/9/2009
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read monthly MRIS data for zip codes and counties
	after downloading html and converting to excel workbook;  
 Workbook must be open before program is run.
Source files scraped by Visual studio program

 Modifications: 7/16/2009, ran for April - June 2009; 7/21/09, ran for 1997-1998
   		09/23/10 L Hendey Added DCDATA format 
**************************************************************************/
/****************************************************************************
FILE NOTES:

*Note for 2006m04 - Fairfax county has inconsistent total numbers so fails one of the tests:  only 1 off 1411/1412;
*Note for 2003m06 - DC has inconsistent total numbers so fails one of the tests:  only 1 off 816/817;
*Note for 2000m09 - Mont has inconsistent total numbers so fails one of the tests:  only 1 off 1175/1176;
*Note for 1999m01 and 1999m02 - 51043 (Clarke County, VA), 51187 (Warren County, VA);
*Note for 1999m07 - 51630 (fred city, va) has inconsistent total numbers so fails one of the tests:  only 1 off 25/26;
*Note for 1997m12 - Mont has inconsistent total numbers so fails one of the tests:  only 1 off 855/854;
*Note for 1998m10 - DC has inconsistent total numbers so fails one of the tests:  only 1 off 620/621;
*Note for 1997/1998 - missing many counties;
*****************************************************************************/



/** Macro Read_foreclosures - Start Definition **/


%macro Read_mris_month_county(year=, st_mo=,end_mo=,geog=, finalize=N, revisions=New file. );
options mprint ; 

%let oldyear = %eval(&year.-1);
%let ext = &geog.; /*using geog as macro var is holdover from trying to combine cnty zip programming*/

%if &year=2010 %then %do;
%include 'D:\DCDATA\LIBRARIES\MRIS\Prog\read_mris_month_macros_2010.sas';
%end;

	%else %if &year~=2010 %then %do;
	%include 'D:\DCDATA\LIBRARIES\MRIS\Prog\read_mris_month_macros.sas';
	%end;

%let path = &_dcdata_path\MRIS\Raw\County\;

**cycle through months**;
%do j = &st_mo. %to &end_mo.;
%if &j<10 %then %let month = 0&j.;
%else %let month = &j. ;
title "&year._&month.";
	
	%syslput year=&year;
	%syslput month=&month;
	%syslput st_mo=&st_mo;
	%syslput end_mo=&end_mo;
	%syslput geog=&geog;

	%let finalize = %upcase( &finalize ); 

	  %if &finalize = Y %then %do;
	    %note_mput( macro=Read_mris_month_county, msg=Finalize=&finalize - MRIS.mris_cnty_&year._&month. and MRIS.Mriscat30_500_cnty_&year._&month. will be replaced. );
	    %let out1 = MRIS.mris_cnty_&year._&month.;
	    %let out1_nolib = mris_cnty_&year._&month.;
		%let out2 = MRIS.Mriscat30_500_cnty_&year._&month.;
		%let out2_nolib=Mriscat30_500_cnty_&year._&month.;
	  %end;
	  %else %do;
	    %warn_mput( macro=Read_mris_month_county, msg=Finalize=&finalize - MRIS.mris_cnty_&year._&month. and MRIS.Mriscat30_500_cnty_&year._&month. will NOT be replaced. );
	    %let out1 = mris_cnty_&year._&month.;
	    %let out1_nolib = mris_cnty_&year._&month.;
		%let out2 = Mriscat30_500_cnty_&year._&month.;
		%let out2_nolib=Mriscat30_500_cnty_&year._&month.;
	  %end;

	  %syslput out1=&out1;
	  %syslput out1_nolib=&out1_nolib;
	  %syslput out2=&out2;
	  %syslput out2_nolib=&out2_nolib;
	  %syslput finalize=&finalize;
	  %syslput revisions=&revisions;


		/*clear old files*/
		proc datasets lib=MRIS;
			delete mris_&ext._&year._&month. mriscat30_500_&ext._&year._&month. ;
			run;
		proc datasets lib=work;
			delete mris_&ext._&year._&month. mriscat30_500_&ext._&year._&month. ;
			run;

	**need to rename dc for now to take out periods of workbook and worksheet;
	%let cntycodes  = 11001 51510 51013 24031 24033 51059 51600 51610 24009 24017 24021 
	                  51107 51153 51179 51683 51685 51043 51061 51177 51187 51630 54037 ;

	**cycle through geographies**;
		%do i = 1 %to 22;
		%let filecode = %scan(&area., &i.); 
		%let fips = %scan(&cntycodes., &i.);

			/*%let excname = excel|&path[&filecode._&month._01_&year..xls]&filecode._&month._01_&year.;*/
			%let excname = excel|&path[&filecode._&month._01_&year..xls];

			/*program results in max 32-char worksheet names, and some of the county file names are longer;
			*get error when file <32 - could get fancy and determine length of field first;*/
			%let excsheet = %substr(&filecode._&month._01_&year.,1,31);

			/*filename statements for all indicators;*/
			%filenm1;

			%*readin in summary indicators;
			data sum&fips.;
				ucounty = "&fips";
				/*infile statements for summary indicators;*/
				%inf_sum;
			run;
			proc append data=sum&fips. out  = mris_&ext._&year._&month.;
			run;

			*read in sales indicators;
			data sale&fips.;
				length pricecat $25. price_cat 3.;
				ucounty = "&fips";
				%inf_sales;
				if pricecat="Under $30,000" then price_cat=1; 
				if pricecat="$30,000-$39,000" then price_cat=2;
				if pricecat="$40,000-$49,999" then price_cat=3;
				if pricecat="$50,000-$59,999" then price_cat=4;
				if pricecat="$60,000-$69,999" then price_cat=5;
				if pricecat="$70,000-$79,999" then price_cat=6;
				if pricecat="$80,000-$89,999" then price_cat=7;
				if pricecat="$90,000-$99,999" then price_cat=8;
				if pricecat="$100,000-$119,999" then price_cat=9;
				if pricecat="$120,000-$139,999" then price_cat=10;
				if pricecat="$140,000-$159,999" then price_cat=11;
				if pricecat="$160,000-$179,999" then price_cat=12;
				if pricecat="$180,000-$199,999" then price_cat=13;
				if pricecat="$200,000-$249,999" then price_cat=14;
				if pricecat="$250,000-$299,999" then price_cat=15;
				if pricecat="$300,000-$399,999" then price_cat=16;
				if pricecat="$400,000-$499,999" then price_cat=17;
				if pricecat="Over $500,000" then price_cat=18;
				if pricecat="Totals" then price_cat=19;
				;
			run;

			proc append data=sale&fips. out  = mriscat30_500_&ext._&year._&month.;
			run;

		%end;  /*end cycling through geographies*/

		***pull together main file***;

		proc sort data=mris_&ext._&year._&month.;
		by ucounty;
		run;

		proc sort data=mris.geograph;
		by ucounty;
		run;

		data mris.mris_&ext._&year._&month. (label="MRIS County Sales Data, &year._&month.");
			merge mris_&ext._&year._&month. (in=a)
				mris.geograph (in=b);
			by ucounty;
			if a and b;
			if numsale&year._&month.  gt 0 then do;
		 		pdays30_&year._&month. = days30_&year._&month./numsale&year._&month.*100;
		 		pdays60_&year._&month. = days60_&year._&month./numsale&year._&month.*100;
		 		pdays90_&year._&month. = days90_&year._&month./numsale&year._&month.*100;
		 		pdays120_&year._&month. = days120_&year._&month./numsale&year._&month.*100;
		 		pdays120p_&year._&month. = days120p_&year._&month./numsale&year._&month.*100;
		 		totdays&year._&month.=avgdays&year._&month.*numsale&year._&month.;
		 	end;

		  if numsale&oldyear._&month. >0 then 
			totdays&oldyear._&month.=avgdays&oldyear._&month.*numsale&oldyear._&month.;
			%labelsum;
			run;

		***process sales price class file***;
		data mris.mriscat30_500_&ext._&year._&month. (label="MRIS County Sales Data by Price Class, &year._&month.");
			set mriscat30_500_&ext._&year._&month. (drop=pricecat);
			sales_tot= sum(sales_bed2,sales_bed3,sales_bed4,sales_condor);
			sales_sf = sum(sales_bed2,sales_bed3,sales_bed4);
			list_tot= sum(list_sf,list_condor);
			%labelcat;

			format ucounty $cnty99f. price_cat $pricecat.; 

		run;

		***data check***;
			proc sort data=mris.mriscat30_500_&ext._&year._&month. out=mriscat30_500_&ext._&year._&month._C;
			by ucounty;
			run;

			proc summary data=mriscat30_500_&ext._&year._&month._C (where= (price_cat = 19)); /*price_cat totals*/
			var sales_tot;
			by ucounty;
			output out=sales_sum&year._&month. sum = sales_tot;
			run;

			proc sort data=mris.mris_&ext._&year._&month. out=mris_&ext._&year._&month._C;
			by ucounty; 
			run;

			data testing&year._&month.;
			merge sales_sum&year._&month.
				mris_&ext._&year._&month._C;
			 by ucounty;
			 daystot = sum(of days30_&year._&month.,days60_&year._&month.,days90_&year._&month.,days120_&year._&month., days120p_&year._&month.);
			if daystot= numsale&year._&month. then test1 = 'ok';
			if sales_tot = numsale&year._&month. then test2 = 'ok';
			 morttot=  sum( of mortconv&year._&month., mortfha&year._&month., mortva&year._&month., mortass&year._&month., 
				mortcash&year._&month., mortown&year._&month., mortoth&year._&month., mortunk&year._&month. );
			if morttot=  numsale&year._&month. then test3 = 'ok';
			if sales&year._&month. = numsale&year._&month. then test4 = 'ok';
			 run;

			proc freq data=testing&year._&month.;
			tables test1-test4;
			run;

			proc print data=testing&year._&month.;
			where test1 ne 'ok' or test2 ne 'ok' or test3 ne 'ok' or test4 ne 'ok'; 
			title2 'records with consistency errors';
			run;
			title2;

		proc means data = mris.mris_&ext._&year._&month. sum;
		var aggsale&oldyear._&month. aggsale&year._&month. numsale&oldyear._&month. numsale&year._&month.;
		run;

		proc print data = mris.mris_&ext._&year._&month. (obs=22) ;
		var aggsale&oldyear._&month. aggsale&year._&month. numsale&oldyear._&month. numsale&year._&month. avgdays&year._&month.
		pdays30_&year._&month. pdays60_&year._&month. pdays90_&year._&month. pdays120_&year._&month. pdays120p_&year._&month.;
		run;

		title;

 	** Start submitting commands to remote server **;
	rsubmit;
  
 	 ** Upload data to Alpha **;
  
  		proc upload status=no
	    data=mris.mris_cnty_&year._&month. 
	    out=mris.mris_cnty_&year._&month. (compress=no);

	 	run;

	   proc upload status=no
	    data=mris.mriscat30_500_cnty_&year._&month.
	    out=mris.mriscat30_500_cnty_&year._&month. (compress=no);

	   run;

		options spool;
		%File_info( data=mris.mris_cnty_&year._&month., printobs=22);
		%File_info( data=mris.mriscat30_500_cnty_&year._&month., printobs=0);


		  %if &finalize = Y %then %do;
		  
		    ** Register metadata **;
		    
		    %Dc_update_meta_file(
		      ds_lib=MRIS,
		      ds_name=&out1_nolib,
		      creator_process=MRIS_&year..sas,
		      restrictions=None,
		      revisions=%str(&revisions)
		    );
		    
		    run;

			%Dc_update_meta_file(
		      ds_lib=MRIS,
		      ds_name=&out2_nolib,
		      creator_process=MRIS_&year..sas,
		      restrictions=None,
		      revisions=%str(&revisions)
		    );
		    
		    run;
		    
		  %end;

	endrsubmit; 
	
	** End submitting commands to remote server **;

%end; /**cycle through months**/




%mend Read_mris_month_county;

/** End Macro Definition **/


