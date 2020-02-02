setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m3\\pres\\class")

resume <- read.csv("resume.csv")

names(resume)

head(resume)

tail(resume)

View(resume)

table(resume$race)

table(resume$call)

table(resume$call, resume$race)

prop.table(table(resume$call, resume$race))

prop.table(table(resume$call, resume$race), 2)

star <- read.csv("STAR.csv")

names(star)

table(star$classtype)

mean(star$g4math, na.rm = T)

mean(star$g4math[star$classtype==1], na.rm = T)

mean(star$g4math[star$classtype==2], na.rm = T)

mean(star$g4math[star$classtype==3], na.rm = T)

prop.table(table(star$hsgrad, star$classtype), 2)
