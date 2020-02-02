************************************************
* Michael Tomz, Stanford University            *
* June 18, 2007                                *
* Stata Version 9.2                            *
* Creates dataset analyzed in Tomz, Goldstein, *
* and Rivers, "Membership Has its Privileges," *
* American Economic Review                     *
************************************************

version 9.2
clear
set mem 400m
set matsize 800
set more off

********************************************
* Prepare Stanford GATT Participation Data *
********************************************

tempfile gattmbr1 gattmbr2
use gattmbr, clear
rename imf imf1
sort imf1 year
save `gattmbr1'
use gattmbr, clear
rename imf imf2
sort imf2 year
save `gattmbr2'

tempfile provmbr1 provmbr2
use gattprov, clear
rename imf2 tmp
rename imf1 imf2
rename tmp imf1
rename ctyname2 tmp
rename ctyname1 ctyname2
rename tmp ctyname1
sort imf1 imf2 year
save `provmbr2'  /* 2nd country is provisional member */
use gattprov, clear
sort imf1 imf2 year
save `provmbr1' /* 1st country is provisional member */

*********************************************
* Get list of country codes in Rose dataset *
*********************************************

use roseaer04, clear
keep cty2
rename cty2 cty1
tempfile country2
save `country2'
use roseaer04, clear
keep cty1
append using `country2'
tempname ccodes
quietly tab cty1, matrow(`ccodes')  /* vector of country codes */
local ncountries = `r(r)'           /* number of countries */


*********************************
* MERGE-IN PARTICIPATION STATUS *
*********************************

use roseaer04, clear
rename cty1 imf1
rename cty2 imf2

* label variables in the Rose dataset
foreach var of varlist pairid-spr {
   local roselabel : variable label `var'
   label var `var' "Rose: `roselabel'"
}
order cty1name cty2name
label var cty1name "Name of country 1"
label var cty2name "Name of country 2"
label var year "Year"

* merge-in GATT participation for 1st country in dyad
sort imf1 year
merge imf1 year using `gattmbr1', keep(imf1 year gattmbr)
replace gattmbr = "out" if _merge==1  /* in master dataset, not in using dataset */
drop if _merge==2  /* in using dataset, not in master dataset */
drop _merge
rename gattmbr gattmbr1

* merge-in GATT participation for 2nd country in dyad
sort imf2 year
merge imf2 year using `gattmbr2', keep(imf2 year gattmbr)
replace gattmbr = "out" if _merge==1  /* in master dataset, not in using dataset */
drop if _merge==2  /* in using dataset, not in master dataset */
drop _merge
rename gattmbr gattmbr2

*******************************************************
* GENERATE MONADIC AND DYADIC PARTICIPATION VARIABLES *
*******************************************************

gen byte bothp = cond(gattmbr1 ~= "out" & gattmbr2 ~= "out", 1, 0)
gen byte nonep = cond(gattmbr1 == "out" & gattmbr2 == "out", 1, 0)
gen byte onep = 1 - bothp - nonep
label var bothp "GATT: Both Participate"
label var nonep "GATT: None Participates"
label var onep "GATT: One Participates"
gen byte gatto1 = cond(gattmbr1 == "out", 1, 0)                                               /* 1st country is OUT */
gen byte gatto2 = cond(gattmbr2 == "out", 1, 0)                                               /* 2nd country is OUT */
gen byte gattp1 = 1 - gatto1                                                                  /* 1st country participates */
gen byte gattp2 = 1 - gatto2                                                                  /* 2nd country participates */
gen byte gattn1 = cond(gattmbr1 == "col" | gattmbr1 == "df" | gattmbr1 == "prov", 1, 0)       /* 1st country is nonmbr participant */
gen byte gattn2 = cond(gattmbr2 == "col" | gattmbr2 == "df" | gattmbr2 == "prov", 1, 0)       /* 2nd country is nonmbr participant */
gen byte gattf1 = cond(gatto1 ~= 1 & gattn1 ~= 1, 1, 0)  /* not out & not nonmbr particip */  /* 1st country is nonmbr participant */
gen byte gattf2 = cond(gatto2 ~= 1 & gattn2 ~= 1, 1, 0)  /* not out & not nonmbr particip */  /* 2nd country is nonmbr participant */
label var gattp1 "GATT: Ctry 1 participates"
label var gattp2 "GATT: Ctry 2 participates"
label var gatto1 "GATT: Ctry 1 is out"
label var gatto2 "GATT: Ctry 2 is out"
label var gattn1 "GATT: Ctry 1 is nonmbr particip"
label var gattn2 "GATT: Ctry 2 is nonmbr particip"
label var gattf1 "GATT: Ctry 1 is formal mbr"
label var gattf2 "GATT: Ctry 2 is formal mbr"
gen byte gattff = gattf1*gattf2                  /* both formal */
gen byte gattnn = gattn1*gattn2                  /* both nonmbr participants */
gen byte gattfn = gattf1*gattn2 + gattf2*gattn1  /* one formal, one nmp */
gen byte gattfo = gattf1*gatto2 + gattf2*gatto1  /* one formal, one out */
gen byte gattno = gattn1*gatto2 + gattn2*gatto1  /* one nmp, one out */
label var gattff "GATT: Both formal members"
label var gattnn "GATT: Both nonmbr participants"
label var gattfn "GATT: Formal + nonmbr particip"
label var gattfo "GATT: Formal + out"
label var gattno "GATT: Nonmbr particip + out"


*************************************************
* MERGE-IN NON-ACCEPTANCE OF PROVISIONAL STATUS *
*************************************************

sort imf1 imf2 year
merge imf1 imf2 year using `provmbr1', keep(imf1 imf2 year)
drop if _merge == 2
gen byte gattnop2 = 0  /* country 2 rejects - or does not accept - provisional status of 1 */
* note: _merge==3 only if country 2 accepts country 1's provisional status
replace gattnop2 = 1 if (gattmbr2 ~= "out" & gattmbr1 == "prov" & _merge ~= 3)
drop _merge
label variable gattnop2 "GATT: Ctry2 d/n accept 1 as prov"


sort imf1 imf2 year
merge imf1 imf2 year using `provmbr2', keep(imf1 imf2 year)
drop if _merge == 2
gen byte gattnop1 = 0  /* country 1 rejects - or does not accept - provisional status of 2 */   
* note: _merge==3 only if country 1 accepts country 2's provisional status
replace gattnop1 = 1 if (gattmbr1 ~= "out" & gattmbr2 == "prov" & _merge ~= 3)
drop _merge
label variable gattnop1 "GATT: Ctry1 d/n accept 2 as prov"

gen byte gattnop = cond(gattnop1 == 1 | gattnop2 == 1, 1, 0)
label variable gattnop "GATT: One d/n accept provisional"


*************************************
* MERGE-IN INVOCATION OF ARTICLE 35 *
*************************************

sort imf1 imf2 year
merge imf1 imf2 year using gatt35, keep(imf1 imf2 year art351 art352)
drop if _merge==2
drop _merge
replace art351 = 0 if art351 == .
replace art352 = 0 if art352 == .
gen byte art35 = cond(art351 == 1 | art352 == 1, 1, 0)   /* either invokes article 35 */
gen byte both35 = cond(art351 == 1 & art352 == 1, 1, 0)  /* both invoke article 35 */
gen byte one35 = art35 - both35                          /* only one invokes article 35 */
label variable art351 "GATT: 1 wholds benefits from 2"
label variable art352 "GATT: 2 wholds benefits from 1"
label variable art35 "GATT: Either invokes XXXV"
label variable both35 "GATT: Both invoke XXXV"
label variable one35 "GATT: One invokes XXXV"
compress

************************************
* Augment regional dummy variables *
************************************

* Add Bahamas and Bermuda to Latin Am & Caribbean
replace latca1 = 1 if imf1 == 313 /* BAHAMAS */
replace latca2 = 1 if imf2 == 313 /* BAHAMAS */
replace latca1 = 1 if imf1 == 319 /* BERMUDA */
replace latca2 = 1 if imf2 == 319 /* BERMUDA */

* Add Gabon and Reunion to Sub-Saharan Africa
replace ssafr1 = 1 if imf1 == 646 /* GABON */
replace ssafr2 = 1 if imf2 == 646 /* GABON */
replace ssafr1 = 1 if imf1 == 696 /* REUNION */
replace ssafr2 = 1 if imf2 == 696 /* REUNION */

* Add Israel, Kuwait, Qatar, UAE, Turkey, Cyprus to mideast/N Africa
replace menaf1 = 1 if imf1 == 436 /* ISRAEL */
replace menaf2 = 1 if imf2 == 436 /* ISRAEL */
replace menaf1 = 1 if imf1 == 443 /* KUWAIT */
replace menaf2 = 1 if imf2 == 443 /* KUWAIT */
replace menaf1 = 1 if imf1 == 453 /* QATAR */
replace menaf2 = 1 if imf2 == 453 /* QATAR */
replace menaf1 = 1 if imf1 == 466 /* UNITED ARAB EMIRATES */
replace menaf2 = 1 if imf2 == 466 /* UNITED ARAB EMIRATES */
replace menaf1 = 1 if imf1 == 186 /* TURKEY */
replace menaf2 = 1 if imf2 == 186 /* TURKEY */
replace menaf1 = 1 if imf1 == 423 /* CYPRUS */
replace menaf2 = 1 if imf2 == 423 /* CYPRUS */


* Add Japan, Hong Kong, and Singapore to East Asia
replace easia1 = 1 if imf1 == 158 /* JAPAN */
replace easia2 = 1 if imf2 == 158 /* JAPAN */
replace easia1 = 1 if imf1 == 532 /* HONG KONG */
replace easia2 = 1 if imf2 == 532 /* HONG KONG */
replace easia1 = 1 if imf1 == 576 /* SINGAPORE */
replace easia2 = 1 if imf2 == 576 /* SINGAPORE */


*****************************
* Correct Income Categories *
*****************************

replace midin1 = 1 if imf1 == 646 /* GABON */
replace midin2 = 1 if imf2 == 646 /* GABON */
replace lowin1 = 1 if imf1 == 654 /* GUINEA BISSAU */
replace lowin2 = 1 if imf2 == 654 /* GUINEA BISSAU */
replace midin1 = 0 if imf1 == 654 /* GUINEA BISSAU */
replace midin2 = 0 if imf2 == 654 /* GUINEA BISSAU */


***************************************
* GATT Round Dummies and Interactions *
***************************************

gen byte round1 = cond(year < 1949, 1, 0)                 /* GATT pre Annecy round */
gen byte round2 = cond(year >= 1949 & year < 1951, 1, 0)  /* Annecy to Torquay round */
gen byte round3 = cond(year >= 1951 & year < 1956, 1, 0)  /* Torquay to Geneva */
gen byte round4 = cond(year >= 1956 & year < 1961, 1, 0)  /* Geneva to Dillon */
gen byte round5 = cond(year >= 1961 & year < 1967, 1, 0)  /* Dillon to Kennedy */
gen byte round6 = cond(year >= 1967 & year < 1979, 1, 0)  /* Kennedy to Tokyo */
gen byte round7 = cond(year >= 1979 & year < 1994, 1, 0)  /* Tokyo to Uruguay */
gen byte round8 = cond(year >= 1994, 1, 0)                /* After Uruguay round */
label var round1 "GATT Rnd 1: pre Annecy"
label var round2 "GATT Rnd 2: Annecy to Torquay"
label var round3 "GATT Rnd 3: Torquay to Geneva"
label var round4 "GATT Rnd 4: Geneva to Dillon"
label var round5 "GATT Rnd 5: Dillon to Kennedy"
label var round6 "GATT Rnd 6: Kennedy to Tokyo"
label var round7 "GATT Rnd 7: Tokyo to Uruguay"
label var round8 "GATT Rnd 8: After Uruguay"
forvalues i = 1/8 {                                  /* create variables for each of 8 rounds */
   * gen byte bothin`i' = bothin * round`i'                 /* bothin and onein replicate rose */
   * gen byte onein`i' = onein * round`i'
   gen byte bothp`i' = bothp * round`i'                   /* bothp and onep are for partipation */
   gen byte onep`i' = onep * round`i'
   * label var bothin`i' "GATT: Both in (Rose) Rnd `i'"
   * label var onein`i' "GATT: One in (Rose) Rnd `i'"
   label var bothp`i' "GATT: Both participate Rnd `i'"
   label var onep`i' "GATT: One participates Rnd `i'"
}

********************************************************
* Create country dummies, dyad indicator, year dummies *
********************************************************

forvalues i = 1/`ncountries' {
   local ccode = `ccodes'[`i',1]
   gen byte c`ccode' = cond(imf1==`ccode'|imf2==`ccode',1,0)
   label variable c`ccode' "Dummy for country `ccode'"
}
quietly tab year, gen(yrdum)
gen dyad = imf1*1000 + imf2
label var dyad "Dyad indicator (6-digit)"

********
* SAVE *
********

compress
label data "Tomz Goldstein Rivers AER" 
save TGR2007, replace
