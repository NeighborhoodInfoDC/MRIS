/* Dollar_convert.sas - UISUG SAS Macro Library
  
   Converts dollars using CPI.
  
   Source URL:  http://data.bls.gov/cgi-bin/surveymost?cu
     U.S. All items, 1982-84=100 - CUUR0000SA0 
     U.S. All items less shelter, 1982-84=100 - CUUR0000SA0L2 
  
   NB:  Program written for SAS Version 9.1
  
   07/28/05  Peter A. Tatian
   10/19/05  Expanded CUUR0000SA0 back to 1980.
             Added MPRINT= option.
   04/03/06  Updated 2005 CPI to full year.  Added 2006 (Jan & Feb only).
   08/07/06  Updated 2006 CPI to half year.
   12/31/06  Changed earliest year to 1979.
   01/30/06  Updated 2006 CPI to full year.
   08/27/07  Updated 2007 CPI to half year.
   01/29/08  Updated 2007 CPI to full year.
   02/02/09  Updated 2008 CPI to full year.
   07/06/09  Updated 2009 CPI to Jan-May average.
   09/02/09  Updated 2009 CPI to half year.
             Added series CUUR0000SA0L2 (All items less shelter). got to: http://data.bls.gov/cgi-bin/srgate  and enter series
   09/03/09  L Hendey Adjusted to Handle Monthly CPI_NS  
   10/26/09  L Hendey Added Aug and Sep 2009
   01/21/10  L Hendey Added Oct-Dec 2009
 ****************************************************************************/

%macro windex(str,target);
%local i res words;
%let res=0;
%let words=%words(&str);
%do i=1 %to &words;
  %if "%scan(&str,&i,%str( ))" EQ "&target" %then %do;
    %let res=&i;
    %let i=&words;
  %end;
%end;
&res
%mend;
%macro words(str,delim=%str( ));

%local i;
%let i=1;
%do %while(%length(%qscan(&str,&i,&delim)) GT 0);
  %let i=%eval(&i + 1);
%end;
%eval(&i - 1)

%mend;

/** Macro Dollar_convert - Start Definition **/

