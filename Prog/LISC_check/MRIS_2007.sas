/**************************************************************************
 Program:  MRIS_2007.sas
 Library:  MRIS
 Project:  NeighborhoodInfo DC
 Author:   L. Hendey
 Created:  09/27/10
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Read MRIS data for 2007

 Modifications: 
**************************************************************************

FILE NOTES:

*Note for 2009m10 - Prince George's has inconsistent total numbers so fails one of the tests: only 1 off 709/710 and -1 under unknown financing; 
*Note for 2009m06 - DC has inconsistent total numbers so fails one of the tests: only 1 off 612/613 and -1 under unknown financing;
*Note for 2006m04 - Fairfax county has inconsistent total numbers so fails one of the tests:  only 1 off 1411/1412;
*Note for 2003m06 - DC has inconsistent total numbers so fails one of the tests:  only 1 off 816/817;
*Note for 2000m09 - Mont has inconsistent total numbers so fails one of the tests:  only 1 off 1175/1176;
*Note for 1999m01 and 1999m02 - 51043 (Clarke County, VA), 51187 (Warren County, VA);
*Note for 1999m07 - 51630 (fred city, va) has inconsistent total numbers so fails one of the tests:  only 1 off 25/26;
*Note for 1997m12 - Mont has inconsistent total numbers so fails one of the tests:  only 1 off 855/854;
*Note for 1998m10 - DC has inconsistent total numbers so fails one of the tests:  only 1 off 620/621;
*Note for 1997/1998 - missing many counties;
*****************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( MRIS )

options nomprint nosymbolgen;

%Read_mris_month_county(
  finalize= Y,
  year = 2007,
  st_mo = 1,
  end_mo = 12,
  geog=cnty,
  revisions = New File.
   )

run;


