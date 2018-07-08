#This file is essentially useless now
p01<-pvtab2
p02<-pvtab2
p1<-pvtab2
p2<-pvtab2
p3<-pvtab2
p4<-pvtab2
p5<-pvtab2
p6<-pvtab2
p7<-pvtab2
p8<-pvtab2
p9<-pvtab2
p10<-pvtab2
p11<-pvtab2
p12<-pvtab2
p13<-pvtab2
p14<-pvtab2
p15<-pvtab2



names()

names(p01)<-c('state', 'total votes', 
              'Republican Votes', 'Percent Republican Votes',
              'Democrat Votes', 'Percent Democrat Votes', 
              'Third Party Vote', 'Percent Third Party Vote', 'year')

      names(    p02)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names( p1)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(   p2)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(   p3)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(    p4)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(    p5)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(    p6)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(    p7)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(    p8)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(   p9)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(   p10)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(   p11)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(   p12)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(   p13)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(   p14)<-c('state', 'total votes',                'Republican Votes', 'Percent Republican Votes',               'Democrat Votes', 'Percent Democrat Votes',                'Third Party Vote', 'Percent Third Party Vote', 'year')
      names(   p15)<-c('state', 'total votes', 
              'Republican Votes', 'Percent Republican Votes',
              'Democrat Votes', 'Percent Democrat Votes', 
              'Third Party Vote', 'Percent Third Party Vote', 'year')



dat<-rbind(p01,
  p02,
  p1,
  p2,
  p3,
  p4,
  p5,
  p6,
  p7,
  p8,
  p9,
  p10,
  p11,
  p12,
  p13,
  p14,
  p15)

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
