#==============================================================================
# Create a matrix of annual unemployment for all states for years 2005-2017
# columns=years; rows=state
#==============================================================================
states<-unique(pdat$st) #take the vector of states from the csp data; the .csv's are saved as state abbrevs

statemat<-matrix(rep(NA,663), nrow=51) #create an empty matrix


for(i in 1:51){ #50 states and DC
state<-read.csv(paste0('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/UnemploymentPost2004/',
      states[i],
      '.csv')) #open the .csv for each state
statevec<-as.numeric(as.matrix(state[11:23, 2:13])) #subset the .csv to the relevant data; change the class because the elements are listed as factors and won't be coerced into a numeric
statematr<-as.data.frame(matrix(statevec, nrow=13)) #create a DF of the data to allow compatibility with rowMeans
statemat[i,]<-rowMeans(statematr) #store vector in row of statemat matrix
}

colnames(statemat)<-c(2005:2017) #cols=year
rownames(statemat)<-states #rows=state
statemat #final output :); update: this was a stupid way to store the data -.-
write.csv(statemat, "unemploymentPost2004.csv")

#==============================================================================
# I used this as a model to create a loop for all 50 states.
# Create a matrix of annual unemployment for AL for years 2005-2017
#==============================================================================
AL1<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/UnemploymentPost2004/AL.csv')
Alvec<-as.numeric(as.matrix(AL1[11:23, 2:13]))
ALmat<-as.data.frame(matrix(Alvec, nrow=13))
AL_unemp<-rowMeans(ALmat)
AL_unemp<-matrix(AL_unemp,nrow=1)

statemat[1,]<-rowMeans(ALmat)


