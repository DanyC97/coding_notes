Ch2. Getting startd with qplot
""""""""""""""""""""""""""""""
The source R script available :download:`here <qplot.R>`

.. include:: /table-template-knitr.rst

.. contents:: `Contents`
    :depth: 2
    :local:

.. code-block:: R

    library(ggplot2)

    options(show.error.locations = TRUE)

    set.seed(1410) # Make the sample reproducible

The Diamonds dataset
====================

.. code-block:: R

    dsmall <- diamonds[sample(nrow(diamonds), 100), ]

.. code-block:: R

    print(xtable::xtable(head(dsmall,n=10)), type='html')

.. raw:: html

   <!-- html table generated in R 3.3.1 by xtable 1.8-2 package -->

.. raw:: html

   <!-- Fri Nov  4 20:04:08 2016 -->

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

carat

.. raw:: html

   </th>

.. raw:: html

   <th>

cut

.. raw:: html

   </th>

.. raw:: html

   <th>

color

.. raw:: html

   </th>

.. raw:: html

   <th>

clarity

.. raw:: html

   </th>

.. raw:: html

   <th>

depth

.. raw:: html

   </th>

.. raw:: html

   <th>

table

.. raw:: html

   </th>

.. raw:: html

   <th>

price

.. raw:: html

   </th>

.. raw:: html

   <th>

x

.. raw:: html

   </th>

.. raw:: html

   <th>

y

.. raw:: html

   </th>

.. raw:: html

   <th>

z

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

1.35

.. raw:: html

   </td>

.. raw:: html

   <td>

Ideal

.. raw:: html

   </td>

.. raw:: html

   <td>

J

.. raw:: html

   </td>

.. raw:: html

   <td>

VS2

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

61.40

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

57.00

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

5862

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

7.10

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

7.13

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.37

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

0.30

.. raw:: html

   </td>

.. raw:: html

   <td>

Good

.. raw:: html

   </td>

.. raw:: html

   <td>

G

.. raw:: html

   </td>

.. raw:: html

   <td>

VVS1

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

64.00

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

57.00

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

678

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.23

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.27

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

2.72

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

0.75

.. raw:: html

   </td>

.. raw:: html

   <td>

Ideal

.. raw:: html

   </td>

.. raw:: html

   <td>

F

.. raw:: html

   </td>

.. raw:: html

   <td>

SI2

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

59.20

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

60.00

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

2248

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

5.87

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

5.92

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

3.49

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

0.26

.. raw:: html

   </td>

.. raw:: html

   <td>

Ideal

.. raw:: html

   </td>

.. raw:: html

   <td>

F

.. raw:: html

   </td>

.. raw:: html

   <td>

VS1

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

60.90

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

57.00

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

580

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.13

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.11

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

2.51

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

0.33

.. raw:: html

   </td>

.. raw:: html

   <td>

Premium

.. raw:: html

   </td>

.. raw:: html

   <td>

H

.. raw:: html

   </td>

.. raw:: html

   <td>

VVS1

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

61.40

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

59.00

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

752

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.42

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.44

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

2.72

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

1.52

.. raw:: html

   </td>

.. raw:: html

   <td>

Ideal

.. raw:: html

   </td>

.. raw:: html

   <td>

G

.. raw:: html

   </td>

.. raw:: html

   <td>

VVS1

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

62.40

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

55.00

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

15959

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

7.30

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

7.39

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.58

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

7

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

0.32

.. raw:: html

   </td>

.. raw:: html

   <td>

Ideal

.. raw:: html

   </td>

.. raw:: html

   <td>

G

.. raw:: html

   </td>

.. raw:: html

   <td>

IF

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

61.30

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

54.00

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

918

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.41

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.47

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

2.72

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

8

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

2.25

.. raw:: html

   </td>

.. raw:: html

   <td>

Ideal

.. raw:: html

   </td>

.. raw:: html

   <td>

I

.. raw:: html

   </td>

.. raw:: html

   <td>

SI2

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

62.40

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

57.00

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

17143

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

8.39

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

8.32

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

5.21

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

9

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

0.25

.. raw:: html

   </td>

.. raw:: html

   <td>

Premium

.. raw:: html

   </td>

.. raw:: html

   <td>

E

.. raw:: html

   </td>

.. raw:: html

   <td>

VVS2

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

62.50

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

59.00

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

740

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.04

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.02

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

2.52

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   <tr>

.. raw:: html

   <td align="right">

10

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

