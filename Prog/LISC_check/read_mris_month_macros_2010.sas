/*%let files  =?alex?dc?arl?mont?pg?fairfax?fairfax city?falls church?
			calvert?charles?frederick?loudoun county?prince william?stafford?manassas city?man park?
			clarke?fauquier?spots?warren?fred city?jeff?;*/

%let area = 
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


%macro filenm1;  /*this is the county macro*/
/***summary indicators*/
filename xlsFilei dde "&excname.&excsheet.!R55C2:R55C2" notab lrecl=1000;

filename xlsFileA dde "&excname.&excsheet.!R58C2:R58C3" notab lrecl=1000;/*Total Sold Dollar Volume*/
filename xlsFileb dde "&excname.&excsheet.!R59C2:R59C3" notab lrecl=1000;/*Average Sold Price:  */
filename xlsFilec dde "&excname.&excsheet.!R60C2:R60C3" notab lrecl=1000;/*Median Sold Price:  */
filename xlsFiled dde "&excname.&excsheet.!R61C2:R61C3" notab lrecl=1000;/*Total Units Sold:  */
filename xlsFilee dde "&excname.&excsheet.!R62C2:R62C3" notab lrecl=1000;/*Average Days on Market:  */
filename xlsFilef dde "&excname.&excsheet.!R63C2:R63C3" notab lrecl=1000;/*Average List Price:  */
filename xlsFileg dde "&excname.&excsheet.!R64C2:R64C3" notab lrecl=1000;/*sales to list:  */

filename xlsFile1 dde "&excname.&excsheet.!R59C6:R59C6" notab lrecl=1000;/*Total NEW listings:*/
filename xlsFile2 dde "&excname.&excsheet.!R62C6:R62C6" notab lrecl=1000;/*Total Properties Marked Contract */
filename xlsFile3 dde "&excname.&excsheet.!R65C6:R65C6" notab lrecl=1000;/*Total Properties Marked Contingent Contract  */
filename xlsFile4 dde "&excname.&excsheet.!R68C6:R68C6" notab lrecl=1000;/*Total NEW pendings (Contracts + Contingents) */
filename xlsFile5 dde "&excname.&excsheet.!R55C6:R55C6" notab lrecl=1000;/*Total Active listings-added 7/21/09 */

filename xlsFilej dde "&excname.&excsheet.!R16c10:R16c10" notab lrecl=1000;/*1 - 30 Days   */
filename xlsFilek dde "&excname.&excsheet.!R18c10:R18c10" notab lrecl=1000;/*31-60 Days*/
filename xlsFilel dde "&excname.&excsheet.!R20c10:R20c10" notab lrecl=1000;/*61 - 90 Days */
filename xlsFilem dde "&excname.&excsheet.!R22c10:R22c10" notab lrecl=1000;/*91-120 Days */
filename xlsFilen dde "&excname.&excsheet.!R24c10:R24c10" notab lrecl=1000;/*Over 120 Days */
												     	     
filename xlsFileO dde "&excname.&excsheet.!R35c10:R35c10" notab lrecl=1000;/*Conventional :  */
filename xlsFileP dde "&excname.&excsheet.!R37c10:R37c10" notab lrecl=1000;/*FHA :  */
filename xlsFileQ dde "&excname.&excsheet.!R39c10:R39c10" notab lrecl=1000;/*VA :  */
filename xlsFileR dde "&excname.&excsheet.!R41c10:R41c10" notab lrecl=1000;/*Assumption :  */
filename xlsFileS dde "&excname.&excsheet.!R43c10:R43c10" notab lrecl=1000;/*Cash :  */
filename xlsFileT dde "&excname.&excsheet.!R45c10:R45c10" notab lrecl=1000;/*Owner Finance :  */
filename xlsFileU dde "&excname.&excsheet.!R47c10:R47c10" notab lrecl=1000;/*All Other :  */
filename xlsFileV dde "&excname.&excsheet.!R49c10:R49c10" notab lrecl=1000;/*Unreported :  */

/*read in price categories, sales and listings*/

*could change to read in totals;
filename xlsFileh dde "&excname.&excsheet.!R16C1:R53C7" notab lrecl=1000;

%mend;



%macro filenmz(sep); /*this is the ZIP code macro*/
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
input aggsale&year._&month.:comma12.
		aggsale&oldyear._&month.:comma12.  ;

infile xlsFileB missover dsd dlm = '09'x ;
input avgsale&year._&month.:comma12.
		avgsale&oldyear._&month.:comma12.  ;

infile xlsFilec missover dsd dlm = '09'x ;
input medsale&year._&month.:comma12.
		medsale&oldyear._&month.:comma12.  ;

infile xlsFiled missover dsd dlm = '09'x ;
input numsale&year._&month.:comma12.
		numsale&oldyear._&month.:comma12.  ;

infile xlsFilee missover dsd dlm = '09'x ;
input avgdays&year._&month.:comma12.
		avgdays&oldyear._&month.:comma12.  ;

infile  xlsFilef missover dsd dlm = '09'x ;
input avglist&year._&month.:comma12.
		avglist&oldyear._&month.:comma12.  ;

infile  xlsFilei missover dsd dlm = '09'x ;
input sales&year._&month.:comma12.;


infile xlsFile1 missover dsd dlm = '09'x  ;
input newlist&year._&month.:comma12. ;

infile xlsFile2 missover dsd dlm = '09'x ;
input contract&year._&month.:comma12.  ;

infile xlsFile3 missover dsd dlm = '09'x ;
input contingent&year._&month.:comma12. ;

