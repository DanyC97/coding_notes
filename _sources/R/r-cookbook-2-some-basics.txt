##############
2. Some basics
##############

.. contents:: `Contents`
   :depth: 2
   :local:



*************
print and cat
*************
.. code-block:: R

    
    > print(matrix(c(1,2,3,4), 2, 2))
         [,1] [,2]
    [1,]    1    3
    [2,]    2    4
    
    > print('
    + hello ')
    [1] "\nhello "

    > print(list("a","b","c"))
    [[1]]
    [1] "a"

    [[2]]
    [1] "b"

    [[3]]
    [1] "c"

    # to print multiple items, use cat
    > cat("The zero occurs at", 2*pi, "radians.", "\n")
    The zero occurs at 6.283185 radians.


    > fib <- c(0,1,1,2,3,5,8,13,21,34)
    > cat("The first few Fibonacci numbers are:", fib, "...\n")
    The first few Fibonacci numbers are: 0 1 1 2 3 5 8 13 21 34 ...

****************************************
setting, listing, and removing variables
****************************************

.. code-block:: R
 
    #=========================================================================#
    # set variables
    #=========================================================================#
    x <- 3

    # global variable assignment
    x <<- 3

    # righward assignment and = operator can also be used....but avoid them as convention!
    foo = 3
    > 5 -> fsum
    > print(fsum)
    [1] 5

    #=========================================================================#
    # show variables
    #=========================================================================#
    > x <- 10
    > y <- 50
    > z <- c("three", "blind", "mice")
    > f <- function(n,p) sqrt(p*(1-p)/n)
    > # hidden variable
    > .hidvar <- 10
    > 
    > ls()
    [1] "f" "x" "y" "z"
    > 
    > # show hidden variables
    > ls(all.names=TRUE)
    [1] ".hidvar"      ".Random.seed" "f"            "x"            "y"           
    [6] "z"  

    #=========================================================================#
    # remove variables
    #=========================================================================# 
    # remove multiple variables at once
    rm(x,y,z)

    # remove all variables
    rm(list=ls())

***************************************
Create vector - the ``c(...)`` operator
***************************************
Vector - single data type (for mixed data-type, use ``list``)

.. code-block:: R

    > c(1,1,2,3,5,8,13,21)
    [1] 1 1 2 3 5 8 13 21
    > c(1*pi, 2*pi, 3*pi, 4*pi)
    [1] 3.141593 6.283185 9.424778 12.566371
    > c("Everyone", "loves", "stats.")
    [1] "Everyone" "loves" "stats."
    > c(TRUE,TRUE,FALSE,TRUE)
    [1] TRUE TRUE FALSE TRUE

    # type coercion when combining vector of different data type
    > v1 <- c(1,2,3)
    > v3 <- c("A","B","C")
    > c(v1,v3)
    [1] "1" "2" "3" "A" "B" "C"

    # check variable type using ``mode``
    > mode(pi)
    [1] "numeric"
    > mode('foo')
    [1] "character"

****************
Basic statistics
****************
.. code-block:: R

    > x <- c(0,1,1,2,3,5,8,13,21,34)
    > mean(x)
    [1] 8.8
    > median(x)
    [1] 4
    > sd(x)
    [1] 11.03328
    > var(x)
    [1] 121.7333
    > y <- log(x+1)
    > cor(x,y)
    [1] 0.9068053
    > cov(x,y)
    [1] 11.49988

    #=========================================================================#
    # handling nans
    #=========================================================================#
    > x <- c(0,1,1,2,3,NA)
    > mean(x)
    [1] NA
    > sd(x)
    [1] NA
    > mean(x, na.rm=TRUE)
    [1] 1.4
    > sd(x, na.rm=TRUE)
    [1] 1.140175

    
    #=========================================================================#
    # mean/sd are smart that it applies to each column separately
    #=========================================================================#
    > print(dframe)
    small medium big
    1 0.6739635 10.526448 99.83624
    2 1.5524619 9.205156 100.70852
    3 0.3250562 11.427756 99.73202
    4 1.2143595 8.533180 98.53608
    5 1.3107692 9.763317 100.74444
    6 2.1739663 9.806662 98.58961
    7 1.6187899 9.150245 100.46707
    8 0.8872657 10.058465 99.88068
    9 1.9170283 9.182330 100.46724
    10 0.7767406 7.949692 100.49814

    > mean(dframe)
    small medium big
    1.245040 9.560325 99.946003

    > sd(dframe)
    small medium big
    0.5844025 0.9920281 0.8135498

    # other functions like *median* does not understand dataframes, so need to apply the median function to each column separately
    # ...see 6.4 Applying a Function to Every Column

    # this computes covariance matrix
    > var(dframe)
    small medium big
    small 0.34152627 -0.21516416 -0.04005275
    medium -0.21516416 0.98411974 -0.09253855
    big -0.04005275 -0.09253855 0.66186326

    > cov(dframe)
    small medium big
    small 0.34152627 -0.21516416 -0.04005275
    medium -0.21516416 0.98411974 -0.09253855
    big -0.04005275 -0.09253855 0.66186326

    # correlation matrix
    > cor(dframe)
    small medium big
    small 1.00000000 -0.3711367 -0.08424345
    medium -0.37113670 1.0000000 -0.11466070
    big -0.08424345 -0.1146607 1.00000000

***********************************************************
Create sequences (``:, seq(from,to,by), rep(arg,times=5)``)
***********************************************************
.. code-block:: R

    # colon operator only works with increments of 1
    > 0:9
    [1] 0 1 2 3 4 5 6 7 8 9
    > 10:19
    [1] 10 11 12 13 14 15 16 17 18 19
    > 9:0
    [1] 9 8 7 6 5 4 3 2 1 0

    # to get increments by more than 1 (like range fucntion)
    > seq(from=0, to=20)
    [1] 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
    > seq(from=0, to=20, by=2)
    [1] 0 2 4 6 8 10 12 14 16 18 20
    > seq(from=0, to=20, by=5)
    [1] 0 5 10 15 20

    # specify length to let R figure out increments
    > seq(from=0, to=20, length.out=5)
    [1] 0 5 10 15 20
    > seq(from=0, to=100, length.out=5)
    [1] 0 25 50 75 100

    # seq can be incremented in decimals
    > seq(from=1.0, to=2.0, length.out=5)
    [1] 1.00 1.25 1.50 1.75 2.00

    # repeat!
    > rep(pi, times=5)
    [1] 3.141593 3.141593 3.141593 3.141593 3.141593

******************************************
Vector comparison (elementwise comparison)
******************************************
.. code-block:: R


    # scalar case
    > a <- 3
    > a == pi # Test for equality
    [1] FALSE
    > a != pi # Test for inequality
    [1] TRUE
    > a < pi
    [1] TRUE
    > a > pi
    [1] FALSE
    > a <= pi
    [1] TRUE
    > a >= pi
    [1] FALSE

    # vector case is elementwise comparison
    > v <- c( 3, pi, 4)
    > w <- c(pi, pi, pi)
    > v == w # Compare two 3-element vectors
    [1] FALSE TRUE FALSE # Result is a 3-element vector
    > v != w
    [1] TRUE FALSE TRUE
    > v < w
    [1] TRUE FALSE FALSE
    > v <= w
    [1] TRUE TRUE FALSE
    > v > w
    [1] FALSE FALSE TRUE

    # to check all or any
    > v <- c(3, pi, 4)
    > any(v == pi) # Return TRUE if any element of v equals pi
    [1] TRUE
    > all(v == 0) # Return TRUE if all elements of v are zero
    [1] FALSE

***************************
Vector indexing and slicing
***************************
.. code-block:: R

    imple index:
    > fib <- c(0,1,1,2,3,5,8,13,21,34)
    > fib
    [1] 0 1 1 2 3 5 8 13 21 34
    > fib[1]
    [1] 0
    > fib[2]
    [1] 1

    > fib[4:9] # Select elements 4 through 9
    [1] 2 3 5 8 13 21

    # index list of indices
    > fib[c(1,2,4,8)]
    [1] 0 1 2 13

    # === R interprets negative indexes to mean exclude a value! ===
    > fib[-1] # Ignore first element
    [1] 1 1 2 3 5 8 13 21 34

    > fib[-(1:3)] # Invert sign of index to exclude instead of select
    [1] 2 3 5 8 13 21 34

    # === using logical mask ===
    > fib < 10
    [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE FALSE FALSE FALSE
    > fib[fib < 10] 
    [1] 0 1 1 2 3 5 8

    > fib %% 2 == 0 # This vector is TRUE wherever fib is even
    [1] TRUE FALSE FALSE TRUE FALSE FALSE TRUE FALSE FALSE TRUE
    > fib[fib %% 2 == 0] 
    [1] 0 2 8 34

    # Select all elements greater than the median
    v[ v > median(v) ]
    # Select all elements in the lower and upper 5%
    v[ (v < quantile(v,0.05)) | (v > quantile(v,0.95)) ]
    # Select all elements that exceed ±2 standard deviations from the mean
    v[ abs(v-mean(v)) > 2*sd(v) ]
    # Select all elements that are neither NA nor NULL
    v[ !is.na(v) & !is.null(v) ]

***************************************************
naming vector elements (gives another way to index)
***************************************************
.. code-block:: R

    > years <- c(1960, 1964, 1976, 1994)
    > names(years) <- c("Kennedy", "Johnson", "Carter", "Clinton")
    > years
    Kennedy Johnson Carter Clinton
    1960 1964 1976 1994

    > years["Carter"]
    Carter
    1976
    > years["Clinton"]
    Clinton
    1994
    > years[c("Carter","Clinton")]
    Carter Clinton
    1976 1994

**********************************
Vector arithmetic (elementwise...)
**********************************
The usual arithmetic operators can perform element-wise operations on entire vectors.

Many functions operate on entire vectors, too, and return a vector result.

.. code-block:: R

    # operartion on vector of equal length (elementwise operation)
    > v <- c(11,12,13,14,15)
    > w <- c(1,2,3,4,5)
    > v + w
    [1] 12 14 16 18 20
    > v - w
    [1] 10 10 10 10 10
    > v * w
    [1] 11 24 39 56 75
    > v / w # r will convert to float for you :)
    [1] 11.000000 6.000000 4.333333 3.500000 3.000000
    > w ^ v
    [1] 1 4096 1594323 268435456 30517578125

    # scalar and vector (simple array broadcasting idea here)
    > w
    [1] 1 2 3 4 5
    > w + 2
    [1] 3 4 5 6 7
    > w - 2
    [1] -1 0 1 2 3
    > w * 2
    [1] 2 4 6 8 10
    > w / 2
    [1] 0.5 1.0 1.5 2.0 2.5
    > w ^ 2
    [1] 1 4 9 16 25
    > 2 ^ w
    [1] 2 4 8 16 32

    # === practical examples ===
    > w
    [1] 1 2 3 4 5
    > w - mean(w)
    [1] -2 -1 0 1 2
    > (w - mean(w)) / sd(w)
    [1] -1.2649111 -0.6324555 0.0000000 0.6324555 1.2649111

    > sqrt(w)
    [1] 1.000000 1.414214 1.732051 2.000000 2.236068
    > log(w)
    [1] 0.0000000 0.6931472 1.0986123 1.3862944 1.6094379
    > sin(w)
    [1] 0.8414710 0.9092974 0.1411200 -0.7568025 -0.9589243

*********************
Some special operator
*********************
.. csv-table:: 
    :header: 
    :delim: |

    ``%%`` |     Modulo operator
    ``%/%`` |     Integer division
    ``%*%`` |     Matrix multiplication
    ``%in%`` |     Returns TRUE if the left operand occurs in its right operand; FALSE otherwise

******************************
Warning on operator precedence
******************************
.. code-block:: R

    > n <− 10
    > 0:n−1 # <- interpreted as (0:n) - 1
    [1] −1 0 1 2 3 4 5 6 7 8 9

    > 0:(n-1)
     [1] 0 1 2 3 4 5 6 7 8 9

*****************
Defining function
*****************
General syntax

.. code-block:: R

    # one-liner syntax
    function(param1, ...., paramN) expr

    # multiline (needs curly-braces)
    function(param1, ..., paramN) {
    expr1
    .
    .
    .
    exprM
    }

Examples

.. code-block:: R

    # coefficient of variation
    > cv <- function(x) sd(x)/mean(x)
    > cv(1:10)
    [1] 0.5504819


    > lapply(lst, cv) # lapply in sec 6.2
    # equivalent anonymous function
    > lapply(lst, function(x) sd(x)/mean(x))