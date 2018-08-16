#====================================================================
# To add a new col from csv, run this file and replace 'total_debt_outstanding_gsp' on line 10
# with the csp variable
#====================================================================

#load csp
library(data.table)
csp<-fread('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/correlatesofstatepolicyprojectv1_14.csv')
#subset csp: should ultimately be 3382 rows
csp<-subset(csp, year>=1950, select = c(year, st,total_debt_outstanding_gsp))
csp<-csp[-(which(csp$st=='DC')),] #remove DC
csp<-csp[-c(which(csp$st=="AK" & csp$year<1959), which(csp$st=="HI" & csp$year<1959)),] #remove HI and AK from 1950-1958

#load prelim dat (not condensed)
govdat<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/prelimGovDat1.csv')
govdat<-govdat[,-1]#remove col of row index
#add csp col
govdat1<-merge(govdat, csp, by=c('year', 'st'))

#condense new col from csp to gov/term row
gov<-govdat1%>%
  group_by(gov_name, term_in_office)%>%
  summarise(total_debt_outstanding_gsp=mean(total_debt_outstanding_gsp, na.rm=T))

fin<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/GovDatFinal.csv')
wdebt<-merge(fin, gov, by=c('term_in_office', 'gov_name'), all.x = T)
wdebt<-wdebt[,c(4:6, 2,1,7:21, 45, 22:44)] #reorder cols, get rid of X index col

write.csv(wdebt, 'GovDatFinal.csv')
