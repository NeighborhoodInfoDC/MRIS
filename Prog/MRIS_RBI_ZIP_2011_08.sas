/************************************************************************
 Program:  MRIS_RBI_ZIP_2011.sas
 Library:  MRIS
 Project:  DC Data Warehouse
 Author:   L. Hendey
 Created:  7/12/2011
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Read data received from RBI (based on 7/11 files). First file will be 2011_07.
			   http://www.rbintel.com/statistics
	       Revisions1 is for the month file and revisions2 is for the file with all years & months.

 Modifications: 09/02/11 LH: Updated with 2011_07. 
				09/08/11 LH: Modified to use with ZIP.
				10/11/11 SL: Updated with 2011_08

************************************************************************/


%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


%dcdata_lib( MRIS )

**** User parameters ****;

options nomprint nosymbolgen;

%read_mris_rbi_zip_update(
 year = 2011,
 file_date = 2011_08,
 raw_month = 201108, 
 finalize = Y, 
 revisions1 = New file.,
 revisions2 = Updated with August 2011. 
 
 )

 run;

