bayrup <- read.csv("bayrup.csv")

names(bayrup)

ggplot(bayrup, aes(x=dtrade))+
  geom_histogram()

### OLS: 

summary(bayrup)


model <- lm(dtrade~Ldist+Ldytr+Lgdp1P+Lgdp2P+Lpop1P+
              Lpop2P+mid+alliance+equwartau+
              demmultdyad+civilwar+cw_join+outnegshort+outdecshort, 
            data=bayrup)

summary(model)

## Hypothesis 1:
### Civil wars lead to decreases in total bilateral trade.

## Hypothesis 2:
### Given that a civil war is occurring in at least one trade partner, the presence of an alliance will increase levels of bilateral trade.

## Hypothesis 3:
### One country’s participation in another country’s civil war decreases the bilateral trade between the joiner and each trading partner.

