<div class="header" style="margin-top:0 px;font-size:60%;">QRMIAS: Fourth Meeting</div>

Quantitative Research Methods – Introduction to Applied Statistics
========================================================
author: DAVID SICHINAVA, RATI SHUBLADZE
date: November 1, 2017
autosize: true
transition: none
css: css/style.css
font-family: 'BPG_upper'
<span style="font-weight:bold; font-family:BPG_upper;">Fourth Meeting</span>



Today's meeting
========================================================

- Causality
	+ Observation
- Confounding bias
- Before-and-after design
- Difference-in-Difference estimate
- Observational studies:
	+ Statistics for one variable
	+ Quantiles
	+ Root of mean squares (RMS)
	+ Standard deviation


Again about causality...
========================================================
* "Cause and effect must be _contiguous_ in space and time..."
* "The same cause always produces the same effect, and the same effect never arises but from the same source..."
<span style="font-weight:bold; font-family:BPG_upper;">David Hume. A Treatise of Human Nature</span>

The role of randomization
========================================================
* Randomization creates homogeneous groups, therefore the difference between the two groups could be attributed to the treatment
* It eliminates selection bias

Observational studies
========================================================
* However, in many cases we cannot randomly administer treatment on research participants
* In these cases, we rely on _observational_ data
	+ Pros: high external validity
	+ Cons: low internal validity, that is, we may fail to properly explain the underlying causal mechanism.

Card & Krueger (1994)
========================================================
* In 1992, New Jersey decided to raise minimum wage from $4.25 to $5.05
* Classic economic theory predicts that it could reduce employment


Card & Krueger (1994)
========================================================
* In order to identify causal mechanism, we need another New Jersey where minimum wage stayed at pre-1992 level.
* However, as this is impossible, Card and Krueger used Pennsylvania as a reference (_control_).

Card & Krueger (1994)
========================================================
- "Treatment group": fast food restaurants in New Jersey (NJ)
- "Tontrol group": fast food restaurants in Pennsylvania (PA)

Card & Krueger (1994)
========================================================
- Treatment intervention: increase of minimum wage.


Card & Krueger (1994)
========================================================
<img src="img/c&k.PNG" alt="Drawing" style="width: 600px; display: block; margin-left: auto; margin-right: auto; margin-top: 40px;"/>

Card & Krueger (1994)
========================================================

```r
minwage <- read.csv("https://davidsichinava.github.io/introstatsr/pages/m4/data/minwage.csv")

### Or download it manually from here:
### https://goo.gl/rgbAxj

minwage <- read.csv("minwage.csv")
```

Card & Krueger (1994)
========================================================

```r
dim(minwage) ### Dimensions of the table

summary(minwage) ### Descriptive statistics
```
Card & Krueger (1994)
========================================================

| variable    | Description                                |
|-----------|---------------------------------------|
| chain | name of the fast-food restaurant chain                     |
| location       | location of the restaurants (centralNJ, northNJ, PA, shoreNJ, southNJ)                                 |
| wageBefore      | wage before the minimum-wage increase                                  |
| wageAfter      | wage after the minimum-wage increase? |
| fullBefore | number of full-time employees before the minimum-wage increase           |
| fullAfter       | number of full-time employees after the minimum-wage increase |
| partBefore      | number of part-time employees before the minimum-wage increase |
| partAfter      | number of part-time employees after the minimum-wage increase |


Card & Krueger (1994):
========================================================
- Difference between the proportion of full-time employes could indicate on the effect of minimum wage increase.
- Dependent variable: proportion of full-time employees


Card & Krueger (1994)
========================================================

```r
## Subset the data for each state
minwageNJ <- subset(minwage, subset = (location != "PA"))
minwagePA <- subset(minwage, subset = (location == "PA"))
```

Card & Krueger (1994)
========================================================

```r
## create a variable for proportion of full-time employees in NJ and PA
minwageNJ$fullPropAfter <- minwageNJ$fullAfter / (minwageNJ$fullAfter + minwageNJ$partAfter)
minwagePA$fullPropAfter <- minwagePA$fullAfter / (minwagePA$fullAfter + minwagePA$partAfter)

## compute the difference-in-means
mean(minwageNJ$fullPropAfter) - mean(minwagePA$fullPropAfter)
```
Card & Krueger (1994)
========================================================

```r
## create a variable for proportion of full-time employees in NJ and PA
minwageNJ$fullPropAfter <- minwageNJ$fullAfter / (minwageNJ$fullAfter + minwageNJ$partAfter)
minwagePA$fullPropAfter <- minwagePA$fullAfter / (minwagePA$fullAfter + minwagePA$partAfter)

## compute the difference-in-means
mean(minwageNJ$fullPropAfter) - mean(minwagePA$fullPropAfter)
```

