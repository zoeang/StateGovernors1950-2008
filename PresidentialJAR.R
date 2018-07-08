#------------------------------------------------------------------------------
# Presidential JAR
#------------------------------------------------------------------------------
pjar<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/PresidentialJAR.csv')
colnames(pjar)
states<-dat$st[order(unique(dat$st))] #order states alphabetically; relies on csp loaded as 'dat'
states<-states[-8] #remove "DC"
statesorder<-states[c(2,1,4,3, 5:11,13:15,12,16:18,21,20,19,
                      22,23,25,24,26,29,33,30:32,34,27,28,35:44,
                      46,45,47,49,48,50)]

pjar$st<-sapply(pjar$STATE, function(x) statesorder[x]) #match state number to state code 
colnames(pjar)
pjar<-pjar[ ,c(ncol(pjar),4:7,9,10)] #maintain and arrange the relevant columns

write.csv(pjar, 'PresJAR.csv') #write csv to make final dataset later and not run this code 
