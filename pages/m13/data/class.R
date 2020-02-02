setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m13\\data")

STAR <- read.csv("star.csv")

t.test(STAR$g4reading, mu = 710)

t.test(STAR$g4reading, mu = 710, conf.level= 0.99)


t.test(STAR$g4reading[STAR$classtype == 1],
       STAR$g4reading[STAR$classtype == 2])

t.test(STAR$g4reading[STAR$classtype == 1],
       STAR$g4reading[STAR$classtype == 2], conf.level = 0.8)

resume <- read.csv("resume.csv")
x <- table(resume$race, resume$call)
prop.test(x, alternative = "greater")

