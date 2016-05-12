
%let year=1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011;

%macro addyears;

%do i=1 %to 13;
%let y=%scan(&year.,&i.," ");

pct_cash&y.=0; cash_&y.=0; fin_total&y.=0;  Ampt_&y.=0; Other_&y.=0; OFin_&y.=0; FHA_&y.=0; VA_&y.=0; conv_&y.=0;
array cash&y. {12} cash_&y._01 cash_&y._02 cash_&y._03 cash_&y._04 cash_&y._05 cash_&y._06 cash_&y._07 cash_&y._08 cash_&y._09 cash_&y._10 cash_&y._11 cash_&y._12;
array ftot&y. {12} fin_total_&y._01 fin_total_&y._02 fin_total_&y._03 fin_total_&y._04 fin_total_&y._05 fin_total_&y._06 fin_total_&y._07 fin_total_&y._08 fin_total_&y._09 fin_total_&y._10 fin_total_&y._11 fin_total_&y._12;
array Ampt&y. {12} Assumption_&y._01 Assumption_&y._02 Assumption_&y._03 Assumption_&y._04 Assumption_&y._05 Assumption_&y._06 Assumption_&y._07 Assumption_&y._08 Assumption_&y._09 Assumption_&y._10 Assumption_&y._11 Assumption_&y._12;
array Other&y. {12} Other_&y._01 Other_&y._02 Other_&y._03 Other_&y._04 Other_&y._05 Other_&y._06 Other_&y._07 Other_&y._08 Other_&y._09 Other_&y._10 Other_&y._11 Other_&y._12;
array OFin&y. {12} Owner_Finance_&y._01 Owner_Finance_&y._02 Owner_Finance_&y._03 Owner_Finance_&y._04 Owner_Finance_&y._05 Owner_Finance_&y._06 Owner_Finance_&y._07 Owner_Finance_&y._08 Owner_Finance_&y._09 Owner_Finance_&y._10 Owner_Finance_&y._11 Owner_Finance_&y._12;
array FHA&y. {12} FHA_&y._01 FHA_&y._02 FHA_&y._03 FHA_&y._04 FHA_&y._05 FHA_&y._06 FHA_&y._07 FHA_&y._08 FHA_&y._09 FHA_&y._10 FHA_&y._11 FHA_&y._12;
array VA&y. {12} VA_&y._01 VA_&y._02 VA_&y._03 VA_&y._04 VA_&y._05 VA_&y._06 VA_&y._07 VA_&y._08 VA_&y._09 VA_&y._10 VA_&y._11 VA_&y._12;
array conv&y. {12} conventional_&y._01 conventional_&y._02 conventional_&y._03 conventional_&y._04 conventional_&y._05 conventional_&y._06 conventional_&y._07 conventional_&y._08 conventional_&y._09 conventional_&y._10 conventional_&y._11 conventional_&y._12;

do j=1 to 12;
fin_total&y.=fin_total&y.+ftot&y.{j};

	if cash&y.{j}=. then cash&y.{j}=0;
	cash_&y.=cash_&y.+cash&y.{j};
	if Ampt&y.{j}=. then Ampt&y.{j}=0;
	Ampt_&y.=Ampt_&y.+Ampt&y.{j};
	if Other&y.{j}=. then Other&y.{j}=0;
	Other_&y.=Other_&y.+Other&y.{j};
	if OFin&y.{j}=. then OFin&y.{j}=0;
	OFin_&y.=OFin_&y.+OFin&y.{j};
	if FHA&y.{j}=. then FHA&y.{j}=0;
	FHA_&y.=FHA_&y.+FHA&y.{j};
	if VA&y.{j}=. then VA&y.{j}=0;
	VA_&y.=VA_&y.+VA&y.{j};
	if conv&y.{j}=. then conv&y.{j}=0;
	conv_&y.=conv_&y.+conv&y.{j};
end;

pct_cash&y=cash_&y./fin_total&y.*100;
pct_ftype_other&y.=(Ampt_&y. + Other_&y. + OFin_&y.)/fin_total&y.*100;
pct_conv&y.=Conv_&y./fin_total&y.*100; 
pct_fha_va&y.=(FHA_&y. + VA_&y.)/fin_total&y.*100;

label 
pct_cash&y="Percent of Sales that are Cash Sales &y"
pct_ftype_other&y="Percent of Sales with Owner Financing, Assumption or Other Financing &y"
pct_conv&y="Percent of Sales with Conventional Financing &y"
pct_fha_va&y="Percent of Sales with FHA or VA Financing &y";

%end; 


%mend; 
data annualsum;
	set mris.rbi_cnty_alldata_tables;

%addyears


run;


data analysis;
	set annualsum (where=((uiorder=0 & ucounty="00000") or (ucounty in ( "24017" "24033" "11001" "51153" "51683"))));

keep uiorder ucounty 
pct_cash2000 pct_cash2001 pct_cash2002 pct_cash2003 pct_cash2004 pct_cash2005 pct_cash2006 pct_cash2007 pct_cash2008 pct_cash2009 pct_cash2010 pct_cash2011
pct_ftype_other2000 pct_ftype_other2001 pct_ftype_other2002 pct_ftype_other2003 pct_ftype_other2004 pct_ftype_other2005 pct_ftype_other2006 pct_ftype_other2007 pct_ftype_other2008 pct_ftype_other2009 pct_ftype_other2010 pct_ftype_other2011
pct_conv2000 pct_conv2001 pct_conv2002 pct_conv2003 pct_conv2004 pct_conv2005 pct_conv2006 pct_conv2007 pct_conv2008 pct_conv2009 pct_conv2010 pct_conv2011
pct_fha_va2000 pct_fha_va2001 pct_fha_va2002 pct_fha_va2003 pct_fha_va2004 pct_fha_va2005 pct_fha_va2006 pct_fha_va2007 pct_fha_va2008 pct_fha_va2009 pct_fha_va2010 pct_fha_va2011;

run;

proc sort data=analysis;
by ucounty;
proc transpose data=analysis out=cash;
by ucounty;
var pct_cash:;
run;
data mris_cash (drop=_name_ _label_);
	set cash;
year=substr(_name_,9,4);
rename col1=pct_cash;
run;
proc transpose data=analysis out=ftype_other;
by ucounty;
var pct_ftype_other:;
run;
data mris_ftype_other (drop=_name_ _label_);
	set ftype_other;
year=substr(_name_,16,4);
rename col1=pct_ftype_other;
run;
proc transpose data=analysis out=conv;
by ucounty;
var pct_conv:;
run;
data mris_conv (drop=_name_ _label_);
	set conv;
year=substr(_name_,9,4);
rename col1=pct_conv;
run;
proc transpose data=analysis out=fha_va;
by ucounty;
var pct_fha_va:;
run;
data mris_fha_va (drop=_name_ _label_);
	set fha_va;
year=substr(_name_,11,4);
rename col1=pct_fha_va;
run;
data financing;
merge mris_cash mris_conv mris_fha_va mris_ftype_other;
by ucounty year;
run;

filename outexc dde "Excel|D:\DCDATA\Libraries\MRIS\Prog\[MD vs VA Analysis.xlsx]Financing!R4C3:R75C6";

data _null_ ;
	file outexc lrecl=65000;
	set financing;

	put pct_cash pct_conv pct_fha_va pct_ftype_other;

	run;
