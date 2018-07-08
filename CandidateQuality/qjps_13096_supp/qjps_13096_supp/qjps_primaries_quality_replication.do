
#delimit ;

set linesize 200;



/*****************************/
/* STATEWIDE OFFICE ANALYSIS */
/*****************************/


/* NUMBERS FOR TABLE 1 */

use qjps_primaries_quality_statewide_replication, clear;

drop if name == "";
keep if win == 100;

replace hq_leg = 100 * hq_leg;
replace hq_exe = 100 * hq_exe;

ttest hq_leg, by(office);
local m_G_LEG = r(mu_1);
local n_G_LEG = r(N_1);
local m_S_LEG = r(mu_2);
local n_S_LEG = r(N_2);
local s_LEG = r(se);
local d_LEG = `m_S_LEG' - `m_G_LEG';

ttest hq_exe, by(office);
local m_G_EXE = r(mu_1);
local n_G_EXE = r(N_1);
local m_S_EXE = r(mu_2);
local n_S_EXE = r(N_2);
local s_EXE = r(se);
local d_EXE = `m_S_EXE' - `m_G_EXE';


/* TABLE 1 */

quietly {;

  capture log close;
  log using table_1.tex, text replace;

  noisily display "\begin{table}[htbp] ";
  noisily display "\centering ";
  noisily display "\begin{threeparttable} ";
  noisily display "\caption{\bf Previous Experience of Primary Winners by Office Sought, 1952-2012} \\ ";
  noisily display "\label{table_1} ";
  noisily display "\begin{tabular}{lccc}";
  noisily display "\toprule ";
  noisily display "& \multicolumn{2}{c}{Office Sought} & \\ [.03in] ";
  noisily display "Type of Experience & U.S. Senate & Governor & Difference\\ [.01in] ";
  noisily display "\midrule ";
  noisily display "& & & \\ [-.15in] ";
  noisily display "U.S. Congress        &  " %4.2f `m_S_LEG' "\% &  " %4.2f `m_G_LEG' "\% &  " %4.2f `d_LEG' "  \\ ";
  noisily display "                     & [" %2.0f `n_S_LEG' "]  & [" %2.0f `n_G_LEG' "]  & (" %4.2f `s_LEG' ") \\ [.10in] ";
  noisily display "Statewide or Mayor   &  " %4.2f `m_S_EXE' "\% &  " %4.2f `m_G_EXE' "\% &  " %4.2f `d_EXE' "  \\ ";
  noisily display "                     & [" %2.0f `n_S_EXE' "]  & [" %2.0f `n_G_EXE' "]  & (" %4.2f `s_EXE' ") \\ [.10in] ";
  noisily display "\bottomrule ";
  noisily display "\end{tabular} ";
  noisily display "\begin{tablenotes} ";
  noisily display "{\footnotesize Cell entries in columns 1 and 2 give the percentage of candidates "; 
  noisily display "who won primary with experience of the given type.  Number of cases in brackets.  Entries in column 3 give the ";
  noisily display "difference between column 1 and column 2, and the standard error of this difference in parentheses.} ";
  noisily display "\end{tablenotes} ";
  noisily display "\end{threeparttable} ";
  noisily display "\end{table} ";

  log close;

};


/* NUMBERS FOR TABLE 2 */

use qjps_primaries_quality_statewide_replication, clear;

collapse (max) number_* win* pct* safe dp, by(race_P office party);

gen     party_strength = dp     if party == "D";
replace party_strength = 1 - dp if party == "R";

gen win_hq    = win_hq_rel;
gen number_hq = number_hq_rel;
gen pct_hq    = pct_hq_rel;

replace win_hq    = 0 if number_cands == 0;
replace number_hq = 0 if number_cands == 0; 

drop if win_hq == .;

reg win_hq        party_strength, robust;
local S_b_wh_2 = _b[party_strength];
local S_s_wh_2 = _se[party_strength];
local S_n_wh_2 = e(N);
reg number_cands  party_strength, robust;
local S_b_nc_2 = _b[party_strength];
local S_s_nc_2 = _se[party_strength];
local S_n_nc_2 = e(N);
reg number_hq     party_strength, robust;
local S_b_nh_2 = _b[party_strength];
local S_s_nh_2 = _se[party_strength];
local S_n_nh_2 = e(N);
reg pct_hq        party_strength, robust;
local S_b_ph_2 = _b[party_strength];
local S_s_ph_2 = _se[party_strength];
local S_n_ph_2 = e(N);

