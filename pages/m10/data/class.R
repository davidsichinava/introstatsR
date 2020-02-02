setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m10\\data")
library(ggplot2)
poll08 <- read.csv("pres08data.csv")

names(poll08)

poll08$winner <- "Obama"
poll08$winner[poll08$Obama < poll08$McCain] <- "McCain"
table(poll08$winner)

ggplot(poll08, aes(x=predicted.margin.poll, y=margin))+
  geom_point(aes(color=winner))+
  scale_color_manual(values=c("red", "blue"))+
  geom_smooth(method='lm')+
  labs(title="Opinion Polls and Election Results",
       subtitle="2008 U.S. Presidential Elections",
       x="Predicted Obama Margin in the Last Opinion Poll",
       y="Actual Margin for Obama")+
  theme_minimal()

model <- lm(margin~predicted.margin.poll, data=poll08)
summary(model)

model_no_dc <- lm(margin~predicted.margin.poll, data=poll08[poll08$state  != "DC", ])
summary(model_no_dc)
plot(model_no_dc)

poll08$residuals <- model$residuals
poll08$predicted <- predict(model)

ggplot(poll08, aes(x=residuals))+
  geom_histogram(bins = 8)

mean(poll08$residuals)


ggplot(poll08, aes(x=predicted, y=residuals))+
  geom_smooth(method="lm")+
  labs(title="Opinion Polls and Election Results",
       subtitle="2008 U.S. Presidential Elections",
       x="Predicted Values",
       y="Residuals")+
  geom_text(aes(label=state, color=winner),
            size=3)+
  scale_color_manual(values=c("red", "blue"))+
  theme_minimal()

par(mfrow=c(2,2))

plot(model)


ggplot(poll08, aes(x=predicted, y=residuals))+
  geom_point(aes(color=winner))+
  labs(title="Opinion Polls and Election Results",
       subtitle="2012 U.S. Presidential Elections",
       x="Predicted Values",
       y="Residuals")+
  geom_text(aes(label=state),
            position = position_dodge(width = 5), 
            size=3)+
  theme_minimal()

ggplot(poll08, aes(x=seq(residuals), y=residuals))+
  geom_point(aes(color=winner))+
  labs(title="Opinion Polls and Election Results",
       subtitle="2012 U.S. Presidential Elections",
       x="Sequence Variable",
       y="Residuals")+
  geom_text(aes(label=state),
            position = position_dodge(width = 5), 
            size=3)+
  theme_minimal()


