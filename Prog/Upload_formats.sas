/**************************************************************************
 Program:  Upload_formats.sas
 Library:  MRIS
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  11/13/07
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload formats to Alpha.

 Modifications: 09/27/10 L Hendey Modified for MRIS Library
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( MRIS )

** Start submitting commands to remote server **;

rsubmit;

proc upload status=no
  inlib=MRIS 
  outlib=MRIS memtype=(catalog);
  select formats;
run;

proc catalog catalog=MRIS.Formats;
  contents;
quit;

run;

endrsubmit;

** End submitting commands to remote server **;

run;

signoff;
