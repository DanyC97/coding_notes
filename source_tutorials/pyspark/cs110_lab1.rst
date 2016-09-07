cs110_lab1_power_ml_pipeline
""""""""""""""""""""""""""""
https://raw.githubusercontent.com/spark-mooc/mooc-setup/master/cs110_lab1_power_plant_ml_pipeline.py

.. important:: 

  This is an actual homework program submitted to EdX. To adhere to the honor code, 
  the ``<FILL IN>`` is kept in my personal private `github repos <https://github.com/wtak23/private_repos/blob/master/cs105_lab2_solutions.rst>`__.

.. contents:: `Contents`
   :depth: 2
   :local:

.. rubric:: During this lab we will cover:

#. Load Your Data
#. Explore Your Data
#. Visualize Your Data
#. Data Preparation
#. Data Modeling
#. Tuning and Evaluation

This notebook is an end-to-end exercise of performing **Extract-Transform-Load** and **Exploratory Data Analysis** on a real-world dataset, and then applying several different machine learning algorithms to solve a **supervised regression problem** on the dataset.

##########
Background
##########
.. admonition:: Predicted demand vs Actual demand
   
   .. image:: http://content.caiso.com/outlook/SP/ems_small.gif
      :align: center

   .. image:: http://www.caiso.com/PublishingImages/LoadGraphKey.gif
      :align: center

   From http://www.caiso.com/Pages/TodaysOutlook.aspx

*******************************
Background --- power generation
*******************************
- **Power generation** is a complex process
- understanding and **predicting power output** is an important element in managing a plant and its connection to the **power grid**. 
- The **operators** of a regional power grid create ``predictions of power demand`` based on **historical information** and **environmental factors** (e.g., temperature). 
- They then compare the **predictions against available resources** (e.g., coal, natural gas, nuclear, solar, wind, hydro power plants). 
- Power generation technologies such as solar and wind are highly dependent on **environmental conditions**, and all generation technologies are subject to **planned and unplanned maintenance**.

**********************************
Challenge for power grid operation
**********************************
The challenge for a power grid operator is **how to handle a shortfall in available ``resources`` versus actual ``demand``**. 

There are three solutions to a power shortfall: 

1. **build more base load power plants** (this process can take many years to decades of planning and construction), 
2. **buy and import power** from other regional power grids (this choice can be very expensive and is limited by the power transmission interconnects between grids and the excess power available from other grids), or 
3. **turn on small Peaker** or Peaking Power Plants. 

Because grid operators need to respond quickly to a power shortfall to avoid a power outage, **grid operators rely on a combination of the last two choices**. 

.. note:: In this exercise, we'll focus on the last choice.

********************
The business problem
********************
- https://en.wikipedia.org/wiki/Peaking_power_plant
- https://en.wikipedia.org/wiki/Base_load_power_plant

- Because they supply power only occasionally, the power supplied by a **peaker power plant** commands a much higher price per kilowatt hour than power from a power grid's base power plants.

  - A **peaker plant** may operate many hours a day, or it may operate only a few hours per year, depending on the condition of the region's electrical grid. 
- Because of the cost of building an efficient power plant, if a **peaker plant** is only going to be run for a short or highly variable time it does not make economic sense to make it as efficient as a **base load power plant**.
- In addition, the equipment and fuels used in **base load plants** are often unsuitable for use in **peaker plants** because the fluctuating conditions would severely strain the equipment.

.. admonition:: The Business Problem
   
  The power output of a peaker power plant varies depending on environmental conditions, so the **business problem** is predicting the power output of a peaker power plant as a function of the environmental conditions -- since this would enable the grid operator to make economic tradeoffs about the number of peaker plants to turn on (or whether to buy expensive power from another grid).

- Given this business problem, we need to first perform **Exploratory Data Analysis** to understand the data and then translate the business problem (predicting power output as a function of envionmental conditions) into a **Machine Learning task**. 
- In this instance, the **ML task is regression** since the label (or target) we are trying to predict is numeric. 
- We will use an Apache Spark ML Pipeline to perform the regression.

The real-world data we are using in this notebook consists of 9,568 data points, each with 4 environmental attributes collected from a Combined Cycle Power Plant over 6 years (2006-2011), and is provided by the UCI dataset.

Our schema definition from UCI appears below:

- AT = Atmospheric Temperature in C
- V = Exhaust Vacuum Speed
- AP = Atmospheric Pressure
- RH = Relative Humidity
- PE = Power Output. This is the value we are trying to predict given the measurements above.

######################
Business Understanding
######################
The first step in any machine learning task is to understand the business need.

As described in the overview we are trying to predict power output given a set of readings from various sensors in a gas-fired power generation plant.

The problem is a regression problem since the label (or target) we are trying to predict is numeric.

######################################
Extract-Transform-Load (ETL) Your Data
######################################
Our data is available on Amazon s3 at the following path:
``dbfs:/databricks-datasets/power-plant/data``

.. code-block:: python

    display(dbutils.fs.ls("/databricks-datasets/power-plant/data"))
    print dbutils.fs.head("/databricks-datasets/power-plant/data/Sheet1.tsv")
    dbutils.fs.help()

***********
Exercise 2a
***********
To use the spark-csv package (`link <https://wtak23.github.io/pyspark/generated/generated/sql.DataFrameReader.csv.html>`__), we use the ``sqlContext.read.format()`` method (`link <https://wtak23.github.io/pyspark/generated/generated/sql.DataFrameReader.format.html>`__)to specify the input data source format: ``'com.databricks.spark.csv'``

.. code-block:: python

    >>> # TODO: Load the data and print the first five lines.
    >>> rawTextRdd = <FILL_IN>
    (1) Spark Jobs

    AT  V AP  RH  PE
    14.96 41.76 1024.07 73.17 463.26
    25.18 62.96 1020.04 59.08 444.37
    5.11  39.4  1012.16 92.14 488.56
    20.86 57.32 1010.24 76.64 446.48


From our initial exploration of a sample of the data, we can make several observations for the ETL process:

- The data is a set of .tsv (Tab Seperated Values) files (i.e., each row of the data is separated using tabs)
- There is a header row, which is the name of the columns
- It looks like the type of the data in each column is consistent (i.e., each column is of type double)

***********
Exercise 2b
***********
https://github.com/databricks/spark-csv#python-api

.. code-block:: python

    >>> # TODO: Replace <FILL_IN> with the appropriate code.
    >>> powerPlantDF = sqlContext.read.format(<FILL_IN>).options(<FILL_IN>).load(<FILL_IN>)

    >>> print powerPlantDF.head()
    Row(AT=14.96, V=41.76, AP=1024.07, RH=73.17, PE=463.26)
    
    >>> powerPlantDF.show(n=5)
    (4) Spark Jobs
    +-----+-----+-------+-----+------+
    |   AT|    V|     AP|   RH|    PE|
    +-----+-----+-------+-----+------+
    |14.96|41.76|1024.07|73.17|463.26|
    |25.18|62.96|1020.04|59.08|444.37|
    | 5.11| 39.4|1012.16|92.14|488.56|
    |20.86|57.32|1010.24|76.64|446.48|
    |10.82| 37.5|1009.23|96.62| 473.9|
    +-----+-----+-------+-----+------+

    >>> print powerPlantDF.dtypes
    [('AT', 'double'), ('V', 'double'), ('AP', 'double'), ('RH', 'double'), ('PE', 'double')]

***********
Exercise 2c
***********
Instead of having `spark-csv <https://spark-packages.org/package/databricks/spark-csv>`__ infer the types of the columns, we can specify the schema as a 
`DataType <https://wtak23.github.io/pyspark/generated/generated/sql.types.DateType.html>`__, which is a list of `StructField <https://wtak23.github.io/pyspark/generated/generated/sql.types.StructType.html>`__.

You can find a list of types in the ``pyspark.sql.types module`` (`link <https://wtak23.github.io/pyspark/generated/sql.types.html>`__). For our data, we will use ``DoubleType()`` (`link <https://wtak23.github.io/pyspark/generated/generated/sql.types.DoubleType.html>`__).

For example, to specify that a column's name and type, we use: ``StructField(name, type, True).`` (The third parameter, True, signifies that the column is nullable.)

``sql.types.StructField`` (`link <https://wtak23.github.io/pyspark/generated/generated/sql.types.StructField.html>`__)

.. code-block:: python

    # TO DO: Fill in the custom schema.
    from pyspark.sql.types import *

    # Custom Schema for Power Plant
    customSchema = StructType([ \
        <FILL_IN>, \
        <FILL_IN>, \
        <FILL_IN>, \
        <FILL_IN>, \
        <FILL_IN> \
                              ])

***********
Exercise 2d
***********
Now, let's use the schema to read the data. 

To do this, we will modify the earlier `sqlContext.read.format <https://wtak23.github.io/pyspark/generated/generated/sql.DataFrameReader.format.html>`__ step.

We can specify the schema by:

- Adding ``schema = customSchema`` to the load method (use a comma and add it after the file name)
- Removing the ``inferschema='true``'option because we are explicitly specifying the schema

.. code-block:: python

    # TODO: Use the schema you created above to load the data again.
    altPowerPlantDF = sqlContext.read.format(<FILL_IN>).options(<FILL_IN>).load(<FILL_IN>)

#################
Explore your data
#################

First, let's **register** our DataFrame as an **SQL table** named ``power_plant``. 

- Because you may run this lab multiple times, we'll take the precaution of removing any existing tables first.
- We can delete any existing ``power_plant`` SQL table using the SQL command: ``DROP TABLE IF EXISTS power_plant`` (we also need to to delete any Hive data associated with the table, which we can do with a Databricks file system operation).
- Once any prior table is removed, we can register our DataFrame as a SQL table using ``sqlContext.registerDataFrameAsTable()``.

**
3a
**
.. code-block:: python

    # remove any existing tables if it exists
    sqlContext.sql("DROP TABLE IF EXISTS power_plant")
    dbutils.fs.rm("dbfs:/user/hive/warehouse/power_plant", True)
    sqlContext.registerDataFrameAsTable(powerPlantDF, "power_plant")

**
3b
**
NOTE: ``%sql`` is a Databricks-only command. It calls ``sqlContext.sql()`` and passes the results to the Databricks-only ``display()`` function. 

These two statements are equivalent::

    %sql SELECT * FROM power_plant
    display(sqlContext.sql("SELECT * FROM power_plant"))

::

  %sql
  -- We can use %sql to query the rows
  SELECT * FROM power_plant

  %sql
  desc power_plant

.. code-block:: python
  
  df = sqlContext.table("power_plant")
  display(df.describe())


###################
Visualize your data
###################

**
4a
**

::

  %sql
  select AT as Temperature, PE as Power from power_plant

.. image:: /_static/img/110_lab1_4a.png
     :align: center  


*************
Exercise 4(b)
*************
Use SQL to create a scatter plot of Power(PE) as a function of ExhaustVacuum (V). Name the y-axis "Power" and the x-axis "ExhaustVacuum"

:: 

  %sql
  -- TO DO: Replace <FILL_IN> with the appropriate SQL command.

.. image:: /_static/img/110_lab1_4b.png
   :align: center

**************
Excercise 4(c)
**************
Use SQL to create a scatter plot of Power(PE) as a function of Pressure (AP).
Name the y-axis "Power" and the x-axis "Pressure"

:: 

  %sql
  -- TO DO: Replace <FILL_IN> with the appropriate SQL command.

.. image:: /_static/img/110_lab1_4c.png
   :align: center

*************
Exercise 4(d)
*************
Use SQL to create a scatter plot of Power(PE) as a function of Humidity (RH). Name the y-axis "Power" and the x-axis "Humidity"

:: 

  %sql
  -- TO DO: Replace <FILL_IN> with the appropriate SQL command.

.. image:: /_static/img/110_lab1_4d.png
   :align: center

###################################
Data Preparation (where i left off)
###################################
*************
Exercise 5(a)
*************
.. code-block:: python

    # TODO: Replace <FILL_IN> with the appropriate code
    from pyspark.ml.feature import VectorAssembler

    datasetDF = <FILL_IN>

    vectorizer = VectorAssembler()
    vectorizer.setInputCols(<FILL_IN>)
    vectorizer.setOutputCol(<FILL_IN>)

#############
Data Modeling
#############

*************
Exercise 6(a)
*************
.. code-block:: python

    >>> # TODO: Replace <FILL_IN> with the appropriate code.
    >>> # We'll hold out 20% of our data for testing and leave 80% for training
    >>> seed = 1800009193L
    >>> (split20DF, split80DF) = datasetDF.<FILL_IN>
    >>> 
    >>> # Let's cache these datasets for performance
    >>> testSetDF = <FILL_IN>
    >>> trainingSetDF = <FILL_IN>

****
6(b)
****
.. code-block:: python

    >>> from pyspark.ml.regression import LinearRegression
    >>> from pyspark.ml.regression import LinearRegressionModel
    >>> from pyspark.ml import Pipeline
    >>> 
    >>> # Let's initialize our linear regression learner
    >>> lr = LinearRegression()
    >>> 
    >>> # We use explain params to dump the parameters we can use
    >>> print(lr.explainParams())
    elasticNetParam: the ElasticNet mixing parameter, in range [0, 1]. For alpha = 0, the penalty is an L2 penalty. For alpha = 1, it is an L1 penalty. (default: 0.0)
    featuresCol: features column name. (default: features)
    fitIntercept: whether to fit an intercept term. (default: True)
    labelCol: label column name. (default: label)
    maxIter: max number of iterations (>= 0). (default: 100)
    predictionCol: prediction column name. (default: prediction)
    regParam: regularization parameter (>= 0). (default: 0.0)
    solver: the solver algorithm for optimization. If this is not set or empty, default value is 'auto'. (default: auto)
    standardization: whether to standardize the training features before fitting the model. (default: True)
    tol: the convergence tolerance for iterative algorithms. (default: 1e-06)
    weightCol: weight column name. If this is not set or empty, we treat all instance weights as 1.0. (undefined)

****
6(c)
****
.. code-block:: python

    # Now we set the parameters for the method
    lr.setPredictionCol("Predicted_PE")\
      .setLabelCol("PE")\
      .setMaxIter(100)\
      .setRegParam(0.1)


    # We will use the new spark.ml pipeline API. If you have worked with scikit-learn this will be very familiar.
    lrPipeline = Pipeline()

    lrPipeline.setStages([vectorizer, lr])

    # Let's first train on the entire dataset to see what we get
    lrModel = lrPipeline.fit(trainingSetDF)

****
6(d)
****
.. code-block:: python

    # The intercept is as follows:
    intercept = lrModel.stages[1].intercept

    # The coefficents (i.e., weights) are as follows:
    weights = lrModel.stages[1].coefficients

    # Create a list of the column names (without PE)
    featuresNoLabel = [col for col in datasetDF.columns if col != "PE"]

    # Merge the weights and labels
    coefficents = zip(weights, featuresNoLabel)

    # Now let's sort the coefficients from greatest absolute weight most to the least absolute weight
    coefficents.sort(key=lambda tup: abs(tup[0]), reverse=True)

    equation = "y = {intercept}".format(intercept=intercept)
    variables = []
    for x in coefficents:
        weight = abs(x[0])
        name = x[1]
        symbol = "+" if (x[0] > 0) else "-"
        equation += (" {} ({} * {})".format(symbol, weight, name))

    # Finally here is our equation
    print("Linear Regression Equation: " + equation)

**
6e
**
.. code-block:: python

    # Apply our LR model to the test data and predict power output
    predictionsAndLabelsDF = lrModel.transform(testSetDF).select("AT", "V", "AP", "RH", "PE", "Predicted_PE")

    display(predictionsAndLabelsDF)

****
6(f)
****
.. code-block:: python

    # Now let's compute an evaluation metric for our test dataset
    from pyspark.ml.evaluation import RegressionEvaluator

    # Create an RMSE evaluator using the label and predicted columns
    regEval = RegressionEvaluator(predictionCol="Predicted_PE", labelCol="PE", metricName="rmse")

    # Run the evaluator on the DataFrame
    rmse = regEval.evaluate(predictionsAndLabelsDF)

    print("Root Mean Squared Error: %.2f" % rmse)

****
6(g)
****
.. code-block:: python

    # Now let's compute another evaluation metric for our test dataset
    r2 = regEval.evaluate(predictionsAndLabelsDF, {regEval.metricName: "r2"})

    print("r2: {0:.2f}".format(r2))

****
6(h)
****
.. code-block:: python

    # First we remove the table if it already exists
    sqlContext.sql("DROP TABLE IF EXISTS Power_Plant_RMSE_Evaluation")
    dbutils.fs.rm("dbfs:/user/hive/warehouse/Power_Plant_RMSE_Evaluation", True)

    # Next we calculate the residual error and divide it by the RMSE
    predictionsAndLabelsDF.selectExpr("PE", "Predicted_PE", "PE - Predicted_PE Residual_Error", "(PE - Predicted_PE) / {} Within_RSME".format(rmse)).registerTempTable("Power_Plant_RMSE_Evaluation")

****
6(i)
****
::

  %sql
  SELECT * from Power_Plant_RMSE_Evaluation

****
6(j)
****
::

  %sql
  -- Now we can display the RMSE as a Histogram
  SELECT Within_RSME  from Power_Plant_RMSE_Evaluation

****
6(k)
****
::

  %sql
  SELECT case when Within_RSME <= 1.0 AND Within_RSME >= -1.0 then 1
              when  Within_RSME <= 2.0 AND Within_RSME >= -2.0 then 2 else 3
         end RSME_Multiple, COUNT(*) AS count
  FROM Power_Plant_RMSE_Evaluation
  GROUP BY case when Within_RSME <= 1.0 AND Within_RSME >= -1.0 then 1  when  Within_RSME <= 2.0 AND Within_RSME >= -2.0 then 2 else 3 end

#####################
Tuning and Evaluation
#####################

****
7(a)
****
.. code-block:: python

    from pyspark.ml.tuning import ParamGridBuilder, CrossValidator

    # We can reuse the RegressionEvaluator, regEval, to judge the model based on the best Root Mean Squared Error
    # Let's create our CrossValidator with 3 fold cross validation
    crossval = CrossValidator(estimator=lrPipeline, evaluator=regEval, numFolds=3)

    # Let's tune over our regularization parameter from 0.01 to 0.10
    regParam = [x / 100.0 for x in range(1, 11)]

    # We'll create a paramter grid using the ParamGridBuilder, and add the grid to the CrossValidator
    paramGrid = (ParamGridBuilder()
                 .addGrid(lr.regParam, regParam)
                 .build())
    crossval.setEstimatorParamMaps(paramGrid)

    # Now let's find and return the best model
    cvModel = crossval.fit(trainingSetDF).bestModel

*************
Exercise 7(b)
*************
.. code-block:: python

    # TODO: Replace <FILL_IN> with the appropriate code.
    # Now let's use cvModel to compute an evaluation metric for our test dataset: testSetDF
    predictionsAndLabelsDF = <FILL_IN>

    # Run the previously created RMSE evaluator, regEval, on the predictionsAndLabelsDF DataFrame
    rmseNew = <FILL_IN>

    # Now let's compute the r2 evaluation metric for our test dataset
    r2New = <FILL_IN>

    print("Original Root Mean Squared Error: {0:2.2f}".format(rmse))
    print("New Root Mean Squared Error: {0:2.2f}".format(rmseNew))
    print("Old r2: {0:2.2f}".format(r2))
    print("New r2: {0:2.2f}".format(r2New))

    print("Regularization parameter of the best model: {0:.2f}".format(cvModel.stages[-1]._java_obj.parent().getRegParam()))

***********************************
Exercise 7(c) DecisionTreeRegressor
***********************************
.. code-block:: python

    # TODO: Replace <FILL_IN> with the appropriate code.
    from pyspark.ml.regression import DecisionTreeRegressor

    # Create a DecisionTreeRegressor
    dt = <FILL_IN>

    dt.setLabelCol("PE")\
      .setPredictionCol("Predicted_PE")\
      .setFeaturesCol("features")\
      .setMaxBins(100)

    # Create a Pipeline
    dtPipeline = <FILL_IN>

    # Set the stages of the Pipeline
    dtPipeline.<FILL_IN>

*************
Exercise 7(d)
*************
.. code-block:: python

    # TODO: Replace <FILL_IN> with the appropriate code.
    # Let's just reuse our CrossValidator with the new dtPipeline,  RegressionEvaluator regEval, and 3 fold cross validation
    crossval.setEstimator(dtPipeline)

    # Let's tune over our dt.maxDepth parameter on the values 2 and 3, create a paramter grid using the ParamGridBuilder
    paramGrid = <FILL_IN>

    # Add the grid to the CrossValidator
    crossval.<FILL_IN>

    # Now let's find and return the best model
    dtModel = crossval.<FILL_IN>

*************
Exercise 7(e)
*************
.. code-block:: python

    # TODO: Replace <FILL_IN> with the appropriate code.

    # Now let's use dtModel to compute an evaluation metric for our test dataset: testSetDF
    predictionsAndLabelsDF = <FILL_IN>

    # Run the previously created RMSE evaluator, regEval, on the predictionsAndLabelsDF DataFrame
    rmseDT = <FILL_IN>

    # Now let's compute the r2 evaluation metric for our test dataset
    r2DT = <FILL_IN>

    print("LR Root Mean Squared Error: {0:.2f}".format(rmseNew))
    print("DT Root Mean Squared Error: {0:.2f}".format(rmseDT))
    print("LR r2: {0:.2f}".format(r2New))
    print("DT r2: {0:.2f}".format(r2DT))

    print dtModel.stages[-1]._java_obj.toDebugString()

***************************************
Exercise 7(f) (Random Forest Regressor)
***************************************
.. code-block:: python

    # TODO: Replace <FILL_IN> with the appropriate code.

    from pyspark.ml.regression import RandomForestRegressor

    # Create a RandomForestRegressor
    rf = <FILL_IN>

    rf.setLabelCol("PE")\
      .setPredictionCol("Predicted_PE")\
      .setFeaturesCol("features")\
      .setSeed(100088121L)\
      .setMaxDepth(8)\
      .setNumTrees(30)

    # Create a Pipeline
    rfPipeline = <FILL_IN>

    # Set the stages of the Pipeline
    rfPipeline.<FILL_IN>

********************************
Exercise 7(g) (cross validation)
********************************
.. code-block:: python

    # TODO: Replace <FILL_IN> with the appropriate code.
    # Let's just reuse our CrossValidator with the new rfPipeline,  RegressionEvaluator regEval, and 3 fold cross validation
    crossval.setEstimator(rfPipeline)

    # Let's tune over our rf.maxBins parameter on the values 50 and 100, create a paramter grid using the ParamGridBuilder
    paramGrid = <FILL_IN>

    # Add the grid to the CrossValidator
    crossval.<FILL_IN>

    # Now let's find and return the best model
    rfModel = <FILL_IN>

********************************
Exercise 7(h) (model evaluation)
********************************
.. code-block:: python

    # TODO: Replace <FILL_IN> with the appropriate code.

    # Now let's use rfModel to compute an evaluation metric for our test dataset: testSetDF
    predictionsAndLabelsDF = <FILL_IN>

    # Run the previously created RMSE evaluator, regEval, on the predictionsAndLabelsDF DataFrame
    rmseRF = <FILL_IN>

    # Now let's compute the r2 evaluation metric for our test dataset
    r2RF = <FILL_IN>

    print("LR Root Mean Squared Error: {0:.2f}".format(rmseNew))
    print("DT Root Mean Squared Error: {0:.2f}".format(rmseDT))
    print("RF Root Mean Squared Error: {0:.2f}".format(rmseRF))
    print("LR r2: {0:.2f}".format(r2New))
    print("DT r2: {0:.2f}".format(r2DT))
    print("RF r2: {0:.2f}".format(r2RF))

    print rfModel.stages[-1]._java_obj.toDebugString()