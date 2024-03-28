/************************************************************************
 Program:  MRIS_RBI_ZIP_2014_04.sas
 Library:  MRIS
 Project:  DC Data Warehouse
 Author:   S Zhang
 Created:  5/16/2014
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Read data received from RBI.
			   http://www.rbintel.com/statistics
	       Revisions1 is for the month file and revisions2 is for the file with all years & months.

 Modifications: 
				

************************************************************************/
%include "L:\SAS\Inc\StdLocal.sas";

%dcdata_lib( MRIS )

**** User parameters ****;

options nomprint nosymbolgen;

%read_mris_rbi_zip_update(
 year = 2014,
 file_date = 2014_04,
 raw_month = 201404, 
 finalize = Y, 
 revisions1 = New file.,
 revisions2 = .
 
 )

 run;

