

libname hnc 'd:\HNC2009\mris';

signon;

rsubmit;
libname hnc "[hnc]";


proc upload data=hnc.mriszip2007m04 out = hnc.mriszip2009m04;
run;

proc upload data=hnc.mriszip2009m05 out = hnc.mriszip2009m05;
run;

proc upload data=hnc.mriszip2009m06 out = hnc.mriszip2009m06;
run;

/*

proc upload data=hnc.mriszip2007m01 out = hnc.mriszip2007m01;
run;

proc upload data=hnc.mriszip2007m02 out = hnc.mriszip2007m02;
run;

proc upload data=hnc.mriszip2007m03 out = hnc.mriszip2007m03;
run;


proc upload data=hnc.mriszip2007m04 out = hnc.mriszip2007m04;
run;

proc upload data=hnc.mriszip2007m05 out = hnc.mriszip2007m05;
run;

proc upload data=hnc.mriszip2007m06 out = hnc.mriszip2007m06;
run;
*/
/*
proc upload data=hnc.mriszip2009m01 out = hnc.mriszip2009m01;
run;

proc upload data=hnc.mriszip2009m02 out = hnc.mriszip2009m02;
run;

proc upload data=hnc.mriszip2009m03 out = hnc.mriszip2009m03;
run;
*/


endrsubmit;

rsubmit;
libname hnc "[hnc]";


proc upload data=hnc.mriscat100_5m_zip2007m01 out = hnc.mriscat100_5m_zip2007m01;
run;

proc upload data=hnc.mriscat100_5m_zip2007m02 out = hnc.mriscat100_5m_zip2007m02;
run;

proc upload data=hnc.mriscat100_5m_zip2007m03 out = hnc.mriscat100_5m_zip2007m03;
run;

proc upload data=hnc.mriscat100_5m_zip2007m04 out = hnc.mriscat100_5m_zip2007m04;
run;

proc upload data=hnc.mriscat100_5m_zip2007m05 out = hnc.mriscat100_5m_zip2007m05;
run;

proc upload data=hnc.mriscat100_5m_zip2007m06 out = hnc.mriscat100_5m_zip2007m06;
run;

proc upload data=hnc.mriscat100_5m_zip2009m01 out = hnc.mriscat100_5m_zip2009m01;
run;

proc upload data=hnc.mriscat100_5m_zip2009m02 out = hnc.mriscat100_5m_zip2009m02;
run;

proc upload data=hnc.mriscat100_5m_zip2009m03 out = hnc.mriscat100_5m_zip2009m03;
run;
endrsubmit;

*hnc.mriscat100_5m_&ext.&year.m&month.
