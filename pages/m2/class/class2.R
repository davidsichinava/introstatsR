setwd("D:\\Dropbox\\My projects\\Courses\\QT_Analysis\\website\\pages\\m2\\class")



room_320 <- 5

room_320 <- c("elene", "liana", "mariam", "anuki", "anano", "dato")

room_319 <- c("Freddie", "Shreck", "Anabelle")
room_319


tsu <- list(room_319, room_320)
tsu

names(tsu) <- c("Uznadze", "Janelidze")

tsu

tsu$Uznadze

tsu$Janelidze



room_320 <- c("Gigi", "Ana", "Tamar", "Elene", "Anano", "Mariam", "Dato")
room_320

room_319 <- c("Giorgi", "Nino", "Erekle")

tsu <- list(room_319, room_320)
tsu

tsu[[1]][1]

names(tsu)<-c("Uznadze", "Janelidze")

table(tsu$Uznadze)



names(tsu) <- c("R1", "R2", "R3")


tsu$Uznadze

tsu$Janelidze


tsu[[1]]


galton <- read.csv("Galton.csv")
  
names(galton)

table(galton$sex)

prop.table(table(galton$sex))


mean(galton$height)

galton$height_cm <- galton$height*2.54

mean(galton$height_cm)

mean(galton$height_cm[galton$sex == "M"])

mean(galton$height_cm[galton$sex == "F"])



