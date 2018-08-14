library(readstata13)
qual <- read.dta13("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/CandidateQuality/qjps_primaries_quality_statewide_replication.dta")
qual<-subset(qual, office=="G") #Subset to gov; original includes Senators
#==============================================================================
# Assign numeric value to party label; assign same name as csp column
#==============================================================================
table(qual$party)
qual$govparty_a<-ifelse(qual$party=="R", 0, 1)
qual<-subset(qual, w_p==1)
qual$name<-toupper(qual$name)
#ref code
#subset both winner and runner up--------------------------------------------------------


#----------------------------
library(readstata13)
cand<- read.dta13('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/Elections/replication/Stata/election1.dta')
names(cand)

cand2<- cand %>% 
  group_by(state, year) %>% 
  top_n(2, wt=vote) 
cand2$candidate<-toupper(cand2$candidate)
cand2$party1<-cand2$party
cand2$party<-substr(cand2$party1,1,1)



test1<-merge(qual, cand2, by=c('state', 'year', 'party'), all.x = T)
test1<-test1[,c(1:5, 38, 6:37, 39:44)]
testcheck<-test1[c(155, 157, 178, 181, 192, 555, 648, 653, 657,658, 662, 697,698, 753),]
#155, 157, : wrong, clean out
#178, 181: correct, runner up