sum party_strength;
local sd = r(sd);
display 2 * `sd' * `S_b_wh_2';
pause;


/* NUMBERS FOR TABLE 3 */

use qjps_primaries_quality_statewide_replication, clear;

gen byte badcase_p = 1 if number_hq_rel == 0 | number_hq_rel == number_cands;
replace  badcase_p = 1 if number_cands == 0 | number_cands == 1;
replace  badcase_p = 1 if number_hq_rel == .;

replace hq_rel = hq_rel * 100;

sum hq_rel if win == 100 & badcase_p != 1 & number_cands == 2;
local S_m_hw_2_3 = r(mean);
local S_n_hw_2_3 = r(N);

sum hq_rel if win == 100 & badcase_p != 1 & number_cands >= 3 & number_cands <= 5;
local S_m_hw_35_3 = r(mean);
local S_n_hw_35_3 = r(N);


/* NUMBERS FOR TABLE 5 */

use qjps_primaries_quality_statewide_replication, clear;

gen     exp = 0;
replace exp = 100 if office == "S" & hq_leg == 1;
replace exp = 100 if office == "G" & hq_exe == 1;

sum exp if (safe == 1) & w_g == 1;
local S_m_u_w_5 = r(mean);
local S_n_u_w_5 = r(N);

sum exp if (safe == 1);
local S_m_u_a_5 = r(mean);
local S_n_u_a_5 = r(N);

sum exp if (safe == 0) & w_g == 1;
local S_m_c_w_5 = r(mean);
local S_n_c_w_5 = r(N);

sum exp if (safe == 0);
local S_m_c_a_5 = r(mean);
local S_n_c_a_5 = r(N);


/* PROPORTION OF NOMINEES THAT ARE HIGH-QUALITY BY PRIMARY TYPE */

gen very_open = (state == "AK" & year <= 1960) | (state == "AK" & year >= 1968 & year <= 1990) | (state == "AK" & year >= 1996 & year <= 1998) | (state == "WA" & year >= 1935) | (state == "LA" & year >= 1975) | (state == "CA" & year == 1998) | (state == "CA" & year == 2012);
ttest exp if w_p == 1, by(very_open);



/***********************/
/* U.S. HOUSE ANALYSIS */
/***********************/

use qjps_primaries_quality_house_replication, clear;


/* NUMBERS FOR TABLE 2 AND TEXT */

use qjps_primaries_quality_house_replication, clear;

collapse (max) win_hq number_cands number_hq pct_hq safe dp year, by(race_P party);

gen     party_strength = dp     if party == "D";
replace party_strength = 1 - dp if party == "R";

drop if win_hq == .;

reg win_hq        party_strength, robust;
local H_b_wh_2 = _b[party_strength];
local H_s_wh_2 = _se[party_strength];
local H_n_wh_2 = e(N);
reg number_cands  party_strength, robust;
local H_b_nc_2 = _b[party_strength];
local H_s_nc_2 = _se[party_strength];
local H_n_nc_2 = e(N);
reg number_hq     party_strength, robust;
local H_b_nh_2 = _b[party_strength];
local H_s_nh_2 = _se[party_strength];
local H_n_nh_2 = e(N);
reg pct_hq        party_strength, robust;
local H_b_ph_2 = _b[party_strength];
local H_s_ph_2 = _se[party_strength];
local H_n_ph_2 = e(N);

sum party_strength;
local sd = r(sd);
display 2 * `sd' * `H_b_wh_2';
pause;



/* NUMBERS FOR TABLE 3 */

use qjps_primaries_quality_house_replication, clear;

gen byte badcase_p = 1 if number_hq == 0 | number_hq == number_cands;
replace  badcase_p = 1 if number_cands == 0 | number_cands == 1;
replace  badcase_p = 1 if number_hq == .;

replace hq = hq * 100;

sum hq if win == 100 & badcase_p != 1 & number_cands == 2;
local H_m_hw_2_3 = r(mean);
local H_n_hw_2_3 = r(N);

