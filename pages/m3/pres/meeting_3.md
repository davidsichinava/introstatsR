<div class="header" style="margin-top:0 px;font-size:60%;">QRMIAS: Third Meeting</div>

Quantitative Research Methods – Introduction to Applied Statistics
========================================================
author: DAVID SICHINAVA
date: October 18, 2019
autosize: true
transition: none
css: css/style.css
font-family: 'BPG_upper'
<span style="font-weight:bold; font-family:BPG_upper;">Third meeting</span>



Today's meeting
========================================================

- Causality
  - Causal effects
  - Counterfactuals | Potential outcomes model
  - Randomized Controlled Experiments (RCTs)

Bertrand & Mullainathan (2004)
========================================================
* Set working directory;
* Open a new notebook document;

Bertrand & Mullainathan (2004)
========================================================
_Are Emily and Greg more employable than Lakisha and Jamal? A field experiment on labor market discrimination_. American Economic Review, vol. 94, no. 4, pp. 991–1013.

Bertrand & Mullainathan (2004)
========================================================
<img src="img/haley.jpg" alt="Drawing" style="width: 600px; display: block; margin-left: auto; margin-right: auto; margin-top: 40px;"/>


Bertrand & Mullainathan (2004)
========================================================
* Is there any racial discrimination in the US job market?

Bertrand & Mullainathan (2004)
========================================================
| variable    | Description                                |
|-----------|---------------------------------------|
| firstname | Jobseeker's name                     |
| sex       | Gender                                 |
| race      | Race                                  |
| call      | Callback? |


Bertrand & Mullainathan (2004)
========================================================

```r
resume <- read.csv("resume.csv")
```

Bertrand & Mullainathan (2004)
========================================================

```r
head(resume)

names(resume)
```

Bertrand & Mullainathan (2004)
========================================================

```r
race_table <- table(race = resume$race, call = resume$call)
addmargins(race_table)
race_table
```

Bertrand & Mullainathan (2004)
========================================================

```r
prop.table(table(resume$race), 1)
prop.table(table(resume$race), 2)
```
Bertrand & Mullainathan (2004)
========================================================

```r
mean(resume$call[resume$race == "black"])
```

Neyman-Rubin-Holland Model of Causal Inference
========================================================
incremental = TRUE
- For every $i$, The $T{i}$ treatment effect could be defined, as $Y_{i}(1) - Y_{i}(0)$, where $Y_{i}(1)$ is the outcome in the treatment group, while $Y_{i}(0)$ represents the outcome in the control group
- Fundamental problem of causal inference

Potential outcomes model
========================================================
* Counterfactuals
	+ What if...
* David Hume

Potential outcomes model
========================================================
>> The key goal of causal inference is to predict _counterfactuals_


The role of randomization
========================================================
* Randomization creates homogeneous groups, therefore the difference between the two groups could be attributed to the treatment
* It eliminates selection bias
* Rule of Large Numbers
* Hawthorne effect

Randomized Controlled Experiments (RCTs)
========================================================

$Y_{i}(1) - Y_{i}(0)$

Sample Average Treatment Effect (SATE): a _sample average_ of individual-level causal effects

$SATE = \frac{1}{n}\sum_{n}^{i=1}\left \{ Y_{i}(1) - Y_{i}(0) \right \}$

Randomized Controlled Experiments (RCTs)
========================================================
incremental = TRUE

- Can we really observe SATE?
- Not really, that's why we use __difference-in-means_ estimator
$\hat{\tau} = \frac{1}{n_{1}}\sum_{i=1}^{n}T_{i}Y_{i} - \frac{1}{n_{0}}\sum_{i=1}^{n}(1-T_{i})Y_{i}$

Challenges (Imai, 2012)
========================================================

* RCTs could be hard to analyze
* Violation of the protocol
	+ Contamination;
	+ Non-compliance;
	+ Missing values;
	+ Measurement error;

Challenges (Imai, 2012)
========================================================

* Experimental effect
	+ Heterogeneity
	+ Failure of correctly understanding the causal effect
* Generalization of the results
	+ Internal vs. external validity
