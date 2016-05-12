/**************************************************************************
 Program:  Read_MRIS_region2.sas
 Library:  HsngMon
 Project:  HNC
 Author:   K Pettit
 Created:  08/07/06
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  converting observations from county-price category to 
	a county-only based file:

 Modifications:
**************************************************************************/

options mprint symbolgen;

%macro assign(suf);
	sales_bed2_&suf. = sales_bed2;
	sales_bed3_&suf. = sales_bed3;
	sales_bed4_&suf. = sales_bed4;
	sales_condo_&suf. = sales_condo;
	sales_grent_&suf. = sales_grent;
	sales_tot_&suf. = sales_tot;
	sales_sf_&suf. = sales_sf;
	sales_condor_&suf. = sales_condor;

%mend;

%macro readmris(year);

proc sort data= hnc.mriscat&year.m&month.;
by ucounty;
run;

data mriscat&year.A (drop = i salescat sales_bed2-sales_bed4 sales_condo sales_grent sales_tot sales_sf sales_condor );
	length sales_bed2_0 - sales_bed2_17
			sales_bed3_0 - sales_bed3_17
			sales_bed4_0 - sales_bed4_17
			sales_condo_0 - sales_condo_17
			sales_grent_0 - sales_grent_17
			sales_tot_0 - sales_tot_17
			sales_sf_0 - sales_sf_17
			sales_condor_0 - sales_condor_17 8.;
		retain sales_bed2_0 - sales_bed2_17
			sales_bed3_0 - sales_bed3_17
			sales_bed4_0 - sales_bed4_17
			sales_condo_0 - sales_condo_17
			sales_grent_0 - sales_grent_17
			sales_tot_0 - sales_tot_17
			sales_sf_0 - sales_sf_17
			sales_condor_0 - sales_condor_17;

	set hnc.mriscat&year.;
	by ucounty;


	if first.ucounty then do;
		array allvars {*} sales_bed2_0 - sales_bed2_17
			sales_bed3_0 - sales_bed3_17
			sales_bed4_0 - sales_bed4_17
			sales_condo_0 - sales_condo_17
			sales_grent_0 - sales_grent_17
			sales_tot_0 - sales_tot_17
			sales_sf_0 - sales_sf_17
			sales_condor_0 - sales_condor_17;

		do i = 1 to dim(allvars);
			allvars{i} = .;
		end;
	end;

	 %let list = Under $100,000?$100,000-$149,000$150,000-$199,999?$200,000-$249,000?
		$250,000-$299,999?$300,000-$349,000?$350,000-$399,999?$400,000-$449,000?$450,000-$499,999 ?$500,000-$599,000?$600,000-$699,000?$700,000-$799,000?$800,000-$899,000?$900,000-$999,000? $1,000,000-2,499,999?
		$2,500,000-4,999,999?$5,000,000 & Over?;

		if salescat = "Totals" then do;
		%assign(0);
		end;
		else if salescat = "Under $100,000" then do;
		%assign(1);
	end;
	else if salescat = "$100,000-$149,999" then do;
		%assign(2);
	end;
	else if salescat = "$150,000-$199,999 " then do;
		%assign(3);
	end;
	else if salescat = "$200,000-$249,999" then do;
		%assign(4);
	end;
	else if salescat = "$250,000-$299,999 " then do;
		%assign(5);
	end;
		else if salescat = "$300,000-$349,999" then do;
		%assign(6);
	end;
	else if salescat = "$350,000-$399,000" then do;
		%assign(7);
	end;
	else if salescat = "$400,000-$449,999" then do;
		%assign(8);
	end;
	else if salescat = "$450,000-$499,999 " then do;
		%assign(9);
	end;
	else if salescat = "$500,000-$599,999" then do;
		%assign(10);
	end;
	else if salescat = "$600,000-$699,999" then do;
		%assign(11);
	end;
	else if salescat = "$700,000-$799,999" then do;
		%assign(12);
	end;
		else if salescat = "$800,000-$899,999" then do;
		%assign(13);
	end;
		else if salescat = "$900,000-$999,999" then do;
		%assign(14);
	end;
		else if salescat = "$1,000,000-2,499,999 " then do;
		%assign(15);
	end;
	else if salescat = "$2,500,000-4,999,999" then do;
		%assign(16);
	end;
	else if salescat = "$5,000,000 & Over" then do;
		%assign(17);
	end;

	
	if last.ucounty then output;
	run;

	data hnc.mriscat&year.A;
	set mriscat&year.A;

	psales_lt100 = (sales_tot_1 )/sales_tot_0*100;
	psales_100_200 = (sales_tot_2 + sales_tot_3)/sales_tot_0*100;


	run;

	proc print;
	var ucounty psales_lt100 psales_100_200	psales_200_300
	psales_300_400 psales_400_500 psales_500_600 psales_600_700
	psales_800_900 psales_900	psales_200_300 = (sales_tot_4 + sales_tot_5)/sales_tot_0*100;
	psales_300_400 = (sales_tot_6 + sales_tot_7)/sales_tot_0*100;
	psales_400_500 = (sales_tot_8 + sales_tot_9)/sales_tot_0*100;
	psales_500_600 = (sales_tot_10)/sales_tot_0*100;
	psales_600_700 = (sales_tot_11)/sales_tot_0*100;
	psales_700_800 = (sales_tot_12)/sales_tot_0*100;
	psales_800_900 = (sales_tot_13)/sales_tot_0*100;
	psales_900_1m = (sales_tot_14)/sales_tot_0*100;
	psales_1mpl = (sales_tot_15+sales_tot_16+sales_tot_17)/sales_tot_0*100;_1m psales_1mpl ;
	format _numeric_ 3.0;
	title "&year.";
	run;
		
%mend;
%readmris(2005);
%readmris(2006);



data test2005 ;
set hnc.mriscat2005a;
sales_sf = sum(sales_sf_0 - sales_sf_17);
sales_condor = sum(sales_condor_0 - sales_condor_17);
run;

proc print data=test2005;
var ucounty sales_sf sales_condor;
where ucounty='51510';
run;

data test2006 ;
set hnc.mriscat2006a;
sales_sf = sum(sales_sf_0 - sales_sf_17);
sales_condor = sum(sales_condor_0 - sales_condor_17);
run;

proc print data=test2006;
var ucounty sales_sf sales_condor;
where ucounty='51510';
run;
