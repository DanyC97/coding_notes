##################
1. Getting started
##################
.. contents:: `Contents`
   :depth: 2
   :local:


************
Getting help
************
http://www.statmethods.net/interface/help.html

.. code-block:: R

    # Use help to display the documentation for the function:
    > help(functionname)
    > help(mean)
    > ?mean

    
    # Use args for a quick reminder of the function arguments:
    > args(functionname)
    > args(sd)
    function (x, na.rm = FALSE)
    NULL

    # Use example to see examples of using the function:
    > example(functionname)
    > example(mean)
    mean> x <- c(0:10, 50)
    mean> xm <- mean(x)
    mean> c(xm, mean(x, trim = 0.10))
    [1] 8.75 5.50

    # getting help on package
    > help(package="packagename")
    > help(package=tseries)

    # getting vignette
    # see a list of all vignettes on your computer
    > vignette()
    # see the vignettes for a particular package by including its name
    > vignette(package="packagename")
    # Each vignette has a name, which you use to view the vignette:
    > vignette("vignettename")

    # search the web for help
    > RSiteSearch("key phrase")

***********
help.search
***********
.. code-block:: R

    > help.search("pattern")

    # equivalent syntax (but no need to quote here!)
    > ??pattern

