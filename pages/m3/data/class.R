setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m3\\data")

resume <- read.csv("resume.csv")

names(resume)

View(resume)

table(resume$race)

table(resume$call)

prop.table(table(resume$call))

prop.table(table(resume$call, resume$race), 2)

leaders <- read.csv("leaders.csv")

names(leaders)


leaders$success <- 0
leaders$success[leaders$result == "dies between a day and a week"] <- 1
leaders$success[leaders$result == "dies between a week and a month"] <- 1
leaders$success[leaders$result == "dies, timing unknown"] <- 1
leaders$success[leaders$result == "dies within a day after the attack"] <- 1

mean(leaders$politybefore[leaders$success == 1])
mean(leaders$politybefore[leaders$success == 0])

mean(leaders$polityafter[leaders$success == 1])
mean(leaders$polityafter[leaders$success == 0])

### Difference-in-difference estimate on polity scores

difference_treated <- mean(leaders$polityafter[leaders$success == 1]) -
mean(leaders$politybefore[leaders$success == 1])

difference_control <- mean(leaders$polityafter[leaders$success == 0]) -
  mean(leaders$politybefore[leaders$success == 0])

difference_treated - difference_control

### Difference-in-difference estimate on polity scores

difference_treated <- mean(leaders$civilwarafter[leaders$success == 1]) -
  mean(leaders$civilwarbefore[leaders$success == 1])

difference_control <- mean(leaders$civilwarafter[leaders$success == 0]) -
  mean(leaders$civilwarbefore[leaders$success == 0])

difference_treated - difference_control

### Difference-in-difference estimate on polity scores

difference_treated <- mean(leaders$interwarafter[leaders$success == 1]) -
  mean(leaders$interwarbefore[leaders$success == 1])

difference_control <- mean(leaders$interwarafter[leaders$success == 0]) -
  mean(leaders$interwarbefore[leaders$success == 0])

difference_treated - difference_control
