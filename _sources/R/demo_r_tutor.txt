Elementary Statistics with R
""""""""""""""""""""""""""""
The source R script available :download:`here <demo_r_tutor.Rmd>`

.. include:: /table-template-knitr.rst

.. contents:: `Contents`
    :depth: 2
    :local:

**Personal notes. Reference: r-tutor**
http://www.r-tutor.com/elementary-statistics

.. code-block:: R

    #library(MASS)
    library(dplyr)
    library(xtable)

    print_table <- function(df,n=6){
      print(xtable::xtable(head(df,n=n)), type='html')
    }

Categorical Data
================

http://www.r-tutor.com/elementary-statistics/qualitative-data

.. code-block:: R

    #https://blog.rstudio.org/2016/03/24/tibble-1-0-0/
    painters <- dplyr::as_data_frame(MASS::painters)
    dim(painters)

::

    ## [1] 54  5

.. code-block:: R

    head(painters)

::

    ## # A tibble: 6 × 5
    ##   Composition Drawing Colour Expression School
    ##         <int>   <int>  <int>      <int> <fctr>
    ## 1          10       8     16          3      A
    ## 2          15      16      4         14      A
    ## 3           8      13     16          7      A
    ## 4          12      16      9          8      A
    ## 5           0      15      8          0      A
    ## 6          15      16      4         14      A

.. code-block:: R

    print_table(painters)

.. raw:: html

   <!-- html table generated in R 3.3.1 by xtable 1.8-2 package -->

.. raw:: html

   <!-- Thu Nov 17 01:00:10 2016 -->

.. raw:: html

   <table border="1">

.. raw:: html

   <tr>

.. raw:: html

   <th>

.. raw:: html

   </th>

.. raw:: html

   <th>

Composition

.. raw:: html

   </th>

.. raw:: html

   <th>

Drawing

.. raw:: html

   </th>

.. raw:: html

   <th>

Colour

.. raw:: html

   </th>

.. raw:: html

   <th>

Expression

.. raw:: html

   </th>

.. raw:: html

   <th>

School

.. raw:: html

   </th>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

1

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

10

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

8

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

16

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

3

.. raw:: html

   </td>

.. raw:: html

   <td>

A

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

2

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

15

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

16

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

14

.. raw:: html

   </td>

.. raw:: html

   <td>

A

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

3

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

8

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

13

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

16

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

7

.. raw:: html

   </td>

.. raw:: html

   <td>

A

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

4

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

12

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

16

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

9

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

8

.. raw:: html

   </td>

.. raw:: html

   <td>

A

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

5

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

0

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

15

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

8

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

0

.. raw:: html

   </td>

.. raw:: html

   <td>

A

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

6

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

15

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

16

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

14

.. raw:: html

   </td>

.. raw:: html

   <td>

A

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   </table>

Get frequency counts using table
--------------------------------

.. code-block:: R

    school = painters$School    
    school

::

    ##  [1] A A A A A A A A A A B B B B B B C C C C C C D D D D D D D D D D E E E
    ## [36] E E E E F F F F G G G G G G G H H H H
    ## Levels: A B C D E F G H

.. code-block:: R

    as.numeric(school)

::

    ##  [1] 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 5 5 5
    ## [36] 5 5 5 5 6 6 6 6 7 7 7 7 7 7 7 8 8 8 8

.. code-block:: R

    # apply table function to get counts
    school.freq = table(school)
    school.freq

::

    ## school
    ##  A  B  C  D  E  F  G  H 
    ## 10  6  6 10  7  4  7  4

.. code-block:: R

    # use cbind to print vertically
    cbind(school.freq)

::

    ##   school.freq
    ## A          10
    ## B           6
    ## C           6
    ## D          10
    ## E           7
    ## F           4
    ## G           7
    ## H           4

.. code-block:: R

    # convert to relative frequency distribution
    default_options = options()
    school.relfreq <- school.freq / nrow(painters) 
    cbind(school.relfreq)

::

    ##   school.relfreq
    ## A     0.18518519
    ## B     0.11111111
    ## C     0.11111111
    ## D     0.18518519
    ## E     0.12962963
    ## F     0.07407407
    ## G     0.12962963
    ## H     0.07407407

.. code-block:: R

    # change digit output
    options(digits=1)
    school.relfreq

::

    ## school
    ##    A    B    C    D    E    F    G    H 
    ## 0.19 0.11 0.11 0.19 0.13 0.07 0.13 0.07

.. code-block:: R

    # reset options
    options(default_options)

Plot as bar/pie charts
----------------------

.. code-block:: R

    par(mfrow=c(1,3))
    barplot(school.freq)
    barplot(school.relfreq)
    colors = c("red", "yellow", "green", "violet", "orange", "blue", "pink", "cyan") 
    barplot(school.freq,col=colors)

|image0|\ 

.. code-block:: R

    # pie char
    par(mfrow=c(1,2))
    pie(school.freq)              
    pie(school.freq,col=colors) 

|image1|\ 

Quantitative Data
=================

http://www.r-tutor.com/elementary-statistics/quantitative-data

.. code-block:: R

    #https://blog.rstudio.org/2016/03/24/tibble-1-0-0/
    faithful <- dplyr::as_data_frame(faithful)
    dim(faithful)

::

    ## [1] 272   2

.. code-block:: R

    head(faithful)

::

    ## # A tibble: 6 × 2
    ##   eruptions waiting
    ##       <dbl>   <dbl>
    ## 1     3.600      79
    ## 2     1.800      54
    ## 3     3.333      74
    ## 4     2.283      62
    ## 5     4.533      85
    ## 6     2.883      55

.. code-block:: R

    print_table(faithful)

.. raw:: html

   <!-- html table generated in R 3.3.1 by xtable 1.8-2 package -->

.. raw:: html

   <!-- Thu Nov 17 01:00:10 2016 -->

.. raw:: html

   <table border="1">

.. raw:: html

   <tr>

.. raw:: html

   <th>

.. raw:: html

   </th>

.. raw:: html

   <th>

eruptions

.. raw:: html

   </th>

.. raw:: html

   <th>

waiting

.. raw:: html

   </th>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

1

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

3.60

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

79.00

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

2

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

1.80

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

54.00

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

3

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

3.33

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

74.00

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

4

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

2.28

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

62.00

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

5

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.53

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

85.00

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

6

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

2.88

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

55.00

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   </table>

.. code-block:: R

    duration <- faithful$eruptions
    range(duration) # min/max

::

    ## [1] 1.6 5.1

.. code-block:: R

    breaks = seq(1.5, 5.5, by=0.5)    # half-integer sequence 
    breaks

::

    ## [1] 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5

Discretize with cut
-------------------

-  cut divides the range of x into intervals and codes the values in x
   according to which interval they fall.
-  The leftmost interval corresponds to level one, the next leftmost to
   level two and so on.

.. code-block:: R

    duration.cut = cut(duration, breaks, right=FALSE) 
    duration.cut[1:5]

::

    ## [1] [3.5,4) [1.5,2) [3,3.5) [2,2.5) [4.5,5)
    ## 8 Levels: [1.5,2) [2,2.5) [2.5,3) [3,3.5) [3.5,4) [4,4.5) ... [5,5.5)

.. code-block:: R

    # now we can apply the table technique to get frequency counts
    duration.freq = table(duration.cut) 
    duration.relfreq = table(duration.cut) / length(duration.cut)

    # add cdf
    duration.cumfreq = cumsum(duration.freq)
    duration.cumrelfreq = duration.cumfreq / nrow(faithful) 


    cbind(duration.freq, duration.relfreq,duration.cumfreq,duration.cumrelfreq) 

::

    ##         duration.freq duration.relfreq duration.cumfreq
    ## [1.5,2)            51       0.18750000               51
    ## [2,2.5)            41       0.15073529               92
    ## [2.5,3)             5       0.01838235               97
    ## [3,3.5)             7       0.02573529              104
    ## [3.5,4)            30       0.11029412              134
    ## [4,4.5)            73       0.26838235              207
    ## [4.5,5)            61       0.22426471              268
    ## [5,5.5)             4       0.01470588              272
    ##         duration.cumrelfreq
    ## [1.5,2)           0.1875000
    ## [2,2.5)           0.3382353
    ## [2.5,3)           0.3566176
    ## [3,3.5)           0.3823529
    ## [3.5,4)           0.4926471
    ## [4,4.5)           0.7610294
    ## [4.5,5)           0.9852941
    ## [5,5.5)           1.0000000

.. code-block:: R

    duration_df <- data.frame(cbind(duration.freq, 
                                    duration.relfreq,
                                    duration.cumfreq,
                                    duration.cumrelfreq ) )
    duration_df

::

    ##         duration.freq duration.relfreq duration.cumfreq
    ## [1.5,2)            51       0.18750000               51
    ## [2,2.5)            41       0.15073529               92
    ## [2.5,3)             5       0.01838235               97
    ## [3,3.5)             7       0.02573529              104
    ## [3.5,4)            30       0.11029412              134
    ## [4,4.5)            73       0.26838235              207
    ## [4.5,5)            61       0.22426471              268
    ## [5,5.5)             4       0.01470588              272
    ##         duration.cumrelfreq
    ## [1.5,2)           0.1875000
    ## [2,2.5)           0.3382353
    ## [2.5,3)           0.3566176
    ## [3,3.5)           0.3823529
    ## [3.5,4)           0.4926471
    ## [4,4.5)           0.7610294
    ## [4.5,5)           0.9852941
    ## [5,5.5)           1.0000000

.. code-block:: R

    colnames <- names(duration_df) <- c('freq','relfreq','cumfreq','duration.cumrelfreq')
    duration_df

::

    ##         freq    relfreq cumfreq duration.cumrelfreq
    ## [1.5,2)   51 0.18750000      51           0.1875000
    ## [2,2.5)   41 0.15073529      92           0.3382353
    ## [2.5,3)    5 0.01838235      97           0.3566176
    ## [3,3.5)    7 0.02573529     104           0.3823529
    ## [3.5,4)   30 0.11029412     134           0.4926471
    ## [4,4.5)   73 0.26838235     207           0.7610294
    ## [4.5,5)   61 0.22426471     268           0.9852941
    ## [5,5.5)    4 0.01470588     272           1.0000000

.. code-block:: R

    # convert to dataframe
    # duration_df <- data.frame( freq = as.vector(duration.freq),
    #                            relfreq = as.vector(duration.relfreq),
    #                            row.names = row.names(duration.freq))
    # duration_df <- as_data_frame(duration_df)
    # duration_df

Plotting
--------

.. code-block:: R

    par(mfrow=c(1,3))
    hist(duration)
    hist(duration,right=FALSE) # intervals closed on the left

    # more styles
    hist(duration,
         col=colors,
         main="Old Faithful eruptions", # title text
         xlab = "Duration minutes") # xaxis label

|image2|\ 

.. code-block:: R

    par(mfrow=c(1,2))
    cumfreq0 = c(0, cumsum(duration.freq)) 
    cumfreq0

::

    ##         [1.5,2) [2,2.5) [2.5,3) [3,3.5) [3.5,4) [4,4.5) [4.5,5) [5,5.5) 
    ##       0      51      92      97     104     134     207     268     272

.. code-block:: R

    plot(breaks, cumfreq0, main = "Old Faithful eruptions", 
         xlab="duration minutes",ylab = "cumulative eruptions")
    lines(breaks,cumfreq0) # connect the dots

    # alternatively, create an interpolation funcion Fn using ecdf
    # ecdf: Compute an empirical cumulative distribution function
    Fn = ecdf(duration) 
    plot(Fn, main="Old Faithful Eruptions", xlab="Duration minutes", 
        ylab="Cumulative eruption proportion") 

|image3|\ 

.. code-block:: R

    # stem and leaf plot
    stem(duration) 

::

    ## 
    ##   The decimal point is 1 digit(s) to the left of the |
    ## 
    ##   16 | 070355555588
    ##   18 | 000022233333335577777777888822335777888
    ##   20 | 00002223378800035778
    ##   22 | 0002335578023578
    ##   24 | 00228
    ##   26 | 23
    ##   28 | 080
    ##   30 | 7
    ##   32 | 2337
    ##   34 | 250077
    ##   36 | 0000823577
    ##   38 | 2333335582225577
    ##   40 | 0000003357788888002233555577778
    ##   42 | 03335555778800233333555577778
    ##   44 | 02222335557780000000023333357778888
    ##   46 | 0000233357700000023578
    ##   48 | 00000022335800333
    ##   50 | 0370

.. code-block:: R

    # scatter plot
    plot(faithful$eruptions, faithful$waiting,            # plot the variables 
          xlab="Eruption duration",        # x−axis label 
          ylab="Time waited")              # y−axis label 

    # enhanced solution
    # (abline: Add Straight Lines to a Plot)
    plot(faithful$eruptions, faithful$waiting,            # plot the variables 
          xlab="Eruption duration",        # x−axis label 
          ylab="Time waited")              # y−axis label 
    # abline(lm( faithful$waiting ~ faithful$eruptions))
    abline(lm( waiting ~ eruptions, data=faithful))

|image4|\ 

Basic statistics
================

http://www.r-tutor.com/elementary-statistics/numerical-measures

Scalar statistics
-----------------

.. code-block:: R

    head(faithful)

::

    ## # A tibble: 6 × 2
    ##   eruptions waiting
    ##       <dbl>   <dbl>
    ## 1     3.600      79
    ## 2     1.800      54
    ## 3     3.333      74
    ## 4     2.283      62
    ## 5     4.533      85
    ## 6     2.883      55

.. code-block:: R

    # === mean, median, sd, var,range, iqr ===
    mean(duration)

::

    ## [1] 3.487783

.. code-block:: R

    median(duration)

::

    ## [1] 4

.. code-block:: R

    sd(duration)

::

    ## [1] 1.141371

.. code-block:: R

    var(duration)

::

    ## [1] 1.302728

.. code-block:: R

    range(duration) # max - min

::

    ## [1] 1.6 5.1

.. code-block:: R

    IQR(duration) # max - min

::

    ## [1] 2.2915

.. code-block:: R

    # repeat using dataframes
    faithful %>% apply(2,mean)

::

    ## eruptions   waiting 
    ##  3.487783 70.897059

.. code-block:: R

    faithful %>% summarise(mean(eruptions),mean(waiting))

::

    ## # A tibble: 1 × 2
    ##   `mean(eruptions)` `mean(waiting)`
    ##               <dbl>           <dbl>
    ## 1          3.487783        70.89706

.. code-block:: R

    # above is tedious if you want to apply same func to all cols....
    # but we can use summarise_each
    # http://stackoverflow.com/questions/21644848/summarizing-multiple-columns-with-dplyr
    # http://stackoverflow.com/questions/21295936/can-dplyr-summarise-over-several-variables-without-listing-each-one
    faithful %>% summarise_each(funs(mean,median,sd,var,IQR)) %>% t()

::

    ##                        [,1]
    ## eruptions_mean     3.487783
    ## waiting_mean      70.897059
    ## eruptions_median   4.000000
    ## waiting_median    76.000000
    ## eruptions_sd       1.141371
    ## waiting_sd        13.594974
    ## eruptions_var      1.302728
    ## waiting_var      184.823312
    ## eruptions_IQR      2.291500
    ## waiting_IQR       24.000000

Quantiles, covariance, correlation
----------------------------------

.. code-block:: R

    # ===  quantiles  ===
    quantile(duration)

::

    ##      0%     25%     50%     75%    100% 
    ## 1.60000 2.16275 4.00000 4.45425 5.10000

.. code-block:: R

    quantiles <- rbind(quantile(faithful$eruptions),quantile(faithful$waiting))
    quantiles

::

    ##        0%      25% 50%      75% 100%
    ## [1,]  1.6  2.16275   4  4.45425  5.1
    ## [2,] 43.0 58.00000  76 82.00000 96.0

.. code-block:: R

    row.names(quantiles) <- c('duration','waiting')
    quantiles

::

    ##            0%      25% 50%      75% 100%
    ## duration  1.6  2.16275   4  4.45425  5.1
    ## waiting  43.0 58.00000  76 82.00000 96.0

.. code-block:: R

    # data frame approach?
    # - use lapply
    #http://stackoverflow.com/questions/17020293/quantiles-of-a-data-frame
    lapply(faithful, quantile)

::

    ## $eruptions
    ##      0%     25%     50%     75%    100% 
    ## 1.60000 2.16275 4.00000 4.45425 5.10000 
    ## 
    ## $waiting
    ##   0%  25%  50%  75% 100% 
    ##   43   58   76   82   96

.. code-block:: R

    as.data.frame(lapply(faithful, quantile))

::

    ##      eruptions waiting
    ## 0%     1.60000      43
    ## 25%    2.16275      58
    ## 50%    4.00000      76
    ## 75%    4.45425      82
    ## 100%   5.10000      96

.. code-block:: R

    # === covariance ===
    # covariance value
    cov(faithful$eruptions,faithful$waiting)

::

    ## [1] 13.97781

.. code-block:: R

    # correlation value
    cor(faithful$eruptions,faithful$waiting)

::

    ## [1] 0.9008112

.. code-block:: R

    # covariance matrix
    cov(faithful)

::

    ##           eruptions   waiting
    ## eruptions  1.302728  13.97781
    ## waiting   13.977808 184.82331

.. code-block:: R

    # correlation matrix
    cor(faithful)

::

    ##           eruptions   waiting
    ## eruptions 1.0000000 0.9008112
    ## waiting   0.9008112 1.0000000

Higher order moments, skewness, kurtosis
----------------------------------------

.. code-block:: R

    # 3rd order moment
    e1071::moment(duration, order=3, center=TRUE) 

::

    ## [1] -0.6149059

.. code-block:: R

    e1071::skewness(duration) 

::

    ## [1] -0.4135498

.. code-block:: R

    e1071::kurtosis(duration) 

::

    ## [1] -1.511605

(incomp) Probability Distributions
==================================

http://www.r-tutor.com/elementary-statistics/probability-distributions

(incomp) Interval estimation
============================

http://www.r-tutor.com/elementary-statistics/interval-estimation

(incomp) Hypothesis testing
===========================

http://www.r-tutor.com/elementary-statistics/hypothesis-testing

(incomp) Type-II Errors
=======================

http://www.r-tutor.com/elementary-statistics/type-2-errors

(incomp) Inference about two populatiosnr
=========================================

http://www.r-tutor.com/elementary-statistics/inference-about-two-populations

(incomp) Goodness of Fit
========================

http://www.r-tutor.com/elementary-statistics/goodness-fit

(incomp) Probability distributions
==================================

http://www.r-tutor.com/elementary-statistics/probability-distributions

(incomp) ANOVA
==============

http://www.r-tutor.com/elementary-statistics/analysis-variance

(incomp) Nonparametric methods
==============================

http://www.r-tutor.com/elementary-statistics/non-parametric-methods

Simple Linear Regression
========================

http://www.r-tutor.com/elementary-statistics/simple-linear-regression

.. code-block:: R

    eruption.lm = lm(eruptions ~ waiting, data=faithful) 
    eruption.lm

::

    ## 
    ## Call:
    ## lm(formula = eruptions ~ waiting, data = faithful)
    ## 
    ## Coefficients:
    ## (Intercept)      waiting  
    ##    -1.87402      0.07563

.. code-block:: R

    ls.str(summary(eruption.lm))

::

    ## adj.r.squared :  num 0.811
    ## aliased :  Named logi [1:2] FALSE FALSE
    ## call :  language lm(formula = eruptions ~ waiting, data = faithful)
    ## coefficients :  num [1:2, 1:4] -1.87402 0.07563 0.16014 0.00222 -11.70212 ...
    ## cov.unscaled :  num [1:2, 1:2] 0.10403 -0.00142 -0.00142 0.00002
    ## df :  int [1:3] 2 270 2
    ## fstatistic :  Named num [1:3] 1162 1 270
    ## r.squared :  num 0.811
    ## residuals :  Named num [1:272] -0.5006 -0.4099 -0.3895 -0.5319 -0.0214 ...
    ## sigma :  num 0.497
    ## terms : Classes 'terms', 'formula'  language eruptions ~ waiting

.. code-block:: R

    summary(eruption.lm)

::

    ## 
    ## Call:
    ## lm(formula = eruptions ~ waiting, data = faithful)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -1.29917 -0.37689  0.03508  0.34909  1.19329 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) -1.874016   0.160143  -11.70   <2e-16 ***
    ## waiting      0.075628   0.002219   34.09   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.4965 on 270 degrees of freedom
    ## Multiple R-squared:  0.8115, Adjusted R-squared:  0.8108 
    ## F-statistic:  1162 on 1 and 270 DF,  p-value: < 2.2e-16

.. code-block:: R

    # get coefficients
    coeffs = coefficients(eruption.lm)
    coeffs

::

    ## (Intercept)     waiting 
    ## -1.87401599  0.07562795

.. code-block:: R

    class(coeffs)

::

    ## [1] "numeric"

.. code-block:: R

    # prediction at test point
    predict(eruption.lm, data.frame(waiting=40))

::

    ##        1 
    ## 1.151102

.. code-block:: R

    predict(eruption.lm, data.frame(waiting=80))

::

    ##       1 
    ## 4.17622

.. code-block:: R

    # coefficient of determination
    summary(eruption.lm)$r.squared

::

    ## [1] 0.8114608

.. code-block:: R

    #Further detail of the summary function for linear regression model
    help(summary.lm)

Significance test and confidence interval for linear regression
---------------------------------------------------------------

.. code-block:: R

    # see coefficients and f-stast
    summary(eruption.lm)

::

    ## 
    ## Call:
    ## lm(formula = eruptions ~ waiting, data = faithful)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -1.29917 -0.37689  0.03508  0.34909  1.19329 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) -1.874016   0.160143  -11.70   <2e-16 ***
    ## waiting      0.075628   0.002219   34.09   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.4965 on 270 degrees of freedom
    ## Multiple R-squared:  0.8115, Adjusted R-squared:  0.8108 
    ## F-statistic:  1162 on 1 and 270 DF,  p-value: < 2.2e-16

.. code-block:: R

    # test point and confidence interval (95%)
    newdata <- data.frame(waiting=80)

    # === prediction vs confidence ===
    #http://stats.stackexchange.com/questions/16493/difference-between-confidence-intervals-and-prediction-intervals
    #https://www.r-bloggers.com/the-uncertainty-of-predictions/
    predict(eruption.lm, newdata, interval="confidence") 

::

    ##       fit      lwr      upr
    ## 1 4.17622 4.104848 4.247592

.. code-block:: R

    predict(eruption.lm, newdata, interval="prediction") 

::

    ##       fit      lwr      upr
    ## 1 4.17622 3.196089 5.156351

.. code-block:: R

    # Further detail of the predict function for linear regression model
    help(predict.lm)

Residual analysis
-----------------

.. math:: \text{residual} = y - \hat{y}

 The **standardized residual** is the residual divided by its standard
deviation.

.. math:: \text{standardized residual } i = \frac{\text{residual } i}{\text{std-dev of resid } i}

.. code-block:: R

    # residual
    eruption.res = resid(eruption.lm) 

    # plot residual against observed values
    par(mfrow=c(1,3))
    plot(faithful$waiting, eruption.res, 
         ylab="Residuals", xlab="Waiting Time", 
         main="Old Faithful Eruptions") 
    abline(0, 0)                  # the horizon 

    # standardized residual
    eruption.stdres = rstandard(eruption.lm) 
    plot(faithful$waiting, eruption.stdres, 
         ylab="Standardized Residuals", xlab="Waiting Time", 
         main="Old Faithful Eruptions") 
    abline(0, 0)                  # the horizon 

    # check normality of residual via qqplot
    qqnorm(eruption.stdres, 
       ylab="Standardized Residuals", 
       xlab="Normal Scores", 
       main="Old Faithful Eruptions") 
    qqline(eruption.stdres) 

|image5|\ 

(incomp) Multiple linear regression
===================================

http://www.r-tutor.com/elementary-statistics/multiple-linear-regression

Logistic regression
===================

http://www.r-tutor.com/elementary-statistics/logistic-regression

glm
---

.. code-block:: R

    mtcars <- as_data_frame(mtcars)
    head(mtcars)

::

    ## # A tibble: 6 × 11
    ##     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
    ##   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    ## 1  21.0     6   160   110  3.90 2.620 16.46     0     1     4     4
    ## 2  21.0     6   160   110  3.90 2.875 17.02     0     1     4     4
    ## 3  22.8     4   108    93  3.85 2.320 18.61     1     1     4     1
    ## 4  21.4     6   258   110  3.08 3.215 19.44     1     0     3     1
    ## 5  18.7     8   360   175  3.15 3.440 17.02     0     0     3     2
    ## 6  18.1     6   225   105  2.76 3.460 20.22     1     0     3     1

.. code-block:: R

    am.glm = glm(formula=am ~ hp + wt, data=mtcars, family=binomial) 

    newdata = data.frame(hp=120, wt=2.8) 

    help(predict.glm)

    # default - scale of linear predictors (prob on logit scale)
    predict(am.glm, newdata, type= 'link')    

::

    ##         1 
    ## 0.5832397

.. code-block:: R

    # scale of response variable (predicted probability)
    predict(am.glm, newdata, type='response') 

::

    ##         1 
    ## 0.6418125

.. code-block:: R

    predict(am.glm, newdata, type='terms') 

::

    ##           hp      wt
    ## 1 -0.9675712 3.37283
    ## attr(,"constant")
    ## [1] -1.822019

Significance test for glm
-------------------------

http://www.r-tutor.com/elementary-statistics/logistic-regression/significance-test-logistic-regression

.. code-block:: R

    summary(am.glm) 

::

    ## 
    ## Call:
    ## glm(formula = am ~ hp + wt, family = binomial, data = mtcars)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.2537  -0.1568  -0.0168   0.1543   1.3449  
    ## 
    ## Coefficients:
    ##             Estimate Std. Error z value Pr(>|z|)   
    ## (Intercept) 18.86630    7.44356   2.535  0.01126 * 
    ## hp           0.03626    0.01773   2.044  0.04091 * 
    ## wt          -8.08348    3.06868  -2.634  0.00843 **
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 43.230  on 31  degrees of freedom
    ## Residual deviance: 10.059  on 29  degrees of freedom
    ## AIC: 16.059
    ## 
    ## Number of Fisher Scoring iterations: 8

.. code-block:: R

    help("summary.glm")

.. |image0| image:: demo_r_tutor_files/figure-html/unnamed-chunk-5-1.png
.. |image1| image:: demo_r_tutor_files/figure-html/unnamed-chunk-5-2.png
.. |image2| image:: demo_r_tutor_files/figure-html/unnamed-chunk-10-1.png
.. |image3| image:: demo_r_tutor_files/figure-html/unnamed-chunk-10-2.png
.. |image4| image:: demo_r_tutor_files/figure-html/unnamed-chunk-10-3.png
.. |image5| image:: demo_r_tutor_files/figure-html/unnamed-chunk-16-1.png