infile xlsFile4 missover dsd dlm = '09'x ;
input newpend&year._&month.:comma12. ;

infile xlsFile5 missover dsd dlm = '09'x ;
input list_tot&year._&month.:comma12. ;

infile xlsFilej missover dsd dlm = '09'x missover ;
input days30_&year._&month.:comma12.;
infile xlsFilek missover dsd dlm = '09'x missover ;
input days60_&year._&month.:comma12.;
infile xlsFilel missover dsd dlm = '09'x missover ;
input days90_&year._&month.:comma12.;
infile xlsFilem missover dsd dlm = '09'x missover ;
input days120_&year._&month.:comma12.;
infile xlsFilen missover dsd dlm = '09'x missover ;
input days120p_&year._&month.:comma12.;
infile xlsFileo missover dsd dlm = '09'x missover ;
input mortconv&year._&month.:comma12.;
infile xlsFilep missover dsd dlm = '09'x missover ;
input mortfha&year._&month.:comma12.;
infile xlsFileq missover dsd dlm = '09'x  ;
input mortva&year._&month.:comma12.;
infile xlsFiler missover dsd dlm = '09'x  ;
input mortass&year._&month.:comma12.;
infile xlsFiles missover dsd dlm = '09'x  ;
input mortcash&year._&month.:comma12.;
infile xlsFilet missover dsd dlm = '09'x  ;
input mortown&year._&month.:comma12.;
infile xlsFileu missover dsd dlm = '09'x  ;
input mortoth&year._&month.:comma12.;
infile xlsFilev missover dsd dlm = '09'x  ;
input mortunk&year._&month.:comma12.;

infile xlsFileg missover dsd dlm = '09'x  ;
input saletolist&year._&month.:comma12.
		saletolist&oldyear._&month.:comma12. ;
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

aggsale&year._&month. 	= "Total Sold Dollar Volume, &year._&month."
avgsale&year._&month. 	= "Average Sold Price, &year._&month."
medsale&year._&month. 	= "Median Sold Price, &year._&month."
numsale&year._&month. 	= "Total Units Sold, &year._&month."

avgdays&year._&month. 	= "Average Days on Market, &year._&month."
totdays&year._&month. 	= "Aggregate Days on Market, &year._&month."
avglist&year._&month. 	= "Average List Price, &year._&month."
saletolist&year._&month.= "Ratio of sales to list price, &year._&month."

newlist&year._&month.    = "Total NEW listings, &year._&month."
contract&year._&month.   = "Total Properties Marked Contract, &year._&month."
contingent&year._&month. = "Total Properties Marked Contingent Contract, &year._&month."
newpend&year._&month.	 = "Total NEW pendings (Contracts + Contingents), &year._&month."
list_tot&year._&month.   	= "Active listings, sales, &year._&month."

sales&year._&month.	 = "Sales from price categories - just for testing, &year._&month."


days30_&year._&month.   = "Time on Market for Sales: 1 - 30 Days, &year._&month."
days60_&year._&month.   = "Time on Market for Sales: 31-60 Days, &year._&month."
days90_&year._&month.   = "Time on Market for Sales: 61 - 90 Days, &year._&month."
days120_&year._&month.  = "Time on Market for Sales: 91-120 Days, &year._&month."
days120p_&year._&month.	= "Time on Market for Sales: Over 120 Days, &year._&month."


pdays30_&year._&month.   = "Pct of sales with time on market: 1 - 30 days, &year._&month."
pdays60_&year._&month.   = "Pct of sales with time on market: 31-60 days, &year._&month."
pdays90_&year._&month.   = "Pct of sales with time on market: 61 - 90 days, &year._&month."
pdays120_&year._&month.  = "Pct of sales with time on market: 91-120 days, &year._&month."
pdays120p_&year._&month.	= "Pct of sales with time on market: Over 120 days, &year._&month."


mortconv&year._&month.  = "Type of financing for sales: Conventional, &year._&month."
mortfha&year._&month.	= "Type of financing for sales: FHA, &year._&month."
mortva&year._&month.	= "Type of financing for sales: VA, &year._&month."
mortass&year._&month.	= "Type of financing for sales: Assumption, &year._&month."
mortcash&year._&month.	= "Type of financing for sales: Cash, &year._&month."
mortown&year._&month. 	= "Type of financing for sales: Owner Finance, &year._&month."
mortoth&year._&month.	= "Type of financing for sales: All Other, &year._&month."
mortunk&year._&month. 	= "Type of financing for sales: Unreported, &year._&month." 

aggsale&oldyear._&month. 	= "Total Sold Dollar Volume, &oldyear._&month."
avgsale&oldyear._&month. 	= "Average Sold Price, &oldyear._&month."
medsale&oldyear._&month. 	= "Median Sold Price, &oldyear._&month."
numsale&oldyear._&month. 	= "Total Units Sold, &oldyear._&month."
avgdays&oldyear._&month. 	= "Average Days on Market, &oldyear._&month."
totdays&oldyear._&month. 	= "Aggregate Days on Market, &oldyear._&month."
avglist&oldyear._&month. 	= "Average List Price, &oldyear._&month."
saletolist&oldyear._&month.	= "Ratio of sales to list price, &oldyear._&month."  
cntyname = "County name"
stusab="State Abbreviation"
ucounty="County Fips, SSCCC"
ui_div="Categorization of Jurisdictions"
uiorder="Order of Jurisdictions for Regional Data Tables"
;

%mend;

%macro labelcat;
label 
price_cat 	= "Price Class"
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


		
