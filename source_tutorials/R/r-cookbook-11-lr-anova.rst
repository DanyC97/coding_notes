11. Linear Regression and ANOVA
"""""""""""""""""""""""""""""""
https://rpubs.com/escott8908/RC11

.. contents:: `Contents`
   :depth: 2
   :local:

.. important:: Things to check in Linear Regression

- **Is the model statistically significant?**
  
  - Check Fstats
- **Are the coefficients significant?**
  
  - Check their t-stats and p-values
  - (or check their confidence intervals)
- **Is the model useful?**
    
  - Check R2
- **Does the model fit the data well?**
  
  - Plot the residuals and check the regression diagnostics
- **Does the data satisfy the assumptions behind linear regression?**
  
  - Check whether the diagnostics confirm that a linear model is reasonable for your data

############################
Syntax for linear regression
############################
.. code-block:: R

    # === simple linear regression ===
    # include intercept: y_i = \beta0 + \beta1 * x_i + e_i
    lm(y ~ x)

    # Take x and y from dfrm
    > lm(y ~ x, data=dfrm)

    # === multiple linear regression ===
    # y_i = b + \beta1 u_i + \beta_2 v_i + \beta_3*w_i + e_i
    > lm(y ~ u + v + w)
    > lm(y ~ u + v + w, data=dfrm)
    Call:
    lm(formula = y ~ u + v + w, data = dfrm)
    
    Coefficients:
    (Intercept) u v w
    1.4222 1.0359 0.9217 0.7261