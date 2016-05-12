/**************************************************************************
 Program:  Update Metadata MRIS Cat.sas
 Library:  MRIS
 Project:  NeighborhoodInfo DC
 Author:   L Hendey
 Created:  10/01/10
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Register the MRIScat files with metadata and reassigns ucounty format;

*************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( MRIS )


%let year=2008 2009;
%let month=01 02 03 04 05 06 07 08 09 10 11 12;

%syslput year=&year.;
%syslput month=&month.;




%macro fixmeta;
%do i=1 %to 2;
	%let yr=%scan(&year.,&i.," ");

	%do j=1 %to 12;
		%let mo=%scan(&month.,&j.," ");	
		
		
		%syslput yr=&yr.;
		%syslput mo=&mo.;
		
data mris.Mriscat30_500_cnty_&yr._&mo. (label="MRIS County Sales Data by Price Class, &yr._&mo.");
	set mris.Mriscat30_500_cnty_&yr._&mo.;

format ucounty $cnty99f. ;
run;


** Start submitting commands to remote server **;

rsubmit;

proc upload data=mris.Mriscat30_500_cnty_&yr._&mo. out=mris.Mriscat30_500_cnty_&yr._&mo.;
run;
   x "purge [dcdata.mris.data]Mriscat30_500_cnty_&yr._&mo..*";


%Dc_update_meta_file(
  ds_lib=MRIS,
  ds_name=Mriscat30_500_cnty_&yr._&mo.,
  creator_process=MRIS_&yr..sas,
  restrictions=None,
  revisions=%str(Revised County format.)
) 

run;

endrsubmit;
** End submitting commands to remote server **;

run;
%end;
%end;

%mend;
%fixmeta;
signoff;
