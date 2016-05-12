/*%let files  =?alex?dc?arl?mont?pg?fairfax?fairfax city?falls church?
			calvert?charles?frederick?loudoun county?prince william?stafford?manassas city?man park?
			clarke?fauquier?spots?warren?fred city?jeff?;*/

%let files = 
RETI_Washington_DC
RETI_Alexandria_City_VA
RETI_Arlington_County_VA
RETI_Montgomery_County_MD
RETI_Prince_Georges_County_MD
RETI_Fairfax_County_VA
RETI_Fairfax_City_VA
RETI_Falls_Church_City_VA
RETI_Calvert_County_MD
RETI_Charles_County_MD
RETI_Frederick_County_MD
RETI_Loudoun_County_VA
RETI_Prince_William_County_VA
RETI_Stafford_County_VA
RETI_Manassas_City_VA
RETI_Manassas_Park_City_VA
RETI_Clarke_County_VA
RETI_Fauquier_County_VA
RETI_Spotsylvania_County_VA
RETI_Warren_County_VA
RETI_Fredericksburg_City_VA
RETI_Jefferson_County_West_Virginia;


%macro filenm1;
/***summary indicators*/
filename xlsFilei dde "&excname.&excsheet.!R53C2:R53C2" notab lrecl=1000;

filename xlsFileA dde "&excname.&excsheet.!R56C2:R56C3" notab lrecl=1000;/*Total Sold Dollar Volume*/
filename xlsFileb dde "&excname.&excsheet.!R57C2:R57C3" notab lrecl=1000;/*Average Sold Price:  */
filename xlsFilec dde "&excname.&excsheet.!R58C2:R58C3" notab lrecl=1000;/*Median Sold Price:  */
filename xlsFiled dde "&excname.&excsheet.!R59C2:R59C3" notab lrecl=1000;/*Total Units Sold:  */
filename xlsFilee dde "&excname.&excsheet.!R60C2:R60C3" notab lrecl=1000;/*Average Days on Market:  */
filename xlsFilef dde "&excname.&excsheet.!R61C2:R61C3" notab lrecl=1000;/*Average List Price:  */
filename xlsFileg dde "&excname.&excsheet.!R62C2:R62C3" notab lrecl=1000;/*sales to list:  */

filename xlsFile1 dde "&excname.&excsheet.!R57C6:R57C6" notab lrecl=1000;/*Total NEW listings:*/
filename xlsFile2 dde "&excname.&excsheet.!R60C6:R60C6" notab lrecl=1000;/*Total Properties Marked Contract */
filename xlsFile3 dde "&excname.&excsheet.!R63C6:R63C6" notab lrecl=1000;/*Total Properties Marked Contingent Contract  */
filename xlsFile4 dde "&excname.&excsheet.!R66C6:R66C6" notab lrecl=1000;/*Total NEW pendings (Contracts + Contingents) */
filename xlsFile5 dde "&excname.&excsheet.!R53C6:R53C6" notab lrecl=1000;/*Total Active listings-added 7/21/09 */

filename xlsFilej dde "&excname.&excsheet.!R14c10:R14c10" notab lrecl=1000;/*1 - 30 Days   */
filename xlsFilek dde "&excname.&excsheet.!R16c10:R16c10" notab lrecl=1000;/*31-60 Days*/
filename xlsFilel dde "&excname.&excsheet.!R18c10:R19c10" notab lrecl=1000;/*61 - 90 Days */
filename xlsFilem dde "&excname.&excsheet.!R20c10:R20c10" notab lrecl=1000;/*91-120 Days */
filename xlsFilen dde "&excname.&excsheet.!R22c10:R22c10" notab lrecl=1000;/*Over 120 Days */
												     	     
