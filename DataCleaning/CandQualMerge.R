dat<-read.csv("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/GovDat.csv")


candqual<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/CandidateQuality/candqualtop2.csv')
names(candqual)[2]<-'st'#relabel state as st for merge
candqual$gov_party<-ifelse(candqual$party=="D", 1, 0)# recode to match dat
candqual$year1<-candqual$year#save as different col so I don't have to change col names and orders, which is annoying 
candqual$year<-candqual$year1+1 #add 1 to the year because candqual lists years as the year a candidate ran for office and datall terms starts when a gov takes office (the calendar year after winning election)
candqual1<-candqual[,c('year', 'st', 'winner', 'gov_party', 'name', 'number_endorsements', 'number_cands')]#subset relevant cols
dat1<-merge(dat, candqual1, by=c('st', 'year', 'gov_party'), all.x = T)

#rearrange cols to check that names match 
dat1<-dat1[,c(1:3, 5,42, 41, 6:40, 43:44)]

dat1$winner_endorsements<-ifelse(dat1$winner==1, dat1$number_endorsements, NA) #if the candqual candidate was the winner, save their endorsements as winner_endorsements
dat1$winner_primary_candidates<-ifelse(dat1$winner==1, dat1$number_cands, NA) # is the candqual candidate was the winner, save the number of candidates in their primary election as wnner_primary_candidates

dat1$runnerup_endorsements<-ifelse(is.na(dat1$winner), dat1$number_endorsements, NA) #if candqual candidate was the runnnerup, same process as ^^^
dat1$runnerup_primary_candidates<-ifelse(is.na(dat1$winner==0), dat1$number_cands, NA)

dat2<-dat1[,-c('name', 'winner', 'number_endorsements', 'number_cands')] #remove columns  ##r didn't like this
dat2<-dat1[,-c(5,6,42,43)]#same thing with numbers 
dat2<-dat2[,c(7, 1:6, 8:12, 40:43, 13:39)] #rearrange cols
setwd('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008')
write.csv(dat2, 'GovDatFinal.csv')
