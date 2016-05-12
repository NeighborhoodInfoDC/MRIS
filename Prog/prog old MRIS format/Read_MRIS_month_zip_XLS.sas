/**************************************************************************
 Program:   D:\DCData\Libraries\MRIS\Prog\Read_MRIS_month_zip_XLS.sas
			backed up at:
				K:\Metro\PTatian\DCData\Libraries\MRIS\Prog\Read_MRIS_month_zip_XLS.sas
 Project:  HNC
 Author:   K Pettit
 Created:  3/9/2009
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read monthly MRIS data for zip codes
	after downloading html and converting to excel workbook;  
 Workbook must be open before program is run.
Source files scraped by Visual studio program

 Modifications: 5/1/09 
		        09/03/10 L Hendey Added DCDATA format 
				12/21/10 D Price - modified to use XLS files directly
**************************************************************************/


%include 'D:\DCDATA\Libraries\MRIS\Prog\mris_zip_list.sas';

* These options make the log file too huge;
%*include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%*DCData_lib( MRIS );

libname MRIS "D:\DCData\Libraries\MRIS\Data";

%macro read_data_point(varname, rowheader, column, lname);
	retain &varname.;
	if index(var1, &rowheader.)>0 and index(upcase(var&column.), 'N/A')=0
		then &varname. = input(var&column.,8.0);
	label &varname. = &lname.;
%mend read_data_point;

%macro create_mris_data(filename, filecode, year, month);

* THIS DATA STEP READS XLS FILES DIRECTLY (they are actually html files);
filename xls_mris &filename.;
data temp_mris;
	infile xls_mris DSD FIRSTOBS=1 LRECL=2000 MISSOVER dlm="`";
	length 
		line $200.
		prev_lines $1500.
	;
	input line $;

	retain prev_lines;

	* Strip whitespaces, dollar signs, percent sign, and commas;
	line = compress(line, ',$%','s');

	* Strip nbsp;
	line = PRXChange('s/&nbsp;//',20,line);

	* Mark end of each line;
	if index(upcase(line), '</TR')>0 then do;
		use=1;
		currline = prev_lines;
	end;

	* Create prev_lines, which holds current line and all previous lines;
	if index(upcase(line), '</TR')=0 then prev_lines = cats(of prev_lines line);
	else prev_lines = '';

run;

* THIS DATA STEP SIMPLIFIES THE DATA;
data temp_mris_2;
	set temp_mris;
	keep zip var:;
	if use;
	length
		var1 - var20 $100.
	;

	* Replace </TD with comma so that can delimit variables later;
	currline = PRXChange('s/<\/TD/,/i',20,currline);
	
	* strip HTML tags;
	currline = PRXChange('s/<[^>]*>//', 100, currline);
	currline = compress(currline,'>');

	* break into new variables;
	%do i=1 %to 20;
		var&i. = scan(currline, &i.,',');
	%end;

	zip = &filecode.;
run;


