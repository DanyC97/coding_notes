Pipeline-old (``pipeline-old``)
"""""""""""""""""""""""""""""""

.. warning:: 
  
  Note taken from Spark 1.6.2 (now 2.0) from: https://spark.apache.org/docs/1.6.2/ml-guide.html

  Content nearly identical to http://spark.apache.org/docs/latest/ml-pipeline.html

  **Timestamp**: 09-08-2016 (15:33)

.. contents:: `Contents`
   :depth: 1
   :local:


##########################
Main concepts in Pipelines
##########################
Spark ML standardizes APIs for machine learning algorithms to make it easier to combine multiple algorithms into a single pipeline, or workflow. This section covers the key concepts introduced by the Spark ML API, where the pipeline concept is mostly inspired by the scikit-learn project.

- ``DataFrame``: Spark ML uses DataFrame from Spark SQL as an ML dataset, which can hold a variety of data types. E.g., a DataFrame could have different columns storing text, feature vectors, true labels, and predictions.
- ``Transformer``: A Transformer is an algorithm which can **transform one DataFrame into another DataFrame**. E.g., an ML model is a Transformer which transforms DataFrame with features into a DataFrame with predictions.
- ``Estimator``: An Estimator is an algorithm which can be **fit on a DataFrame to produce a Transformer**. E.g., a learning algorithm is an Estimator which trains on a DataFrame and produces a model.
- ``Pipeline``: A Pipeline **chains multiple Transformers and Estimators** together to specify an ML workflow.
- ``Parameter``: All Transformers and Estimators now share a common API for specifying parameters.

#########
DataFrame
#########
- Spark ML adopts the ``DataFrame`` from Spark SQL in order to support a variety of data types.
- In addition to the types listed in the Spark SQL guide, DataFrame can use ``ML Vector types``.
- Columns in a DataFrame are named. The code examples below use names such as ``“text,” “features,” and “label.”``

###################
Pipeline components
###################

************
Transformers
************
.. math::
    
    \text{Transformer}(DataFrame)\rightarrow DataFrame

- A ``Transformer`` is an abstraction that includes feature transformers and learned models. 
- Technically, a Transformer implements a method ``transform()``, which converts one DataFrame into another, generally by appending one or more columns. 

For example:

- A **feature transformer** might take a DataFrame, read a column (e.g., text), map it into a new column (e.g., feature vectors), and output a **new DataFrame with the mapped column appended**.
- A **learning model** might take a DataFrame, read the column containing feature vectors, predict the label for each feature vector, and output a new DataFrame with **predicted labels appended as a column**.

**********
Estimators
**********
- An ``Estimator`` abstracts the concept of a learning algorithm or any algorithm that fits or trains on data. 
- Technically, an Estimator implements a method ``fit()``, which accepts a DataFrame and produces a ``Model``, which is a **Transformer**. 

For example, a learning algorithm such as ``LogisticRegression`` is an **Estimator**, and calling ``fit()`` trains a ``LogisticRegressionModel``, which is a **Model** and hence a **Transformer**.

*********************************
Properties of pipeline components
*********************************
``Transformer.transform()``s and ``Estimator.fit()``s are both **stateless**. In the future, stateful algorithms may be supported via alternative concepts.

Each instance of a Transformer or Estimator has a unique ID, which is useful in specifying parameters (discussed below).

######################################
Pipeline (transformers and estimators)
######################################

.. admonition:: simple text document processing workflow 

    Consider an example ML workflow:

    - Split each document’s text into words.
    - Convert each document’s words into a numerical feature vector.
    - Learn a prediction model using the feature vectors and labels.

Spark ML represents such a workflow as a ``Pipeline``, which consists of a sequence of ``PipelineStages`` **(Transformers and Estimators)** to be run in a specific order. 

************
How it works
************
A ``Pipeline`` is specified as a sequence of ``stages``, and each stage is either a **Transformer** or an **Estimator**. 

- These stages are run in order, and the input DataFrame is transformed as it passes through each stage. 
- For **Transformer** stages, the ``transform()`` method is called on the DataFrame. 
- For **Estimator stages**, the ``fit()`` method is called to produce a **Transformer** (which becomes part of the ``PipelineModel``, or **fitted Pipeline**), and that Transformer's ``transform()`` method is called on the DataFrame.


