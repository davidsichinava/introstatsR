************************************************
* Michael Tomz, Stanford University            *
* June 18, 2007                                *
* Stata Version 9.2                            *
* Replicates analysis in Tomz, Goldstein,      *
* and Rivers, "Membership Has its Privileges," *
* American Economic Review                     *
************************************************

version 9.2
clear
set mem 400m
set matsize 800
set more off

capture log close
log using classify, text replace

***************************************************************
* COMPARE ROSE CLASSIFICATIONS TO TOMZ, GOLDSTEIN, AND RIVERS *
***************************************************************

** CREATE MONADIC MEMBERSHIP DATASET **
tempfile bottom
use TGR2007, clear             /* load merged data */
keep cty2name year join2 curcol gattmbr2  /* 2nd country in dyad */
rename cty2name ctyname
rename join2 join
rename gattmbr2 gattmbr
save `bottom'
use TGR2007, clear             /* reload merged data */
keep cty1name year join1 curcol gattmbr1  /* 1st country in dyad */
rename cty1name ctyname
rename join1 join
rename gattmbr1 gattmbr
append using `bottom'                     /* stack 1st, 2nd countries */
duplicates drop ctyname year join curcol gattmbr, force
gen rosein = (join <= year)

** ROSE'S TREATMENT OF PROVISIONAL MEMBERS **
egen maxrose = max(rosein) if gattmbr == "prov", by(ctyname)
egen minrose = min(rosein) if gattmbr == "prov", by(ctyname)

* Rose dataset treats the following provisionals
* as members in their relations with all countries
tab ctyname if minrose == 1

* Rose dataset treats the following provisionals
* as nonmembers in their relations with all countries
tab ctyname if maxrose == 0

* Were there any mixed cases, in which provisionals were treated
* as members in relations with some countries but not with others?
tab ctyname if maxrose ~= minrose
drop maxrose minrose

** ROSE'S TREATMENT OF DE FACTO MEMBERS **
egen maxrose = max(rosein) if gattmbr == "df", by(ctyname)
egen minrose = min(rosein) if gattmbr == "df", by(ctyname)

* Rose dataset treats the following de factos
* as members in their relations with all countries
tab ctyname if minrose == 1

* Rose dataset treats the following de factos
* as nonmembers in their relations with all countries
tab ctyname if maxrose == 0
return list

* Were there any mixed cases, in which de factos were treated as
* members in relations with some countries but not with others?
tab ctyname if maxrose ~= minrose
drop maxrose minrose

** ROSE'S TREATMENT OF COLONIAL PARTICIPANTS **

* How many countries in the rose dataset were colonial
* members for at least some years covered in the dataset?
tab ctyname if gattmbr == "col"
return list

* The Rose dataset classifies the following colonies as members
egen maxrose = max(rosein) if gattmbr == "col", by(ctyname)
egen minrose = min(rosein) if gattmbr == "col", by(ctyname)
tab ctyname if minrose == 1

* The Rose dataset misses the following colonial participants
tab ctyname if maxrose == 0

* The Rose dataset classifies the following colonies as members for
* years in which they were not actually subject to the agreement
tab ctyname if curcol == 1 & rosein == 1 & gattmbr == "out"
drop maxrose minrose

* The Rose dataset treats the following colonies as
* insiders when paired with their metropole
egen minrose = min(rosein) if gattmbr == "col" & curcol==1, by(ctyname)
tab ctyname if minrose==1
drop minrose

* The Rose dataset treats the following colonies as
* outsiders when they are paired with countries other than their metropole
egen maxrose = max(rosein) if gattmbr == "col" & curcol==0, by(ctyname)
egen minrose = min(rosein) if gattmbr == "col" & curcol==0, by(ctyname)
tab ctyname if maxrose == 0
return list

* Were there any mixed cases, in which colonies were treated as
* members in relations with some countries but not with others?
tab ctyname if maxrose ~= minrose
drop maxrose minrose

