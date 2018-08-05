gov<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/GovElectionVotes/GovVotes.csv')
#remove stupid commas from elements

#convert to character
for(i in c(3:5,7,8,10)){ #this doesn't work, which is dumb
gov[,i]<-as.character(gov[,i])
#gov[,i]<-as.numeric(gsub(",","",gov[i]))

}
#delete comma
gov[,3]<-as.numeric(gsub(",","",gov[,3]))
gov[,4]<-as.numeric(gsub(",","",gov[,4]))
gov[,5]<-as.numeric(gsub(",","",gov[,5]))

gov[,7]<-as.numeric(gsub(",","",gov[,7]))
gov[,8]<-as.numeric(gsub(",","",gov[,8]))
gov[,10]<-as.numeric(gsub(",","",gov[,10]))
#name cols for merge
names(gov)[c(1,2)]<-c('year', 'state')
#replace string NA with NA
gov[gov=="N/A"]<-NA
#delete cols for third vote (issue with NA, so had to do this separately)
gov$ThirdVotesAll<-as.character(gov2$ThirdVotesAll)
gov$ThirdVotesAll<-as.numeric(gsub(",","",gov2$ThirdVotesAll))
#get the number of votes for runner up 
for(i in c(1:539, 541:643, 645:nrow(gov))){
  gov$second[i]<-sort(gov[i,c(4:7)], decreasing=T)[2]
}
gov1<-gov[,c(1:3, 18, 4:17)] #check
#==========================================================
# merge dfs
#=========================================================
dat1<-merge(dat, gov, by=c('year', 'state'), all.x = T)

#-----------------
#WHy is this not working now?-----------
#------------------------
dat1$PluralityPartyAll<-as.character(dat1$PluralityPartyAll) #convert to string to test logical

#
dat1$votes_for_winner<-ifelse(is.na(dat1$votes_for_winner) & dat1$PluralityPartyAll=="R", dat1$RepVotesAll,  dat1$votes_for_winner)
dat1$votes_for_winner<-ifelse(is.na(dat1$votes_for_winner) & dat1$PluralityPartyAll=="D", dat1$DemVotesAll,  dat1$votes_for_winner)
dat1$votes_for_winner<-ifelse(is.na(dat1$votes_for_winner) & dat1$PluralityPartyAll=="T", dat1$ThirdVotesAll,  dat1$votes_for_winner)
dat1$votes_for_winner<-ifelse(is.na(dat1$votes_for_winner) & dat1$PluralityPartyAll=="O", dat1$OtherVotesAll,  dat1$votes_for_winner)

#runner up votes
dat1$votes_for_runnerup<-ifelse(is.na(dat1$votes_for_runnerup), dat1$second, dat1$votes_for_runnerup)
dat1$votes_for_runnerup<-as.character(dat1$votes_for_runnerup)
dat1$votes_for_runnerup<-ifelse(dat1$votes_for_runnerup=="NA",NA,dat1$votes_for_runnerup)
dat1$votes_for_runnerup<-as.numeric(dat1$votes_for_runnerup)
class(dat1$votes_for_runnerup)
#Total votes
dat1$total_votes<-ifelse(is.na(dat1$total_votes), dat1$TotalVotesAll, dat1$total_votes)

#winner_vote_proportion: divide by 100 to get proportion
dat1$winner_vote_proportion<-ifelse(is.na(dat1$winner_vote_proportion) & dat1$PluralityPartyAll=="R", dat1$RepVotesTotalPercentAll/100,  dat1$winner_vote_proportion)
dat1$winner_vote_proportion<-ifelse(is.na(dat1$winner_vote_proportion) & dat1$PluralityPartyAll=="D", dat1$DemVotesTotalPercentAll/100,  dat1$winner_vote_proportion)
dat1$winner_vote_proportion<-ifelse(is.na(dat1$winner_vote_proportion) & dat1$PluralityPartyAll=="T", dat1$ThirdVotesTotalPercentAll/100,  dat1$winner_vote_proportion)
dat1$winner_vote_proportion<-ifelse(is.na(dat1$winner_vote_proportion) & dat1$PluralityPartyAll=="O", dat1$OtherVotesTotalPercentAll/100,  dat1$winner_vote_proportion)

#runnerup_vote_proportion
dat1$runnerup_vote_proportion<-ifelse(is.na(dat1$runnerup_vote_proportion), (dat1$votes_for_runnerup/dat1$total_votes), dat1$runnerup_vote_proportion)

##diff_vote_proportion
dat1$diff_vote_proportion<-ifelse(is.na(dat1$diff_vote_proportion), (dat1$winner_vote_proportion-dat1$runnerup_vote_proportion), dat1$diff_vote_proportion)
names(dat1)
dat1<-dat1[,c(1:31)] #remove merged cols

#there are more commas :(
dat1$total_popular_votes<-as.character(dat1$total_popular_votes)
dat1$total_popular_votes<-as.numeric(gsub(",","",dat1$total_popular_votes))

dat1$Republican_Popular_Vote<-as.character(dat1$Republican_Popular_Vote)
dat1$Republican_Popular_Vote<-as.numeric(gsub(",","",dat1$Republican_Popular_Vote))

names(dat1)[28]<-'Democrat_Popular_Vote'
dat1$Democrat_Popular_Vote<-as.character(dat1$Democrat_Popular_Vote)
dat1$Democrat_Popular_Vote<-as.numeric(gsub(",","",dat1$Democrat_Popular_Vote))

dat1$Third_Party_Popular_Vote<-as.character(dat1$Third_Party_Popular_Vote)
dat1$Third_Party_Popular_Vote<-as.numeric(gsub(",","",dat1$Third_Party_Popular_Vote))

#Change percent variables to proportions
dat1$Percent_Republican_Popular_Vote<-(dat1$Percent_Republican_Popular_Vote/100)
dat1$Percent_Democrat_Popular_Vote<-(dat1$Percent_Democrat_Popular_Vote/100)
dat1$Percent_Third_Party_Popular_Vote<-(dat1$Percent_Third_Party_Popular_Vote/100)

colnames(dat1)[c(27,29,31)]<-c('Republican_Popular_Vote_Proportion',
                               'Democrat_Popular_Vote_Proportion',
                               'Third_Party_Popular_Vote_Proportion')
setwd('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008')
write.csv(dat1, 'prelimGovDat.csv')
