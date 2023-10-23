** Part(c) **
import delimited "C:\Users\Lenovo\Downloads\PUBLIC_FILTER.csv", varnames(1)

**Answer: Now I have succesfully import the filtered data(this is a csv file) into STATA. **



** Part(d) **
describe

// Contains data
//  Observations:        11,667                  
//     Variables:             9                  
// -----------------------------------------------------------------------------------
// Variable      Storage   Display    Value
//     name         type    format    label      Variable label
// -----------------------------------------------------------------------------------
// caseid          int     %8.0g                 CaseID
// b3              str19   %19s                  B3
// nd2             str15   %15s                  ND2
// b7_b            str9    %9s                   B7_b
// gh1             str57   %57s                  GH1
// ppeducat        str64   %64s                  
// race_5cat       str8    %9s                   
// weight          float   %9.0g                 
// weight_pop      float   %9.0g                 
// -----------------------------------------------------------------------------------
// Sorted by: 
//      Note: Dataset has changed since last saved.



** Answer: Here we see that our subset of the original data has number of rows of 11667 and totally 9 variables that we want. The number of rows of the subdata matches the number of rows of original data by looking at the codebook.



** Part(e) **
preserve
replace b3 = "0" if b3 == "Much worse off"
replace b3 = "0" if b3 == "Somewhat worse off"
replace b3 = "1" if b3 == "About the same"
replace b3 = "1" if b3 == "Somewhat better off"
replace b3 = "1" if b3 == "Much better off"

** Change the b3(string type) into numeric variable and rename it as b3_new**
destring b3, generate(b3_new)

** Answer: Then we have convert the Likert scale into binary variable. **



** Part(f) **
svyset caseid [pw = weight_pop]

// Sampling weights: weight_pop
//              VCE: linearized
//      Single unit: missing
//         Strata 1: <one>
//  Sampling unit 1: caseid
//            FPC 1: <zero>

** Now I have tell stata that the data is from a complex sample, and then I will carry out a logistic regression. I first need to transform strings in each variable to be numeric
replace nd2 = "1" if nd2 == "Much higher"
replace nd2 = "2" if nd2 == "Somewhat higher"
replace nd2 = "3" if nd2 == "About the same"
replace nd2 = "4" if nd2 == "Somewhat lower"
replace nd2 = "5" if nd2 == "Much lower"
destring nd2, generate(nd2_new)

replace b7_b = "1" if b7_b == "Poor"
replace b7_b = "2" if b7_b == "Only fair"
replace b7_b = "3" if b7_b == "Good"
replace b7_b = "4" if b7_b == "Excellent"
destring b7_b, generate(b7_b_new)

replace gh1 = "1" if gh1 == "Own your home with a mortgage or loan"
replace gh1 = "2" if gh1 == "Own your home free and clear (without a mortgage or loan)"
replace gh1 = "3" if gh1 == "Pay rent"
replace gh1 = "4" if gh1 == "Neither own nor pay rent"
destring gh1, generate(gh1_new)

replace ppeducat = "1" if ppeducat == "No high school diploma or GED"
replace ppeducat = "2" if ppeducat == "High school graduate (high school diploma or the equivalent GED)"
replace ppeducat = "3" if ppeducat == "Some college or Associate's degree"
replace ppeducat = "4" if ppeducat == "Bachelor's degree or higher"
destring ppeducat, generate(ppeducat_new)

replace race_5cat = "1" if race_5cat == "White"
replace race_5cat = "2" if race_5cat == "Black"
replace race_5cat = "3" if race_5cat == "Hispanic"
replace race_5cat = "4" if race_5cat == "Asian"
replace race_5cat = "5" if race_5cat == "Other"
destring race_5cat, generate(race_5cat_new)

** Now I can carry out the logistic regression
svy : logit b3_new i.nd2_new i.b7_b_new i.gh1_new i.ppeducat_new i.race_5cat_new

//
// Survey: Logistic regression
//
// Number of strata =      1                        Number of obs   =      11,667
// Number of PSUs   = 11,667                        Population size = 255,114,223
//                                                  Design df       =      11,666
//                                                  F(17, 11650)    =       56.70
//                                                  Prob > F        =      0.0000
//
// -------------------------------------------------------------------------------
//               |             Linearized
//        b3_new | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
// --------------+----------------------------------------------------------------
//       nd2_new |
//            2  |   .0816722   .0925755     0.88   0.378    -.0997913    .2631356
//            3  |   .0618535   .0854686     0.72   0.469    -.1056792    .2293863
//            4  |   .2533888   .2045978     1.24   0.216    -.1476572    .6544347
//            5  |    .229354   .1672799     1.37   0.170    -.0985426    .5572505
//               |
//      b7_b_new |
//            2  |   1.110649   .0488662    22.73   0.000     1.014863    1.206435
//            3  |   1.806251   .0796863    22.67   0.000     1.650052    1.962449
//            4  |   2.485125   .3463415     7.18   0.000     1.806238    3.164013
//               |
//       gh1_new |
//            2  |  -.0702921    .056382    -1.25   0.213    -.1808102     .040226
//            3  |   .0190607   .0587346     0.32   0.746    -.0960689    .1341904
//            4  |   .3465325   .0994184     3.49   0.000     .1516557    .5414092
//               |
//  ppeducat_new |
//            2  |   .0767668   .1036364     0.74   0.459    -.1263778    .2799115
//            3  |   .1075004   .1008067     1.07   0.286    -.0900975    .3050983
//            4  |   .2288346    .099574     2.30   0.022     .0336528    .4240164
//               |
// race_5cat_new |
//            2  |   .7060141   .0810818     8.71   0.000     .5470803     .864948
//            3  |   .1635498   .0711263     2.30   0.021     .0241303    .3029693
//            4  |   .4567994   .1259942     3.63   0.000     .2098298    .7037691
//            5  |  -.0210142   .1659436    -0.13   0.899    -.3462915    .3042631
//               |
//         _cons |  -.4852955   .1301287    -3.73   0.000    -.7403696   -.2302214




** Answer: after the logistic regression, we fail to reject H_0 and we may conclude that the factor nd2_new(thinking that the chance of experiencing a natural disaster or severe weather event will be higher, lower or about the same in 5 years.) is not statistical significant by looking at those P-values, and we may remove this predictor. 



* Then I will save the data I revised and then move the data to R *
restore