filename xlsFileO dde "&excname.&excsheet.!R33c10:R33c10" notab lrecl=1000;/*Conventional :  */
filename xlsFileP dde "&excname.&excsheet.!R35c10:R35c10" notab lrecl=1000;/*FHA :  */
filename xlsFileQ dde "&excname.&excsheet.!R37c10:R37c10" notab lrecl=1000;/*VA :  */
filename xlsFileR dde "&excname.&excsheet.!R39c10:R39c10" notab lrecl=1000;/*Assumption :  */
filename xlsFileS dde "&excname.&excsheet.!R41c10:R41c10" notab lrecl=1000;/*Cash :  */
filename xlsFileT dde "&excname.&excsheet.!R43c10:R43c10" notab lrecl=1000;/*Owner Finance :  */
filename xlsFileU dde "&excname.&excsheet.!R45c10:R45c10" notab lrecl=1000;/*All Other :  */
filename xlsFileV dde "&excname.&excsheet.!R47c10:R47c10" notab lrecl=1000;/*Unreported :  */

/*read in price categories, sales and listings*/

*could change to read in totals;
filename xlsFileh dde "&excname.&excsheet.!R14C1:R51C7" notab lrecl=1000;

%mend;



%macro filenmz(sep);
/***summary indicators*/
filename xlsFilei dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R50C2:R50C2" notab lrecl=1000;

filename xlsFileA dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R54C2:R54C3" notab lrecl=1000;/*Total Sold Dollar Volume*/
filename xlsFileb dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R55C2:R55C3" notab lrecl=1000;/*Average Sold Price:  */
filename xlsFilec dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R56C2:R56C3" notab lrecl=1000;/*Median Sold Price:  */
filename xlsFiled dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R57C2:R57C3" notab lrecl=1000;/*Total Units Sold:  */
filename xlsFilee dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R58C2:R58C3" notab lrecl=1000;/*Average Days on Market:  */
filename xlsFilef dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R59C2:R59C3" notab lrecl=1000;/*Average List Price:  */
filename xlsFileg dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R60C2:R60C3" notab lrecl=1000;/*sales to list:  */

filename xlsFile1 dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R53C6:R53C6" notab lrecl=1000;/*Total NEW listings:*/
filename xlsFile2 dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R54C6:R54C6" notab lrecl=1000;/*Total Properties Marked Contract */
filename xlsFile3 dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R55C6:R55C6" notab lrecl=1000;/*Total Properties Marked Contingent Contract  */
filename xlsFile4 dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R56C6:R56C6" notab lrecl=1000;/*Total NEW pendings (Contracts + Contingents) */
filename xlsFile5 dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R53C6:R53C6" notab lrecl=1000;/*Total Active listings-added 7/21/09 */

filename xlsFilej dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R13c12:R13c12" notab lrecl=1000;/*1 &sep. 30 Days   */
filename xlsFilek dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R15c12:R15c12" notab lrecl=1000;/*31&sep.60 Days*/
filename xlsFilel dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R17c12:R17c12" notab lrecl=1000;/*61 &sep. 90 Days */
filename xlsFilem dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R19c12:R19c12" notab lrecl=1000;/*91&sep.120 Days */
filename xlsFilen dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R21c12:R21c12" notab lrecl=1000;/*Over 120 Days */
												     	     
filename xlsFileO dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R32c12:R32c12" notab lrecl=1000;/*Conventional :  */
filename xlsFileP dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R34c12:R34c12" notab lrecl=1000;/*FHA :  */
filename xlsFileQ dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R36c12:R36c12" notab lrecl=1000;/*VA :  */
filename xlsFileR dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R38c12:R38c12" notab lrecl=1000;/*Assumption :  */
filename xlsFileS dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R40c12:R40c12" notab lrecl=1000;/*Cash :  */
filename xlsFileT dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R42c12:R42c12" notab lrecl=1000;/*Owner Finance :  */
filename xlsFileU dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R44c12:R44c12" notab lrecl=1000;/*All Other :  */
filename xlsFileV dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R46c12:R46c12" notab lrecl=1000;/*Unreported :  */

/*read in price categories*/

