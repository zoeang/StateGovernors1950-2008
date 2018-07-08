clear
set more off
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

sum vote_share democratic_id 

bys pos: sum vote_share democratic_id



