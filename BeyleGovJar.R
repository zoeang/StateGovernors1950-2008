#==============================================================================
#Beyle Gov Job Approval Rating
#==============================================================================

jar<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/BeyleJAR/BeyleGovJAR.csv')
states<-dat$st[order(unique(dat$st))] #order states alphabetically; relies on csp loaded as 'dat'
states<-states[-c(1,11)] #remove second AZ
#==============================================================================
# Aside: It is incredibly inconvenient that the state names are not in the same alphabetical order
# as the state codes. I don't know if I should be disappointed with the individual responsible for this,
# or myself for my 23 years of ignorance on this matter. It just feels a bit personal.  
#==============================================================================
# Order state codes to match state name order
statesorder<-states[c(2,1,4,3, 5:11,13:15,12,16:18,21,20,19,
                      22,23,25,24,26,29,33,30:32,34,27,28,35:44,
                      46,45,47,49,48,50)]
jar$st<-sapply(jar$STATE, function(x) statesorder[x]) #match state number to state code 
jar<-jar[,c(1,ncol(jar),2:(ncol(jar)-1))] # move the state columns next to one another
#----------------------------------------
#whatever I did above was dumb and probably took me more time than I spent on below
#-------------------------------------------------------------------------------
statesorder<-as.data.frame(cbind(seq(1:50), 
                           c('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
               'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 
               'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH',
               'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 
               'SC', 'SD', 'TN', 'TX', 'UT',' VT', 'VA','WA', 'WV', 'WI', 'WY')))


names(statesorder)<-c('STATE', 'st')
jar1<-merge(statesorder, jar, by='STATE')
#----------------------------------------------------------------------------------
# Find year the JAR question was in the field to get a yearly measure of gov JAR

jar1yr<-jar1[which(!(jar1$YEARIN==jar1$YEAROUT)),] # observations where the question spans over the calendar year (such as oct to jan)
changeyr<-which(!(jar1$YEARIN==jar1$YEAROUT)) #vector of rows that have weird survey dates
jar1$YEAROUT[changeyr]<-c(1992, NA, NA, NA, NA, 1994, NA, #replace with more accurate number
                                                         NA, NA, NA, NA, 1995, NA, 1996, 
                                                         NA, 1991, 1992, 1992, 1993, 1994, 1996)
names(jar1)
jarvars<-jar1[,c('st', 'NAME', 'POSPCT', 'NEGPCT', "RATINGSC", 'YEAROUT', 'SAMPLE')]
jarvars$POSPCT<-jarvars$POSPCT/100 #convert to proportion
jarvars$NEGPCT<-jarvars$NEGPCT/100 #convert to proportion
names(jarvars)[-1]<-c('gov.name', 'percent.approve', 'percent.dissaprove', 'JAR.rating', 'year', 'sample.size')
class(jarvars$sample.size)
#get average for gov by year 
library(dplyr)
totsample.names<-jarvars%>% #find average approval/disapproval means; not weighted
  group_by(year, st)%>%
  summarise(surveys=n(),
            mean.approve=sum(percent.approve)/surveys,
            mean.disapprove=sum(percent.dissaprove)/surveys, 
            mean.rating=sum(RATINGSC)/surveys)

jarvars1<-totsample[,-3]
setwd('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/BeyleJAR')
write.csv(jarvars1, "GovJAR.csv") #df of approval/disapproval by st and year

