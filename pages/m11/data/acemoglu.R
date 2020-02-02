library(ggplot2)

setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m11\\data")

figure1 <- read.csv("figure1.csv", stringsAsFactors = F)

ggplot(figure1, aes(x=lrgdpch, y=fhpolrigaug))+
  geom_text(aes(label=code), size=2)+
  geom_smooth(method="lm")+
  labs(x="Log GDP per Capita (Penn World Tables)",
       y="Freedom House Measure of Democracy",
       title="Figure 1",
       subtitle="Democracy and Income, 1990s")+
  theme_bw()

acem1 <- lm(fhpolrigaug~lrgdpch, data=figure1)

summary(acem1)

acem1$r.squared

par(mfrow=c(2,2)) # 

plot(acem1) #


figure2 <- read.csv("figure2.csv", stringsAsFactors = FALSE,
                    sep="\t")

ggplot(figure2, aes(x=growth, y=democ))+
  geom_text(aes(label=code), size=2)+
  geom_smooth(method="lm")+
  labs(x="Change in Log GDP per Capita",
       y="Change in Democracy",
       title="Figure 5",
       subtitle="Change in Democracy and Change in Income, 1500-2000")

acem2 <- lm(democ~growth, data=figure2)

summary(acem2)

figure3 <- read.csv("figure3.csv", stringsAsFactors = FALSE, sep="\t")

ggplot(figure3, aes(x=growth, y=democ))+
  geom_text(aes(label=code), size=2)+
  geom_smooth(method="lm")+
  labs(x="Change in Log GDP per Capita",
       y="Change in Democracy",
       title="Figure 5",
       subtitle="Change in Democracy and Change in Income, 1500-2000")

democracy <- lm(democ~consfirstaug+indcent+
              rel_catho80+rel_muslim80+rel_protmg80, 
              data=figure3)
growth <- lm(growth~consfirstaug+indcent+
               rel_catho80+rel_muslim80+rel_protmg80, 
             data=figure3)
summary(democracy)
summary(growth)

growth$residuals <- as.numeric(growth$residuals)
democracy$residuals <- as.numeric(democracy$residuals)

residuals <- as.data.frame(cbind(democracy$residuals, growth$residuals))

names(residuals) <- c("democracy", "growth")
  
ggplot(residuals, aes(x=growth, y=democracy))+
  geom_point()+
  geom_smooth(method="lm")+
  labs(x="Change in Log GDP per Capita, Independent of Historical Factors",
       y="Change in Democracy Independent of Historical Factors",
       title="Change in Democracy and Change in Income, 1500-2000",
       subtitle="Conditional on Historical Factors")


### install.packages("haven")

library(haven)

ndi_april <- read_dta("NDI_2019_April_22.04.19_Public.dta")

### SOCDRUS, RESPSEX, RESPAGE, RESPEDU, SETTYPE

ndi_april$hi_ed <- 0
ndi_april$hi_ed[ndi_april$RESPEDU>4] <- 1

ndi_april$SOCDRUS[ndi_april$SOCDRUS < 0] <- NA
ndi_april$RESPEDU[ndi_april$RESPEDU < 0] <- NA

ru_dist <- lm(SOCDRUS~factor(RESPSEX)+hi_ed+factor(SETTYPE)+RESPAGE,
              data=ndi_april)
summary(ru_dist)

#### Histogram
ggplot(figure1, aes(fhpolrigaug))+
  geom_histogram()

#### Teachers survey

teachers <- read_dta("UNW_VAW_2019_25.06.19_Public.dta")

teachers$index <- teachers$q8_1+teachers$q8_2+teachers$q8_3+teachers$q8_4+teachers$q8_5+teachers$q8_6

ggplot(teachers, aes(index))+
  geom_histogram()

teacher_model <- lm(index~factor(q39)+q38+q41+factor(q45)+q53+factor(settype),
                    data=teachers)

summary(teacher_model)






