clear all
set more off
use merged_data2.dta, replace
gen stc = statecode
keep if stc==1 | stc==3 | stc==6 | stc==10 | stc==11 | stc==15 | stc==17 | stc==18 | stc==19 | stc==20 | stc==21 | stc==28 | stc==31 | stc==32 | stc==34 | stc==36 | stc==37| stc==38| stc==39 | stc ==40 | stc == 41 | stc==42 | stc==43 | stc ==49 
tsset stc year
local myx  "real_income  population aged kids"
local myx0 "population aged kids"

xi: qui xtreg real_expenditure `myx' i.year  
predict mes1, e

xi: qui xtreg real_sales_income `myx' i.year 
predict mes2, e	  
	  
xi: qui xtreg income_growth `myx0' i.year 
predict mes3, e

xi: qui xtreg spread2 `myx' i.year 
predict mes4, e 

xi: qui xtreg real_compensation2 `myx' i.year 
predict mes5, e

********************************************************************************
* select two term limit states
********************************************************************************
keep if year<=2011
keep if termlimit_id == 2 | termlimit_id == 4
           
gen     election_id = "1st term"  if bind==0 & reelection_id ==1
replace election_id = "2nd term"  if bind==1 & reelection_id ==1
replace election_id = "extremist" if extremist>=1 & extremist<=3

gen     election_num = 1 if election_id == "1st term"
replace election_num = 2 if election_id == "2nd term"
replace election_num = 3 if election_id == "extremist"

gen election_code = 1000*nextelection + stc*10 + party_id         

merge m:1 election_code using election2.dta
tab _merge
drop if _merge==2 & year>=1950

drop candidate _merge

keep if year<=2011

tsset stc year

* sample selection**********************************************************************
* drop 2 term governors whose data is available for only one term due to data limitation
drop if stc==18 & year >=2008 & year<= 2011 // 1st term only
drop if stc==19 & year >=2008 & year<= 2011 // 1st term only
drop if stc==31 & year >=1950 & year<= 1953 // 2nd term only
drop if stc==32 & year == 1950              // 2nd term only
drop if stc==19 & year >=1964 & year<= 1971 // convertied from 1 term to two term.
drop if extremist==3 // resign

* served less than half term

drop if stc==1 & year==1994   
drop if stc==15 & year==2004   
drop if stc==17 & year>=2009  & year<=2010  
drop if stc==31 & year ==2001  
drop if stc==31 & year ==2005  
drop if stc==39 & year ==2002  

drop if reelection_id == 0 & extremist==. // truncated observations
drop if party_id == 0                     // independent party
gen extremist_id = 0
replace extremist_id = 1 if election_id == "extremist"

recode stc (1=1)(3=2)(6=3)(10=4)(11=5)(15=6)(17=7)(18=8)(19=9)(20=10)(21=11)(28=12)(31=13)(32=14)(34=15)(36=16)(37=17)(38=18)(39=19)(40=20)(41=21)(42=22)(43=23)(49=24)    ,gen(stc2)

replace vote_share = 0 if vote_share==.
gen governor = 1
local N = _N
forvalues i = 2/`N' {
	if gove_name[`i'] == gove_name[`i'-1]  {
		qui replace governor = governor[`i'-1]  in `i'
	}
	else {
		qui replace governor = governor[`i'-1]+1  in `i'
	}
}

keep stc2 party_id mes1 mes2 mes3 mes4 mes5 election_code election_num vote_share governor
outsheet using datafile6, nonames noquote nolabel replace