.. admonition:: Training time usage of ``Pipeline``
    
    The top row represents a ``Pipeline`` with **three stages**. 
    
    - The **Tokenizer and HashingTF** are **Transformers (blue)**
    - ``LogisticRegression`` is an **Estimator (red)**. 
    
    The bottom row represents data flowing through the pipeline, where **cylinders indicate DataFrames**. 

    - The ``Pipeline.fit()`` method is called on the original DataFrame, which has raw text documents and labels. 
    - The ``Tokenizer.transform()`` method splits the raw text documents into words, adding a new column with words to the DataFrame. 
    - The ``HashingTF.transform()`` method converts the words column into feature vectors, adding a new column with those vectors to the DataFrame. 
    - Since ``LogisticRegression`` is an **Estimator**, the Pipeline first calls ``LogisticRegression.fit()`` to produce a ``LogisticRegressionModel``. 
    - If the Pipeline had more stages, it would call the LogisticRegressionModel's ``transform()`` method on the DataFrame before passing the DataFrame to the next stage.

    .. image:: https://spark.apache.org/docs/1.6.2/img/ml-Pipeline.png
       :align: center

.. admonition:: Test time usage of ``PipelineModel``
   
   A **Pipeline is an Estimator**. Thus, after a Pipeline's fit() method runs, it produces a ``PipelineModel``, which is a Transformer. This ``PipelineModel`` is used at **test time**; the figure below illustrates this usage.

   In the figure below, the ``PipelineModel`` has the same number of stages as the original ``Pipeline``, but **all Estimators in the original Pipeline have become Transformers**. When the PipelineModel's ``transform()`` method is called on a test dataset, the data are passed through the fitted pipeline in order. Each stage's ``transform()`` method updates the dataset and passes it to the next stage.

   .. note:: ``Pipelines`` and ``PipelineModels`` help to ensure that training and test data go through identical feature processing steps.

   .. image:: https://spark.apache.org/docs/1.6.2/img/ml-PipelineModel.png
      :align: center

*******
Details
*******
**DAG Pipelines**: A Pipeline’s stages are specified as an **ordered array**. The examples given here are all for **linear Pipelines**, i.e., Pipelines in which each stage uses data produced by the previous stage. It is possible to create **non-linear Pipelines** as long as the data flow graph forms a Directed Acyclic Graph (**DAG**). This graph is currently specified implicitly based on the input and output column names of each stage (generally specified as parameters). If the Pipeline forms a DAG, then the stages must be specified in **topological order**.

**Runtime checking**: Since Pipelines can operate on DataFrames with varied types, they *cannot use compile-time type checking*. Pipelines and PipelineModels instead do **runtime checking** before actually running the Pipeline. This type checking is done using the DataFrame schema, a description of the data types of columns in the DataFrame.

**Unique Pipeline stages**: A Pipeline’s stages should be unique instances. E.g., *the same instance myHashingTF should not be inserted into the Pipeline twice* since *Pipeline stages must have unique IDs*. However, different instances myHashingTF1 and myHashingTF2 (both of type ``HashingTF``) can be put into the same Pipeline since *different instances will be created with different IDs*.


##########
Parameters
##########
Spark ML Estimators and Transformers use a uniform API for specifying parameters.

- A ``Param`` is a named parameter with self-contained documentation. 
- A ``ParamMap`` is a set of (parameter, value) pairs.

There are two main ways to pass parameters to an algorithm:

- Set parameters for an instance. 

  - E.g., if ``lr`` is an instance of ``LogisticRegression``, one could call ``lr.setMaxIter(10)`` to make ``lr.fit()`` use at most 10 iterations. 
  - This API resembles the API used in ``spark.mllib package``.
- Pass a ``ParamMap`` to ``fit()`` or ``transform()``. 

  - Any parameters in the ParamMap will override parameters previously specified via setter methods.

Parameters belong to specific instances of Estimators and Transformers. 

- For example, suppose we have two **LogisticRegression** instances ``lr1`` and ``lr2``
- we can build a *ParamMap* with both *maxIter* parameters specified: ``ParamMap(lr1.maxIter -> 10, lr2.maxIter -> 20)``. 
- This is useful if there are two algorithms with the *maxIter* parameter in a *Pipeline*.


############################
Saving and Loading Pipelines
############################
Often times it is worth it to save a model or a pipeline to disk for later use. In Spark 1.6, a model import/export functionality was added to the Pipeline API. Most basic transformers are supported as well as some of the more basic ML models. Please refer to the algorithm’s API documentation to see if saving and loading is supported.

#############
Code Examples
#############
*********************************
Estimator, Transformer, and Param
*********************************
This example covers the concepts of Estimator, Transformer, and Param.

