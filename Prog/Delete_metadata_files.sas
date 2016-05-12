/**************************************************************************
 Program:  Delete_metadata_files.sas
 Library:  Metadata
 Project:  DC Data Warehouse
 Author:   P. Tatian
 Created:  12/30/04
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Delete files from metadata system.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

/** Macro DC_delete_meta_file - Start Definition **/

rsubmit;

%macro DC_delete_meta_file( 
         ds_lib= ,
         ds_name= ,
);

  %Delete_metadata_file(  
         ds_lib=&ds_lib,
         ds_name=&ds_name,
         meta_lib=metadat,
         meta_pre= meta,
         update_notify=
  )

  ** Purge extra copies of metadata files **;

  x "purge /keep=2 [&_dcdata_path..metadata.data]meta*.*";

%mend DC_delete_meta_file;

/** End Macro Definition **/

run;

endrsubmit;



** Delete files from metadata system **;

rsubmit;

%macro mris;

%do j = 1999 %to 2010;
 %let year = &j.;
 /*cycle through months*/
	 %do m = 1 %to 12;
	 	%if &m<10 %then %let month = 0&m.;
	 	%else %let month = &m. ;
 
%DC_delete_meta_file( ds_lib=MRIS , ds_name=Mriscat30_500_cnty_&year._&month. )

run;

%DC_delete_meta_file( ds_lib=MRIS , ds_name= Mris_cnty_&year._&month. )

run; 
%end;
%end;


%DC_delete_meta_file( ds_lib=MRIS , ds_name=Rbi_1999_01_2011_06  )


%DC_delete_meta_file( ds_lib=MRIS , ds_name=Rbi_1999_01_2011_07 )

run;

%mend;

%mris;
endrsubmit;

signoff;