sum hq if win == 100 & badcase_p != 1 & number_cands >= 3 & number_cands <= 5;
local H_m_hw_35_3 = r(mean);
local H_n_hw_35_3 = r(N);


/* NUMBERS FOR TABLE 5 */

use qjps_primaries_quality_house_replication, clear;
gen exp = 100 * hq;

sum exp if safe == 1 & w_g == 1;
local H_m_u_w_5 = r(mean);
local H_n_u_w_5 = r(N);

sum exp if safe == 1;
local H_m_u_a_5 = r(mean);
local H_n_u_a_5 = r(N);

sum exp if safe == 0 & w_g == 1;
local H_m_c_w_5 = r(mean);
local H_n_c_w_5 = r(N);

sum exp if safe == 0;
local H_m_c_a_5 = r(mean);
local H_n_c_a_5 = r(N);


/* PROPORTION OF NOMINEES THAT ARE HIGH-QUALITY BY PRIMARY TYPE */

gen very_open = (state == "AK" & year <= 1960) | (state == "AK" & year >= 1968 & year <= 1990) | (state == "AK" & year >= 1996 & year <= 1998) | (state == "WA" & year >= 1935) | (state == "LA" & year >= 1975) | (state == "CA" & year == 1998) | (state == "CA" & year == 2012);
ttest exp if w_p == 1, by(very_open);


capture erase tmp1.dta;
capture erase tmp2.dta;
capture erase tmp3.dta;




/*********************/
/* IL JUDGE ANALYSIS */
/*********************/


/* NUMBERS FOR TABLE 2 AND TEXT */

use qjps_primaries_quality_judges_replication, clear;
keep if election_type == "P";

collapse (max) win_hq number_cands number_hq pct_hq safe dnv year, by(race party);

gen     party_strength = dnv     if party == "D";
replace party_strength = 1 - dnv if party == "R";

reg win_hq        party_strength if win_hq != ., robust;
local J_b_wh_2 = _b[party_strength];
local J_s_wh_2 = _se[party_strength];
local J_n_wh_2 = e(N);
reg number_cands  party_strength, robust;
local J_b_nc_2 = _b[party_strength];
local J_s_nc_2 = _se[party_strength];
local J_n_nc_2 = e(N);
reg number_hq     party_strength if win_hq != ., robust;
local J_b_nh_2 = _b[party_strength];
local J_s_nh_2 = _se[party_strength];
local J_n_nh_2 = e(N);
reg pct_hq        party_strength if win_hq != ., robust;
local J_b_ph_2 = _b[party_strength];
local J_s_ph_2 = _se[party_strength];
local J_n_ph_2 = e(N);

sum party_strength if win_hq != .;
local sd = r(sd);
display 2 * `sd' * `J_b_wh_2';
pause;


/* NUMBERS FOR TABLE 3 */

use qjps_primaries_quality_judges_replication, clear;
keep if election_type == "P";

gen byte badcase_p = 1 if number_hq == 0 | number_hq == number_cands;
replace  badcase_p = 1 if number_cands == 0 | number_cands == 1;
replace  badcase_p = 1 if number_hq == .;

replace hq = hq * 100;

sum hq if win == 100 & badcase_p != 1 & number_cands == 2;
local J_m_hw_2_3 = r(mean);
local J_n_hw_2_3 = r(N);

sum hq if win == 100 & badcase_p != 1 & number_cands >= 3 & number_cands <= 5;
local J_m_hw_35_3 = r(mean);
local J_n_hw_35_3 = r(N);


/* NUMBERS FOR TABLE 5 */

use qjps_primaries_quality_judges_replication, clear;

gen w_g = outcome;
gen exp = 100 * hq;

sum exp if safe == 1 & w_g == 1 & election_type == "G";
local J_m_u_w_5 = r(mean);
local J_n_u_w_5 = r(N);

sum exp if safe == 1 & election_type == "P";
local J_m_u_a_5 = r(mean);
local J_n_u_a_5 = r(N);

sum exp if safe == 0 & w_g == 1 & election_type == "G";
local J_m_c_w_5 = r(mean);
local J_n_c_w_5 = r(N);

sum exp if safe == 0 & election_type == "P";
local J_m_c_a_5 = r(mean);
local J_n_c_a_5 = r(N);


