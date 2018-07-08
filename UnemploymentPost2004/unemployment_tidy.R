#the unemployment matrix was apparently a dumb way to organize the data

unemp<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/unemploymentPost2004.csv')

library(stringr)
colnames(unemp)<- str_replace(colnames(unemp), 'X', '') #remove X from col names (thanks  excel)
colnames(unemp)[1]<-'st' #name state code col


library(dplyr)
library(tidyr)

unemp1<-as.data.frame(unemp) %>% #make new df where year is a variable, rather than column name
  mutate(id = rownames(.)) %>%
  gather(colnames(unemp), unemployment, -id)
head(unemp1)

#the first 51 rows do not have unemployment data, but do have the state code; the other rows
# have unemployment data, but not the state code
# "merge" the two portions of the df
unemp2<-merge(unemp1[1:51,],unemp1[52:714,], by='id')
unemp2<-unemp2[,3:5] #remove meaningless cols
colnames(unemp2)<-c('st', 'year', 'unemployment') #name cols for merging

setwd('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008')
write.csv(unemp2, 'unemployment_tidy.csv')
#----------------------


