clear
import delimited "C:\Users\Lenovo\Downloads\cars (1).csv" 

* Part(a): Raname the columes of the data
rename dimensionsheight dimH
rename dimensionslength dimL
rename dimensionswidth  dimW
rename engineinformationdriveline edrive
rename engineinformationenginetype etype
rename engineinformationhybrid ehybrid
rename engineinformationnumberofforward efor
rename engineinformationtransmission etrans
rename fuelinformationcitympg cmpg
rename fuelinformationfueltype ftype
rename fuelinformationhighwaympg hmpg
rename identificationclassification ic
rename identificationid iid
rename identificationmake imake
rename identificationmodelyear iyear
rename engineinformationenginestatistic ehorse
rename v18 etor
rename identificationyear Ipubyear

* Part(b): Retrict data to cars whose fule Type is Gasoline
keep if ftype == "Gasoline"

* Part(c):
* We first do regression hmpg and horsepower
regress hmpg ehorse

// ```stata
// . regress hmpg ehorse
//
//       Source |       SS           df       MS      Number of obs   =     4,591
// -------------+----------------------------------   F(1, 4589)      =   2059.91
//        Model |  51769.1357         1  51769.1357   Prob > F        =    0.0000
//     Residual |  115329.832     4,589  25.1318004   R-squared       =    0.3098
// -------------+----------------------------------   Adj R-squared   =    0.3097
//        Total |  167098.968     4,590  36.4050038   Root MSE        =    5.0132
//
// ------------------------------------------------------------------------------
//         hmpg | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
// -------------+----------------------------------------------------------------
//       ehorse |  -.0344689   .0007595   -45.39   0.000    -.0359578     -.03298
//        _cons |   34.18615   .2161842   158.13   0.000     33.76232    34.60997
// ------------------------------------------------------------------------------

// Answer : If we only contain the variable of horsepower, basically our conclusion will be with one more unit horsepower, the highway mpg will decrease by 0.034 averagely, and it seems the coefficient is statistically significant.


*We then do regression hmpg, horsepower, torque
regress hmpg ehorse etor

//       Source |       SS           df       MS      Number of obs   =     4,591
// -------------+----------------------------------   F(2, 4588)      =   1502.69
//        Model |   66136.072         2   33068.036   Prob > F        =    0.0000
//     Residual |  100962.896     4,588  22.0058622   R-squared       =    0.3958
// -------------+----------------------------------   Adj R-squared   =    0.3955
//        Total |  167098.968     4,590  36.4050038   Root MSE        =     4.691
//
// ------------------------------------------------------------------------------
//         hmpg | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
// -------------+----------------------------------------------------------------
//       ehorse |   .0193318   .0022223     8.70   0.000     .0149751    .0236886
//         etor |  -.0545998   .0021369   -25.55   0.000    -.0587891   -.0504105
//        _cons |   34.38641    .202445   169.86   0.000     33.98952     34.7833
// ------------------------------------------------------------------------------

//Answer: Now if we contain the variable of torque, then coefficient of horsepower would be explained as: fix torque, one more unit of horsepower will increase the mpg by 0.019 averagely, and the coefficient is statistically significant.

regress hmpg ehorse dimH dimL dimW
//
//       Source |       SS           df       MS      Number of obs   =     4,591
// -------------+----------------------------------   F(4, 4586)      =    575.69
//        Model |  55857.3173         4  13964.3293   Prob > F        =    0.0000
//     Residual |   111241.65     4,586  24.2567925   R-squared       =    0.3343
// -------------+----------------------------------   Adj R-squared   =    0.3337
//        Total |  167098.968     4,590  36.4050038   Root MSE        =    4.9251
//
// ------------------------------------------------------------------------------
//         hmpg | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
// -------------+----------------------------------------------------------------
//       ehorse |  -.0334608   .0007537   -44.39   0.000    -.0349385   -.0319832
//         dimH |   .0115352   .0011995     9.62   0.000     .0091836    .0138867
//         dimL |   .0008645   .0009439     0.92   0.360    -.0009859     .002715
//         dimW |  -.0062758   .0009286    -6.76   0.000    -.0080964   -.0044553
//        _cons |   32.97479   .3514685    93.82   0.000     32.28574    33.66383
// ------------------------------------------------------------------------------

// Now if we contain the variable of all three dimensions, then coefficient of horsepower would be explained as: fix other variables, one more unit of horsepower will decrease the mpg by 0.0334 averagely, and the coefficient is statistically significant. Since the length seems statistically insignificant, we will remove it in the future.


regress hmpg ehorse i.Ipubyear
//
//       Source |       SS           df       MS      Number of obs   =     4,591
// -------------+----------------------------------   F(4, 4586)      =    560.86
//        Model |  54891.4902         4  13722.8726   Prob > F        =    0.0000
//     Residual |  112207.477     4,586  24.4673958   R-squared       =    0.3285
// -------------+----------------------------------   Adj R-squared   =    0.3279
//        Total |  167098.968     4,590  36.4050038   Root MSE        =    4.9465
//
// ------------------------------------------------------------------------------
//         hmpg | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
// -------------+----------------------------------------------------------------
//       ehorse |  -.0344725   .0007504   -45.94   0.000    -.0359437   -.0330013
//              |
//     Ipubyear |
//        2010  |  -.4340551   .7244638    -0.60   0.549    -1.854353    .9862428
//        2011  |   .1849839   .7234525     0.26   0.798    -1.233331    1.603299
//        2012  |   1.710272   .7292147     2.35   0.019     .2806602    3.139884
//              |
//        _cons |   33.85348   .7436835    45.52   0.000     32.39551    35.31146
// ------------------------------------------------------------------------------

