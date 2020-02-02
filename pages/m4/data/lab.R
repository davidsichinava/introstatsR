setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m4\\data")


minwage <- read.csv("minwage.csv")


names(minwage)

table(minwage$location)


treat_change <- mean(minwage$fullAfter[minwage$location!="PA"])-mean(minwage$fullBefore[minwage$location!="PA"])

control_change <- mean(minwage$fullAfter[minwage$location=="PA"])-mean(minwage$fullBefore[minwage$location=="PA"])

treat_change-control_change
