library(ggplot2)
setwd("D:\\Dropbox\\My Projects\\Courses\\QT_Analysis\\meetings\\m01-intro\\pres\\viz")
mdata<-read.csv("Education_Employment.csv")
library(extrafont)

theme_mplot <- theme(
  axis.text.y = element_text(colour="black", size = 12, family = "BPG Arial 2010"),
  axis.text.x = element_text(colour="black", size = 12, family="BPG Arial 2010"),
  axis.title.x = element_text(size=12, family = "BPG Arial 2010", face="bold"),
  axis.title.y = element_text(size=12, family = "BPG Arial 2010", face="bold"),
  panel.border = element_rect(fill=NA, linetype = "solid", colour = "black"),
  panel.background = element_rect(fill = NA),
  panel.grid.major = element_line(colour = "grey"),
  plot.title = element_text(colour = "Black", size=14, family = "Gill Sans MT"),
  legend.position = "none"
)



p <- ggplot(mdata, aes(PropHiEd, PropWhiteCollar))
p <- p + geom_point(aes(size = Pop10More, colour=Pop10More)) + 
  xlab("უმაღლესი განათლების მქონეთა წილი") +
  ylab("თეთრსაყელოიანი დასაქმებულები") + 
  theme_mplot

ggsave("scatterplot", p, width = 12, height = 6, device=cairo_pdf)