// Now if we contain the variable of year of car released, then coefficient of horsepower would be explained as: fix other variables, one more unit of horsepower will decrease the mpg by 0.0344 averagely, and the coefficient is statistically significant. Since new variables seems statistically insignificant, we will also remove it in the future.

regress hmpg ehorse dimH dimW etor
//
//       Source |       SS           df       MS      Number of obs   =     4,591
// -------------+----------------------------------   F(4, 4586)      =    785.78
//        Model |  67952.5223         4  16988.1306   Prob > F        =    0.0000
//     Residual |  99146.4453     4,586  21.6193732   R-squared       =    0.4067
// -------------+----------------------------------   Adj R-squared   =    0.4061
//        Total |  167098.968     4,590  36.4050038   Root MSE        =    4.6497
//
// ------------------------------------------------------------------------------
//         hmpg | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
// -------------+----------------------------------------------------------------
//       ehorse |   .0181316    .002292     7.91   0.000     .0136382     .022625
//         dimH |   .0101964   .0011316     9.01   0.000      .007978    .0124147
//         dimW |  -.0002471   .0009126    -0.27   0.787    -.0020362     .001542
//         etor |  -.0524688   .0022164   -23.67   0.000     -.056814   -.0481235
//        _cons |   32.66571   .3180634   102.70   0.000     32.04215    33.28926
// ------------------------------------------------------------------------------

// Now if we contain the other 3 variables, then coefficient of horsepower would be explained as: fix other variables, one more unit of horsepower will increase the mpg by 0.0181 averagely, and the coefficient is statistically significant. Since variable D_wid seems statistically insignificant, we will remove it in the future.

regress hmpg ehorse dimH etor

//       Source |       SS           df       MS      Number of obs   =     4,591
// -------------+----------------------------------   F(3, 4587)      =   1047.90
//        Model |  67950.9372         3  22650.3124   Prob > F        =    0.0000
//     Residual |  99148.0303     4,587  21.6150055   R-squared       =    0.4067
// -------------+----------------------------------   Adj R-squared   =    0.4063
//        Total |  167098.968     4,590  36.4050038   Root MSE        =    4.6492
//
// ------------------------------------------------------------------------------
//         hmpg | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
// -------------+----------------------------------------------------------------
//       ehorse |   .0183004   .0022053     8.30   0.000     .0139769     .022624
//         dimH |   .0102436   .0011179     9.16   0.000     .0080519    .0124352
//         etor |  -.0526358   .0021286   -24.73   0.000    -.0568089   -.0484627
//        _cons |   32.62385   .2779493   117.37   0.000     32.07894    33.16877
// ------------------------------------------------------------------------------

// Now if we contain the other 2 variables, then coefficient of horsepower would be explained as: fix other variables, one more unit of horsepower will increase the mpg by 0.0183 averagely, and the coefficient is statistically significant.
//
// General conclusion: I think according common sense, higher horsepower should give us higher highway mpg, and after we removed some unnecessary variables(coefficient that is not statistically significant), the summary of last regression modelroughly tell us that given other variables unchanged, the one more unit of horsepower will increase the highway mpg 0.018 averagely. But in fact we still need to do more work to judge the causal effect since we don't know if there are some dependency between different variables, and the R-squared we get in each model is not big enough to help us conclude if the model fit our data well.


* part(d) 
preserve
keep if etor == 235 | etor == 236 | etor == 350
regress ehorse c.hmpg##i.etor

//       Source |       SS           df       MS      Number of obs   =       172
// -------------+----------------------------------   F(5, 166)       =    596.33
//        Model |   259143.16         5   51828.632   Prob > F        =    0.0000
//     Residual |  14427.5086       166  86.9127025   R-squared       =    0.9473
// -------------+----------------------------------   Adj R-squared   =    0.9457
//        Total |  273570.669       171  1599.82847   Root MSE        =    9.3227
//
// ------------------------------------------------------------------------------
//       ehorse | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
// -------------+----------------------------------------------------------------
//         hmpg |    .836542   .8048081     1.04   0.300    -.7524371    2.425521
//              |
//         etor |
//         236  |   149.8457   18.12717     8.27   0.000     114.0562    185.6352
//         350  |  -140.5092    18.7978    -7.47   0.000    -177.6228   -103.3956
//              |
//  etor#c.hmpg |
//         236  |  -5.036691    .847222    -5.94   0.000     -6.70941   -3.363972
//         350  |   12.41673   .9289043    13.37   0.000     10.58274    14.25072
//              |
//        _cons |   193.5033   16.63605    11.63   0.000     160.6578    226.3488
// ------------------------------------------------------------------------------

margin i.etor, at(c.hmpg = (20(1)40))
marginsplot


* I don't know how to insert a graph to this do-file, so I will attach this graph seperately on Canvas.






restore