/* TABLE 2 */

quietly {;

  capture log close;
  log using table_2.tex, text replace;

  noisily display "\begin{table}[htbp] ";
  noisily display "\centering ";
  noisily display "\begin{threeparttable} ";
  noisily display "\caption{\bf Candidate Quality and Constituency Partisanship in Open Seat Primaries} ";
  noisily display "\label{table_2} ";
  noisily display "\begin{tabular}{lcccc} ";
  noisily display "\toprule ";
  noisily display "                         &                        & Total                  & Number of              & Fraction     \\ ";
  noisily display "Office Sought            & Winner is              & Number of              & High Quality           & High Quality \\ ";
  noisily display "and Time Period          & High Quality           & Candidates             & Candidates             & Candidates   \\ ";
  noisily display "\midrule ";
  noisily display "Governor \& U.S. Senate  &  " %5.3f `S_b_wh_2' "  &  " %5.3f `S_b_nc_2' "  &  " %5.3f `S_b_nh_2' "  &  " %5.3f `S_b_ph_2' " \\ ";
  noisily display "1952-2012                & (" %5.3f `S_s_wh_2' ") & (" %5.3f `S_s_nc_2' ") & (" %5.3f `S_s_nh_2' ") & (" %5.3f `S_s_ph_2' ")\\ "; 
  noisily display "                         & [" %3.0f `S_n_wh_2' "] & [" %3.0f `S_n_nc_2' "] & [" %3.0f `S_n_nh_2' "] & [" %3.0f `S_n_ph_2' "]\\ ";
  noisily display "\midrule ";
  noisily display "U.S. House               &  " %5.3f `H_b_wh_2' "  &  " %5.3f `H_b_nc_2' "  &  " %5.3f `H_b_nh_2' "  &  " %5.3f `H_b_ph_2' " \\ ";
  noisily display "1978-2012                & (" %5.3f `H_s_wh_2' ") & (" %5.3f `H_s_nc_2' ") & (" %5.3f `H_s_nh_2' ") & (" %5.3f `H_s_ph_2' ")\\ ";
  noisily display "                         & [" %3.0f `H_n_wh_2' "] & [" %3.0f `H_n_nc_2' "] & [" %3.0f `H_n_nh_2' "] & [" %3.0f `H_n_ph_2' "]\\ ";
  noisily display "\midrule ";
  noisily display "IL Judges                &  " %5.3f `J_b_wh_2' "  &  " %5.3f `J_b_nc_2' "  &  " %5.3f `J_b_nh_2' "  &  " %5.3f `J_b_ph_2' " \\ ";
  noisily display "1986-2010                & (" %5.3f `J_s_wh_2' ") & (" %5.3f `J_s_nc_2' ") & (" %5.3f `J_s_nh_2' ") & (" %5.3f `J_s_ph_2' ")\\ ";
  noisily display "                         & [" %3.0f `J_n_wh_2' "] & [" %3.0f `J_n_nc_2' "] & [" %3.0f `J_n_nh_2' "] & [" %3.0f `J_n_ph_2' "]\\ ";
  noisily display "\bottomrule ";
  noisily display "\end{tabular} ";
  noisily display "\begin{tablenotes} ";
  noisily display "{\footnotesize Each column presents OLS estimates for a linear regression in which ";
  noisily display "the dependent variable listed at the top of the column is regressed on Primary Constituency Partisanship. ";
  noisily display "The cell entries show the estimated coefficients on Primary Constituency Partisanship, ";
  noisily display "robust standard errors in parenthesis, and the number of observations in brackets. High Quality is defined as follows. ";
  noisily display "For Governor candidates, High Quality = 1 if candidate has previous experience as an elected statewide officer or mayor of a ";
  noisily display "large city.  For U.S. Senate candidates, High Quality = 1 if candidate has previous experience in the U.S. House or U.S. Senate. ";
  noisily display "For U.S. House candidates, High Quality = 1 if candidate has previous experience in the state legislature, U.S. House, U.S. Senate. ";
  noisily display "For IL Judge candidates, High Quality = 1 if candidate was rated favorably by state (or Chicago area) bar associations.  IL Judge ";
  noisily display "races are for state circuit courts.  The number of observations is sometimes lower in the fourth column, because uncontested ";
  noisily display "primaries are dropped (since the dependent variable is undefined for such cases).} ";
  noisily display "\end{tablenotes} ";
  noisily display "\end{threeparttable} ";
  noisily display "\end{table} ";

  log close;

};


/* TABLE 3 */

quietly {;

  capture log close;
  log using table_3.tex, text replace;

  noisily display "\begin{table}[htbp] ";
  noisily display "\centering ";
  noisily display "\begin{threeparttable} ";
  noisily display "\caption{\bf Candidate Quality and Winning in Open Seat Primaries with Variation in Quality} ";
  noisily display "\label{table_3} ";
  noisily display "\begin{tabular}{lcc} ";
  noisily display "\toprule ";
  noisily display "Office Sought            & Races with                & Races with                 \\ ";
  noisily display "and Time Period          & 2 Candidates              & 3-5 Candidates             \\ ";
  noisily display "\midrule ";
  noisily display "Governor \& U.S. Senate  &  " %5.2f `S_m_hw_2_3' "\% &  " %5.2f `S_m_hw_35_3' "\% \\ ";
  noisily display "1952-2012                & [" %3.0f `S_n_hw_2_3' "]  & [" %3.0f `S_n_hw_35_3' "]  \\ ";
  noisily display "\midrule ";
  noisily display "U.S. House               &  " %5.2f `H_m_hw_2_3' "\% &  " %5.2f `H_m_hw_35_3' "\% \\ ";
  noisily display "1978-2012                & [" %3.0f `H_n_hw_2_3' "]  & [" %3.0f `H_n_hw_35_3' "]  \\ ";
  noisily display "\midrule ";
  noisily display "IL Judges                &  " %5.2f `J_m_hw_2_3' "\% &  " %5.2f `J_m_hw_35_3' "\% \\ ";
  noisily display "1986-2010                & [" %3.0f `J_n_hw_2_3' "]  & [" %3.0f `J_n_hw_35_3' "]  \\ ";
  noisily display "\bottomrule ";
  noisily display "\end{tabular} ";
  noisily display "\begin{tablenotes} ";
  noisily display "{\footnotesize Cell entries show percentage of races in which the winning ";
  noisily display "candidate is High Quality. See Table 2 or text for definition of High Quality for each office sought. ";
  noisily display "Number of races in brackets.} ";
  noisily display "\end{tablenotes} ";
  noisily display "\end{threeparttable} ";
  noisily display "\end{table} ";

  log close;

};