** ROSE'S TREATMENT OF FORMAL MEMBERS **
generate formal = cond(gattmbr=="orig" | gattmbr=="art26:5" | gattmbr=="art33" | gattmbr=="wto",1,0)
* The Rose dataset overlooks the following formal members
* for at least some years
tab ctyname if formal==1 & rosein==0

** A list of all countries in the Rose dataset that were 
** nonmember participants in at least some years covered by the dataset
gen nmp = cond(gattmbr=="col" | gattmbr=="df" | gattmbr=="prov",1,0)
tab ctyname if nmp==1
return list

log close

log using table1, text replace

***********************************
* TOMZ, GOLDSTEIN, RIVERS TABLE 1 *
***********************************

use TGR2007, clear
tempvar gattp gattf rosembr

* Create a single variable that summarizes GATT participation
gen `gattp' = 0                         /* initialize to "none in" */
replace `gattp' = -1 if onep == 1       /* -1 if only one participates */
replace `gattp' = -2 if bothp == 1      /* -2 if both participate */
label define mbr -2 "BothIn" -1 "OneIn" 0 "NoneIn" 
label values `gattp' mbr
label var `gattp' "Participation"

* Create a single variable that summarizes true formal membership
gen `gattf' = 0                                    /* initialize to "none formal" */
replace `gattf' = -1 if gattfo == 1 | gattfn == 1  /* -1 if only one is a formal member */
replace `gattf' = -2 if gattff == 1                /* -2 if both are formal members */
label values `gattf' mbr
label var `gattf' "Formal Membership"

* Create a single variable that summarizes rose's membership variable
gen `rosembr' = 0                                  /* initialize to "none formal */
replace `rosembr' = -1 if onein == 1               /* -1 if only one is a formal member */
replace `rosembr' = -2 if bothin == 1              /* -2 if both are formal members */
label values `rosembr' mbr
label var `rosembr' "Rose Formal Membership"

tab `gattp' `gattf'     /* tabulate participation against true formal membership variable */
tab `gattp' `rosembr'   /* tabulate participation against Rose's formal membership variable */

log close


log using table2, text replace

***********************************
* TOMZ, GOLDSTEIN, RIVERS TABLE 2 *
***********************************

