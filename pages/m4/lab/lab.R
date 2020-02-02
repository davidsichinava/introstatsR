setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m4\\lab")
leaders <- read.csv("leaders.csv")
names(leaders)

leader_count <- data.frame(table(leaders$leadername))
View(leader_count)
names(leader_count) <- c("name", "count")

mean(leader_count$count)
