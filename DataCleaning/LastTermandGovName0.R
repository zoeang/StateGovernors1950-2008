gov<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/GovDat.csv')
gov<-gov[, -c(1,23)]
gov<-gov[,-10]
library(dplyr)
gov1<-gov%>%
  group_by(gov_name)%>%
  top_n(term_in_office, n=1)
length(unique(gov1$gov_name))
gov1$last_term<-1
gov2<-gov1[, c(1,3:5, 39)]
gov3<-merge(gov, gov2, by=c('year', 'st', 'gov_name', 'term_in_office'), all.x = T)
gov3<-gov3[,c(1:4, 39, 5:38)]
gov4<-gov3%>%
  arrange(gov_name)
gov4$last_term<-ifelse(is.na(gov4$last_term), 0, gov4$last_term)
table(gov4$last_term)
test0<-gov4[which(gov4$term_in_office==0), c(1:6)] #50
contains(' and ', gov4$gov_name)
gov4$term_in_office[grep(' and ', gov4$gov_name)]<-999#length 9
gov4$term_in_office[grep(' then ', gov4$gov_name)]<-999
gov4$term_in_office[grep(' followed ', gov4$gov_name)]<-999
gov4$term_in_office[grep("/", gov4$gov_name)]<-999

setwd('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/')
write.csv(gov4, 'GovDat.csv')
