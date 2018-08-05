#==============================================================================
# Variables and Information
#==============================================================================
# See format for election2 from Candidate
# preserve some economic measures (maybe; only 24 states; worth getting 27 more?)
# merge1= 49 states; missing Alaska and DC
#==============================================================================
# Unit of analysis: governor term
#Scope: All states from 1950 to as close to now as possible
#Governor
#---govname1; govname2
#State
#Party of governor
#---govparty_a: up to 2011
#Governor same party as President? Dummy.
#Term: is this governor in his/her first term, second, term, or what?
#---(term_length)
#Election year
#Term limits: One term limit, limited to two consecutive terms, limited to two lifetime terms, no term limit (this changes over time within some states)
#---limit_type (1959-2009) from file "GovTermLimits"
#Lame duck: Is this governor in his/her lame duck term (ineligible for reelection)
#---lame_duck_last_term (1960-2010)
#---lame_duck_last_year
#Governor job approval rating (JAR): From Beyle data and try to extend forward in time
#A bunch of other measures of government performance (unemployment, economic growth, etc.) :  Mostly to impute gaps in JAR data
#--- real_inc1000s_quar (real personal income)
#--- employ_pop (rolling employment population ratio; 2008-2015)
#--- state_cpi_bfh OR state_cpi_bfh_est(state CPI) OR pfh_cpi_multiplier (change in state CPI)
#--- gsp_q(Gross state product 1963-2010)
#--- total_revenue (total state revenue)
#--- total_expenditure (total state expenditure ) (combine into rate ^^)
#Presidential approval: Average during that governor's term
#State liberalism: A variety of public opinion measures are available from CSP. Presidential vote might also be used. 
#--- citi6013 (citizen idology 1960-2013)
#--- Wideo (weighted state ideology score )
#Election-level variables (note: should pertain to the election at the BEGINNING of that term, so the election in which this governor took office for this term)
#--- gub_election (gubernatorial election that year; calendar year)
#Number of votes for governor
#---(ranney3_gub_prop) proportion of two party vote for dem gub candidate
#Number of votes for best performing opponent
#Candidate "quality" for both candidates (Hirano & Snyder data)
#-- Electoral competitiveness
#-- folded_ranney_4yrs



library(csp)
library(dplyr)
library(tidyr)
library(data.table)
dat_all<-fread("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/correlatesofstatepolicyprojectv1_14.csv")
dat<-subset(dat_all, year>=1950) #subset to year>= 1950 for ease of creating new columns

#==============================================================================
#Create Governor same party as President dummy variable
#!!! Need govparty_a for 2012-2018 for future 
#==============================================================================
dem<-c(1950:1952, 1961:1968, 1977:1980, 1993:2000, 2009:2016) #years with D president
#Note^: Presidential terms overlap due to inaguration occurring once a year has already started
# The year in which a new president was inagurated is coded as the party of the incoming president.
# Example: The Bush administration as from 2001-2009; the Obama administration was from 2009-2017. 
# 2001 is coded as 1 for Republican; 2009 is 0 for Democrat.



#Double check this; post-2008 still have gov.pres party values
# Only create am element up to year 2008; leave post-2008 blank
#When the party of thegovernor changes mid-year (eight cases),
#the fraction of the year with a Democratic governor is put in as a value. 
3486-length(which(dat$year>2008)) #3029 rows range from year 1950-2008

#Create a column of the president's party (oh my gosh, this is so slow. I need to learn how to use apply functions)
for (i in 1:3029){
if(dat$year[i] %in% dem){
  dat$pres_party[i]<-0 #0== D president
} else{
  dat$pres_party[i]<-1 #1== R president
}
}

#Match the governors' and presidents' party
dat$gov_pres_same_party<-ifelse(dat$govparty_a== dat$pres_party, 1, 0)

#return column govparty_a to original form
dat$govparty_a<-ifelse(dat$govparty_a==2, NA, dat$govparty_a)

#==============================================================================
# Gov and Pres election in the same year? Might control for coattail
#==============================================================================