%macro Dollar_convert_month( amount1, amount2, from, to, series=CUUR0000SA0, quiet=Y, mprint=N );

  %push_option( mprint, quiet=y )
  
  %if %upcase( &mprint ) = Y %then %do;
    options mprint;
  %end;
  %else %if %upcase( &mprint ) = N %then %do;
    options nomprint;
  %end;

  %global _dcnv_count;
  
  %let MIN_YEAR = _Jan_1979;
  %let MAX_YEAR = _Dec_2009;

    %let series = %upcase( &series );

 %if &series = CUUR0000SA0L2 %then %do;
    %************************************************** 
        Consumer Price Index - All Urban Consumers
		Series Id:    CUUR0000SA0L2
		Not Seasonally Adjusted
		Area:         U.S. city average
		Item:         All items less shelter
		Base Period:  1982-84=100
    ***************************************************;
  %let	CPI_Jan1979	=	70.3; 
  %let	CPI_Feb1979	=	71; 
  %let	CPI_Mar1979	=	71.7;
  %let	CPI_Apr1979	=	72.5;
  %let	CPI_May1979	=	73.4;
  %let	CPI_Jun1979	=	74.2;
  %let	CPI_Jul1979	=	74.9;
  %let	CPI_Aug1979	=	75.4;
  %let	CPI_Sep1979	=	76.1;
  %let	CPI_Oct1979	=	76.6;
  %let	CPI_Nov1979	=	77;
  %let	CPI_Dec1979	=	77.7;
  %let	CPI_Jan1980	=	78.7; 
  %let	CPI_Feb1980	=	79.8;
  %let	CPI_Mar1980	=	80.9;
  %let	CPI_Apr1980	=	81.6;
  %let	CPI_May1980	=	82.2;
  %let	CPI_Jun1980	=	82.7;
  %let	CPI_Jul1980	=	83.2;
  %let	CPI_Aug1980	=	84;
  %let	CPI_Sep1980	=	84.9;
  %let	CPI_Oct1980	=	85.3;
  %let	CPI_Nov1980	=	85.8;
  %let	CPI_Dec1980	=	86.3;
  %let	CPI_Jan1981	=	87.2;
  %let	CPI_Feb1981	=	88.5;
  %let	CPI_Mar1981	=	89.2;
  %let	CPI_Apr1981	=	89.8;
  %let	CPI_May1981	=	90.2;
  %let	CPI_Jun1981	=	90.8;
  %let	CPI_Jul1981	=	91.5;
  %let	CPI_Aug1981	=	92;
  %let	CPI_Sep1981	=	92.8;
  %let	CPI_Oct1981	=	93.1;
  %let	CPI_Nov1981	=	93.5;
  %let	CPI_Dec1981	=	93.7;
  %let	CPI_Jan1982	=	94.2;
  %let	CPI_Feb1982	=	94.5;
  %let	CPI_Mar1982	=	94.5;
  %let	CPI_Apr1982	=	94.6;
  %let	CPI_May1982	=	95.3;
  %let	CPI_Jun1982	=	96.4;
  %let	CPI_Jul1982	=	96.9;
  %let	CPI_Aug1982	=	97.1;
  %let	CPI_Sep1982	=	97.5;
  %let	CPI_Oct1982	=	97.9;
  %let	CPI_Nov1982	=	97.9;
  %let	CPI_Dec1982	=	98;
  %let	CPI_Jan1983	=	98.1;
  %let	CPI_Feb1983	=	98.1;
  %let	CPI_Mar1983	=	98.1;
  %let	CPI_Apr1983	=	98.9;
  %let	CPI_May1983	=	99.4;
  %let	CPI_Jun1983	=	99.8;
  %let	CPI_Jul1983	=	100.2;
  %let	CPI_Aug1983	=	100.5;
  %let	CPI_Sep1983	=	101;
  %let	CPI_Oct1983	=	101.2;
  %let	CPI_Nov1983	=	101.3;
  %let	CPI_Dec1983	=	101.5;
  %let	CPI_Jan1984	=	102;
  %let	CPI_Feb1984	=	102.6;
  %let	CPI_Mar1984	=	102.8;
  %let	CPI_Apr1984	=	103.2;
  %let	CPI_May1984	=	103.5;
  %let	CPI_Jun1984	=	103.8;
  %let	CPI_Jul1984	=	104.1;
  %let	CPI_Aug1984	=	104.5;
  %let	CPI_Sep1984	=	105;
  %let	CPI_Oct1984	=	105.2;
  %let	CPI_Nov1984	=	105.1;
  %let	CPI_Dec1984	=	105.1;
  %let	CPI_Jan1985	=	105.3;
  %let	CPI_Feb1985	=	105.6;
  %let	CPI_Mar1985	=	106.2;
  %let	CPI_Apr1985	=	106.6;
  %let	CPI_May1985	=	106.8;
  %let	CPI_Jun1985	=	107.2;
  %let	CPI_Jul1985	=	107.2;
  %let	CPI_Aug1985	=	107.3;
  %let	CPI_Sep1985	=	107.6;
  %let	CPI_Oct1985	=	107.9;
  %let	CPI_Nov1985	=	108.2;
  %let	CPI_Dec1985	=	108.4;
  %let	CPI_Jan1986	=	108.7;
  %let	CPI_Feb1986	=	108.2;
  %let	CPI_Mar1986	=	107.5;
  %let	CPI_Apr1986	=	106.9;
  %let	CPI_May1986	=	107.3;
  %let	CPI_Jun1986	=	107.9;
  %let	CPI_Jul1986	=	107.8;
  %let	CPI_Aug1986	=	107.9;
  %let	CPI_Sep1986	=	108.4;
  %let	CPI_Oct1986	=	108.4;
  %let	CPI_Nov1986	=	108.5;
  %let	CPI_Dec1986	=	108.6;
  %let	CPI_Jan1987	=	109.3;
  %let	CPI_Feb1987	=	109.7;
  %let	CPI_Mar1987	=	110.2;
  %let	CPI_Apr1987	=	110.8;
  %let	CPI_May1987	=	111.1;
  %let	CPI_Jun1987	=	111.7;
  %let	CPI_Jul1987	=	111.8;
  %let	CPI_Aug1987	=	112.3;
  %let	CPI_Sep1987	=	113;
  %let	CPI_Oct1987	=	113.2;
  %let	CPI_Nov1987	=	113.3;
  %let	CPI_Dec1987	=	113.2;
  %let	CPI_Jan1988	=	113.3;
  %let	CPI_Feb1988	=	113.5;
  %let	CPI_Mar1988	=	114;
  %let	CPI_Apr1988	=	114.7;
  %let	CPI_May1988	=	115.2;
  %let	CPI_Jun1988	=	115.7;
  %let	CPI_Jul1988	=	116.1;
  %let	CPI_Aug1988	=	116.5;
  %let	CPI_Sep1988	=	117.5;
  %let	CPI_Oct1988	=	117.9;
  %let	CPI_Nov1988	=	118;
  %let	CPI_Dec1988	=	118.1;
  %let	CPI_Jan1989	=	118.7;
  %let	CPI_Feb1989	=	119.2;
  %let	CPI_Mar1989	=	119.9;
  %let	CPI_Apr1989	=	121;
  %let	CPI_May1989	=	121.7;
  %let	CPI_Jun1989	=	122;
  %let	CPI_Jul1989	=	122;
  %let	CPI_Aug1989	=	122;
  %let	CPI_Sep1989	=	122.6;
  %let	CPI_Oct1989	=	123.1;
  %let	CPI_Nov1989	=	123.3;
  %let	CPI_Dec1989	=	123.5;
  %let	CPI_Jan1990	=	125;
  %let	CPI_Feb1990	=	125.7;
  %let	CPI_Mar1990	=	126.2;
  %let	CPI_Apr1990	=	126.5;
  %let	CPI_May1990	=	126.7;
  %let	CPI_Jun1990	=	127.3;
  %let	CPI_Jul1990	=	127.5;
  %let	CPI_Aug1990	=	128.6;
  %let	CPI_Sep1990	=	130.1;
  %let	CPI_Oct1990	=	131.2;
  %let	CPI_Nov1990	=	131.5;
  %let	CPI_Dec1990	=	131.5;
  %let	CPI_Jan1991	=	132.1;
  %let	CPI_Feb1991	=	132.2;
  %let	CPI_Mar1991	=	132.2;
  %let	CPI_Apr1991	=	132.6;
  %let	CPI_May1991	=	133.1;
  %let	CPI_Jun1991	=	133.3;
  %let	CPI_Jul1991	=	133.3;
  %let	CPI_Aug1991	=	133.7;
  %let	CPI_Sep1991	=	134.5;
  %let	CPI_Oct1991	=	134.6;
  %let	CPI_Nov1991	=	135;
  %let	CPI_Dec1991	=	135;
  %let	CPI_Jan1992	=	135.1;
  %let	CPI_Feb1992	=	135.5;
  %let	CPI_Mar1992	=	136.2;
  %let	CPI_Apr1992	=	136.6;
  %let	CPI_May1992	=	136.9;
  %let	CPI_Jun1992	=	137.2;
  %let	CPI_Jul1992	=	137.3;
  %let	CPI_Aug1992	=	137.7;
  %let	CPI_Sep1992	=	138.4;
  %let	CPI_Oct1992	=	138.9;
  %let	CPI_Nov1992	=	139.2;
  %let	CPI_Dec1992	=	139.1;
  %let	CPI_Jan1993	=	139.5;
  %let	CPI_Feb1993	=	140;
  %let	CPI_Mar1993	=	140.5;
  %let	CPI_Apr1993	=	140.9;
  %let	CPI_May1993	=	141.3;
  %let	CPI_Jun1993	=	141.2;
  %let	CPI_Jul1993	=	141.1;
  %let	CPI_Aug1993	=	141.5;
  %let	CPI_Sep1993	=	142;
  %let	CPI_Oct1993	=	142.6;
  %let	CPI_Nov1993	=	142.9;
  %let	CPI_Dec1993	=	142.7;
  %let	CPI_Jan1994	=	142.9;
  %let	CPI_Feb1994	=	143.2;
  %let	CPI_Mar1994	=	143.7;
  %let	CPI_Apr1994	=	144;
  %let	CPI_May1994	=	144.2;
  %let	CPI_Jun1994	=	144.6;
  %let	CPI_Jul1994	=	144.9;
  %let	CPI_Aug1994	=	145.5;
  %let	CPI_Sep1994	=	146;
  %let	CPI_Oct1994	=	146.1;
  %let	CPI_Nov1994	=	146.3;
  %let	CPI_Dec1994	=	146.3;
  %let	CPI_Jan1995	=	146.8;
  %let	CPI_Feb1995	=	147.2;
  %let	CPI_Mar1995	=	147.7;
  %let	CPI_Apr1995	=	148.3;
  %let	CPI_May1995	=	148.6;
  %let	CPI_Jun1995	=	148.8;
  %let	CPI_Jul1995	=	148.6;
  %let	CPI_Aug1995	=	148.9;
  %let	CPI_Sep1995	=	149.4;
  %let	CPI_Oct1995	=	149.8;
  %let	CPI_Nov1995	=	149.7;
  %let	CPI_Dec1995	=	149.6;
  %let	CPI_Jan1996	=	150.3;
  %let	CPI_Feb1996	=	150.8;
  %let	CPI_Mar1996	=	151.6;
  %let	CPI_Apr1996	=	152.4;
  %let	CPI_May1996	=	152.8;
  %let	CPI_Jun1996	=	152.8;
  %let	CPI_Jul1996	=	152.8;
  %let	CPI_Aug1996	=	152.9;
  %let	CPI_Sep1996	=	153.8;
  %let	CPI_Oct1996	=	154.2;
  %let	CPI_Nov1996	=	154.6;
  %let	CPI_Dec1996	=	154.7;
  %let	CPI_Jan1997	=	155;
  %let	CPI_Feb1997	=	155.3;
  %let	CPI_Mar1997	=	155.6;
  %let	CPI_Apr1997	=	155.8;
  %let	CPI_May1997	=	155.7;
  %let	CPI_Jun1997	=	155.7;
  %let	CPI_Jul1997	=	155.6;
  %let	CPI_Aug1997	=	155.9;
  %let	CPI_Sep1997	=	156.6;
  %let	CPI_Oct1997	=	156.9;
  %let	CPI_Nov1997	=	156.8;
  %let	CPI_Dec1997	=	156.4;
  %let	CPI_Jan1998	=	156.4;
  %let	CPI_Feb1998	=	156.4;
  %let	CPI_Mar1998	=	156.5;
  %let	CPI_Apr1998	=	156.9;
  %let	CPI_May1998	=	157.3;
  %let	CPI_Jun1998	=	157.3;
  %let	CPI_Jul1998	=	157.3;
  %let	CPI_Aug1998	=	157.4;
  %let	CPI_Sep1998	=	157.6;
  %let	CPI_Oct1998	=	157.9;
  %let	CPI_Nov1998	=	157.9;
  %let	CPI_Dec1998	=	157.8;
  %let	CPI_Jan1999	=	158.1;
  %let	CPI_Feb1999	=	158.1;
  %let	CPI_Mar1999	=	158.5;
  %let	CPI_Apr1999	=	159.9;
  %let	CPI_May1999	=	159.9;
  %let	CPI_Jun1999	=	159.7;
  %let	CPI_Jul1999	=	160.1;
  %let	CPI_Aug1999	=	160.6;
  %let	CPI_Sep1999	=	161.6;
  %let	CPI_Oct1999	=	162;
  %let	CPI_Nov1999	=	162.1;
  %let	CPI_Dec1999	=	162.1;
  %let	CPI_Jan2000	=	162.3;
  %let	CPI_Feb2000	=	163.3;
  %let	CPI_Mar2000	=	164.8;
  %let	CPI_Apr2000	=	164.9;
  %let	CPI_May2000	=	165.1;
  %let	CPI_Jun2000	=	166;
  %let	CPI_Jul2000	=	166.2;
  %let	CPI_Aug2000	=	166;
  %let	CPI_Sep2000	=	167.4;
  %let	CPI_Oct2000	=	167.5;
  %let	CPI_Nov2000	=	167.7;
  %let	CPI_Dec2000	=	167.5;
  %let	CPI_Jan2001	=	168.6;
  %let	CPI_Feb2001	=	169.1;
  %let	CPI_Mar2001	=	169.2;
  %let	CPI_Apr2001	=	170.1;
  %let	CPI_May2001	=	170.9;
  %let	CPI_Jun2001	=	171;
  %let	CPI_Jul2001	=	170;
  %let	CPI_Aug2001	=	169.7;
  %let	CPI_Sep2001	=	170.9;
  %let	CPI_Oct2001	=	169.9;
  %let	CPI_Nov2001	=	169.3;
  %let	CPI_Dec2001	=	168.2;
  %let	CPI_Jan2002	=	168.4;
  %let	CPI_Feb2002	=	168.7;
  %let	CPI_Mar2002	=	169.7;
  %let	CPI_Apr2002	=	170.9;
  %let	CPI_May2002	=	170.9;
  %let	CPI_Jun2002	=	170.9;
  %let	CPI_Jul2002	=	170.9;
  %let	CPI_Aug2002	=	171.3;
  %let	CPI_Sep2002	=	171.9;
  %let	CPI_Oct2002	=	172.2;
  %let	CPI_Nov2002	=	172.3;
  %let	CPI_Dec2002	=	171.7;
  %let	CPI_Jan2003	=	172.3;
  %let	CPI_Feb2003	=	174;
  %let	CPI_Mar2003	=	175.3;
  %let	CPI_Apr2003	=	174.7;
  %let	CPI_May2003	=	174.1;
  %let	CPI_Jun2003	=	174.3;
  %let	CPI_Jul2003	=	174.2;
  %let	CPI_Aug2003	=	175;
  %let	CPI_Sep2003	=	176;
  %let	CPI_Oct2003	=	175.5;
  %let	CPI_Nov2003	=	174.9;
  %let	CPI_Dec2003	=	174.7;
  %let	CPI_Jan2004	=	175.6;
  %let	CPI_Feb2004	=	176.7;
  %let	CPI_Mar2004	=	177.6;
  %let	CPI_Apr2004	=	178.2;
  %let	CPI_May2004	=	179.6;
  %let	CPI_Jun2004	=	180.2;
  %let	CPI_Jul2004	=	179.6;
  %let	CPI_Aug2004	=	179.5;
  %let	CPI_Sep2004	=	180.1;
  %let	CPI_Oct2004	=	181.4;
  %let	CPI_Nov2004	=	181.9;
  %let	CPI_Dec2004	=	180.9;
  %let	CPI_Jan2005	=	180.9;
  %let	CPI_Feb2005	=	181.9;
  %let	CPI_Mar2005	=	183.2;
  %let	CPI_Apr2005	=	185.1;
  %let	CPI_May2005	=	185;
  %let	CPI_Jun2005	=	184.9;
  %let	CPI_Jul2005	=	185.7;
  %let	CPI_Aug2005	=	187.1;
  %let	CPI_Sep2005	=	191;
  %let	CPI_Oct2005	=	191.1;
  %let	CPI_Nov2005	=	189;
  %let	CPI_Dec2005	=	187.7;
  %let	CPI_Jan2006	=	189.3;
  %let	CPI_Feb2006	=	189.4;
  %let	CPI_Mar2006	=	190.3;
  %let	CPI_Apr2006	=	192.3;
  %let	CPI_May2006	=	193.5;
  %let	CPI_Jun2006	=	193.7;
  %let	CPI_Jul2006	=	194;
  %let	CPI_Aug2006	=	194.4;
  %let	CPI_Sep2006	=	193.1;
  %let	CPI_Oct2006	=	191.2;
  %let	CPI_Nov2006	=	190.7;
  %let	CPI_Dec2006	=	191.1;
  %let	CPI_Jan2007	=	191.328;
  %let	CPI_Feb2007	=	192.272;
  %let	CPI_Mar2007	=	194.482;
  %let	CPI_Apr2007	=	196.062;
  %let	CPI_May2007	=	197.783;
  %let	CPI_Jun2007	=	197.913;
  %let	CPI_Jul2007	=	197.408;
  %let	CPI_Aug2007	=	196.803;
  %let	CPI_Sep2007	=	197.708;
  %let	CPI_Oct2007	=	198.171;
  %let	CPI_Nov2007	=	199.998;
  %let	CPI_Dec2007	=	199.734;
  %let	CPI_Jan2008	=	200.609;
  %let	CPI_Feb2008	=	201.11;
  %let	CPI_Mar2008	=	203.217;
  %let	CPI_Apr2008	=	205.04;
  %let	CPI_May2008	=	207.566;
  %let	CPI_Jun2008	=	210.242;
  %let	CPI_Jul2008	=	211.468;
  %let	CPI_Aug2008	=	210.264;
  %let	CPI_Sep2008	=	209.936;
  %let	CPI_Oct2008	=	206.776;
  %let	CPI_Nov2008	=	201.075;
  %let	CPI_Dec2008	=	198.127;
  %let	CPI_Jan2009	=	198.936;
  %let	CPI_Feb2009	=	200.184;
  %let	CPI_Mar2009	=	200.626;
  %let	CPI_Apr2009	=	201.271;
  %let	CPI_May2009	=	202.171;
  %let	CPI_Jun2009	=	204.578;
  %let	CPI_Jul2009	=	204.069;
  %let	CPI_Aug2009	=	204.776;
  %let	CPI_Sep2009	=	205.263;
  %let	CPI_Oct2009	=	205.567;
  %let	CPI_Nov2009	=	206.286;
  %let	CPI_Dec2009	=	205.888;
  						

  %end;
  %else %do;
    %err_mput( macro=Dollar_convert, msg=Invalid SERIES= value: &series )
    %goto exit_macro;
  %end;
  
  %if &_dcnv_count = %then %let _dcnv_count = 1;
  %else %let _dcnv_count = %eval( &_dcnv_count + 1 );
  