.. code-block:: python

    from pyspark.mllib.linalg import Vectors
    from pyspark.ml.classification import LogisticRegression
    from pyspark.ml.param import Param, Params

    # Prepare training data from a list of (label, features) tuples.
    training = sqlContext.createDataFrame([
        (1.0, Vectors.dense([0.0, 1.1, 0.1])),
        (0.0, Vectors.dense([2.0, 1.0, -1.0])),
        (0.0, Vectors.dense([2.0, 1.3, 1.0])),
        (1.0, Vectors.dense([0.0, 1.2, -0.5]))], ["label", "features"])

    # Create a LogisticRegression instance. This instance is an Estimator.
    lr = LogisticRegression(maxIter=10, regParam=0.01)
    # Print out the parameters, documentation, and any default values.
    print "LogisticRegression parameters:\n" + lr.explainParams() + "\n"

    # Learn a LogisticRegression model. This uses the parameters stored in lr.
    model1 = lr.fit(training)

    # Since model1 is a Model (i.e., a transformer produced by an Estimator),
    # we can view the parameters it used during fit().
    # This prints the parameter (name: value) pairs, where names are unique IDs for this
    # LogisticRegression instance.
    print "Model 1 was fit using parameters: "
    print model1.extractParamMap()

    # We may alternatively specify parameters using a Python dictionary as a paramMap
    paramMap = {lr.maxIter: 20}
    paramMap[lr.maxIter] = 30 # Specify 1 Param, overwriting the original maxIter.
    paramMap.update({lr.regParam: 0.1, lr.threshold: 0.55}) # Specify multiple Params.

    # You can combine paramMaps, which are python dictionaries.
    paramMap2 = {lr.probabilityCol: "myProbability"} # Change output column name
    paramMapCombined = paramMap.copy()
    paramMapCombined.update(paramMap2)

    # Now learn a new model using the paramMapCombined parameters.
    # paramMapCombined overrides all parameters set earlier via lr.set* methods.
    model2 = lr.fit(training, paramMapCombined)
    print "Model 2 was fit using parameters: "
    print model2.extractParamMap()

    # Prepare test data
    test = sqlContext.createDataFrame([
        (1.0, Vectors.dense([-1.0, 1.5, 1.3])),
        (0.0, Vectors.dense([3.0, 2.0, -0.1])),
        (1.0, Vectors.dense([0.0, 2.2, -1.5]))], ["label", "features"])

    # Make predictions on test data using the Transformer.transform() method.
    # LogisticRegression.transform will only use the 'features' column.
    # Note that model2.transform() outputs a "myProbability" column instead of the usual
    # 'probability' column since we renamed the lr.probabilityCol parameter previously.
    prediction = model2.transform(test)
    selected = prediction.select("features", "label", "myProbability", "prediction")
    for row in selected.collect():
        print row

*****************
Example: Pipeline
*****************
This example follows the simple text document Pipeline illustrated in the figures below.

.. image:: https://spark.apache.org/docs/1.6.2/img/ml-Pipeline.png
    :align: center

.. code-block:: python

    from pyspark.ml import Pipeline
    from pyspark.ml.classification import LogisticRegression
    from pyspark.ml.feature import HashingTF, Tokenizer
    from pyspark.sql import Row

    # Prepare training documents from a list of (id, text, label) tuples.
    LabeledDocument = Row("id", "text", "label")
    training = sqlContext.createDataFrame([
        (0L, "a b c d e spark", 1.0),
        (1L, "b d", 0.0),
        (2L, "spark f g h", 1.0),
        (3L, "hadoop mapreduce", 0.0)], ["id", "text", "label"])

    # Configure an ML pipeline, which consists of tree stages: tokenizer, hashingTF, and lr.
    tokenizer = Tokenizer(inputCol="text", outputCol="words")
    hashingTF = HashingTF(inputCol=tokenizer.getOutputCol(), outputCol="features")
    lr = LogisticRegression(maxIter=10, regParam=0.01)
    pipeline = Pipeline(stages=[tokenizer, hashingTF, lr])

    # Fit the pipeline to training documents.
    model = pipeline.fit(training)

    # Prepare test documents, which are unlabeled (id, text) tuples.
    test = sqlContext.createDataFrame([
        (4L, "spark i j k"),
        (5L, "l m n"),
        (6L, "mapreduce spark"),
        (7L, "apache hadoop")], ["id", "text"])

    # Make predictions on test documents and print columns of interest.
    prediction = model.transform(test)
    selected = prediction.select("id", "text", "prediction")
    for row in selected.collect():
        print(row)

