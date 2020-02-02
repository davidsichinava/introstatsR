setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m11\\class")


minwage <- read.csv("minwage.csv")


names(minwage)

table(minwage$location)

minwage$treat <- ifelse(minwage$location == "PA",
                        0, 1)

## minwage$fullAfter

t.test(minwage$fullAfter[minwage$treat == 0], minwage$fullAfter[minwage$treat == 1])

model <- lm(fullAfter~treat, data=minwage)
summary(model)

face <- read.csv("face.csv")
face$d_share <- face$d.votes/(face$d.votes+face$r.votes)
face$r_share <- face$r.votes/(face$d.votes+face$r.votes)
face$difference <- face$d_share-face$r_share
model_1 <- lm(difference~d.comp, data=face)
summary(model_1)


