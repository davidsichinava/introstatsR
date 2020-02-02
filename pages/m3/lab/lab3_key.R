# Read data file

star <- read.csv("https://davidsichinava.github.io/introstatsr/pages/m4/data/STAR.csv")
attach(star)
names(star)
table(classtype)

# Create kinder variable

star$kinder<-factor(classtype,
      levels = c(1,2,3),
      labels = c("small", "regular", "regular w/aid")
      )
table(star$kinder)

table(star$race)
star$race[star$race == 4] <- 4
star$race[star$race == 5] <- 4
star$race[star$race == 6] <- 4
table(star$race)

star$race<-factor(race,
                    levels = c(1,2,3, 4),
                    labels = c("white", "black", "hispanic", "other")
)
table(star$race, useNA = "ifany")

# mean, median, quintiles and the standard deviation of g4math and g4reading
mean(star$g4math, na.rm=TRUE)
mean(star$g4reading, na.rm=TRUE)

median(star$g4math, na.rm=TRUE)
median(star$g4reading, na.rm=TRUE)

sd(star$g4math, na.rm=TRUE)
sd(star$g4reading, na.rm=TRUE)

# mean and quintiles of g4reading and g4math variables

mean(star$g4math[star$kinder=="small"], na.rm=TRUE)
mean(star$g4math[star$kinder=="regular"], na.rm=TRUE)
mean(star$g4math[star$kinder=="regular w/aid" | star$kinder=="regular"], na.rm=TRUE)

mean(star$g4reading[star$kinder=="small"], na.rm=TRUE)
mean(star$g4reading[star$kinder=="regular"], na.rm=TRUE)
mean(star$g4reading[star$kinder=="regular w/aid" | star$kinder=="regular"], na.rm=TRUE)

quantile(star$g4math[star$kinder=="small"], c(.33, .66), na.rm=TRUE)
quantile(star$g4math[star$kinder=="regular"], c(.33, .66), na.rm=TRUE)
quantile(star$g4math[star$kinder=="regular w/aid" | star$kinder=="regular"], c(.33, .66), na.rm=TRUE)

quantile(star$g4reading[star$kinder=="small"], c(.33, .66), na.rm=TRUE)
quantile(star$g4reading[star$kinder=="regular"], c(.33, .66), na.rm=TRUE)
quantile(star$g4reading[star$kinder=="regular w/aid" | star$kinder=="regular"], c(.33, .66), na.rm=TRUE)


table(star$kinder)

table(star$yearssmal[star$kinder=="small"])


mean(star$g4math[star$kinder=="small" & star$yearssmall==1], na.rm=TRUE)
mean(star$g4math[star$kinder=="small" & star$yearssmall==2], na.rm=TRUE)
mean(star$g4math[star$kinder=="small" & star$yearssmall==3], na.rm=TRUE)
mean(star$g4math[star$kinder=="small" & star$yearssmall==4], na.rm=TRUE)

