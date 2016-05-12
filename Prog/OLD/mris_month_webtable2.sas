** program name:mris_month_webtable2.sas
** previous program name: mris_month_webtable.sas
** following program name:
** project name: HNC
** Description:  This program prepares the MONTHLY MRIS data for the metro area by subarea and county to output to web tables**
mris_month_webtable.sas was created earlier that has calculations and output 
** Date Created: 9-6-09
** Updated: 
** ksp
***********************************************;

*lhendey libnames;
libname hnc "D:\Data Sets\MRIS\Data\mris";

*kpettit libnames;
*libname hnc 'd:\hnc2009\mris';

%include 'k:\metro\kpettit\hnc2009\programs\hncformats.sas';

filename uiautos "K:\Metro\PTatian\UISUG\Uiautos";
options sasautos=(uiautos sasautos);

proc sort data=hnc.mris199701_200909;
	by uiorder ucounty;
	run;
*from mris_month_webtable2.sas;
%macro outmris(var,tab);
filename outexc dde "Excel|k:\metro\kpettit\hnc2009\web2009\[hnc_2009_appendix_e.xls]e&tab.!R7c3:R38C160" ;
data _null_ ;
	file outexc lrecl=65000;
	set hnc.mris199701_200909; ;
	put ucounty    &var.1997m01 - &var.1997m12  &var.1998m01 - &var.1998m12
				 &var.1999m01 - &var.1999m12
				 &var.2000m01 - &var.2000m12
				&var.2001m01 - &var.2001m12
				&var.2002m01 - &var.2002m12
				 &var.2003m01 - &var.2003m12
				&var.2004m01 - &var.2004m12
				&var.2005m01 - &var.2005m12
				 &var.2006m01 - &var.2006m12
				&var.2007m01 - &var.2007m12
				&var.2008m01 - &var.2008m12
				&var.2009m01 - &var.2009m09;
	if _n_ in (1,2,5,11,20,30) then put;  
	run;
%mend;
%outmris(list_tot,11);
%outmris(list_sf,12);
%outmris(list_condor,13);
%outmris(inv,14);
%outmris(newlist,15);
%outmris(numsale,16);
%outmris(sales_sf,17);
%outmris(sales_condor,18);
%outmris(avgdays,19 );	
%outmris(wgtsale,20);
*21 should be infl adjusted sales*;
%outmris(wgtsaleR,21);
/*skip

%outmris(saletolist);
%outmris(avgsale);
%outmris(medsale);*/
