setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m9\\data")

library(ggplot2)

face <- read.csv("face.csv")

#### დამოკიდებულება დემოკრატი კანდიდატის კომპეტენციასა და მის მიერ მიღებული ხმების პროპორციას შორის 

face$d_share <- face$d.votes/(face$d.votes+face$r.votes)
cor(face$d_share, face$d.comp)

face$r_share <- face$r.votes/(face$d.votes+face$r.votes)
cor(face$r_share, face$r.comp)

face$difference <- face$d_share-face$r_share

#### მონაცემების ვიზუალიზაცია

ggplot(face, aes(d.comp, difference))+
  geom_point(aes(color=w.party))+
  geom_smooth(method="lm")+
  geom_vline(xintercept = 0)+
  scale_color_manual(values=c("blue", "red"))+
  labs(title="Facial competence vs. electoral success",
       x="Facial competence",
       y="Difference between democratic and republican votes")

## სხვაობა დემ. და რესპ. შორის = a+b*სახის კომპეტენტურობა+e

model_1 <- lm(difference~d.comp, data=face)
summary(model_1)


####

face$d.share <- face$d.votes / (face$d.votes + face$r.votes)

face$r.share <- face$r.votes / (face$d.votes + face$r.votes)

face$diff.share <- face$d.share - face$r.share

fit <- lm(diff.share~d.comp, data=face)
fit
summary(fit)

ggplot(face, aes(x=d.comp, y=diff.share))+
  geom_point()+
  geom_smooth(method="lm")

library(haven)
cb <- read_dta("CB_2017_Georgia_17.11.17.dta")

cb$j14[cb$j14 == -3 | cb$j14 == -2 | cb$j14 == -1] <- NA
cb$p4_02[cb$p4_02==-3 ] <- NA
cb$p4_02[cb$p4_02==-2 |cb$p4_02==-1  ] <-3

trubank <- lm(p4_02~j14, data=cb)
summary(trubank)

