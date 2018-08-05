#------------------------------------------------------------------------------
# Presidential JAR
#------------------------------------------------------------------------------
pjar<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/PresidentialJAR/PresidentialJAR.csv')
colnames(pjar)
#code states------------------------------------------------------------------
statesorder<-as.data.frame(cbind(seq(1:50), 
                                 c('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
                                   'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 
                                   'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH',
                                   'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 
                                   'SC', 'SD', 'TN', 'TX', 'UT',' VT', 'VA','WA', 'WV', 'WI', 'WY')))


names(statesorder)<-c('STATE', 'st')
pjar1<-merge(statesorder, pjar, by='STATE')

#-----------------------------------------------------------------------------
pjar1yr<-pjar1[which(!(pjar1$YEARIN==pjar1$YEAROUT)), c('DATEIN', 'DATEOUT', 'YEAROUT')] # observations where the question spans over the calendar year (such as oct to jan)
changeyr<-which(!(pjar1$YEARIN==pjar1$YEAROUT)) #vector of rows that have weird survey dates
pjar1$YEAROUT[changeyr]<-c(2003, 2003, NA, 2005, NA, 1995)
names(pjar1)
pjar1<-pjar1[-c(3873:3875, 3884:3886,3888:3889, 4405, 4431:4433,323, 648, 2097,2377, 2192, 2193),] #remove rows where there were surveys for former presidents (ex: survey about nixon in 1884)
pjar2<-pjar1[,c('st', 'PARTY', 'POS.PCT', 'NEG.PCT', 'RATING.SC', 'YEAROUT')]
pjar2$PARTY[which(pjar2$PARTY==2)]<-0 #change 2 to 0 to code republican
pjar2$POS.PCT<-pjar2$POS.PCT/100
pjar2$NEG.PCT<-as.integer(as.character(pjar2$NEG.PCT)) #originally was a factor
pjar2$NEG.PCT<-pjar2$NEG.PCT/100
names(pjar2)[-1]<-c('presidential.party', 'percent.approve', 'percent.disapprove', 'presidential.rating', 'year')






#----------------------------------------------------------------------------------
# Find year the JAR question was in the field to get a yearly measure of pres JAR
library(dplyr)
pres<-pjar2%>%
  group_by(st, year)%>%
  summarise(surveys=n(),
            mean.pres.approve=sum(percent.approve)/surveys,
            mean.pres.disapprove=sum(percent.disapprove)/surveys, 
            presidential.party=sum(presidential.party)/surveys)

#reconcile rows where pres party is neither 0 nor 1
which(!(pres$presidential.party==0 | pres$presidential.party==1))

pres$presidential.party[91]<-1
pres$presidential.party[163]<-1

# 91 (should be 1, ca 93) 569 (should be 1, NY 1998) 
pres<-pres[,-3] #remove row of surveys
write.csv(pres, 'PresJAR.csv') #write csv to make final dataset later and not run this code 