#create a vector of rows where it is a presidential and gubernatorial election year 
gov_pres_elect<-which(dat$prez_election_year==1 & dat$prez_election_year==dat$gub_election)

for(i in gov_pres_elect){ #assign 1 to each row in which the president and governor are elected in the same year
  dat$gov_pres_same_elect_year[i]<-1
}

#assign 0 to all other entries for the column
dat$gov_pres_same_elect_year<-ifelse(is.na(dat$gov_pres_same_elect_year), 0, dat$gov_pres_same_elect_year)

#==============================================================================
# Subset the relevant variables
#==============================================================================
dat1<-subset(dat, year>=1950, select=c(year,
                                       st, 
                                       state,
                                       govname1,
                                       govparty_a, #party: 1=D; 0=R; .5=I; no data post-2011
                                       gov_pres_same_party, #created this variable
                                       term_length,
                                       gub_election, #1=gov election that year
                                       gov_pres_same_elect_year, #created this variable; 1=gov and pres were elected in the same year
                                       limit_type, #ask Keith; reference ballotopedia (credible?)
                                       lame_duck_last_term, #ineligible for reelection
                                       new_gov_b, # Gov incumbency
                                       unemployment, 
                                       pc_inc_ann,#per capita income
                                       bfh_cpi_multiplier, #percent change in cpi
                                       state_cpi_bfh_est, #state Consumer price index
                                       gini_coef, #Gini coefficient income inequality
                                       citi6013, #citizen ideology; 1960-2013
                                       wideo, #weighted state ideology; 1976-2011
                                       mood, #Stimson's policy mood; starts in 1956
                                       ranney3_gub_prop, # proportion of two party vote for dem gub candidate
                                       folded_ranney_4yrs #electoral competitiveness
                                       ))
setwd("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008")
write.csv(dat1,'prelimGovDat.csv') #write this in a .csv for now so I don't have to rerun the previous lines

#------------------------------------------------------------------------------
library(data.table)
pdat<-fread("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/prelimGovDat.csv")

#add unemployment from 2005-2017
unemp<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/unemployment_tidy.csv')
pdat2<-merge(pdat[,-1], unemp[,2:4],by= c('year', 'st'), all.x=T)

#candidate vote info: votes for winner and runner up
cand<-read.csv("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/Elections/cand_vote.csv")
#create proportion of vote for runner up, because apparently I didn't
cand$runnerup_vote_proportion<-cand$votes_for_runnerup/cand$total_votes
colnames(cand)[7]<-"winner_vote_proportion" #name column meaningfully
#create difference in percentage of vote: winner - runnerup
cand$diff_vote_proportion<-cand$winner_vote_proportion-cand$runnerup_vote_proportion
pdat3<-merge(pdat2, cand[,-1], by= c('year', 'st'), all.x=T)

setwd("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008")
write.csv(pdat3,'prelimGovDat.csv')
dat<-read.csv("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/prelimGovDat.csv")

#--------------------------------
#fill in term limit
#--------------------------------
# https://www.thegreenpapers.com/Hx/LengthOfTermGovernor.phtml

#4 yrs: AL, CA, CT, DE, FL, GA, ID, IN, KY, LA, MD, MS, MO, MT, NV, NJ, NY, NC, OK, OR, PA, SC, UT
 #       VA, WA, WV, WY
dat$term_length[which(is.na(dat$term_length) & dat$st=="AL" | dat$st=="CA"
                      | dat$st=="CT" | dat$st=="DE" |dat$st=="FL" |
                        dat$st=="GA" | dat$st=="ID" |dat$st=="IN" |dat$st=="KY" |
                        dat$st=="LA" | dat$st=="MD" | dat$st=="MS" | dat$st=="MO"
                      | dat$st=="MT"| dat$st=="NV" | dat$st=="NJ"| dat$st=="NY"
                      | dat$st=="NC" | dat$st=="OK" | dat$st=="OR" | dat$st=="PA"
                      | dat$st=="SC" | dat$st=="UT" | dat$st=="VA" | dat$st=="WA"
                      | dat$st=="WV"| dat$st=="WY")]<-4

