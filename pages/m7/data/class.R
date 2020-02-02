setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m7\\data")

library(ggplot2)
library(tidyr)


congress <- read.csv("congress.csv")

### პირველი ვარიანტი

congress80112 <- congress[congress$congress == 80 | congress$congress == 112]

### მეორე ვარიანტი

congress80112 <- subset(congress, subset = (congress == 80 | congress == 112))


####

ggplot(congress80112, aes(x=dwnom1, y=dwnom2))+
  geom_point(aes(color=party))+
  facet_wrap(~congress)


####

ggplot(congress80112, aes(x=dwnom1, y=dwnom2))+
  geom_point(aes(color=party))+
  scale_color_manual(values=c("blue", "green", "red"))+
  facet_grid(~congress)+
  labs(title="Polarization of the US Congress, 1948-2011",
       x="Economic liberalism/conservatism",
       y="Racial liberalism/conservatism")

rep <- congress[congress$party == "Republican", ]
dem <- congress[congress$party == "Democrat", ]

dem_median <- tapply(dem$dwnom1, dem$congress, median)
rep_median <- tapply(rep$dwnom1, rep$congress, median)

####

gini <- read.csv("USGini.csv")

names(gini)

cor(gini$gini[seq(from = 2, to = nrow(gini), by = 2)],
    rep_median - dem_median)

cor(gini$gini[seq(from = 2, to = nrow(gini), by = 2)],
    rep_median - dem_median, method="spearman")

cor(gini$gini[seq(from = 2, to = nrow(gini), by = 2)],
    rep_median - dem_median, method="kendall")

### მეორე ვარიანტი

gini_two_years <- gini$gini[seq(from = 2, to = nrow(gini), by = 2)]
polarization <- rep_median - dem_median

my_data <- as.data.frame(cbind(gini_two_years, polarization))

cor(my_data$gini_two_years, my_data$polarization)

cor(my_data$gini_two_years, my_data$polarization, method="spearman")

cor(my_data$gini_two_years, my_data$polarization, method="kendall")
