


	*add in Peter real change macro;
/*	*decide if this is right...;
	%Dollar_convert(  avgsale&year.m&month.,  avgsale_adj&year.m&month., &year., 2008 , quiet=Y );
	%Dollar_convert(  medsale&year.m&month.,  medsale_adj&year.m&month., &year., 2008 , quiet=Y );
*/
  /*
%if &year. ne 1999 %then %do;
	pchnumsale_&year.m&month. = (numsale&year.m&month.- numsale&oldyear.&month.)/numsale&oldyear.&month.*100;
	pchavgsale_adj&oldyear._&year.m&month. = (avgsale_adj&year.m&month.- avgsale_adj&oldyear.&month.)/avgsale_adj&oldyear.&month.*100;
	pchmedsale_adj&oldyear._&year.m&month. = (medsale_adj&year.m&month.- medsale_adj&oldyear.&month.)/medsale_adj&oldyear.&month.*100;

	*example: %Dollar_convert( wages1, wages2, 1995, 2005 );
%end;
*/