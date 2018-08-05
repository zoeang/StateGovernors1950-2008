dat<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/prelimGovDat.csv')
library(dplyr)
dat$govname1<-as.character(dat$govname1)
dat$govname1<-ifelse(dat$govname1=="", NULL, dat$govname1)
unemp<-dat%>%
  group_by(year, state, govname1)%>%
  summarise(mean(unemployment, na.rm=T))


dat[which(dat$govname1==sav),]
str(dat)
dat$govname1<-as.factor(dat$govname1)
length(is.na(dat$govname1))
class(dat$govname1)
dat$govname1[5]<-'Johnson, Walter Walford'
dat$govname1[c(54, 103, 152,201,250)]<-'Thonton, Daniel I.J.'
dat$govname1[11]<-'Robins, C.A.'
dat$govname1[c(60,109,158,207)]<-'Jordan, Leonard B.'
dat$govname1[256]<-'Smylie, Robert E.'
dat$govname1[c(12,61,110)]<-'Stevensn II, Adlai'
dat$govname1[c(159,208,257)]<-dat$govname1[306]
dat$govname1[c(14,63,112,161)]<-'Beardsley, William S.'

dat$govname1[c(210,259)]<-'Elthon, Leo'
dat$govname1[512]<-dat$govname1[563]
dat$govname1[3415]<-'Reynolds, Kim'
dat$govname1[15]<-'Hagaman, Frank L.'
dat$govname1[c(64,113,162,211)]<-'Arn, Edward F.'
dat$govname1[260]<-dat$govname1[309]
dat$govname1[115]<-'Long, Earl K./Kennon, Robert F.'
dat$govname1[c(20,69,118)]<-'Dever, Paul A.'
dat$govname1[c(167,216,265)]<-dat$govname1[314]
dat$govname1[c(21,70,119,168,217,266)]<-dat$govname1[315]
dat$govname1[22]<-'Youngdahl, Luther W.'
dat$govname1[71]<-'Youngdahl, Luther W./Anderson, C. Elmer'
dat$govname1[c(120,169,218)]<-'Anderson, C. Elmer'
dat$govname1[267]<-dat$govname1[316]
dat$govname1[c(25,74,123)]<-'Bonner, John W.'
dat$govname1[c(172,221,270)]<-dat$govname1[319]
dat$govname1[c(26,75,124)]<-'Peterson, Val'
dat$govname1[c(173, 222)]<-'Crosby, Robert B.'
dat$govname1[271]<-dat$govname1[320]
dat$govname1[27]<-'Pittman, Vail M.'
dat$govname1[c(76,125,174,223,272)]<-dat$govname1[321]
dat$govname1[c(28,77,126)]<-'Adams, Sherman'
dat$govname1[c(175,224)]<-'Gregg, Hugh'
dat$govname1[273]<-dat$govname1[322]
dat$govname1[c(31,80,129,178,227)]<-'Dewey, Thomas'
dat$govname1[276]<-dat$govname1[325]
dat$govname1[33]<-'Aandahl, Fred G.'
dat$govname1[c(82,131,180,229,278)]<-dat$govname1[327]
dat$govname1[which(dat$st=="OH" & dat$year<1956)]<-dat$govname1[328]
dat$govname1[which(dat$st=="RI" & dat$year<1956)]<-dat$govname1[332]
dat$govname1[38]<-'Pastore, John Orlando/McKiernan, John S.'
dat$govname1[40]<-'Mickelson, George T.'
dat$govname1[c(89,138,187, 236)]<-'Anderson, Sigurd'
dat$govname1[285]<-dat$govname1[334]
dat$govname1[which(dat$st=="TX" & dat$year<1956)]<-dat$govname1[336]
dat$govname1[which(dat$st=="UT" & dat$year<1956)]<-dat$govname1[337]
dat$govname1[44]<-'Arthur, Harold J.'
dat$govname1[c(93,142,191,240)]<-'Emerson, Lee E.'
dat$govname1[289]<-dat$govname1[338]
dat$govname1[49]<-'Crane, Arthur G.'
dat$govname1[c(98,147)]<-'Barrett, Frank A.'
dat$govname1[c(196,245)]<-'Rogers, Clifford J.'
dat$govname1[294]<-dat$govname1[343]
setwd('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008')
write.csv(dat, 'prelimGovDat.csv')
unem<-c(5.6,7.9,4.4,4.5,3.9,
        5.1,4.7,8.6,4.6,5.5,
        5.4,4.2,3.3,3.7,4.9,
        6.5,5.1,4.8,3.4,5.8,
        3.6,5.7,2.6,5.0,3.2,
        6.2,2.9,4.4,4.9,6.4,
        5.4,2.9,5.1,2.8,4.1,
        4.3,5.8,7.6,3.7,4.0)
sts<-c('Alabama','Alaska', 'Arizona', 'Arkansas', 'Colorado',
       'Connecticut', 'Deleware', 'District of Columbia','Georgia', 'Hawaii',
       'Idaho', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 
       'Louisiana','Maine', 'Maryland', 'Minnesota', 'Mississippi',
       'Missouri', 'Montana', 'Nebraska', 'Nevada','New Hampshire',
       'New Mexico', 'North Dakota', 'Oklahoma', 'Oregon' , 'Rhode Island',
       'South Carolina', 'South Dakota', 'Tennessee', 'Utah','Vermont',
       'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming')
unem1995<-as.data.frame(cbind(sts, unem))
unem1995$year<-1995
names(unem1995)<-c('state', 'unemployment.1', 'year')
dat1<-merge(dat, unem1995, by=c('state',  'year'), all.x = T)
dat1$unemployment<-ifelse()

which(dat$unemployment==NA)
write.csv(unem1995, 'unemployment1995.csv')