1.02

.. raw:: html

   </td>

.. raw:: html

   <td>

Premium

.. raw:: html

   </td>

.. raw:: html

   <td>

H

.. raw:: html

   </td>

.. raw:: html

   <td>

I1

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

62.50

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

60.00

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

3141

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

6.39

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

6.41

.. raw:: html

   </td>

.. raw:: html

   <td align="right">

4.00

.. raw:: html

   </td>

.. raw:: html

   </tr>

.. raw:: html

   </table>

2.3 Basic use
=============

.. code-block:: R

    qplot(carat, price, data = diamonds)

|image0|\ 

.. code-block:: R

    qplot(log(carat), log(price), data = diamonds)

|image1|\ 

.. code-block:: R

    qplot(carat, x * y * z, data = diamonds)

|image2|\ 

.. code-block:: R

    # Mapping point colour to diamond colour (left), and point shape to cut
    # quality (right).
    qplot(carat, price, data = dsmall, colour = color)

|image3|\ 

.. code-block:: R

    qplot(carat, price, data = dsmall, shape = cut)

|image4|\ 

.. code-block:: R

    # Reducing the alpha value from 1/10 (left) to 1/100 (middle) to 1/200
    # (right) makes it possible to see where the bulk of the points lie.
    qplot(carat, price, data = diamonds, alpha = I(1/10))

|image5|\ 

.. code-block:: R

    qplot(carat, price, data = diamonds, alpha = I(1/100))

|image6|\ 

.. code-block:: R

    qplot(carat, price, data = diamonds, alpha = I(1/200))

|image7|\ 

.. code-block:: R

    # Smooth curves add to scatterplots of carat vs.\ price. The dsmall
    # dataset (left) and the full dataset (right).
    qplot(carat, price, data = dsmall, geom = c("point", "smooth"))

|image8|\ 

.. code-block:: R

    qplot(carat, price, data = diamonds, geom = c("point", "smooth"))

|image9|\ 

Code below needed some correction (to allow ``span`` to work). See:

-  https://groups.google.com/forum/#!topic/ggplot2/XkpxtrH09DQ
-  http://stackoverflow.com/questions/35102453/r-not-plotting-says-unknown-parameter-method-ggplot2/35103164

.. code-block:: R

    # The effect of the span parameter.  (Left) \code{span = 0.2}, and
    # (right) \code{span = 1}.
    qplot(carat, price, data = dsmall, geom = c("point", "smooth")) + 
      stat_smooth(span = 0.2)

|image10|\ 

.. code-block:: R

    qplot(carat, price, data = dsmall, geom = c("point", "smooth")) +  
      stat_smooth(span = 1)

|image11|\ 

.. code-block:: R

    # The effect of the formula parameter, using a generalised additive
    # model as a smoother.  (Left) \code{formula = y ~ s(x)}, the default;
    # (right) \code{formula = y ~ s(x, bs = "cs")}.
    library(mgcv)

::

    ## Loading required package: nlme

::

    ## This is mgcv 1.8-14. For overview type 'help("mgcv-package")'.

.. code-block:: R

    qplot(carat, price, data = dsmall, geom = c("point", "smooth")) + 
      geom_smooth(method = "gam", formula = y ~ s(x))

|image12|\ 

.. code-block:: R

    qplot(carat, price, data = dsmall, geom = c("point", "smooth")) +
      geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"))

|image13|\ 

.. code-block:: R

    # The effect of the formula parameter, using a linear model as a
    # smoother.  (Left) \code{formula = y ~ x}, the default; (right)
    # \code{formula = y ~ ns(x, 5)}.
    library(splines)
    qplot(carat, price, data = dsmall, geom = c("point", "smooth")) +
      geom_smooth(method = "lm")

|image14|\ 

.. code-block:: R

    qplot(carat, price, data = dsmall, geom = c("point", "smooth")) + 
      geom_smooth(method = "lm", formula = y ~ ns(x,5))

|image15|\ 

.. code-block:: R

    # Using jittering (left) and boxplots (right) to investigate the
    # distribution of price per carat, conditional on colour.  As the
    # colour improves (from left to right) the spread of values decreases,
    # but there is little change in the centre of the distribution.
    qplot(color, price / carat, data = diamonds, geom = "jitter")

|image16|\ 

.. code-block:: R

    qplot(color, price / carat, data = diamonds, geom = "boxplot")

|image17|\ 

