library(readstata13)
qual <- read.dta13("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/CandidateQuality/qjps_primaries_quality_statewide_replication.dta")
qual<-subset(qual, office=="G") #Subset to gov; original includes Senators
#==============================================================================
# Assign numeric value to party label; assign same name as csp column
#==============================================================================
qual$govparty_a<-ifelse(qual$party=="R", 0, 1)

unique(qual$office)
