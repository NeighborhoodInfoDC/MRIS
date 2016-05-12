/************************************************************************
 Program:  MRIS_RBI_2013_08.sas
 Library:  MRIS
 Project:  DC Data Warehouse
 Author:   S Zhang
 Created:  03/04/2014
 Version:  SAS 9.1
 Environment:  Local Windows session (desktop)
 
 Description:  Read data received from RBI . First file will be 2013_08.
			   http://www.rbintel.com/statistics
	       Revisions1 is for the month file and revisions2 is for the file with all years & months.

 Modifications: 

************************************************************************/


%include "L:\SAS\Inc\StdLocal.sas";

%dcdata_lib( MRIS )

**** User parameters ****;

options nomprint nosymbolgen;

%read_mris_rbi_cnty_update(
 year = 2013,
 file_date = 2013_08,
 raw_month = 201308, 
 finalize = Y, 
 revisions1 = New file.,
 revisions2 = Updated with August 2013 .
 
 )

 