.. code-block:: R

    # Varying the alpha level.  From left to right: $1/5$, $1/50$, $1/200$.
    # As the opacity decreases we begin to see where the bulk of the data
    # lies.  However, the boxplot still does much better.
    qplot(color, price / carat, data = diamonds, geom = "jitter",
          alpha = I(1 / 5))

|image18|\ 

.. code-block:: R

    qplot(color, price / carat, data = diamonds, geom = "jitter",
          alpha = I(1 / 50))

|image19|\ 

.. code-block:: R

    qplot(color, price / carat, data = diamonds, geom = "jitter",
          alpha = I(1 / 200))

|image20|\ 

.. code-block:: R

    # Displaying the distribution of diamonds.  (Left) \code{geom =
    # "histogram"} and (right) \code{geom = "density"}.
    qplot(carat, data = diamonds, geom = "histogram")

::

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

|image21|\ 

.. code-block:: R

    qplot(carat, data = diamonds, geom = "density")

|image22|\ 

.. code-block:: R

    # Varying the bin width on a histogram of carat reveals interesting
    # patterns.  Binwidths from left to right: 1, 0.1 and 0.01 carats. Only
    # diamonds between 0 and 3 carats shown.
    qplot(carat, data = diamonds, geom = "histogram", binwidth = 1, 
          xlim = c(0,3))

::

    ## Warning: Removed 32 rows containing non-finite values (stat_bin).

|image23|\ 

.. code-block:: R

    qplot(carat, data = diamonds, geom = "histogram", binwidth = 0.1,
          xlim = c(0,3))

::

    ## Warning: Removed 32 rows containing non-finite values (stat_bin).

|image24|\ 

.. code-block:: R

    qplot(carat, data = diamonds, geom = "histogram", binwidth = 0.01,
          xlim = c(0,3))

::

    ## Warning: Removed 32 rows containing non-finite values (stat_bin).

|image25|\ 

.. code-block:: R

    # Mapping a categorical variable to an aesthetic will automatically
    # split up the geom by that variable.  (Left) Density plots are
    # overlaid and (right) histograms are stacked.
    qplot(carat, data = diamonds, geom = "density", colour = color)

|image26|\ 

.. code-block:: R

    qplot(carat, data = diamonds, geom = "histogram", fill = color)

::

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

|image27|\ 

.. code-block:: R

    # Bar charts of diamond colour.  The left plot shows counts and the
    # right plot is weighted by \code{weight = carat} to show the total
    # weight of diamonds of each colour.
    qplot(color, data = diamonds, geom = "bar")

|image28|\ 

.. code-block:: R

    qplot(color, data = diamonds, geom = "bar", weight = carat) +
      scale_y_continuous("carat")

|image29|\ 

.. code-block:: R

    # Two time series measuring amount of unemployment.  (Left) Percent of
    # population that is unemployed and (right) median number of weeks
    # unemployed.  Plots created with {\tt geom="line"}.
    qplot(date, unemploy / pop, data = economics, geom = "line")

|image30|\ 

.. code-block:: R

    qplot(date, uempmed, data = economics, geom = "line")

|image31|\ 

.. code-block:: R

    # Path plots illustrating the relationship between percent of people
    # unemployed and median length of unemployment.  (Left) Scatterplot
    # with overlaid path.  (Right) Pure path plot coloured by year.
    year <- function(x) as.POSIXlt(x)$year + 1900
    qplot(unemploy / pop, uempmed, data = economics, 
          geom = c("point", "path"))

|image32|\ 

