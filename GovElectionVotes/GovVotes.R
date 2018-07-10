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
#Total votes
dat1$total_votes<-ifelse(is.na(dat1$total_votes), dat1$TotalVotesAll, dat1$total_votes)
names(dat1)
