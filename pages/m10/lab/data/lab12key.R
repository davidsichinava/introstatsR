setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m12\\lab\\data")

geo <- read.csv("geoelections.csv")

names(geo)

cor(geo$Orthodox, geo$Georgian)

cor(geo$HiEd, geo$Urban)

cor(geo$WHC, geo$Urban)

cor(geo$TurnoutProp, geo$UNMProp)



ggplot(geo, aes(x=TurnoutProp, y=UNMProp))+
  geom_point(aes(colour=Elections))+
  geom_smooth(method="lm")+
  labs(title="UNM Vote and Turnout",
       x="Turnout",
        y ="UNM")

model1 <- lm(UNMProp~TurnoutProp, data=geo)
summary(model1)

model2 <- lm(UNMProp~TurnoutProp+Urban+Georgian+Orthodox+HiEd+WHC, data=geo)
summary(model2)

