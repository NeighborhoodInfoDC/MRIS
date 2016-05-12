libname mris "D:\DCData\Libraries\MRIS\Data";

%let yr = 2012;
%let mo = 06;
%let last = 2011;

data mris.yoy_sales_map_data_&yr.&mo. (keep = zip yoy_sale);
	length yoy_sale 5;
	format yoy_sale 5.1;
	set mris.rbi_zip_alldata_tables;
	if numsale&yr._&mo. ne . and numsale&yr._&mo. ge 5 and numsale&last._&mo. ne . and numsale&last._&mo. ge 5 then do;
		yoy_sale = (((numsale&yr._&mo. - numsale&last._&mo.)/numsale&last._&mo.)*100);
		output;
	end;
run;
/*
proc sql;
create table mris.yoy_sales_map_data&yr.&mo. as
	select zip, yoy_sale
	from mris.yoy_sales_map_data
	order zip, yoy_sale;
quit;

proc freq data=mris.rbi_zip_alldata_tables;
tables numsale&last._&mo. numsale&yr._&mo.;
run;

proc means data = mris.rbi_zip_alldata_tables;
var numsale&last._&mo. numsale&yr._&mo.;
output out = region_total
sum = salesum&last. salesum&yr.;
run;

data mris.region_yoy;
	set region_total;
		yoy_sale = (((salesum&yr. - salesum&last.)/salesum&last.)*100);
run;

proc means data = mris.yoy_sales_map_data_&yr.&mo. q1 q3 median;
run;
