#number of votes for the winning candidate and runner up

library(readstata13)
library(dplyr)
election1<- read.dta13('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/Elections/replication/Stata/election1.dta')
gov_votes <- election1 %>% 
  group_by(state, year)


#year 1948 mislabeled as 1984; correct it ------------------------------------------------
gov_votes$year[which(gov_votes$year==1984 & gov_votes$vote==226958 )]<-1948

#create a df with a col of total vote by election/year and state---------------------------
voteByYearByState <- gov_votes %>% 
  group_by(state, year) %>% 
  summarise( totalByYearByState=sum(vote))
voteByYearByState

#merge the created df to make the total vote a column in the gov_vote df------------------
gov_vote2<-merge(gov_votes, voteByYearByState, by=c('state', 'year'), all=T, sort=F)
#create a col of proportion of the total vote (all parties, not two party)
gov_vote2$vote_prop<-(gov_vote2$vote/gov_vote2$totalByYearByState)
head(gov_vote2)

#subset both winner and runner up--------------------------------------------------------
gov_vote3<- gov_vote2 %>% 
  group_by(state, year) %>% 
  top_n(2, wt=vote) 
#subset df of only the winner -----------------------------------------------------------
gov_win<- gov_vote2 %>% 
  group_by(state, year) %>% 
  top_n(1, wt=vote) 

gov_win_sub<-gov_win[,c(1,2,5,10,11)] #select relevant cols
colnames(gov_win_sub)[3:5]<-c("votes_for_winner", 'total_votes', 'vote_proportion') #rename cols

#subset runner up-----------------------------------------------------------------------
gov_vote3$index<-rep(c(0,1), 269)
gov_vote_run<-gov_vote3[which(gov_vote3$index==1),c(1,2,5)]
colnames(gov_vote_run)[3]<-'votes_for_runnerup'

#merge the runner and winner dfs-------------------------------------------------------
gov_outcome<-merge(gov_vote_run, gov_win_sub, by=c('state', 'year'))
colnames(gov_outcome)[1]<-'st'
setwd('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/Elections')
write.csv(gov_outcome, 'cand_vote.csv')

#-----------------------------------------------



