clear 
set more off
use merged_data2.dta, clear
keep if year<=2011
keep if year>=1950


replace income_growth = income_growth*100
replace spread2 = spread2*100
replace population = population/1000000
replace aged = aged*100
replace kids = kids*100

gen democratic_party=1 if party_id==1

sum real_sales_tax1 real_income_tax real_corp_tax real_expenditure income_growth spread2 real_compensation2 
*sum real_income population aged kids bind  democratic_party

