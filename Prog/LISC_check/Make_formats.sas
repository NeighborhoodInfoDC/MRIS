/**************************************************************************
 Program:  Make_formats.sas
 Library:  LPS
 Project:  NeighborhoodInfo DC
 Author:   L Hendey
 Created:  03/26/10
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create formats for MRIS data.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( MRIS )

proc format library=MRIS;

value $grade
'Prime'='Prime'
'Government'='Government'
'Subprime'='Subprime'
'AltA'='AltA'
/*'Other'='Other'*/;

value $clusnm

'99'  =  'No cluster'
'29'  =  'Eastland Gardens'
'30'  =  'Mayfair'
'31'  =  'Deanwood'
'33'  =  'Capitol View'
'34'  =  'Twining'
'36'  =  'Woodland'
'38'  =  'Douglass'
'39'  =  'Congress Heights'
'23'  =  'Ivy City'
'28'  =  'Anacostia'
'32'  =  'River Terrace'
'37'  =  'Sheridan'
'21'  =  'Edgewood'
'25'  =  'Union Station'
'27'  =  'Near Southeast'
'02'  =  'Mt. Pleasant'
'07'  =  'Logan Circle'
'17'  =  'Takoma'
'18'  =  'Brightwood Park'
'19'  =  'Lamond Riggs'
'20'  =  'North Michigan Park'
'22'  =  'Brookland'
'24'  =  'Woodridge'
'35'  =  'Fairfax Village'
'09'  =  'SW Employment Area'
'14'  =  'Cathedral Heights'
'05'  =  'West End'
'01'  =  'Kalorama Heights'
'06'  =  'Dupont Circle'
'08'  =  'Downtown'
'26'  =  'Capitol Hill'
'03'  =  'Howard University'
'10'  =  'Hawthorne'
'11'  =  'Friendship Heights'
'12'  =  'N. Cleveland Park'
'13'  =  'Spring Valley'
'15'  =  'Cleveland Park'
'16'  =  'Colonial Village'
'04'  =  'Georgetown' 
'98' = 	'Ungeocoded'
 ;

value price

0= "District of Columbia"
1= "Lower price 1994 ($69,000-$105,000)"
2= "Medium price 1994 ($105,000-$200,000)"
3= "Higher price 1994 ($200,000-$320,000)"
4= "Predominantly multifamily ($97,000-$202,000)"
9= "No cluster"
;

value cltype
1 = "Moderate growth 1999-2004"
2 = "Rapid growth 1999-2004"
3 = "Very rapid growth 1999-2004"
4 = "Moderate/rapid growth 1999-2004"
5 = "Very rapid growth 1999-2004"
6 = "Moderate/rapid growth 1999-2004"
7 = "Predominantly multifamily (73%+)"
9 = "No Cluster";

value $ziptype
'0' = 'District of Columbia'
'1_2' = 'East of River'
'3_7' = 'City Core'
'4' = 'Upper Northeast'
'8' = 'Upper Northwest'
'9C' = 'Colleges'
'9X' = 'Other'
'9U' = 'Organization zips'
'9PO' = 'P.O. Boxes';

value $cntynm

'11001' ='District of Columbia'
'51013'	='Arlington County, VA'
'51510'	='Alexandria city, VA'
'24031'	='Montgomery County, MD'
'24033'	="Prince George's County, MD"
'51059'	='Fairfax County, VA'
'51600'	='Fairfax city, VA'
'51610'	='Falls Church city, VA'
'24009'	='Calvert County, MD'
'24017'	='Charles County, MD'
'24021'	='Frederick County, MD'
'51107'	='Loudoun County, VA'
'51153'	='Prince William County, VA'
'51179'	='Stafford County, VA'
'51683'	='Manassas city, VA'
'51685'	='Manassas Park city, VA'
'51043'	='Clarke County, VA'
'51061'	='Fauquier County, VA'
'51177'	='Spotsylvania County, VA'
'51187'	='Warren County, VA'
'51630'	='Fredericksburg city, VA'
'54037'	='Jefferson County, WV';

value reo

1="Minimal REO Risk"
2="Moderate REO Risk"
3="High REO Risk"
4="Highest REO Risk"
;

value chgI

1="Now High or Highest Risk"
2="Now Minimal or Moderate Risk";

value chgII
1="Minimal"
2="Moderate"
3="High"
4="Highest"
;

value pricecat
1="Under $30,000"
2="$30,000-$39,000"
3="$40,000-$49,999"
4="$50,000-$59,999"
5="$60,000-$69,999"
6="$70,000-$79,999"
7="$80,000-$89,999"
8="$90,000-$99,999"
9="$100,000-$119,999"
10="$120,000-$139,999"
11="$140,000-$159,999"
12="$160,000-$179,999"
13="$180,000-$199,999"
14="$200,000-$249,999"
15="$250,000-$299,999"
16="$300,000-$399,999"
17="$400,000-$499,999"
18="Over $500,000"
19="Totals"
;

run;