filename xlsFileh dde "excel|&path[&filecode.&sep.&month.&sep.01&sep.&year..xls]&filecode.&sep.&month.&sep.01&sep.&year.!R13C1:R49C9" notab lrecl=1000;

%mend;

%macro inf_sum;
infile xlsFileA missover dsd dlm = '09'x  ;
input aggsale&year.m&month.:comma12.
		aggsale&oldyear.m&month.:comma12.  ;

infile xlsFileB missover dsd dlm = '09'x ;
input avgsale&year.m&month.:comma12.
		avgsale&oldyear.m&month.:comma12.  ;

infile xlsFilec missover dsd dlm = '09'x ;
input medsale&year.m&month.:comma12.
		medsale&oldyear.m&month.:comma12.  ;

infile xlsFiled missover dsd dlm = '09'x ;
input numsale&year.m&month.:comma12.
		numsale&oldyear.m&month.:comma12.  ;

infile xlsFilee missover dsd dlm = '09'x ;
input avgdays&year.m&month.:comma12.
		avgdays&oldyear.m&month.:comma12.  ;

infile  xlsFilef missover dsd dlm = '09'x ;
input avglist&year.m&month.:comma12.
		avglist&oldyear.m&month.:comma12.  ;

infile  xlsFilei missover dsd dlm = '09'x ;
input sales&year.m&month.:comma12.;


infile xlsFile1 missover dsd dlm = '09'x  ;
input newlist&year.m&month.:comma12. ;

infile xlsFile2 missover dsd dlm = '09'x ;
input contract&year.m&month.:comma12.  ;

infile xlsFile3 missover dsd dlm = '09'x ;
input contingent&year.m&month.:comma12. ;

infile xlsFile4 missover dsd dlm = '09'x ;
input newpend&year.m&month.:comma12. ;

infile xlsFile5 missover dsd dlm = '09'x ;
input list_tot&year.m&month.:comma12. ;

infile xlsFilej missover dsd dlm = '09'x missover ;
input days30_&year.m&month.:comma12.;
infile xlsFilek missover dsd dlm = '09'x missover ;
input days60_&year.m&month.:comma12.;
infile xlsFilel missover dsd dlm = '09'x missover ;
input days90_&year.m&month.:comma12.;
infile xlsFilem missover dsd dlm = '09'x missover ;
input days120_&year.m&month.:comma12.;
infile xlsFilen missover dsd dlm = '09'x missover ;
input days120p_&year.m&month.:comma12.;
infile xlsFileo missover dsd dlm = '09'x missover ;
input mortconv&year.m&month.:comma12.;
infile xlsFilep missover dsd dlm = '09'x missover ;
input mortfha&year.m&month.:comma12.;
infile xlsFileq missover dsd dlm = '09'x  ;
input mortva&year.m&month.:comma12.;
infile xlsFiler missover dsd dlm = '09'x  ;
input mortass&year.m&month.:comma12.;
infile xlsFiles missover dsd dlm = '09'x  ;
input mortcash&year.m&month.:comma12.;
infile xlsFilet missover dsd dlm = '09'x  ;
input mortown&year.m&month.:comma12.;
infile xlsFileu missover dsd dlm = '09'x  ;
input mortoth&year.m&month.:comma12.;
infile xlsFilev missover dsd dlm = '09'x  ;
input mortunk&year.m&month.:comma12.;

infile xlsFileg missover dsd dlm = '09'x  ;
input saletolist&year.m&month.:comma12.
		saletolist&oldyear.m&month.:comma12. ;
%mend;

%macro inf_sales;
infile xlsFileh   dsd dlm = '09'x ;

input 
pricecat:
sales_bed2 :comma12.
sales_bed3 :comma12.
sales_bed4 :comma12.
sales_condor: comma12.
list_sf :comma12. /*listed as "residential"_assuming it is SF*/
list_condor :comma12.;
if pricecat = '' then delete;

%mend;

%macro inf_salez;
infile xlsFileh   dsd dlm = '09'x ;

