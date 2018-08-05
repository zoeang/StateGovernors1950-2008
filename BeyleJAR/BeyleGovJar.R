#==============================================================================
#Beyle Gov Job Approval Rating
#==============================================================================

jar<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/BeyleGovJAR.csv')
states<-dat$st[order(unique(dat$st))] #order states alphabetically; relies on csp loaded as 'dat'
states<-states[-8] #remove "DC"
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

jarvars<-jar[,c(2,4:7, 10:12)] #maintain the relevant columns
write.csv(jarvars, "GovJAR.csv")

