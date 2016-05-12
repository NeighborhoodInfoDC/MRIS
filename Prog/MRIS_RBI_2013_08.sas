/************************************************************************
 Program:  MRIS_RBI_2013_08.sas
 Library:  MRIS
 Project:  DC Data Warehouse
 Author:   R Grace
 Created:  10/09/2013
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Read data received from RBI (based on 7/11 files). First file will be 2011_07.
			   http://www.rbintel.com/statistics
	       Revisions1 is for the month file and revisions2 is for the file with all years & months.

 Modifications: 

************************************************************************/


%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;


%dcdata_lib( MRIS )

**** User parameters ****;

options nomprint nosymbolgen;

%read_mris_rbi_cnty_update(
 year = 2013,
 file_date = 2013_08,
 raw_month = 201308, 
 finalize = N, 
 revisions1 = New file.,
 revisions2 = Updated with August 2013. 
 
 )

 run;