input 
pricecat:
sales_bed2 :comma12.
sales_bed3 :comma12.
sales_bed4 :comma12.
sales_condo:comma12.
sales_grent:comma12.
list_sf :comma12. /*listed as "residential"_assuming it is SF*/
list_condo :comma12.
list_grent:comma12.;
if pricecat = '' then delete;

%mend;

%macro labelsum;

label

aggsale&year.m&month. 	= "Total Sold Dollar Volume"
avgsale&year.m&month. 	= "Average Sold Price"
medsale&year.m&month. 	= "Median Sold Price"
numsale&year.m&month. 	= "Total Units Sold"

avgdays&year.m&month. 	= "Average Days on Market"
totdays&year.m&month. 	= "Aggregate Days on Market"
avglist&year.m&month. 	= "Average List Price"
saletolist&year.m&month.= "Ratio of sales to list price"

newlist&year.m&month.    = "Total NEW listings"
contract&year.m&month.   = "Total Properties Marked Contract"
contingent&year.m&month. = "Total Properties Marked Contingent Contract"
newpend&year.m&month.	 = "Total NEW pendings (Contracts + Contingents)"
list_tot&year.m&month.   	= "Active listings, sales"

sales&year.m&month.	 = "Sales from price categories - just for testing"


days30_&year.m&month.   = "Time on Market for Sales: 1 - 30 Days"
days60_&year.m&month.   = "Time on Market for Sales: 31-60 Days"
days90_&year.m&month.   = "Time on Market for Sales: 61 - 90 Days"
days120_&year.m&month.  = "Time on Market for Sales: 91-120 Days"
days120p_&year.m&month.	= "Time on Market for Sales: Over 120 Days"


pdays30_&year.m&month.   = "Pct of sales with time on market: 1 - 30 days"
pdays60_&year.m&month.   = "Pct of sales with time on market: 31-60 days"
pdays90_&year.m&month.   = "Pct of sales with time on market: 61 - 90 days"
pdays120_&year.m&month.  = "Pct of sales with time on market: 91-120 days"
pdays120p_&year.m&month.	= "Pct of sales with time on market: Over 120 days"


mortconv&year.m&month.  = "Type of financing for sales: Conventional"
mortfha&year.m&month.	= "Type of financing for sales: FHA "
mortva&year.m&month.	= "Type of financing for sales: VA "
mortass&year.m&month.	= "Type of financing for sales: Assumption "
mortcash&year.m&month.	= "Type of financing for sales: Cash "
mortown&year.m&month. 	= "Type of financing for sales: Owner Finance "
mortoth&year.m&month.	= "Type of financing for sales: All Other "
mortunk&year.m&month. 	= "Type of financing for sales: Unreported " 

aggsale&oldyear.m&month. 	= "Total Sold Dollar Volume"
avgsale&oldyear.m&month. 	= "Average Sold Price"
medsale&oldyear.m&month. 	= "Median Sold Price"
numsale&oldyear.m&month. 	= "Total Units Sold"
avgdays&oldyear.m&month. 	= "Average Days on Market"
totdays&oldyear.m&month. 	= "Aggregate Days on Market"
avglist&oldyear.m&month. 	= "Average List Price"
saletolist&oldyear.m&month.	= "Ratio of sales to list price"  
cntyname = "County name"
;

%mend;

%macro labelcat;
label 
pricecat 	= "Price Class"
sales_bed2 	= "Sales, 2 bedroom or less"
sales_bed3 	= "Sales, 3 bedroom "
sales_bed4 	= "Sales, 4+ bedroom	"
sales_condor 	= "Sales, Condo, coop, ground rent "
sales_sf    	= "Sales, single-family homes"
sales_tot   	= "Sales, total"
list_condor 	= "Active listings, condos/coops"
list_sf  	= "Active listings, single-family"
list_tot   	= "Active listings, sales"
cntyname = "County name"
label ucounty = 'County Fips, SSCCC';
%mend;


		