* THIS DATA STEP READS NEEDED VARIABLES INTO THEIR PROPER PLACES;
%let prevyear = %eval(&year. - 1);
data mriszip&year.m&month._&filecode.;
	set temp_mris_2;
	by zip;
	retain zip;* &varlist.;
	drop var:;

	%read_data_point(aggsale&year.m&month., "TotalSoldDollarVolume:", 2, "Total Sold Dollar Volume");
	%read_data_point(aggsale&prevyear.m&month., "TotalSoldDollarVolume:", 3, "Total Sold Dollar Volume");

	%read_data_point(avgsale&year.m&month., "AverageSoldPrice:", 2, "Average Sold Price");
	%read_data_point(avgsale&prevyear.m&month., "AverageSoldPrice:", 3, "Average Sold Price");

	%read_data_point(medsale&year.m&month., "MedianSoldPrice:", 2, "Median Sold Price");
	%read_data_point(medsale&prevyear.m&month., "MedianSoldPrice:", 3, "Median Sold Price");

	%read_data_point(numsale&year.m&month., "TotalUnitsSold:", 2, "Total Units Sold");
	%read_data_point(numsale&prevyear.m&month., "TotalUnitsSold:", 3, "Total Units Sold");
	
	%read_data_point(avgdays&year.m&month., "AverageDaysonMarket:", 2, "Average Days on Market");
	%read_data_point(avgdays&prevyear.m&month., "AverageDaysonMarket:", 3, "Average Days on Market");
	
	%read_data_point(avglist&year.m&month., "AverageListPriceforSolds:", 2, "Average List Price");
	%read_data_point(avglist&prevyear.m&month., "AverageListPriceforSolds:", 3, "Average List Price");	

	%read_data_point(sales&year.m&month., "GrandTotals", 2, "Sales from price categories - just for testing");

	%read_data_point(newlist&year.m&month.,'TotalNEWlistings:',2,'Total NEW listings');
	%read_data_point(contract&year.m&month.,'TotalPropertiesMarkedContract:',2,'Total Properties Marked Contract');
	%read_data_point(contingent&year.m&month.,'TotalPropertiesMarkedContingentContract:',2,'Total Properties Marked Contingent Contract');
	%read_data_point(newpend&year.m&month.,'TotalNEWpendings(Contracts+Contingents):',2,'Total NEW pendings (Contracts + Contingents)');
	%read_data_point(days30_&year.m&month.,'Under100000',11,'Time on Market for Sales: 1 - 30 Days');
	%read_data_point(days60_&year.m&month.,'100000-149999',11,'Time on Market for Sales: 31-60 Days');
	%read_data_point(days90_&year.m&month.,'150000-199999',11,'Time on Market for Sales: 61 - 90 Days');
	%read_data_point(days120_&year.m&month.,'200000-249999',11,'Time on Market for Sales: 91-120 Days');
	%read_data_point(days120p_&year.m&month.,'250000-299999',11,'Time on Market for Sales: Over 120 Days');
	%read_data_point(mortconv&year.m&month.,'500000-599999',11,'Type of financing for sales: Conventional');
	%read_data_point(mortfha&year.m&month.,'600000-699999',11,'Type of financing for sales: FHA');
	%read_data_point(mortva&year.m&month.,'700000-799999',11,'Type of financing for sales: VA');
	%read_data_point(mortass&year.m&month.,'800000-899999',11,'Type of financing for sales: Assumption');
	%read_data_point(mortcash&year.m&month.,'900000-999999',11,'Type of financing for sales: Cash');
	%read_data_point(mortown&year.m&month.,'1000000-2499999',11,'Type of financing for sales: Owner Finance');
	%read_data_point(mortoth&year.m&month.,'2500000-4999999',11,'Type of financing for sales: All Other');
	%read_data_point(mortunk&year.m&month.,'5000000&Over',11,'Type of financing for sales: Unreported');

	%read_data_point(saletolist&year.m&month.,'AvgSalePriceasapercentageofAvgListPrice:',2,'Ratio of sales to list price');
	%read_data_point(saletolist&prevyear.m&month.,'AvgSalePriceasapercentageofAvgListPrice:',3,'Ratio of sales to list price');

	*NEW VARIABLE - NOT ON INITIAL DATA SET;
	%read_data_point(actlist&year.m&month., "GrandTotals", 3, "ACTIVE listings");


	* Created calculated variables;
	if last.zip then do;

		if numsale&year.m&month. ne 0 then do;
			pdays30_&year.m&month. = days30_&year.m&month./numsale&year.m&month.*100;
			pdays60_&year.m&month. = days60_&year.m&month./numsale&year.m&month.*100;
			pdays90_&year.m&month. = days90_&year.m&month./numsale&year.m&month.*100;
			pdays120_&year.m&month. = days120_&year.m&month./numsale&year.m&month.*100;
			pdays120p_&year.m&month. = days120p_&year.m&month./numsale&year.m&month.*100;
			
			totdays&year.m&month. = avgdays&year.m&month. * numsale&year.m&month.;
		end;

		if numsale&prevyear.m&month. ne 0 then do;
			totdays&prevyear.m&month. = avgdays&prevyear.m&month. * numsale&prevyear.m&month.;
		end;

		if numsale&year.m&month. ne 0 then do;
			mnthinv&year.m&month. = actlist&year.m&month./numsale&year.m&month.;
		end;
	end;

	label 
		pdays30_&year.m&month. = "Pct of sales with time on market: 1 - 30 days"
		pdays60_&year.m&month. = "Pct of sales with time on market: 31-60 days"
		pdays90_&year.m&month. = "Pct of sales with time on market: 61 - 90 days"
		pdays120_&year.m&month. = "Pct of sales with time on market: 91-120 days"
		pdays120p_&year.m&month. = "Pct of sales with time on market: Over 120 days"
		totdays&year.m&month. = "Aggregate Days on Market"
		totdays&prevyear.m&month. = "Aggregate Days on Market"
		mnthinv&year.m&month. = "Months of Inventory";
	;

	* Only keep the last observation;
	if last.zip;