%let _dcnv_array = _dcnv&_dcnv_count;

%let cpimonth = 
_Jan1979 _Jan1980 _Jan1981 _Jan1982 _Jan1983 _Jan1984 _Jan1985 _Jan1986 _Jan1987 _Jan1988 _Jan1989 _Jan1990 _Jan1991 _Jan1992 _Jan1993 _Jan1994	_Jan1995 _Jan1996 _Jan1997 _Jan1998 _Jan1999 _Jan2000 _Jan2001 _Jan2002 _Jan2003 _Jan2004 _Jan2005 _Jan2006 _Jan2007 _Jan2008 _Jan2009
_Feb1979 _Feb1980 _Feb1981 _Feb1982 _Feb1983 _Feb1984 _Feb1985 _Feb1986 _Feb1987 _Feb1988 _Feb1989 _Feb1990 _Feb1991 _Feb1992 _Feb1993 _Feb1994	_Feb1995 _Feb1996 _Feb1997 _Feb1998 _Feb1999 _Feb2000 _Feb2001 _Feb2002 _Feb2003 _Feb2004 _Feb2005 _Feb2006 _Feb2007 _Feb2008 _Feb2009
_Mar1979 _Mar1980 _Mar1981 _Mar1982 _Mar1983 _Mar1984 _Mar1985 _Mar1986 _Mar1987 _Mar1988 _Mar1989 _Mar1990 _Mar1991 _Mar1992 _Mar1993 _Mar1994	_Mar1995 _Mar1996 _Mar1997 _Mar1998 _Mar1999 _Mar2000 _Mar2001 _Mar2002 _Mar2003 _Mar2004 _Mar2005 _Mar2006 _Mar2007 _Mar2008 _Mar2009
_Apr1979 _Apr1980 _Apr1981 _Apr1982 _Apr1983 _Apr1984 _Apr1985 _Apr1986 _Apr1987 _Apr1988 _Apr1989 _Apr1990 _Apr1991 _Apr1992 _Apr1993 _Apr1994	_Apr1995 _Apr1996 _Apr1997 _Apr1998 _Apr1999 _Apr2000 _Apr2001 _Apr2002 _Apr2003 _Apr2004 _Apr2005 _Apr2006 _Apr2007 _Apr2008 _Apr2009
_May1979 _May1980 _May1981 _May1982 _May1983 _May1984 _May1985 _May1986 _May1987 _May1988 _May1989 _May1990 _May1991 _May1992 _May1993 _May1994	_May1995 _May1996 _May1997 _May1998 _May1999 _May2000 _May2001 _May2002 _May2003 _May2004 _May2005 _May2006 _May2007 _May2008 _May2009
_Jun1979 _Jun1980 _Jun1981 _Jun1982 _Jun1983 _Jun1984 _Jun1985 _Jun1986 _Jun1987 _Jun1988 _Jun1989 _Jun1990 _Jun1991 _Jun1992 _Jun1993 _Jun1994	_Jun1995 _Jun1996 _Jun1997 _Jun1998 _Jun1999 _Jun2000 _Jun2001 _Jun2002 _Jun2003 _Jun2004 _Jun2005 _Jun2006 _Jun2007 _Jun2008 _Jun2009
_Jul1979 _Jul1980 _Jul1981 _Jul1982 _Jul1983 _Jul1984 _Jul1985 _Jul1986 _Jul1987 _Jul1988 _Jul1989 _Jul1990 _Jul1991 _Jul1992 _Jul1993 _Jul1994	_Jul1995 _Jul1996 _Jul1997 _Jul1998 _Jul1999 _Jul2000 _Jul2001 _Jul2002 _Jul2003 _Jul2004 _Jul2005 _Jul2006 _Jul2007 _Jul2008 _Jul2009
_Aug1979 _Aug1980 _Aug1981 _Aug1982 _Aug1983 _Aug1984 _Aug1985 _Aug1986 _Aug1987 _Aug1988 _Aug1989 _Aug1990 _Aug1991 _Aug1992 _Aug1993 _Aug1994 _Aug1995 _Aug1996 _Aug1997 _Aug1998 _Aug1999 _Aug2000 _Aug2001 _Aug2002 _Aug2003 _Aug2004 _Aug2005 _Aug2006 _Aug2007 _Aug2008 _Aug2009
_Sep1979 _Sep1980 _Sep1981 _Sep1982 _Sep1983 _Sep1984 _Sep1985 _Sep1986 _Sep1987 _Sep1988 _Sep1989 _Sep1990 _Sep1991 _Sep1992 _Sep1993 _Sep1994 _Sep1995 _Sep1996 _Sep1997 _Sep1998 _Sep1999 _Sep2000 _Sep2001 _Sep2002 _Sep2003 _Sep2004 _Sep2005 _Sep2006 _Sep2007 _Sep2008 _Sep2009
_Oct1979 _Oct1980 _Oct1981 _Oct1982 _Oct1983 _Oct1984 _Oct1985 _Oct1986 _Oct1987 _Oct1988 _Oct1989 _Oct1990 _Oct1991 _Oct1992 _Oct1993 _Oct1994 _Oct1995 _Oct1996 _Oct1997 _Oct1998 _Oct1999 _Oct2000 _Oct2001 _Oct2002 _Oct2003 _Oct2004 _Oct2005 _Oct2006 _Oct2007 _Oct2008 _Oct2009
_Nov1979 _Nov1980 _Nov1981 _Nov1982 _Nov1983 _Nov1984 _Nov1985 _Nov1986 _Nov1987 _Nov1988 _Nov1989 _Nov1990 _Nov1991 _Nov1992 _Nov1993 _Nov1994 _Nov1995 _Nov1996 _Nov1997 _Nov1998 _Nov1999 _Nov2000 _Nov2001 _Nov2002 _Nov2003 _Nov2004 _Nov2005 _Nov2006 _Nov2007 _Nov2008 _Nov2009
_Dec1979 _Dec1980 _Dec1981 _Dec1982 _Dec1983 _Dec1984 _Dec1985 _Dec1986 _Dec1987 _Dec1988 _Dec1989 _Dec1990 _Dec1991 _Dec1992 _Dec1993 _Dec1994 _Dec1995 _Dec1996 _Dec1997 _Dec1998 _Dec1999 _Dec2000 _Dec2001 _Dec2002 _Dec2003 _Dec2004 _Dec2005 _Dec2006 _Dec2007 _Dec2008 _Dec2009
;
%let words=%words(&cpimonth.); 
%let to_index=%windex(&cpimonth.,&to); 
%let from_index=%windex(&cpimonth.,&from);