#AK, 4 yrs
dat$term_length[which(is.na(dat$term_length) & dat$st=="AK" &dat$year>=1958)]<-4

#AZ 1950-68=2yr; 1970- present=4yrs
dat$term_length[which(is.na(dat$term_length) & dat$st=="AZ" & dat$year<1970 )]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="AZ" & dat$year>=1970)]<-4


#AR 1950-84=2; 1986-present=4
dat$term_length[which(is.na(dat$term_length) & dat$st=="AR" & dat$year<1986 )]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="AR" & dat$year>=1986)]<-4


#CO 1950-56=2; 1958 post=4
dat$term_length[which(is.na(dat$term_length) & dat$st=="CO" & dat$year<1958)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="CO" & dat$year>=1958)]<-4

#HI 1962 post=4
dat$term_length[which(is.na(dat$term_length) & dat$st=="HI" & dat$year>=1962)]<-4

#IL 1976=2yr, else= 4
dat$term_length[which(is.na(dat$term_length) & dat$st=="IL")]<-4
dat$term_length[which(is.na(dat$term_length) & dat$st=="IL"  & dat$year==1976)]<-2

#IA, KS, SD, TX 1950-72=2, 1974 post=4
dat$term_length[which(is.na(dat$term_length) & dat$st=="IA" & dat$year<1974)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="IA" & dat$year>=1974)]<-4

dat$term_length[which(is.na(dat$term_length) & dat$st=="KS" & dat$year<1974)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="KS" & dat$year>=1974)]<-4

dat$term_length[which(is.na(dat$term_length) & dat$st=="SD" & dat$year<1974)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="SD" & dat$year>=1974)]<-4

dat$term_length[which(is.na(dat$term_length) & dat$st=="TX" & dat$year<1974)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="TX" & dat$year>=1974)]<-4

#ME, OH 1950-56=2, 1958 post=4
dat$term_length[which(is.na(dat$term_length) & dat$st=="ME" & dat$year<1958)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="ME" & dat$year>=1958)]<-4

dat$term_length[which(is.na(dat$term_length) & dat$st=="OH" & dat$year<1958)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="OH" & dat$year>=1958)]<-4

#MA, MI, NE 1950-64=2; 1966 post=4
dat$term_length[which(is.na(dat$term_length) & dat$st=="MA" & dat$year<1966)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="MA" & dat$year>=1966)]<-4

dat$term_length[which(is.na(dat$term_length) & dat$st=="MI" & dat$year<1966)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="MI" & dat$year>=1966)]<-4

dat$term_length[which(is.na(dat$term_length) & dat$st=="NE" & dat$year<1966)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="NE" & dat$year>=1966)]<-4

#MN 1950-60=2; 1962 post=4
dat$term_length[which(is.na(dat$term_length) & dat$st=="MN" & dat$year<1964)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="MN" & dat$year>=1964)]<-4

#NH, VT 2 yr
dat$term_length[which(is.na(dat$term_length) & dat$st=="NH")]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="VT")]<-2
#NM, WI 1950-68=2, 1970 post=4
dat$term_length[which(is.na(dat$term_length) & dat$st=="NM" & dat$year<1970)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="NM" & dat$year>=1970)]<-4

dat$term_length[which(is.na(dat$term_length) & dat$st=="WI" & dat$year<1970)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="WI" & dat$year>=1970)]<-4

#ND 1950-62=2, 1964 post=4
dat$term_length[which(is.na(dat$term_length) & dat$st=="ND" & dat$year<1964)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="ND" & dat$year>=1964)]<-4

#RI 1950-92=2, 1994 post=4
dat$term_length[which(is.na(dat$term_length) & dat$st=="RI" & dat$year<1994)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="RI" & dat$year>=1994)]<-4

