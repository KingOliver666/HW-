
* Part(a)
* I first transform XPT file into dta using R, and then import the merged data into stata
use "C:\Users\Lenovo\Downloads\xpt_data1.dta", clear

merge 1:1 SEQN using "C:\Users\Lenovo\Downloads\xpt_data2.dta"

keep if _merge == 3

count
* Part(b)

* Version 1:(This is the one I try to use for loop and continue modify and revised under guidience of Chatgpt)
preserve
drop if missing(RIDAGEMN)
gen age_years = RIDAGEMN / 12
keep if VIQ220 == 1 | VIQ220 == 2
replace VIQ220 = 0 if VIQ220 == 2

* Create age intervals
gen age_interval = floor(age_years / 10) * 10

* Calculate and display the mean for each age interval
foreach i in 10 20 30 40 50 60 70 80 {
    local lower_limit `i'
    local upper_limit `i' + 9
    
    summarize VIQ220 if age_interval >= `lower_limit' & age_interval <= `upper_limit', meanonly
    display "Age Interval: `lower_limit' - `upper_limit', Mean VIQ220: " r(mean)
}

// Age Interval: 10 - 10 + 9, Mean VIQ220: .32088123
// Age Interval: 20 - 20 + 9, Mean VIQ220: .32657417
// Age Interval: 30 - 30 + 9, Mean VIQ220: .35866667
// Age Interval: 40 - 40 + 9, Mean VIQ220: .36998706
// Age Interval: 50 - 50 + 9, Mean VIQ220: .5500821
// Age Interval: 60 - 60 + 9, Mean VIQ220: .62222222
// Age Interval: 70 - 70 + 9, Mean VIQ220: .6689038
// Age Interval: 80 - 80 + 9, Mean VIQ220: .66489362
restore


* Version 2 (This is the version that I use the most silly way to show the table)
preserve
drop if missing(RIDAGEMN)
gen age_years = RIDAGEMN / 12
keep if VIQ220 == 1 | VIQ220 == 2
replace VIQ220 = 0 if VIQ220 == 2
summarize(age_years)

//     Variable |        Obs        Mean    Std. dev.       Min        Max
// -------------+---------------------------------------------------------
//    age_years |      6,422    37.35762    21.00756         12   84.91666

* Thus, we only need to consider intervals of [10, 20), ......[80, 90) 

*
summarize VIQ220 if (age_years >= 10 & age_years <20)

//     Variable |        Obs        Mean    Std. dev.       Min        Max
// -------------+---------------------------------------------------------
//       VIQ220 |      2,088    .3208812    .4669271          0          1

. summarize VIQ220 if (age_years >= 20 & age_years <30)
//
//     Variable |        Obs        Mean    Std. dev.       Min        Max
// -------------+---------------------------------------------------------
//       VIQ220 |        937    .3265742    .4692104          0          1

. summarize VIQ220 if (age_years >= 30 & age_years <40)

//     Variable |        Obs        Mean    Std. dev.       Min        Max
// -------------+---------------------------------------------------------
//       VIQ220 |        750    .3586667    .4799292          0          1

. summarize VIQ220 if (age_years >= 40 & age_years <50)

//     Variable |        Obs        Mean    Std. dev.       Min        Max
// -------------+---------------------------------------------------------
//       VIQ220 |        773    .3699871    .4831134          0          1

. summarize VIQ220 if (age_years >= 50 & age_years <60)

//     Variable |        Obs        Mean    Std. dev.       Min        Max
// -------------+---------------------------------------------------------
//       VIQ220 |        609    .5500821    .4978944          0          1

. summarize VIQ220 if (age_years >= 60 & age_years <70)

//     Variable |        Obs        Mean    Std. dev.       Min        Max
// -------------+---------------------------------------------------------
//       VIQ220 |        630    .6222222    .4852169          0          1

. summarize VIQ220 if (age_years >= 70 & age_years <80)

//     Variable |        Obs        Mean    Std. dev.       Min        Max
// -------------+---------------------------------------------------------
//       VIQ220 |        447    .6689038    .4711349          0          1

. summarize VIQ220 if (age_years >= 80 & age_years <90)

//     Variable |        Obs        Mean    Std. dev.       Min        Max
// -------------+---------------------------------------------------------
//       VIQ220 |        188    .6648936    .4732881          0          1
restore




* Part(c)
preserve 
* first fo a single regression with predictor age
keep if VIQ220 == 1 | VIQ220 == 2
replace VIQ220 = 0 if VIQ220 == 2
logit VIQ220 RIDAGEMN, or

// Iteration 0:   log likelihood = -4363.8419  
// Iteration 1:   log likelihood = -4158.5951  
// Iteration 2:   log likelihood = -4158.3283  
// Iteration 3:   log likelihood = -4158.3283  
//
// Logistic regression                                     Number of obs =  6,422
//                                                         LR chi2(1)    = 411.03
//                                                         Prob > chi2   = 0.0000
// Log likelihood = -4158.3283                             Pseudo R2     = 0.0471
//
// ------------------------------------------------------------------------------
//       VIQ220 | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
// -------------+----------------------------------------------------------------
//     RIDAGEMN |   1.002075   .0001051    19.75   0.000     1.001869    1.002281
//        _cons |   .2786616   .0153179   -23.24   0.000     .2501999    .3103611
// ------------------------------------------------------------------------------


