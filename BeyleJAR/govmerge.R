govs<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/BeyleJAR/BeyleGovJar.csv')
govsdf<-govs[,c('NAME', 'ELECYR', 'STATE')]
govsdf<-unique(govsdf)
statesorder<-as.data.frame(cbind(seq(1:50), 
                                 c('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
                                   'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 
                                   'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH',
                                   'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 
                                   'SC', 'SD', 'TN', 'TX', 'UT',' VT', 'VA','WA', 'WV', 'WI', 'WY')))


names(statesorder)<-c('STATE', 'st')
govs1<-merge(statesorder, govsdf, by='STATE')
govs<-govs1[,-1]