/* TABLE 5 */

quietly {;

  capture log close;
  log using table_5.tex, text replace;

  noisily display "\begin{table}[htbp] ";
  noisily display "\centering ";
  noisily display "\begin{threeparttable} ";
  noisily display "\caption{\bf Quality of General Election Winners vs. All Candidates for Open Seats} ";
  noisily display "\label{table_5} ";
  noisily display "\begin{tabular}{lcc} ";
  noisily display "\toprule ";
  noisily display "& Safe      &   Competitive  \\ ";
  noisily display "& District  &   District        \\ ";
  noisily display "\midrule ";
  noisily display "\multicolumn{3}{c}{\bf Governor and U.S. Senate, 1952-2012} \\ ";
  noisily display "\midrule ";
  noisily display "Winners with High Quality    & " %4.2f `S_m_u_w_5' "\% & " %4.2f `S_m_c_w_5' "\% \\ [.03in] ";
  noisily display "All Cands with High Quality  & " %4.2f `S_m_u_a_5' "\% & " %4.2f `S_m_c_a_5' "\% \\ ";
  noisily display "\midrule ";
  noisily display "\multicolumn{3}{c}{\bf U.S. House Representatives, 1978-2012} \\ ";
  noisily display "\midrule ";
  noisily display "Winners with High Quality    & " %4.2f `H_m_u_w_5' "\% & " %4.2f `H_m_c_w_5' "\% \\ [.03in] ";
  noisily display "All Cands with High Quality  & " %4.2f `H_m_u_a_5' "\% & " %4.2f `H_m_c_a_5' "\% \\ ";
  noisily display "\midrule ";
  noisily display "\multicolumn{3}{c}{\bf Illinois Circuit Court Judges} \\ ";
  noisily display "\midrule ";
  noisily display "Winners with High Quality    & " %4.2f `J_m_u_w_5' "\% & " %4.2f `J_m_c_w_5' "\% \\ [.03in] ";
  noisily display "All Cands with High Quality  & " %4.2f `J_m_u_a_5' "\% & " %4.2f `J_m_c_a_5' "\% \\ ";
  noisily display "\bottomrule ";
  noisily display "\end{tabular} ";
  noisily display "\begin{tablenotes} ";
  noisily display "{\footnotesize Cell entries give the percentage races where a high quality candidate was elected to office.} ";
  noisily display "\end{tablenotes} ";
  noisily display "\end{threeparttable} ";
  noisily display "\end{table} ";

  log close;

};