#TN 1950-52=2, 1954 post=4
dat$term_length[which(is.na(dat$term_length) & dat$st=="TN" & dat$year<1954)]<-2
dat$term_length[which(is.na(dat$term_length) & dat$st=="TN" & dat$year>=1954)]<-4

#check----
show<-which(is.na(dat$term_length))
dat[show, c(2,3,8)]
unique(dat$st[which(is.na(dat$term_length))])
dat$year[which(is.na(dat$term_length) & dat$st=="ND")]
#-----------------------------------------------------
#remove AK and HI when not a state

dat<-dat[which(!(dat$st=='AK' & dat$year<1959)),]
dat<-dat[which(!(dat$st=='HI' & dat$year<1959)),]

setwd("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008")
write.csv(dat,'prelimGovDat.csv')

#==============================================================================
#Merge popular vote data
#==============================================================================
dat<-read.csv("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/prelimGovDat.csv")
popvote<-read.csv("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/PopularVote/PopularVote.csv")
popvote<-popvote[, -1]
names(dat)
dat1<-merge(dat[,-c(1,2)], popvote, by=c('state', 'year'),all.x=T)

#Fill in gov names and party
dat1$govname1<-as.character(dat1$govname1) #coerce from factor to string
dat1$govname1[c(63:68)]<-"Bentley, Robert" #AL gov 2012-2017
dat1[c(63:68),5]<-0 #republican ^^^

dat1[c(122:124),4]<-"Parnell, Sean" #AK gov 2009-2014
dat1[c(122:124),5]<-0 #rep^^^
dat1[c(125:127),4]<-"Walker, Bill"
dat1[c(125:127),5]<-.5 #independent ^^^
dat1$govname1<-as.character(dat1$govname1)

dat1[128,4]<-"Garvey, Dan" #AZ 1950 
dat1[c(129:133),4]<-"Pyle, John" 
dat1[133,4]<-"McFarland, Ernest W."

dat1[c(190:192),4]<-'Brewer, Jan' #az, 2009-15
dat1[c(190:195),5]<-0#rep
dat1[c(193:195),4]<-'Ducey, Doug'#2015 to present

