setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m14\\data")
library(haven)
library(ggplot2)
library(margins)
library(ggeffects)

may17 <- read_dta("May17_Only_responses_10072013.dta")

names(may17)

table(may17$q7)

may17$homophobia <- 0
may17$homophobia[may17$q7==5] <- 1
table(may17$homophobia)

### 

may17$hied <- 0
may17$hied[may17$d4>=5] <- 1
table(may17$hied)

homophobia.model <- glm(homophobia~hied, data=may17, family = "binomial")
summary(homophobia.model)
exp(homophobia.model$coefficients)

### უმაღლესი განათლების მქონე ადამიანის ჰომოფობობის ალბათობა:

exp(-0.6809+(-0.391)*1)/(1+exp(-0.6809+(-0.391)*1))

### უმაღლესი განათლების არმქონე ადამიანის ჰომოფობობის ალბათობა:
exp(-0.6809+(-0.391)*0)/(1+exp(-0.6809+(-0.391)*0))

ggpredict(homophobia.model, "hied")
plot(ggpredict(homophobia.model, "hied"))

View(cplot(homophobia.model, "hied"))


may17$d1<-factor(may17$d1, levels=c(1, 2), labels=c("Male", "Female"))

may17$relig[may17$d10 == 5] <- 0
may17$relig[may17$d10 == 4] <- 1
may17$relig[may17$d10 == 3] <- 2
may17$relig[may17$d10 == 2] <- 3
may17$relig[may17$d10 == 1] <- 4

h2 <- glm(homophobia~d1+d2+hied+relig, data=may17, family="binomial")


gender <- ggpredict(h2, c("d1", "hied"))
plot(gender)


relig <- ggpredict(h2, "relig")
plot(relig)
