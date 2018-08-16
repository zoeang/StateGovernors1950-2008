# Change in var: (var_1/var_0)-1 ------------------------------------
#Group by year and state to create lag
library(tidyr)
library(plyr) #load plyr before dplyr because witchcraft and wizardry (and satan)
library(dplyr)
library(data.table)
csp<-fread('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/correlatesofstatepolicyprojectv1_14.csv')
#subset csp: should ultimately be 3382 rows
csp<-subset(csp, year>=1950, select = c(year, st,total_debt_outstanding_gsp))
csp<-csp[-(which(csp$st=='DC')),] #remove DC
csp<-csp[-c(which(csp$st=="AK" & csp$year<1959), which(csp$st=="HI" & csp$year<1959)),] #remove HI and AK from 1950-1958
csp<-data.table(csp) #convert to data table
lg <- function(x)c(NA, x[1:(length(x)-1)]) #lag function

#1. change in total_debt_outstanding_gsp from last year
csp2<-csp[,lag_total_debt_outstanding_gsp := lg(total_debt_outstanding_gsp), by = c("st")]#lag total_debt_outstanding_gsp within state
csp2$change_total_debt_outstanding_gsp<-ifelse(!is.na(csp2$total_debt_outstanding_gsp) & !is.na(csp2$lag_total_debt_outstanding_gsp),
                             (csp2$total_debt_outstanding_gsp/csp2$lag_total_debt_outstanding_gsp)-1, NA) #create change_gsp var
#2. total_debt_outstanding_gsp minus the mean of total_debt_outstanding_gsp for all states in that year
csp3<-csp2 %>% 
  group_by(year) %>% 
  mutate(new_debt = scale(total_debt_outstanding_gsp, scale=F))
#3. change in the measure above from last year
csp3<-data.table(csp3)
csp4<-csp3[,lag_new_debt := lg(new_debt), by = eval(("st"))]#lag new_debt within state
csp4$change_new_debt<-ifelse(!is.na(csp4$new_debt) & !is.na(csp4$lag_new_debt),
                                               (csp4$new_debt/csp4$lag_new_debt)-1, NA) #create change_gsp var


#merge csp4 and pre-condensed govdat; then, condense to gov/term 
govprelim<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/prelimGovDat1.csv')
govprelim<-govprelim[,c(2,4,5,6)] #get year, st (to match now) and gov_name, term_in_office (to match with the condensed version)
govdebt<-merge(csp4, govprelim, by=c('year', 'st'), all.x = T)
#find mean of values by term
govdebt0 <- as.data.frame(govdebt)
govdebt1<-govdebt0%>%
  group_by(gov_name,term_in_office)%>%
  summarise(total_debt_outstanding_gsp=mean(total_debt_outstanding_gsp, na.rm = T),
            change_total_debt_outstanding_gsp=mean(change_total_debt_outstanding_gsp, na.rm=T),
            new_debt=mean(new_debt, na.rm=T),
            change_new_debt=mean(change_new_debt, na.rm=T)
            )
#merge with existing final data
govdat<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/GovDatFinal.csv')
govmerge<-merge(govdat, govdebt1, by=c('gov_name', 'term_in_office'), all.x = T)
govmerge<-govmerge[,-3]# rm col of indices
govmerge<-govmerge[,c(5,3,4,1,2,6:ncol(govmerge))]
names(govmerge)[c(47:48)]<-c('scaled_total_debt_outstanding_gsp', 'change_scaled_total_debt_outstanding_gsp')
govmerge<-govmerge[,-45]# remove extra total_debt_outstanding_gsp
names(govmerge)[21]<-'total_debt_outstanding_gsp'
govmerge<-govmerge[,c(1:21, 45:47, 22:44)]
govmerge<-govmerge%>% #group my state then year
  arrange(st, year)

write.csv(govmerge, 'GovDatFinal.csv')
