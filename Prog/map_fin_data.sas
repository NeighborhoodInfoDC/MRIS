libname mris "D:\DCData\Libraries\MRIS\Data";

data mris.fin_map_data;
	set mris.finance_map;
	max_fin= max(pcash_3mavg_2012_03, pfha_va_3mavg_2012_03, pconv_3mavg_2012_03);
	if max_fin = pcash_3mavg_2012_03 then do;
		max_fin_cash = max_fin;
		fin_type = 1;
	end;
	if max_fin = pfha_va_3mavg_2012_03 then do;
		max_fin_fha_va = max_fin;
		fin_type = 2;
	end;
	if max_fin = pconv_3mavg_2012_03 then do;
		max_fin_conv = max_fin;
		fin_type = 3;
	end;
run;