``scale_area`` deprecated; replaced with ``scale_size``
(http://mfcovington.github.io/r\_club/errata/2013/03/05/ch5-errata/)

.. code-block:: R

    # qplot(unemploy / pop, uempmed, data = economics, 
    #       geom = "path", colour = year(date)) + scale_area()
    qplot(unemploy / pop, uempmed, data = economics, 
          geom = "path", colour = year(date)) + scale_size_area()

|image33|\ 

.. code-block:: R

    # Histograms showing the distribution of carat conditional on colour.
    # (Left) Bars show counts and (right) bars show densities (proportions
    # of the whole).  The density plot makes it easier to compare
    # distributions ignoring the relative abundance of diamonds within each
    # colour. High-quality diamonds (colour D) are skewed towards small
    # sizes, and as quality declines the distribution becomes more flat.
    qplot(carat, data = diamonds, facets = color ~ ., 
          geom = "histogram", binwidth = 0.1, xlim = c(0, 3))

::

    ## Warning: Removed 32 rows containing non-finite values (stat_bin).

|image34|\ 

.. code-block:: R

    qplot(carat, ..density.., data = diamonds, facets = color ~ .,
          geom = "histogram", binwidth = 0.1, xlim = c(0, 3))

::

    ## Warning: Removed 32 rows containing non-finite values (stat_bin).

|image35|\ 

.. code-block:: R

    qplot(
      carat, price, data = dsmall, 
      xlab = "Price ($)", ylab = "Weight (carats)",  
      main = "Price-weight relationship"
    )

|image36|\ 

.. code-block:: R

    qplot(
      carat, price/carat, data = dsmall, 
      ylab = expression(frac(price,carat)), 
      xlab = "Weight (carats)",  
      main="Small diamonds", 
      xlim = c(.2,1)
    )

::

    ## Warning: Removed 35 rows containing missing values (geom_point).

|image37|\ 

.. code-block:: R

    qplot(carat, price, data = dsmall, log = "xy")

|image38|\ 

.. |image0| image:: qplot_files/figure-html/unnamed-chunk-4-1.png
.. |image1| image:: qplot_files/figure-html/unnamed-chunk-4-2.png
.. |image2| image:: qplot_files/figure-html/unnamed-chunk-4-3.png
.. |image3| image:: qplot_files/figure-html/unnamed-chunk-4-4.png
.. |image4| image:: qplot_files/figure-html/unnamed-chunk-4-5.png
.. |image5| image:: qplot_files/figure-html/unnamed-chunk-4-6.png
.. |image6| image:: qplot_files/figure-html/unnamed-chunk-4-7.png
.. |image7| image:: qplot_files/figure-html/unnamed-chunk-4-8.png
.. |image8| image:: qplot_files/figure-html/unnamed-chunk-4-9.png
.. |image9| image:: qplot_files/figure-html/unnamed-chunk-4-10.png
.. |image10| image:: qplot_files/figure-html/unnamed-chunk-5-1.png
.. |image11| image:: qplot_files/figure-html/unnamed-chunk-5-2.png
.. |image12| image:: qplot_files/figure-html/unnamed-chunk-5-3.png
.. |image13| image:: qplot_files/figure-html/unnamed-chunk-5-4.png
.. |image14| image:: qplot_files/figure-html/unnamed-chunk-5-5.png
.. |image15| image:: qplot_files/figure-html/unnamed-chunk-5-6.png
.. |image16| image:: qplot_files/figure-html/unnamed-chunk-5-7.png
.. |image17| image:: qplot_files/figure-html/unnamed-chunk-5-8.png
.. |image18| image:: qplot_files/figure-html/unnamed-chunk-5-9.png
.. |image19| image:: qplot_files/figure-html/unnamed-chunk-5-10.png
.. |image20| image:: qplot_files/figure-html/unnamed-chunk-5-11.png
.. |image21| image:: qplot_files/figure-html/unnamed-chunk-5-12.png
.. |image22| image:: qplot_files/figure-html/unnamed-chunk-5-13.png
.. |image23| image:: qplot_files/figure-html/unnamed-chunk-5-14.png
.. |image24| image:: qplot_files/figure-html/unnamed-chunk-5-15.png
.. |image25| image:: qplot_files/figure-html/unnamed-chunk-5-16.png
.. |image26| image:: qplot_files/figure-html/unnamed-chunk-5-17.png
.. |image27| image:: qplot_files/figure-html/unnamed-chunk-5-18.png
.. |image28| image:: qplot_files/figure-html/unnamed-chunk-5-19.png
.. |image29| image:: qplot_files/figure-html/unnamed-chunk-5-20.png
.. |image30| image:: qplot_files/figure-html/unnamed-chunk-5-21.png
.. |image31| image:: qplot_files/figure-html/unnamed-chunk-5-22.png
.. |image32| image:: qplot_files/figure-html/unnamed-chunk-5-23.png
.. |image33| image:: qplot_files/figure-html/unnamed-chunk-6-1.png
.. |image34| image:: qplot_files/figure-html/unnamed-chunk-6-2.png
.. |image35| image:: qplot_files/figure-html/unnamed-chunk-6-3.png
.. |image36| image:: qplot_files/figure-html/unnamed-chunk-6-4.png
.. |image37| image:: qplot_files/figure-html/unnamed-chunk-6-5.png
.. |image38| image:: qplot_files/figure-html/unnamed-chunk-6-6.png
