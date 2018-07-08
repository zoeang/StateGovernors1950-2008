#Get presidential vote to make a state liberalism measure

#install.packages('XML')
library(XML)
library(stringr)
setwd('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/PopularVote')


#------------------------------------------------------------------------------
# 1952
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=1952'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(11:58),c(1:4, 6,7)]
pvtab2[,c(7,8)]<-NA
pvtab2[,9]<-1952
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
write.csv(pvtab2, 'pv1952.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 1956
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=1956'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(11:58),c(1:4, 6,7)]
pvtab2[,c(7,8)]<-NA
pvtab2[,9]<-1956
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)
pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
write.csv(pvtab2, 'pv1956.csv')
rm(list=ls())

#------------------------------------------------------------------------------
# 1960
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=1960'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(9:58),c(1,2,6,7, 3,4)]
pvtab2[,c(7,8)]<-NA
pvtab2[,9]<-1960
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)
pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
write.csv(pvtab2, 'pv1960.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 1964
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=1964'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(10:60),c(1,2,6,7, 3,4)]
pvtab2[,c(7,8)]<-NA
pvtab2[,9]<-1964
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)

pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv1964.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 1968
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=1968'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(9:59),c(1:4, 6,7,9,10)]
pvtab2[,9]<-1968
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)

pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv1968.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 1972
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=1972'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(10:60),c(1,2,3,4, 6,7)]
pvtab2[,c(7,8)]<-NA
pvtab2[,9]<-1972
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)

pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv1972.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 1976
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=1976'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(10:60),c(1,2,6,7, 3,4)]
pvtab2[,c(7,8)]<-NA
pvtab2[,9]<-1976
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)
pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv1976.csv')
rm(list=ls())

#------------------------------------------------------------------------------
# 1980
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=1980'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(9:59),c(1:4, 6,7,9,10)]
pvtab2[,9]<-1980
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)

pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv1980.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 1984
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=1984'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(10:60),c(1,2,3,4, 6,7)]
pvtab2[,c(7,8)]<-NA
pvtab2[,9]<-1984
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)

pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv1984.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 1988
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=1988'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(10:60),c(1,2,3,4, 6,7)]
pvtab2[,c(7,8)]<-NA
pvtab2[,9]<-1988
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)

pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv1988.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 1992
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=1992'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(9:59),c(1:2,6,7,3,4,9,10)]
pvtab2[,9]<-1992
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)

pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv1992.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 1996
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=1996'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(9:59),c(1:2,6,7,3,4,9,10)]
pvtab2[,9]<-1996
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)

pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv1996.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 2000
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=2000'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(9:59),c(1:4, 6,7,9,10)]
pvtab2[,9]<-2000
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)

pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv2000.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 2004
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=2004'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(9:59),c(1,2,3,4, 6,7)]
pvtab2[,c(7,8)]<-NA
pvtab2[,9]<-2004
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)

pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv2004.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 2008
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=2008'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(9:64),c(1,2, 6,7, 3,4)]
pvtab2[,c(7,8)]<-NA
pvtab2[,9]<-2008
str_match(pvtab2[,1], "CD")
pvtab2<-pvtab2[-c(21,22,31,32,33),]
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)

pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv2008.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 2012
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=2012'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(11:61),c(1,2, 6,7, 3,4)]
pvtab2[,c(7,8)]<-NA
pvtab2[,9]<-2012
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)

pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv2012.csv')
rm(list=ls())
#------------------------------------------------------------------------------
# 2016
#------------------------------------------------------------------------------
pv<-'http://www.presidency.ucsb.edu/showelection.php?year=2016'
pvt<-readHTMLTable(pv, header=T, stringAsFactors=F)
pvtab1<-as.data.frame(pvt[12])
pvtab2<-pvtab1[c(13:66),c(1,2, 6,7,3,4,9,10)]
pvtab2[,9]<-2016
str_match(pvtab2[,1], "CD")
pvtab2<-pvtab2[-c(29,30,31),]
names(pvtab2)<-c('state', 'total votes', 
                 'Republican Votes', 'Percent Republican Votes',
                 'Democrat Votes', 'Percent Democrat Votes', 
                 'Third Party Vote', 'Percent Third Party Vote', 'year')
pvtab2$state<-as.character(pvtab2$state)

pvtab2$state<-str_replace(pvtab2$state, "\\*", "")
pvtab2$state<-str_replace(pvtab2$state, "Dist. of Col.", "District of Columbia")
write.csv(pvtab2, 'pv2016.csv')
rm(list=ls())


#=============================================================
names(dat)<-c('state', 'total_popular_votes', 
              'Republican_Popular_Vote', 'Percent_Republican_Popular_Vote',
              'Democrat_Popular_Votes', 'Percent_Democrat_Popular_Vote', 
              'Third_Party_Popular_Vote', 'Percent_Third_Party_Popular_Vote', 'year')
dat$state<-as.character(dat$state)
dat$state<-str_replace(dat$state, "\\*", "")
dat$`Percent Republican Votes`<-str_replace(dat$`Percent Republican Votes`, "%", "")
dat$state<-str_replace(dat$state, "Dist. of Col.", "District of Columbia")
dat1<-dat[,c(1,9,2:8)]
write.csv(dat1, 'PopularVote.csv')