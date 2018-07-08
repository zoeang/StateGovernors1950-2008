clear all
set more off
use merged_election.dta, replace
***********************************************
* keep 24 states
************************************************
keep if stc==1 | stc==3 | stc==6 | stc==10 | stc==11 | stc==15 | stc==17 | stc==18 | stc==19 | stc==20 | stc==21 | stc==28 | stc==31 | stc==32 | stc==34 | stc==36 | stc==37| stc==38| stc==39 | stc ==40 | stc == 41 | stc==42 | stc==43 | stc ==49 
************************************************
* control time fixed effects
************************************************
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

xi: qui xtreg real_compensation `myx' i.year 
predict mes5, e
********************************************************************************
* select two term limit states
********************************************************************************
keep if year<=2011
keep if termlimit_id == 2 | termlimit_id == 4

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

corr mes1 mes2 mes3 mes4 mes5

corr real_expenditure real_sales_income income_growth real_compensation spread2

gen extremist_id = 0
replace extremist_id = 1 if election_id == "extremist"

*************************************************************************************************************************************
*************************************************************************************************************************************
xi: qui xtreg mes1  i.state
predict res1, e

xi: qui xtreg mes2  i.state
predict res2, e	  
	  
xi: qui xtreg mes3   i.state
predict res3, e

xi: qui xtreg mes4  i.state
predict res4, e

xi: qui xtreg mes5  i.state
predict res5, e


drop  _Istate_2- _Istate_24
********************************************************************************
** define governor types
********************************************************************************
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


bys governor: egen min1 = min(bind)
bys governor: egen max1 = max(bind)

sort stc year

gen     election_num = 1 if election_id == "1st term"
replace election_num = 2 if election_id == "2nd term"
replace election_num = 3 if election_id == "extremist"

gen     reelected_id = 1 if election_num<=2
replace reelected_id = 2 if election_num>=3

drop democratic_party
gen democratic_party = 0
gen democratic_nbind = 0
gen republican_nbind = 0
replace democratic_party = 1 if party_id==1 
replace democratic_nbind = 1 if party_id==1 & bind == 0
replace republican_nbind = 1 if party_id==2 & bind == 0

bys governor election_num: egen mres1 = mean(res1)
bys governor election_num: egen mres2 = mean(res2)
bys governor election_num: egen mres3 = mean(res3)
bys governor election_num: egen mres4 = mean(res4)
bys governor election_num: egen mres5 = mean(res5)

sort governor election_id
bys governor: gen exp_id = 1 if mres1[_N]>0
bys governor: replace exp_id = 0 if mres1[_N]<=0			
sort governor election_id
bys governor: gen tax_id = 1 if mres2[_N]>0
bys governor: replace tax_id = 0 if mres2[_N]<=0


********************************************************************************
* variance of moments using bootstrap
********************************************************************************
gen ext_id=0
replace ext_id = 1 if election_num==3

sum res3
local std3 = r(sd)
gen a_type3 = .
replace a_type3 = 1 if res3<- `std3'
replace a_type3 = 2 if res3>=-`std3' & res3<0
replace a_type3 = 3 if res3>=0 & res3<`std3'
replace a_type3 = 4 if res3>= `std3'

bootstrap range1=(r(mean)) , reps(100) seed(10) saving(pt1) : summarize ext_id if election_num~=2 & party_id == 1
bootstrap range2=(r(mean)) , reps(100) seed(10) saving(pt2) : summarize ext_id if election_num~=2 & party_id == 2

bootstrap range4= sqrt(r(F)) , reps(100) seed(10) saving(sdt11) : sdtest res1 if election_num~=3 & party_id==1, by(election_num)
bootstrap range5= sqrt(r(F)) , reps(100) seed(10) saving(sdt12) : sdtest res1 if election_num~=3 & party_id==2, by(election_num)


bootstrap range6 =(r(mean)) , reps(100) seed(10) saving(at41) : summarize ext_id if election_num~=2 & a_type3 == 1
bootstrap range7 =(r(mean)) , reps(100) seed(10) saving(at42) : summarize ext_id if election_num~=2 & a_type3 == 2
bootstrap range8=(r(mean)) , reps(100) seed(10) saving(at43) : summarize ext_id if election_num~=2 & a_type3 == 3
bootstrap range9=(r(mean)) , reps(100) seed(10) saving(at44) : summarize ext_id if election_num~=2 & a_type3 == 4

***********************************************************************************************************************************
use election1.dta, clear
gen statecode = 0

replace statecode=	1	if state ==	"AL"
replace statecode=	3	if state ==	"AZ"
replace statecode=	4	if state ==	"AR"
replace statecode=	5	if state ==	"CA"
replace statecode=	6	if state ==	"CO"
replace statecode=	7	if state ==	"CT"
replace statecode=	8	if state ==	"DE"
replace statecode=	10	if state ==	"FL"
replace statecode=	11	if state ==	"GA"
replace statecode=	13	if state ==	"ID"
replace statecode=	14	if state ==	"IL"
replace statecode=	15	if state ==	"IN"
replace statecode=	16	if state ==	"IA"
replace statecode=	17	if state ==	"KS"
replace statecode=	18	if state ==	"KY"
replace statecode=	19	if state ==	"LA"
replace statecode=	20	if state ==	"ME"
replace statecode=	21	if state ==	"MD"
replace statecode=	22	if state ==	"MA"
replace statecode=	23	if state ==	"MI"
replace statecode=	24	if state ==	"MN"
replace statecode=	25	if state ==	"MS"
replace statecode=	26	if state ==	"MO"
replace statecode=	27	if state ==	"MT"
replace statecode=	28	if state ==	"NE"
replace statecode=	29	if state ==	"NV"
replace statecode=	30	if state ==	"NH"
replace statecode=	31	if state ==	"NJ"
replace statecode=	32	if state ==	"NM"
replace statecode=	33	if state ==	"NY"
replace statecode=	34	if state ==	"NC"
replace statecode=	35	if state ==	"ND"
replace statecode=	36	if state ==	"OH"
replace statecode=	37	if state ==	"OK"
replace statecode=	38	if state ==	"OR"
replace statecode=	39	if state ==	"PA"
replace statecode=	40	if state ==	"RI"
replace statecode=	41	if state ==	"SC"
replace statecode=	42	if state ==	"SD"
replace statecode=	43	if state ==	"TN"
replace statecode=	44	if state ==	"TX"
replace statecode=	45	if state ==	"UT"
replace statecode=	46	if state ==	"VT"
replace statecode=	47	if state ==	"VA"
replace statecode=	48	if state ==	"WA"
replace statecode=	49	if state ==	"WV"
replace statecode=	50	if state ==	"WI"
replace statecode=	51	if state ==	"WY"

sort statecode year vote
bys statecode year: gen rank = 1 if _n==_N
bys statecode year: replace rank = 2 if _n==_N-1
replace party = "Democratic" if party == "DEMOCRAT"
replace party = "Democratic" if party == "Democratic "
replace party = "Republican" if party == "REPUBLICAN"
replace party = "Republican" if party == "REPUBLICAN "

gen party_id = 0
replace party_id = 1 if party=="Democratic"
replace party_id = 2 if party=="Republican"

gen open_election = 1 if pos == 3
gen incumbent = 1 if pos == 1
gen challenger = 1 if pos == 2

keep if rank<=2
bys state year: egen total_vote = total(vote)
gen vote_share = vote/total_vote

gen democratic_id = 0
replace democratic_id = 1 if party_id == 1

list party  if party_id ==0

drop if party_id==0
drop if termlimit == "1 term limit"

keep if rank==1

keep if year<=2011
keep if year>=1950

keep if rank==1
bootstrap range3= (r(mean)) , reps(100) seed(10) saving(open) : sum democratic_id if pos==3

use pt1, clear
merge using pt2
drop _merge
merge using open
drop _merge
merge using sdt11
drop _merge
merge using sdt12
drop _merge
merge using at41
drop _merge
merge using at42
drop _merge
merge using at43
drop _merge
merge using at44


sum range1-range9

rm pt1.dta 
rm pt2.dta 
rm open.dta 
rm sdt11.dta 
rm sdt12.dta 
rm at41.dta 
rm at42.dta 
rm at43.dta 
rm at44.dta
