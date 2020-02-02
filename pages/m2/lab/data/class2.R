setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m2\\lab\\data")

galton <- read.csv("Galton.csv")

galton$height_cm <- galton$height*2.54

galton$height_gr <- galton$height_cm

galton$height_gr[galton$height_cm<150] <- 1

galton$height_gr[galton$height_cm>=150 & galton$height_cm<170 ] <- 2

galton$height_gr[galton$height_cm>=170 & galton$height_cm<190 ] <- 3

galton$height_gr[galton$height_cm>=190] <- 4

galton$height_gr <- factor(galton$height_gr, 
                           levels= c(1, 2, 3, 4),
                           labels=c("Short", "Medium", "Tall", "Very tall"))

table(galton$height_gr)
