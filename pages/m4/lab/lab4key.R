setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m4\\lab")
leaders <- read.csv("leaders.csv")
names(leaders)
unique(leaders$country)
table(leaders$year[leaders$country=="Georgia"])

leaders$success <- 0
leaders$success[leaders$result=="dies between a day and a week"] <- 1 
leaders$success[leaders$result=="dies between a week and a month"] <- 1 
leaders$success[leaders$result=="dies within a day after the attack"] <- 1 
leaders$success[leaders$result=="dies, timing unknown"] <- 1 



table(leaders$success)

mean(leaders$politybefore[leaders$success==1])
mean(leaders$politybefore[leaders$success==0])


mean(leaders$age[leaders$success==1])
mean(leaders$age[leaders$success==0])

mean(leaders$politybefore[leaders$success==1])
mean(leaders$politybefore[leaders$success==0])

mean(leaders$polityafter[leaders$success==1])
mean(leaders$polityafter[leaders$success==0])


leaders$warbefore <- 0

leaders$warbefore[leaders$interwarbefore==1 | leaders$civilwarbefore==1 ] <- 1

table(leaders$warbefore)

mean(leaders$politybefore[leaders$warbefore== 1])
     
mean(leaders$politybefore[leaders$warbefore== 0])


leaders$warafter <- 0

leaders$warafter[leaders$interwarafter==1 | leaders$civilwarafter==1 ] <- 1

table(leaders$warafter)

prop.table(table(war=leaders$warafter, assasination=leaders$success))
