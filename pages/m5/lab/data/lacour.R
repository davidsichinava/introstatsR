setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m5\\lab\\data")

lacour <- read.csv("gay.csv")

names(lacour)



#####

lacour_study_1 <- lacour[lacour$study == 1, ]
nrow(lacour_study_1)


lacour_cansvassing <- lacour_study_1[lacour_study_1$treatment == "No Contact" | 
                                       lacour_study_1$treatment == "Same-Sex Marriage Script by Gay Canvasser" | 
                                       lacour_study_1$treatment == "Same-Sex Marriage Script by Straight Canvasser", ]
table(lacour_cansvassing$treatment)

names(lacour_cansvassing)


mean(lacour_cansvassing$ssm[lacour_cansvassing$wave== 1])
mean(lacour_cansvassing$ssm[lacour_cansvassing$wave== 2])
mean(lacour_cansvassing$ssm[lacour_cansvassing$wave== 3])
mean(lacour_cansvassing$ssm[lacour_cansvassing$wave== 4])
mean(lacour_cansvassing$ssm[lacour_cansvassing$wave== 5])
mean(lacour_cansvassing$ssm[lacour_cansvassing$wave== 6])
mean(lacour_cansvassing$ssm[lacour_cansvassing$wave== 7])


# 1. Gay vs. No contact

mean(lacour_cansvassing$ssm[lacour_cansvassing$treatment == "Same-Sex Marriage Script by Gay Canvasser" 
                            & lacour_cansvassing$wave==2])-
mean(lacour_cansvassing$ssm[lacour_cansvassing$treatment == "No Contact" 
                              & lacour_cansvassing$wave==2])


mean(lacour_cansvassing$ssm[lacour_cansvassing$treatment == "Same-Sex Marriage Script by Gay Canvasser" & lacour_cansvassing$wave==2])-
  mean(lacour_cansvassing$ssm[lacour_cansvassing$treatment == "Same-Sex Marriage Script by Straight Canvasser" & lacour_cansvassing$wave==2])


###

diff_treat <- mean(lacour_cansvassing$ssm[lacour_cansvassing$treatment == "Same-Sex Marriage Script by Gay Canvasser" & lacour_cansvassing$wave==2])-mean(lacour_cansvassing$ssm[lacour_cansvassing$treatment == "Same-Sex Marriage Script by Gay Canvasser" & lacour_cansvassing$wave==1])
diff_treat

diff_control <- mean(lacour_cansvassing$ssm[lacour_cansvassing$treatment == "No Contact" & lacour_cansvassing$wave==2])-mean(lacour_cansvassing$ssm[lacour_cansvassing$treatment == "No Contact" & lacour_cansvassing$wave==1])
diff_control

diff_treat-diff_control

diff_treat <- mean(lacour_cansvassing$ssm[lacour_cansvassing$treatment == "Same-Sex Marriage Script by Gay Canvasser" & lacour_cansvassing$wave==7])-mean(lacour_cansvassing$ssm[lacour_cansvassing$treatment == "Same-Sex Marriage Script by Gay Canvasser" & lacour_cansvassing$wave==1])
diff_treat

diff_control <- mean(lacour_cansvassing$ssm[lacour_cansvassing$treatment == "No Contact" & lacour_cansvassing$wave==7])-mean(lacour_cansvassing$ssm[lacour_cansvassing$treatment == "No Contact" & lacour_cansvassing$wave==1])
diff_control

diff_treat-diff_control