array &_dcnv_array{372} _temporary_
( 					
    %do i= 1 %to 372;
	%let cpimo=%scan(&cpimonth.,&i.,' ');
      &&&CPI&cpimo 
    %end;
  );


  %let Result = (&amount1) * (&_dcnv_array{&to_index}/&_dcnv_array{&from_index});
/*
  if (&from) < &MIN_YEAR or (&from) > &MAX_YEAR then do;
    %if %datatyp(&from) = NUMERIC %then %do;
      %err_put( macro=Dollar_convert_month, msg=_n_= "Invalid year FROM=&from..  Only years &MIN_YEAR-&MAX_YEAR supported." )
    %end;
    %else %do;
      %err_put( macro=Dollar_convert_month, msg=_n_= "Invalid year FROM=" &from ". Only years &MIN_YEAR-&MAX_YEAR supported." )
    %end;
  end;
  else if (&to) < &MIN_YEAR or (&to) > &MAX_YEAR then do;
    %if %datatyp(&to) = NUMERIC %then %do;
      %err_put( macro=Dollar_convert_month, msg=_n_= "Invalid year TO=&to..  Only years &MIN_YEAR-&MAX_YEAR supported." )
    %end;
    %else %do;
      %err_put( macro=Dollar_convert_month, msg=_n_= "Invalid year TO=" &to ". Only years &MIN_YEAR-&MAX_YEAR supported." )
    %end;
  end;
  else do;*/
    &amount2 = (&result);
  /*end;*/

  %exit_macro:
  
  %if %upcase( &quiet ) = N %then %do;
  	  %note_mput( macro=Dollar_convert_month, msg=TO=&to )
  	%note_mput( macro=Dollar_convert_month, msg=FROM=&from )
	  	  %note_mput( macro=Dollar_convert_month, msg=TO Index=&to_index )
  	%note_mput( macro=Dollar_convert_month, msg=FROM Index=&from_index )
    %note_mput( macro=Dollar_convert_month, msg=Result=&result )
  %end;
  
  %pop_option( mprint, quiet=y )

