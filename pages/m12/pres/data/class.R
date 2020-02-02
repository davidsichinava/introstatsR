n <- 1000

x.bar <- 0.6

s.e. <- sqrt(x.bar * (1 - x.bar) / n)

## 99%
c(x.bar - qnorm(0.995) * s.e., x.bar + qnorm(0.995) * s.e.)

## 95%

c(x.bar - qnorm(0.975) * s.e., x.bar + qnorm(0.975) * s.e.)

## 90%

c(x.bar - qnorm(0.95) * s.e., x.bar + qnorm(0.95) * s.e.)

