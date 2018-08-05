#condense dataset to gov/term
library(dplyr)
dat<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/prelimGovDat1.csv')
dat<-dat[,-1] #remove col of row index
dat1<- dat%>%group_by(gov_name, term_in_office)%>%top_n( -1, year) #maintain year when office was taken, state, st of gov
dat2<-test1%>%
  group_by(gov_name, term_in_office)%>%
  summarise(unemployment=mean(unemployment, na.rm=T),
            state_cpi=mean(state_cpi, na.rm=T),
            gross_state_product=mean(gross_state_product, na.rm=T),
            change_gsp=mean(change_gsp, na.rm=T),
            electoral_competitiveness=mean(electoral_competitiveness, na.rm=T),
            citizen_ideology=mean(citizen_ideology, na.rm=T),
            state_ideology=mean(state_ideology, na.rm=T),
            stimson_mood=mean(stimson_mood, na.rm=T),
            votes_for_runnerup=mean(votes_for_runnerup, na.rm=T), # find avg with NA omit; takes one number, but compensates if the number of votes was not on the same line as top_n -1
            votes_for_winner=mean(votes_for_winner, na.rm=T),
            total_gub_votes=mean(total_gub_votes, na.rm=T),
            winner_vote_proportion=mean(winner_vote_proportion, na.rm=T),
            runnerup_vote_proportion=mean(runnerup_vote_proportion, na.rm=T),
            diff_vote_proportion=mean(diff_vote_proportion, na.rm=T),
            mean_gub_approve=mean(mean_gub_approve, na.rm=T),
            mean_gub_disapprove=mean(mean_gub_disapprove, na.rm=T),
            Republican_Popular_Vote=mean(Republican_Popular_Vote, na.rm=T),
            Democrat_Popular_Vote=mean(Democrat_Popular_Vote, na.rm=T),
            Third_Party_Popular_Vote=mean(Third_Party_Popular_Vote, na.rm=T),
            total_popular_votes=mean(total_popular_votes, na.rm=T),
            Republican_Popular_Vote_Proportion=mean(Republican_Popular_Vote_Proportion, na.rm=T),
            Democrat_Popular_Vote_Proportion=mean(Democrat_Popular_Vote_Proportion, na.rm=T),
            Third_Party_Popular_Vote_Proportion=mean(Third_Party_Popular_Vote_Proportion, na.rm=T),
            mean_pres_approve=mean(mean_pres_approve, na.rm=T),
            mean_pres_disapprove=mean(mean_pres_disapprove, na.rm=T)
            )
dat3<-merge(dat1[,1:5], dat2, by=c('gov_name', 'term_in_office'), all.y = T)
dat4<-dat3[, c(3:5,1,2, 6:ncol(dat3))]
dat5<-merge(dat1[,1:12], dat4[,4:ncol(dat4)], by=c('gov_name', 'term_in_office') )

which(!(names(dat1)%in%names(dat6)))
dat6<-merge(dat5, dat1[,c('gov_name', 'term_in_office', 'pres_party', 'gub_dem_vote_prop')], by=c('gov_name', 'term_in_office'))
dat6<-dat6%>%
  arrange(state, year)
dat6<-dat6[,c(3:5,1,2,6:20,ncol(dat6), 21:ncol(dat6)-1)]


#fill pres_party 
dem<-c(1950:1952, 1961:1968, 1977:1980, 1993:2000, 2009:2016) #years with D president
dat6$pres_party<-ifelse(dat6$year%in% dem, 1,0)
getwd()
write.csv(dat6, 'GovDat.csv') #data set
