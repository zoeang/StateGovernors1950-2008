install.packages('expss')

for (i in 1:9){
  load(paste0('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/GeneralElectionData/00013-000',i,'-Data.rda'))
  
}
for (i in 10:15){
  load(paste0('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/GeneralElectionData/00013-00',i,'-Data.rda'))
  
}
allElec<-rbind(da00013.0001,
               da00013.0002,
               da00013.0003,
               da00013.0004,
               da00013.0005,
               da00013.0006,
               da00013.0007,
               da00013.0008,
               da00013.0009,
               da00013.0010,
               da00013.0011,
               da00013.0012,
               da00013.0013,
               da00013.0014,
               da00013.0015)

da00013.0001l<-as.list(da00013.0001)
colSums(da00013.0001[,4:ncol(da00013.0001)], na.rm = T)
names(da00013.0002)


#get state code -----------------------------------------------------------------
library(tidyr)
library(dplyr)
library(stringr)
stcode<-da00013.0015[,4:5] #subset statecode and county
stcode<-separate(stcode, V4, c('state_number', 'state'), sep=' ', extra='merge') #break string into number and state
stcode$state_number[1:3140]<-substr(stcode$state_number[1:3140], 2,3) #remove parens
colnames(stcode)[3]<-"county_name" #name county col
stcodekey<-unique(stcode[,1:2]) #create df key for merging


#pres 2
pres2<-da00013.0002[,1:29]
pres2$year<-1976
head(pres2)

#pres 3: 1952-60


#---------------------
if(da00013.0002$V1==42){
  sum(da00013.0002$V30)
}