* Do a regression with predictors "age" and "gender"
logit VIQ220 RIDAGEMN i.RIAGENDR i.RIDRETH1, or

// Iteration 0:   log likelihood = -4363.8419  
// Iteration 1:   log likelihood =  -4060.098  
// Iteration 2:   log likelihood = -4058.4786  
// Iteration 3:   log likelihood = -4058.4784  
//
// Logistic regression                                     Number of obs =  6,422
//                                                         LR chi2(6)    = 610.73
//                                                         Prob > chi2   = 0.0000
// Log likelihood = -4058.4784                             Pseudo R2     = 0.0700
//
// ------------------------------------------------------------------------------
//       VIQ220 | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
// -------------+----------------------------------------------------------------
//     RIDAGEMN |   1.001922   .0001098    17.52   0.000     1.001707    1.002137
//   2.RIAGENDR |   1.668947   .0893991     9.56   0.000     1.502612    1.853694
//              |
//     RIDRETH1 |
//           2  |   1.173444   .1930589     0.97   0.331     .8500019    1.619962
//           3  |   1.959667   .1380709     9.55   0.000     1.706907    2.249857
//           4  |   1.313854   .1010448     3.55   0.000     1.130014    1.527604
//           5  |   1.954163    .266163     4.92   0.000      1.49632    2.552096
//              |
//        _cons |   .1538866   .0122459   -23.52   0.000     .1316633    .1798611
// ------------------------------------------------------------------------------

* Do the last regression
logit VIQ220 RIDAGEMN i.RIAGENDR i.RIDRETH1 INDFMPIR, or

// Iteration 0:   log likelihood =  -4175.519  
// Iteration 1:   log likelihood = -3876.7781  
// Iteration 2:   log likelihood = -3875.2623  
// Iteration 3:   log likelihood = -3875.2621  
//
// Logistic regression                                     Number of obs =  6,136
//                                                         LR chi2(7)    = 600.51
//                                                         Prob > chi2   = 0.0000
// Log likelihood = -3875.2621                             Pseudo R2     = 0.0719
//
// ------------------------------------------------------------------------------
//       VIQ220 | Odds ratio   Std. err.      z    P>|z|     [95% conf. interval]
// -------------+----------------------------------------------------------------
//     RIDAGEMN |   1.001879   .0001126    16.71   0.000     1.001658      1.0021
//   2.RIAGENDR |   1.688141   .0925971     9.55   0.000     1.516069    1.879743
//              |
//     RIDRETH1 |
//           2  |   1.126952   .1898906     0.71   0.478     .8099877     1.56795
//           3  |   1.649955   .1248903     6.62   0.000     1.422466    1.913825
//           4  |    1.24501   .0990402     2.75   0.006     1.065271    1.455076
//           5  |    1.73547   .2446496     3.91   0.000     1.316507    2.287764
//              |
//     INDFMPIR |   1.123114   .0200761     6.50   0.000     1.084447     1.16316
//        _cons |    .128681   .0114689   -23.01   0.000     .1080562    .1532425
// ------------------------------------------------------------------------------




* Part(d)
* Answer for the first question, since we find that the Odds ratio is greater than 1 and has the P value very close to 0, this means it seems that the "odd" of men and women being wears of glasess/contact lenses for distance vision differs.
tabulate RIAGENDR VIQ220

//            |    Glasses/contact
//            |    lenses worn for
//            |       distance
//     Gender |         0          1 |     Total
// -----------+----------------------+----------
//          1 |     2,014      1,181 |     3,195 
//          2 |     1,766      1,584 |     3,350 
// -----------+----------------------+----------
//      Total |     3,780      2,765 |     6,545 


prtest VIQ220, by (RIAGENDR)

// Two-sample test of proportions                     1: Number of obs =     3195
//                                                    2: Number of obs =     3350
// ------------------------------------------------------------------------------
//        Group |       Mean   Std. err.      z    P>|z|     [95% conf. interval]
// -------------+----------------------------------------------------------------
//            1 |   .3696401   .0085398                      .3529023    .3863778
//            2 |   .4728358   .0086259                      .4559293    .4897423
// -------------+----------------------------------------------------------------
//         diff |  -.1031958   .0121382                     -.1269861   -.0794054
//              |  under H0:   .0122146    -8.45   0.000
// ------------------------------------------------------------------------------
//         diff = prop(1) - prop(2)                                  z =  -8.4485
//     H0: diff = 0
//
//     Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
//  Pr(Z < z) = 0.0000         Pr(|Z| > |z|) = 0.0000          Pr(Z > z) = 1.0000

* Answer: So by doing proportional test, we notice that the P-value is close to zero, meaning we will reject null hypothesis and conclude that it seem that two genders has different propertion of wearers of glass/contact lenses for distance. 
restore