run;

%mend create_mris_data;

* NOW, MERGE ZIP CODES TOGETHER;
%macro create_file_single_month(year, month, sep);
	%do j = 1 %to 532;
		%let filecode = %scan(&ziplist., &j.);
		%put &filecode.;
		%create_mris_data("D:/DCData/Libraries/MRIS/Data/Zip/&filecode.&sep.&month.&sep.01&sep.&year..xls", &filecode., &year., &month.);
	%end;

	data mris.mriszip&year.m&month._new (compress=binary);
		set
			%do i = 1 %to 532;
				%let filecode = %scan(&ziplist., &i.);
				Mriszip&year.m&month._&filecode.
			%end;
		;
	run;

%mend create_file_single_month;

/*
%create_file_single_month(2005, 10, -);
%create_file_single_month(2005, 12, -);

%create_file_single_month(2006, 01, -);
%create_file_single_month(2006, 02, -);
%create_file_single_month(2006, 03, -);
%create_file_single_month(2006, 04, -);
%create_file_single_month(2006, 05, -);
%create_file_single_month(2006, 06, -);
%create_file_single_month(2006, 07, -);
%create_file_single_month(2006, 08, -);
%create_file_single_month(2006, 09, -);
%create_file_single_month(2006, 10, -);
%create_file_single_month(2006, 11, -);
%create_file_single_month(2006, 12, -);

%create_file_single_month(2007, 01, -);
%create_file_single_month(2007, 02, -);
%create_file_single_month(2007, 03, -);
%create_file_single_month(2007, 04, -);
%create_file_single_month(2007, 05, -);
%create_file_single_month(2007, 06, -);
%create_file_single_month(2007, 07, -);
%create_file_single_month(2007, 08, -);
%create_file_single_month(2007, 09, -);
%create_file_single_month(2007, 10, -);
%create_file_single_month(2007, 11, -);
%create_file_single_month(2007, 12, -);

%create_file_single_month(2008, 01, -);
%create_file_single_month(2008, 02, -);
%create_file_single_month(2008, 03, -);
%create_file_single_month(2008, 04, -);
%create_file_single_month(2008, 05, -);
%create_file_single_month(2008, 06, -);
*/

%create_file_single_month(2008, 07, _);
%create_file_single_month(2008, 08, _);
%create_file_single_month(2008, 09, _);
%create_file_single_month(2008, 10, _);
%create_file_single_month(2008, 11, _);
%create_file_single_month(2008, 12, _);

%create_file_single_month(2009, 01, _);
%create_file_single_month(2009, 02, _);

/*
%create_file_single_month(2009, 03, _);
%create_file_single_month(2009, 04, _);
%create_file_single_month(2009, 05, _);
%create_file_single_month(2009, 06, _);
%create_file_single_month(2009, 07, _);
%create_file_single_month(2009, 08, _);
%create_file_single_month(2009, 09, _);
%create_file_single_month(2009, 10, _);
%create_file_single_month(2009, 11, _);
%create_file_single_month(2009, 12, _);


%create_file_single_month(2010, 01, _);
%create_file_single_month(2010, 02, _);
%create_file_single_month(2010, 03, _);
%create_file_single_month(2010, 04, _);
%create_file_single_month(2010, 05, _);
%create_file_single_month(2010, 06, _);
%create_file_single_month(2010, 07, _);
%create_file_single_month(2010, 08, _);
*/
