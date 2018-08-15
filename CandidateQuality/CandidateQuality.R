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
library(dplyr)
cand<- read.dta13('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/Elections/replication/Stata/election1.dta')
names(cand)

cand2<- cand %>% #get df of just the winner and runner up
  group_by(state, year) %>% 
  top_n(2, wt=vote) 

cand2$party1<-cand2$party#there was a reason for this, but I don't remember
cand2$party<-substr(cand2$party1,1,1) # get the first letter for merging

test1<-merge(qual, cand2, by=c('state', 'year', 'party'), all.x = T) #merge candidate votes and candidate quality
test1<-test1[,c(1:5, 39, 6:38, 40:44)] #rearrange rows so candidate name strings are next to one another
testcheck<-test1[c(155, 157, 178, 181, 192, 555, 648, 653, 657,658, 662, 697,698, 753),] #df of strings that do not "match"
#155, 157, 192,555,648, 653, 657,658, 662, 753, : wrong, clean out
#178, 181: correct, runner up
#switch 697,698


test1[c(155, 157, 192,555,648, 653, 657,658, 662, 753), c(6,39:44)]<-NA #clean out things that were wrong (candidates did not match and there wasn't a matching candidate for the row), replace with NA
test1$winner<-ifelse(test1$w_g==1,1,0) #code for runner up, basically the same as w_g, but maintains the original col
test1$winner[c(178,181)]<-0
save697<-test1[697,]# save this info so I can switch inputed cand vars 
test1[697, c(6,39:44)]<-test1[698, c(6,39:44)] #save 698 into 697
test1[698, c(6,39:44)]<-save697[,c(6,39:44)]#save 697 into 698
#if winner==1,
setwd('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/CandidateQuality')
write.csv(test1, 'candqualtop2.csv')
