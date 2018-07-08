clear
set more off
  
use merged_data.dta, clear

sort statecode year 
by statecode: gen pop_growth = (population-population[_n-1])/ population[_n-1]
by statecode: gen income_growth = (personal_income-personal_income[_n-1])/personal_income[_n-1]
by statecode: gen debt_growth = (debt-debt[_n-1])/debt[_n-1]
gen spread1 = interest1/debt
gen spread2 = interest2/debt

replace workercompbenpaymtsy14 = workercompbenpaymtsy14[_n+1] if year==1950

gen real_sales_tax1 =  totsales/cpi*100/population*1000
gen real_sales_tax2 =  totalgensalestaxt09/cpi*100/population*1000
gen real_income_tax =   individualincometaxt40/cpi*100/population*1000
gen real_corp_tax =    corpnetincometaxt41/cpi*100/population*1000
gen real_expenditure =  generalexpenditure/cpi*100/population*1000
gen real_income =  personal_income/cpi*100/population*1000
gen real_minimum_wage = minimum_wage/cpi*100
gen real_compensation = compensation/cpi*100
gen real_total_tax = totaltax/cpi*100/population*1000
gen real_sales_income = real_sales_tax1 + real_income_tax

gen real_compensation2 = workercompbenpaymtsy14/cpi*100/population*1000
gen real_unemployemnt = unempcomptotalexp/cpi*100/population*1000

save merged_data2.dta, replace

*keep if year<=2011
*keep if termlimit_id == 2 | termlimit_id == 4
           
gen election_id = "1st term" if bind==0 & reelection_id ==1
replace election_id = "2nd term"  if bind==1 & reelection_id ==1
replace election_id = "extremist" if extremist>=1 & extremist<=3

gen election_code = 1000*nextelection + statecode*10 + party_id         

merge m:1 election_code using election2.dta
tab _merge
drop if _merge==2 & year>=1950

drop candidate _merge
gen stc = statecode
*************************************************
* state name
gen statename= "a"			
replace statename=	"AL"	if stc ==	1
replace statename=	"AZ"	if stc ==	3
replace statename=	"AR"	if stc ==	4
replace statename=	"CA"	if stc ==	5
replace statename=	"CO"	if stc ==	6
replace statename=	"CT"	if stc ==	7
replace statename=	"DE"	if stc ==	8
replace statename=	"FL"	if stc ==	10
replace statename=	"GA"	if stc ==	11
replace statename=	"ID"	if stc ==	13
replace statename=	"IL"	if stc ==	14
replace statename=	"IN"	if stc ==	15
replace statename=	"IA"	if stc ==	16
replace statename=	"KS"	if stc ==	17
replace statename=	"KY"	if stc ==	18
replace statename=	"LA"	if stc ==	19
replace statename=	"ME"	if stc ==	20
replace statename=	"MD"	if stc ==	21
replace statename=	"MA"	if stc ==	22
replace statename=	"MI"	if stc ==	23
replace statename=	"MN"	if stc ==	24
replace statename=	"MS"	if stc ==	25
replace statename=	"MO"	if stc ==	26
replace statename=	"MT"	if stc ==	27
replace statename=	"NE"	if stc ==	28
replace statename=	"NV"	if stc ==	29
replace statename=	"NH"	if stc ==	30
replace statename=	"NJ"	if stc ==	31
replace statename=	"NM"	if stc ==	32
replace statename=	"NY"	if stc ==	33
replace statename=	"NC"	if stc ==	34
replace statename=	"ND"	if stc ==	35
replace statename=	"OH"	if stc ==	36
replace statename=	"OK"	if stc ==	37
replace statename=	"OR"	if stc ==	38
replace statename=	"PA"	if stc ==	39
replace statename=	"RI"	if stc ==	40
replace statename=	"SC"	if stc ==	41
replace statename=	"SD"	if stc ==	42
replace statename=	"TN"	if stc ==	43
replace statename=	"TX"	if stc ==	44
replace statename=	"UT"	if stc ==	45
replace statename=	"VT"	if stc ==	46
replace statename=	"VA"	if stc ==	47
replace statename=	"WA"	if stc ==	48
replace statename=	"WV"	if stc ==	49
replace statename=	"WI"	if stc ==	50
replace statename=	"WY"	if stc ==	51

save merged_election.dta, replace