***************************************
Example: model selection via CV (Scala)
***************************************
.. code-block:: scala

    import org.apache.spark.ml.Pipeline
    import org.apache.spark.ml.classification.LogisticRegression
    import org.apache.spark.ml.evaluation.BinaryClassificationEvaluator
    import org.apache.spark.ml.feature.{HashingTF, Tokenizer}
    import org.apache.spark.ml.tuning.{ParamGridBuilder, CrossValidator}
    import org.apache.spark.mllib.linalg.Vector
    import org.apache.spark.sql.Row

    // Prepare training data from a list of (id, text, label) tuples.
    val training = sqlContext.createDataFrame(Seq(
      (0L, "a b c d e spark", 1.0),
      (1L, "b d", 0.0),
      (2L, "spark f g h", 1.0),
      (3L, "hadoop mapreduce", 0.0),
      (4L, "b spark who", 1.0),
      (5L, "g d a y", 0.0),
      (6L, "spark fly", 1.0),
      (7L, "was mapreduce", 0.0),
      (8L, "e spark program", 1.0),
      (9L, "a e c l", 0.0),
      (10L, "spark compile", 1.0),
      (11L, "hadoop software", 0.0)
    )).toDF("id", "text", "label")

    // Configure an ML pipeline, which consists of three stages: tokenizer, hashingTF, and lr.
    val tokenizer = new Tokenizer()
      .setInputCol("text")
      .setOutputCol("words")
    val hashingTF = new HashingTF()
      .setInputCol(tokenizer.getOutputCol)
      .setOutputCol("features")
    val lr = new LogisticRegression()
      .setMaxIter(10)
    val pipeline = new Pipeline()
      .setStages(Array(tokenizer, hashingTF, lr))

    // We use a ParamGridBuilder to construct a grid of parameters to search over.
    // With 3 values for hashingTF.numFeatures and 2 values for lr.regParam,
    // this grid will have 3 x 2 = 6 parameter settings for CrossValidator to choose from.
    val paramGrid = new ParamGridBuilder()
      .addGrid(hashingTF.numFeatures, Array(10, 100, 1000))
      .addGrid(lr.regParam, Array(0.1, 0.01))
      .build()

    // We now treat the Pipeline as an Estimator, wrapping it in a CrossValidator instance.
    // This will allow us to jointly choose parameters for all Pipeline stages.
    // A CrossValidator requires an Estimator, a set of Estimator ParamMaps, and an Evaluator.
    // Note that the evaluator here is a BinaryClassificationEvaluator and its default metric
    // is areaUnderROC.
    val cv = new CrossValidator()
      .setEstimator(pipeline)
      .setEvaluator(new BinaryClassificationEvaluator)
      .setEstimatorParamMaps(paramGrid)
      .setNumFolds(2) // Use 3+ in practice

    // Run cross-validation, and choose the best set of parameters.
    val cvModel = cv.fit(training)

    // Prepare test documents, which are unlabeled (id, text) tuples.
    val test = sqlContext.createDataFrame(Seq(
      (4L, "spark i j k"),
      (5L, "l m n"),
      (6L, "mapreduce spark"),
      (7L, "apache hadoop")
    )).toDF("id", "text")

    // Make predictions on test documents. cvModel uses the best model found (lrModel).
    cvModel.transform(test)
      .select("id", "text", "probability", "prediction")
      .collect()
      .foreach { case Row(id: Long, text: String, prob: Vector, prediction: Double) =>
        println(s"($id, $text) --> prob=$prob, prediction=$prediction")
      }

***********************************************************
Example: model selection via train validation split (scala)
***********************************************************
.. code-block:: scala

    import org.apache.spark.ml.evaluation.RegressionEvaluator
    import org.apache.spark.ml.regression.LinearRegression
    import org.apache.spark.ml.tuning.{ParamGridBuilder, TrainValidationSplit}

    // Prepare training and test data.
    val data = sqlContext.read.format("libsvm").load("data/mllib/sample_linear_regression_data.txt")
    val Array(training, test) = data.randomSplit(Array(0.9, 0.1), seed = 12345)

    val lr = new LinearRegression()

    // We use a ParamGridBuilder to construct a grid of parameters to search over.
    // TrainValidationSplit will try all combinations of values and determine best model using
    // the evaluator.
    val paramGrid = new ParamGridBuilder()
      .addGrid(lr.regParam, Array(0.1, 0.01))
      .addGrid(lr.fitIntercept)
      .addGrid(lr.elasticNetParam, Array(0.0, 0.5, 1.0))
      .build()

    // In this case the estimator is simply the linear regression.
    // A TrainValidationSplit requires an Estimator, a set of Estimator ParamMaps, and an Evaluator.
    val trainValidationSplit = new TrainValidationSplit()
      .setEstimator(lr)
      .setEvaluator(new RegressionEvaluator)
      .setEstimatorParamMaps(paramGrid)
      // 80% of the data will be used for training and the remaining 20% for validation.
      .setTrainRatio(0.8)

    // Run train validation split, and choose the best set of parameters.
    val model = trainValidationSplit.fit(training)

    // Make predictions on test data. model is the model with combination of parameters
    // that performed best.
    model.transform(test)
      .select("features", "label", "prediction")
      .show()