/*************************/
/* ENDORSEMENTS ANALYSIS */
/*************************/

use qjps_primaries_quality_endorsements_replication, clear;

foreach i in 1 2 3 {;

  sum  good_rel_`i'_a  if NUM == 2;
  local m_`i'_a_2  = r(mean);	
  local n_`i'_a_2  = r(N);

  sum  good_rel_`i'_a  if NUM >= 3;
  local m_`i'_a_34 = r(mean);
  local n_`i'_a_34 = r(N);

  sum  good_rel_`i'_b  if NUM == 2;
  local m_`i'_b_2  = r(mean);
  local n_`i'_b_2  = r(N);

  sum  good_rel_`i'_b  if NUM >= 3;
  local m_`i'_b_34 = r(mean);
  local n_`i'_b_34 = r(N);

  sum  good_rel_`i'_c  if NUM == 2;
  local m_`i'_c_2  = r(mean);
  local n_`i'_c_2  = r(N);

  sum  good_rel_`i'_c  if NUM >= 3;
  local m_`i'_c_34 = r(mean);
  local n_`i'_c_34 = r(N);

};

/* TABLE 4 */

quietly {;

  capture log close;
  log using table_4.tex, text replace;

  noisily display "\begin{table}[htbp] ";
  noisily display "\centering ";
  noisily display "\begin{threeparttable} ";
  noisily display "\caption{\bf Primary Outcomes and Endorsements, 1990-2012} ";
  noisily display "\label{table_4} ";
  noisily display "\begin{tabular}{lcc}";
  noisily display "\toprule\ ";
  noisily display "Definition of Highly   & 2 Cands      & 3+ Cands \\ ";
  noisily display "Endorsed Candidate     & in Primary   & in Primary \\[.01in] ";
  noisily display "\midrule ";
  noisily display "At Least 3 Endorsements    &  " %4.1f `m_3_a_2' "\% &  " %4.1f `m_3_a_34' "\% \\ "; 
  noisily display "\quad and 75\% of Total    & [" %2.0f `n_3_a_2' "]  & [" %2.0f `n_3_a_34' "] \\ [.03in] ";
  noisily display "At Least 2 Endorsements    &  " %4.1f `m_2_a_2' "\% &  " %4.1f `m_2_a_34' "\% \\ ";
  noisily display "\quad and 75\% of Total    & [" %2.0f `n_2_a_2' "]  & [" %2.0f `n_2_a_34' "] \\ [.01in] ";
  noisily display "\midrule ";
  noisily display "At Least 3 Endorsements    &  " %4.1f `m_3_b_2' "\% &  " %4.1f `m_3_b_34' "\% \\ ";  
  noisily display "\quad and 67\% of Total    & [" %2.0f `n_3_b_2' "]  & [" %2.0f `n_3_b_34' "] \\ [.03in] ";
  noisily display "At Least 2 Endorsements    &  " %4.1f `m_2_b_2' "\% &  " %4.1f `m_2_b_34' "\% \\ ";  
  noisily display "\quad and 67\% of Total    & [" %2.0f `n_2_b_2' "]  & [" %2.0f `n_2_b_34' "] \\ [.01in] ";
  noisily display "\bottomrule ";
  noisily display "\end{tabular} ";
  noisily display "\begin{tablenotes} ";
  noisily display "{\footnotesize Cell entries give the percentage of endorsed candidates who won primary. ";
  noisily display "Number of observations in brackets.} ";
  noisily display "\end{tablenotes} ";
  noisily display "\end{threeparttable} ";
  noisily display "\end{table} ";

  log close;

};