dat1[c(196:198),4]<-"McMath, Sid"
dat1[c(199:201),4]<-"Cherry, Francis"
dat1[c(258:260),4]<-"Beebe, Mike"
dat1[c(258:260),5]<-1
dat1[c(261:263),4]<-"Hutchinson, Asa"
dat1[c(261:263),5]<-0
dat1[c(264:267),4]<-"Warren, Earl" #CA, 1950-53
dat1[c(268:269),4]<-"Knight, Goodwin" #ca, 1954-5
dat1[c(326:331),c(4,5)]<-dat1[325, c(4,5)] #ca present gov
dat1[c(394:399),c(4,5)]<-dat1[393, c(4,5)]#co present gov
dat1[c(462:467),c(4,5)]<-dat1[461, c(4,5)]#ct present gov
dat1[c(530:534),c(4,5)]<-dat1[529, c(4,5)]#de 2009-17
dat1[535, 4]<-"Carney, John"
dat1[535, 5]<-1
dat1[c(666:671),c(4,5)]<-dat1[665, c(4,5)]#fl present gov
dat1[c(734:739),c(4,5)]<-dat1[733, c(4,5)]#GA present gov
dat1[740,5]<-0 #HI gov party, 1959
dat1[c(793:795),c(4,5)]<-dat1[792, c(4,5)]#HI 2010-2014 gov
dat1[c(796:798),4]<-"Ige, David"#HI 2015-present gov
dat1[c(861:866),c(4,5)]<-dat1[860, c(4,5)]#ID present gov
dat1[c(929:931),c(4,5)]<-dat1[928, c(4,5)]#IL 2009-2014/15
dat1[c(932:934),4]<-"Rauner, Bruce"
dat1[c(932:934),5]<-0
dat1[c(997),c(4,5)]<-dat1[996, c(4,5)]
dat1[c(998:1001),4]<-"Pence, Mike"
dat1[c(998:1001),5]<-0
dat1[c(1002),c(4,5)]<-c("Holcomb, Eric", 0)
dat1[c(1065:1069),c(4,5)]<-dat1[1064, c(4,5)]
dat1[c(1070),5]<-0
dat1[c(1133:1138),c(4,5)]<-dat1[1132, c(4,5)]
dat1[c(1201:1204),c(4,5)]<-dat1[1200, c(4,5)]
dat1[c(1205:1206),4]<-'Bevin, Matt'
dat1[c(1205:1206),5]<-0
dat1[c(1269:1272),c(4,5)]<-dat1[1268, c(4,5)] #LA 12-15
dat1[c(1273:1274),5]<-1
dat1[c(1273:1274),4]<-'Edwards, John'
dat1[c(1337:1342),c(4,5)]<-dat1[1336, c(4,5)] #ME present gov
dat1[c(1405:1407),c(4,5)]<-dat1[1404, c(4,5)]
dat1[c(1406:1410),5]<-0
dat1[c(1406:1410),4]<-"Hogan Jr., Lawrence"
dat1[c(1473:1475),c(4,5)]<-dat1[1472, c(4,5)]
dat1[c(1476:1478),5]<-0
dat1[c(1476:1478),4]<-"Baker, Charlie"
dat1[c(1541:1546),c(4,5)]<-dat1[1540, c(4,5)]#MI present gov
dat1[c(1609:1614),c(4,5)]<-dat1[1608, c(4,5)]#MN present gov
dat1[c(1677:1682),5]<-0
dat1[c(1677:1682),4]<-'Bryant, Phil'
dat1[c(1745:1749),c(4,5)]<-dat1[1744, c(4,5)]#MO
dat1[1750,4]<-"Greitens, Eric"
dat1[1750,5]<-0
dat1[1813, c(4,5)]<-dat1[1812, c(4,5)]
dat1[c(1814:1818),4]<-'Bullock, Steve'
dat1[c(1814:1818),5]<-1
dat1[c(1881:1883), c(4,5)]<-dat1[1880, c(4,5)]
dat1[c(1884:1886),4]<-'Ricketts, Pete'
dat1[c(1884:1886),5]<-0
dat1[c(1949:1954), c(4,5)]<-dat1[1948, c(4,5)]
dat1[2017, c(4,5)]<-dat1[2016, c(4,5)]
dat1[c(2018:2021),5]<-1
dat1[c(2018:2021),4]<-'Hassan, Maggie'
dat1[2022,5]<-0
dat1[2022,4]<-'Sununu, Chris'
dat1[c(2085:2090), c(4,5)]<-dat1[2084, c(4,5)]#NJ present
dat1[c(2153:2158), c(4,5)]<-dat1[2152, c(4,5)] #nm
dat1[c(2221:2226), c(4,5)]<-dat1[2220, c(4,5)] #ny
dat1[c(2289:2293),5]<-0
dat1[c(2289:2293),4]<-'McCrory, Pat'
dat1[2294,5]<-1
dat1[2294,4]<-'Cooper, Roy'
dat1[c(2357:2361), c(4,5)]<-dat1[2356, c(4,5)] #ny
dat1[2362,5]<-0
dat1[2362,4]<-"Burgum, Doug"
dat1[c(2425:2430), c(4,5)]<-dat1[2424, c(4,5)] #OH
dat1[c(2493:2498), c(4,5)]<-dat1[2492, c(4,5)] 
dat1[c(2561:2563), c(4,5)]<-dat1[2560, c(4,5)]
dat1[2564,4]<-'Kitzhaber, John A./Brown, Kate'
dat1[2564,5]<-1
dat1[c(2565, 2566), 4]<-'Brown, Kate'
dat1[c(2565, 2566), 5]<-1
dat1[c(2629:2631), c(4,5)]<-dat1[2628, c(4,5)]
dat1[c(2632:2634),5]<-1
dat1[c(2632:2634),4]<-'Wolf, Tom'
dat1[c(2697:2698), c(4,5)]<-dat1[2696, c(4,5)]
dat1[c(2699:2700), 4]<-dat1[2696, 4]
dat1[c(2699:2702), 5]<-1
dat1[c(2701:2702), 4]<-'Raimondo, Gina'
dat1[c(2765:2769), c(4,5)]<-dat1[2764, c(4,5)]
dat1[2770, 5]<-0
dat1[2770, 4]<-'McMaster, Henry'
dat1[c(2833:2838),c(4,5)]<-dat1[2832, c(4:5)] #SD
dat1[c(2901:2906),c(4,5)]<-dat1[2900, c(4:5)] #TN
dat1[c(2969:2971),c(4,5)]<-dat1[2968, c(4:5)]
dat1[c(2972:2974), 5]<-0
dat1[c(2972:2974), 4]<-"Abbott, Greg"
dat1[c(3037:3042),c(4,5)]<-dat1[3036, c(4:5)] #UT
dat1[c(3105:3109),c(4,5)]<-dat1[3104, c(4:5)] #VT

