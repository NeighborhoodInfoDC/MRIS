/************************************************************************
 Program:  MRIS_RBI_2012_02.sas
 Library:  MRIS
 Project:  DC Data Warehouse
 Author:   R. Grace
 Created:  03/30/2012
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Read data received from RBI (based on 01/12 files). First file will be 2012/01.
			   http://www.rbintel.com/statistics
	       Revisions1 is for the month file and revisions2 is for the file with all years & months.

 Modifications:  05/08/12 RAG Re-ran with completed data.

************************************************************************/


%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


%dcdata_lib( MRIS )

**** User parameters ****;

options nomprint nosymbolgen;

%read_mris_rbi_cnty_update(
 year = 2012,
 file_date = 2012_02,
 raw_month = 201202, 
 finalize = Y, 
 revisions1 = New file.,
 revisions2 = Updated with February 2012. 
 
 )

 run;