%mend Dollar_convert_month;

/** End Macro Definition **/


/************ UNCOMMENT TO TEST ****************************

filename uiautos "K:\Metro\PTatian\UISUG\Uiautos";
options sasautos=(uiautos sasautos);

options mprint nosymbolgen nomlogic;
options msglevel=i;

data _null_;

  %dollar_convert( 100, amount2, 1980, 2005, quiet=N, series=CUUR0000SA0L2 );
  put amount2=;
  
  %dollar_convert( 100, amount2, 2005, 1980, quiet=N, mprint=y, series=CUUR0000SA0L2 );
  put amount2=;
  
  %dollar_convert( 100, amount2, 1994, 2005, quiet=N, mprint=, series=CUUR0000SA0L2 );
  put amount2=;
  
  %dollar_convert( 100, amount2, 1995, 2010, quiet=N, series=CUUR0000SA0L2 );
  put amount2=;

  %dollar_convert( 100, amount2, 1995, 2005, quiet=N, series=CUUR0000SA0L2 );
  put amount2=;
  
  %dollar_convert( 100, amount2, 2000, 2005, quiet=N, series=CUUR0000SA0L2 );
  put amount2=;
  
  %dollar_convert( 100, amount2, 2005, 1995, quiet=N, series=CUUR0000SA0L2 );
  put amount2=;
  
run;

data _null_;

  input amount from to ;

  %dollar_convert( amount, amount2, from, to, quiet=N, series=CUUR0000SA0L2 );
  put amount2= amount= from= to=;

cards;
100 1980 2005
100 2005 1980
100 1994 2005
100 1995 2010
100 1995 2005
100 2000 2005
100 2005 1995
;
  
run;

/*****************************************************************/