dat1[3110, 5]<-0
dat1[3110, 4]<-"Scott, Phil"
dat1[c(3173:3174),c(4,5)]<-dat1[3172, c(4:5)] #VA
dat1[c(3175:3178), 5]<-1
dat1[c(3175:3178), 4]<-'McAuliffe, Terry'
dat1[c(3179:3184), 4]<-'Langlie, Arthur B.'
dat1[3241, c(4:5)]<-dat1[3240, c(4:5)]
dat1[c(3242:3246), 5]<-1
dat1[c(3242:3246), 4]<-'Inslee, Jay'
dat1[c(3309:3313),c(4,5)]<-dat1[3308, c(4:5)] #WV
dat1[3314, 5]<-.5
dat1[3314, 4]<-'Justice, Jim'
dat1[3114,c(4,5)]<-dat1[3113, c(4:5)] 
dat1[c(3315:3320), 4]<-'Kohler Jr., Walter J.'
dat1[c(3377:3382),c(4,5)]<-dat1[3376, c(4:5)] #WI
dat1[c(3445:3450),c(4,5)]<-dat1[3444, c(4:5)] #WY
getwd()
write.csv(dat1, 'prelimGovDat.csv')
#==============================
# combine unemployment.x and unemployment.y
#============================
which(!(is.na(dat$unemployment.x)) & !(is.na(dat$unemployment.y))) #no lines where there are values for both unemployment variables
dat$unemployment<-ifelse(is.na(dat$unemployment.x), dat$unemployment.y, dat$unemployment.x)
dat<-dat[, c(2:12,34,14:19, 21:33)]

length(which(!is.na(dat$diff_vote_proportion)))

#============================
# add gross state product
#============================
library(data.table)

prelim<-read.csv("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/prelimGovDat.csv")
csp_all<-fread("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/correlatesofstatepolicyprojectv1_14.csv")
csp<-subset(csp_all, year>=1950) #subset to year>= 1950 for ease of creating new columns
del<-c(which(csp$state=="Hawaii" & csp$year<1959), which(csp$state=="Alaska" & csp$year<1959)) #remove AK and HI pre 1959
csp<-csp[-del, ]
prelim$gross_state_product<-csp$gsp_q


# Change in GSP: (gsp_1/gsp_0)-1 ------------------------------------
#Group by year and state to create lag
library(tidyr)
library(dplyr)
library(plyr)
prelimdt<-data.table(prelim) #convert to data table
lg <- function(x)c(NA, x[1:(length(x)-1)]) #lag function
prelimdt2<-prelimdt[,lgsp := lg(gross_state_product), by = c("state")]#lag gsp within state
prelimdt2$change_gsp<-ifelse(!is.na(prelimdt2$gross_state_product) & !is.na(prelimdt2$lgsp),
                              (prelimdt2$gross_state_product/prelimdt2$lgsp)-1, NA) #create change_gsp var
write.csv(prelimdt2[,-1], 'prelimGovDat.csv')
