/************************************************************************
 Program:  MRIS_RBI_ZIP_2013_11.sas
 Library:  MRIS
 Project:  DC Data Warehouse
 Author:   S Zhang
 Created:  03/07/2014
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
 year = 2013,
 file_date = 2013_11,
 raw_month = 201311, 
 finalize = Y, 
 revisions1 = New file.,
 revisions2 = Updated with November 2013. 
 
 )

 run;