capture program drop fx_pct
program define fx_pct
   version 9.2
   syntax varlist
   foreach v in `varlist' {
      di "`v': % increase in trade " %3.0f 100*(exp(_b[`v'])-1) "% with unrounded coeff, " %3.0f 100*(exp( round(_b[`v'],.01) )-1) "% with rounded coeff"
   }
end

* Table 2, Column 1: ROSE'S FORMAL MEMBERS, YEAR FIXED EFFECTS (REPLICATES AER 2004 Table 1.1)
areg ltrade bothin onein gsp ldist lrgdp lrgdppc regional custrict comlang border landl island lareap comcol curcol colony comctry, a(year) robust cluster(dyad)
estimates store t2c1  /* store table2 column 1 */
fx_pct bothin onein   

* Table 2, Column 2: CORRECTED FORMAL MEMBERS, YEAR FIXED EFFECTS
areg ltrade gattff gattfo gsp ldist lrgdp lrgdppc regional custrict comlang border landl island lareap comcol curcol colony comctry, a(year) robust cluster(dyad)
estimates store t2c2
fx_pct gattff gattfo 

* Table 2, Column 3: PARTICIPATION x 5, YEAR FIXED EFFECTS
areg ltrade gattff gattfn gattnn gattfo gattno gsp ldist lrgdp lrgdppc regional custrict comlang border landl island lareap comcol curcol colony comctry, a(year) robust cluster(dyad)
estimates store t2c3
fx_pct gattff gattfn gattnn gattfo gattno  

* Table 2, Column 4: PARTICIPATION x 5, YEAR AND COUNTRY FIXED EFFECTS
areg ltrade gattff gattfn gattnn gattfo gattno gsp ldist lrgdp lrgdppc regional custrict comlang border landl island lareap comcol curcol colony comctry c111-c968, a(year) robust cluster(dyad)
estimates store t2c4
fx_pct gattff gattfn gattnn gattfo gattno 

* Table 2, Column 5: PARTICIPATION x 5, YEAR AND DYADIC FIXED EFFECTS
areg ltrade gattff gattfn gattnn gattfo gattno gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52, a(dyad) robust cluster(dyad)
estimates store t2c5
fx_pct gattff gattfn gattnn gattfo gattno 

* Table 2, Column 6: PARTICIPATION x 2, YEAR AND DYADIC FIXED EFFECTS
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52, a(dyad) robust cluster(dyad)
estimates store t2c6
fx_pct bothp onep  
di "How much higher % when both participate? " %7.2f 100*(exp(_b[bothp] - _b[onep]) - 1) 
di "Same quantity using rounded coefficients " %7.2f 100*(exp(round(_b[bothp],.01) - round(_b[onep],.01)) - 1) 

* Table 2, Column 7: PARTICIPATION x 2 with Article 35, YEAR AND DYADIC FIXED EFFECTS
areg ltrade bothp onep both35 one35 gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52, a(dyad) robust cluster(dyad)
estimates store t2c7
di "Percentage effects when no one invokes article 35:" 
fx_pct bothp onep
di "Bothp when one invokes article 35: " %7.2f 100*(exp(_b[bothp] + _b[one35]) - 1)
di "Same quantity using rounded coeffs: " %7.2f 100*(exp( round(_b[bothp],.01) + round(_b[one35],.01) ) - 1)
di "Bothp when both invoke article 35: " %7.2f 100*(exp(_b[bothp] + _b[both35]) - 1)
di "Same quantity using rounced coeffs: " %7.2f 100*(exp( round(_b[bothp],.01) + round(_b[both35],.01) ) - 1)
tab art35  
tab art351 art352 

* Print Table 2
estimates table t2c1 t2c2, se b(%5.2f) stats(rmse r2) stfmt(%5.3f) keep(bothin onein gattff gattfo gsp regional custrict curcol lrgdp lrgdppc ldist comlang border landl island lareap comcol colony comctry)
estimates table t2c3 t2c4 t2c5 t2c6 t2c7, se b(%5.2f) stats(rmse r2) stfmt(%5.3f) keep(gattff gattfn gattnn bothp gattfo gattno onep both35 one35 gsp regional custrict curcol lrgdp lrgdppc ldist comlang border landl island lareap comcol colony comctry)
estimates stats t2c1 t2c2 t2c3 t2c4 t2c5 t2c6 t2c7

* FOOTNOTE: DID PARTNER SIGN DECLARATION OF PROVISIONAL ACCESSION?
* STANFORD MEMBERSHIP x 2 with Provisional Non-Acceptance and Article 35, YEAR AND DYADIC FIXED EFFECTS
areg ltrade bothp onep gattnop both35 one35 gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52, a(dyad) robust cluster(dyad)
fx_pct bothp onep
di "Bothp when one does not sign provisional protocol: " %7.2f 100*(exp(_b[bothp] + _b[gattnop]) - 1)  /* delete? */
di "Same quantity when use rounded coefficients: " %7.2f 100*(exp( round(_b[bothp],.01) + round(_b[gattnop],.01) ) - 1)  /* delete? */

log close

log using table3, text replace

***********************************
* TOMZ, GOLDSTEIN, RIVERS TABLE 3 *
***********************************

* model with FE for years only
areg ltrade bothp1 bothp2 bothp3 bothp4 bothp5 bothp6 bothp7 bothp8 onep1 onep2 onep3 onep4 onep5 onep6 onep7 onep8 gsp regional custrict ldist lrgdp lrgdppc comlang border landl island lareap comcol curcol colony comctry, a(year) robust cluster(dyad)
estimates store t3pt1
fx_pct bothp1 bothp2 bothp3 bothp4 bothp5 bothp6 bothp7 bothp8 onep1 onep2 onep3 onep4 onep5 onep6 onep7 onep8 

* model with FE for dyads and years
areg ltrade bothp1 bothp2 bothp3 bothp4 bothp5 bothp6 bothp7 bothp8 onep1 onep2 onep3 onep4 onep5 onep6 onep7 onep8 gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52, a(dyad) robust cluster(dyad)
estimates store t3pt2
fx_pct bothp1 bothp2 bothp3 bothp4 bothp5 bothp6 bothp7 bothp8 onep1 onep2 onep3 onep4 onep5 onep6 onep7 onep8 

* Print Table 3
estimates table t3pt1 t3pt2, se b(%5.2f) stats(rmse r2) stfmt(%5.3f) keep(bothp1 bothp2 bothp3 bothp4 bothp5 bothp6 bothp7 bothp8 onep1 onep2 onep3 onep4 onep5 onep6 onep7 onep8)
estimates table t3pt1 t3pt2, b(%5.2f) stats(rmse r2) stfmt(%5.3f) keep(bothp1 bothp2 bothp3 bothp4 bothp5 bothp6 bothp7 bothp8 onep1 onep2 onep3 onep4 onep5 onep6 onep7 onep8) star

* FOOTNOTE: DYNAMICS ARDL(1,1)
* Create lags of independent variables and dependent variable
sort dyad year
by dyad: gen Lbothp = bothp[_n-1] if (year == year[_n-1]+1)
by dyad: gen Lonep = onep[_n-1] if (year == year[_n-1]+1)
foreach var in ltrade gsp regional custrict lrgdp lrgdppc curcol {
   by dyad: gen L`var' = `var'[_n-1] if (year == year[_n-1]+1)
   local laglist `laglist' L`var'
}
* AUTOREGRESSIVE DISTRIBUTED LAG MODEL ARDL(1,1), with dyad and year effects
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol Lbothp Lonep `laglist' yrdum2-yrdum52, a(dyad) robust cluster(dyad)
di "The long-run coefficient on bothp is: " (_b[bothp] + _b[Lbothp]) / (1 - _b[Lltrade])
di "Same, expressed as a percentage: " %5.0f 100 * (exp( (_b[bothp] + _b[Lbothp]) / (1 - _b[Lltrade]) ) - 1)
di "Same, based on rounded coefficients: " %5.0f 100 * (exp( ( round(_b[bothp],.01) + round(_b[Lbothp],.01) ) / (1 - round(_b[Lltrade],.01) ) ) - 1)
di "The long-run coefficient on onep is: " (_b[onep] + _b[Lonep]) / (1 - _b[Lltrade])
di "Same, expressed as a percentage: " %5.0f 100 * (exp( (_b[onep] + _b[Lonep]) / (1 - _b[Lltrade]) ) - 1)
di "Same, based on rounded coefficients: " %5.0f 100 * (exp( ( round(_b[onep],.01) + round(_b[Lonep],.01) ) / (1 - round(_b[Lltrade],.01) ) ) - 1)

log close

log using table4, text replace

***********************************
* TOMZ, GOLDSTEIN, RIVERS TABLE 4 *
***********************************

* no industrial
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52 if imf1 >= 200, a(dyad) robust cluster(dyad)
estimates store t4r1
fx_pct bothp onep

* only industrial
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52 if imf2 < 200, a(dyad) robust cluster(dyad)
estimates store t4r2
fx_pct bothp onep

* industrial with non-industrial
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52 if imf1 < 200 & imf2 >= 200, a(dyad) robust cluster(dyad)
estimates store t4r3
fx_pct bothp onep

* high income
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52 if highi1==1 | highi2==1, a(dyad) robust cluster(dyad)
estimates store t4r4
fx_pct bothp onep

* middle income
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52 if midin1==1 | midin2==1, a(dyad) robust cluster(dyad)
estimates store t4r5
fx_pct bothp onep

* low income
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52 if lowin1==1 | lowin2==1, a(dyad) robust cluster(dyad)
estimates store t4r6
fx_pct bothp onep

* least developed
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52 if least1==1 | least2==1, a(dyad) robust cluster(dyad)
estimates store t4r7
fx_pct bothp onep

* Latin America or Caribbean
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52 if latca1==1 | latca2==1, a(dyad) robust cluster(dyad)
estimates store t4r8
fx_pct bothp onep

* Sub Saharan Africa
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52 if ssafr1==1 | ssafr2==1, a(dyad) robust cluster(dyad)
estimates store t4r9
fx_pct bothp onep

* Middle East or North Africa
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52 if menaf1==1 | menaf2==1, a(dyad) robust cluster(dyad)
estimates store t4r10
fx_pct bothp onep

* South Asia
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52 if sasia1==1 | sasia2==1, a(dyad) robust cluster(dyad)
estimates store t4r11
fx_pct bothp onep

* East Asia
areg ltrade bothp onep gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52 if easia1==1 | easia2==1, a(dyad) robust cluster(dyad)
estimates store t4r12
fx_pct bothp onep

* Print Table 4
estimates table t4r1 t4r2 t4r3 t4r4 t4r5 t4r6, se b(%5.2f) keep(bothp onep)
estimates table t4r7 t4r8 t4r9 t4r10 t4r11 t4r12, se b(%5.2f) keep(bothp onep)
estimates stats t4r1 t4r2 t4r3 t4r4 t4r5 t4r6 t4r7 t4r8 t4r9 t4r10 t4r11 t4r12

log close

log using table5, text replace

***********************************
* TOMZ, GOLDSTEIN, RIVERS TABLE 5 *
***********************************

reg ltrade bothp onep gsp regional custrict ldist lrgdp lrgdppc comlang border landl island lareap comcol curcol colony comctry if year==1950, robust
estimates store t5r1
fx_pct bothp onep

reg ltrade bothp onep gsp regional custrict ldist lrgdp lrgdppc comlang border landl island lareap comcol curcol colony comctry if year==1955, robust
estimates store t5r2
fx_pct bothp onep

reg ltrade bothp onep gsp regional custrict ldist lrgdp lrgdppc comlang border landl island lareap comcol curcol colony comctry if year==1960, robust
estimates store t5r3
fx_pct bothp onep

reg ltrade bothp onep gsp regional custrict ldist lrgdp lrgdppc comlang border landl island lareap comcol curcol colony comctry if year==1965, robust
estimates store t5r4
fx_pct bothp onep

reg ltrade bothp onep gsp regional custrict ldist lrgdp lrgdppc comlang border landl island lareap comcol curcol colony comctry if year==1970, robust
estimates store t5r5
fx_pct bothp onep

reg ltrade bothp onep gsp regional custrict ldist lrgdp lrgdppc comlang border landl island lareap comcol curcol colony comctry if year==1975, robust
estimates store t5r6
fx_pct bothp onep

reg ltrade bothp onep gsp regional custrict ldist lrgdp lrgdppc comlang border landl island lareap comcol curcol colony comctry if year==1980, robust
estimates store t5r7
fx_pct bothp onep

reg ltrade bothp onep gsp regional custrict ldist lrgdp lrgdppc comlang border landl island lareap comcol curcol colony comctry if year==1985, robust
estimates store t5r8
fx_pct bothp onep

reg ltrade bothp onep gsp regional custrict ldist lrgdp lrgdppc comlang border landl island lareap comcol curcol colony comctry if year==1990, robust
estimates store t5r9
fx_pct bothp onep

reg ltrade bothp onep gsp regional custrict ldist lrgdp lrgdppc comlang border landl island lareap comcol curcol colony comctry if year==1995, robust
estimates store t5r10
fx_pct bothp onep

* print Table 5
estimates table t5r1 t5r2 t5r3 t5r4 t5r5, se b(%5.2f) keep(bothp onep)
estimates table t5r6 t5r7 t5r8 t5r9 t5r10, se b(%5.2f) keep(bothp onep)
estimates stats t5r1 t5r2 t5r3 t5r4 t5r5 t5r6 t5r7 t5r8 t5r9 t5r10

*****************************************************
* BY MEMBERSHIP COMBINATION - Omitted to save space *
*****************************************************

* gattff is already defined                                                                                 /* two formal members */
gen byte gattfc = cond( (gattf1==1 & gattmbr2=="col") | (gattmbr1=="col" & gattf2==1), 1, 0)                /* formal member and colonial member */
gen byte gattfd = cond( (gattf1==1 & gattmbr2=="df") | (gattmbr1=="df" & gattf2==1), 1, 0)                  /* formal member and defacto member */
gen byte gattfp = cond( (gattf1==1 & gattmbr2=="prov") | (gattmbr1=="prov" & gattf2==1), 1, 0)              /* formal member and provisional member */
* gattfo is already defined                                                                                 /* formal member and outsider */
gen byte gattcc = cond( gattmbr1=="col" & gattmbr2=="col", 1, 0)                                            /* two colonial members */
gen byte gattcd = cond( (gattmbr1=="col" & gattmbr2=="df") | (gattmbr1=="df" & gattmbr2=="col"), 1, 0)      /* colonial and defacto */
gen byte gattcp = cond( (gattmbr1=="col" & gattmbr2=="prov") | (gattmbr1=="prov" & gattmbr2=="col"), 1, 0)  /* colonial and provisional */
gen byte gattco = cond( (gattmbr1=="col" & gattmbr2=="out") | (gattmbr1=="out" & gattmbr2=="col"), 1, 0)    /* colonial and outsider */
gen byte gattdd = cond( gattmbr1=="df" & gattmbr2=="df", 1, 0)                                              /* two defacto members */
gen byte gattdp = cond( (gattmbr1=="df" & gattmbr2=="prov") | (gattmbr1=="prov" & gattmbr2=="df"), 1, 0)    /* defacto and provisional */
gen byte gattdo = cond( (gattmbr1=="df" & gattmbr2=="out") | (gattmbr1=="out" & gattmbr2=="df"), 1, 0)      /* defacto and outsider */
gen byte gattpp = cond( gattmbr1=="prov" & gattmbr2=="prov", 1, 0)                                          /* two provisional members */
gen byte gattpo = cond( (gattmbr1=="prov" & gattmbr2=="out") | (gattmbr1=="out" & gattmbr2=="prov"), 1, 0)  /* provisional and outsider */

* display number in each category
foreach v in gattff gattfc gattfd gattfp gattcc gattcd gattcp gattdd gattdp gattpp gattfo gattco gattdo gattpo {
   tab `v'
}

* Analysis with year and dyadic effects
areg ltrade gattff gattfc gattfd gattfp gattcc gattcd gattcp gattdd gattdp gattpp gattfo gattco gattdo gattpo gsp regional custrict lrgdp lrgdppc curcol yrdum2-yrdum52, a(dyad) robust cluster(dyad)
estimates store bytype_fe
fx_pct gattff gattfc gattfd gattfp gattcc gattcd gattcp gattdd gattdp gattpp gattfo gattco gattdo gattpo 
estimates table bytype_fe, se b(%5.2f) keep(gattff gattfc gattfd gattfp gattcc gattcd gattcp gattdd gattdp gattpp gattfo gattco gattdo gattpo)    /* table with std errors */
estimates table bytype_fe, b(%5.2f) keep(gattff gattfc gattfd gattfp gattcc gattcd gattcp gattdd gattdp gattpp gattfo gattco gattdo gattpo) star  /* table with "stars" */
estimates stats bytype_fe

log close

