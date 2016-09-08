Extracting, transforming and selecting features (``et-fs``)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
http://spark.apache.org/docs/latest/ml-features.html

.. admonition:: Section summary
   
    This section covers algorithms for working with features, roughly divided into these groups:

    - **Extraction**: Extracting features from “raw” data
    - **Transformation**: Scaling, converting, or modifying features
    - **Selection**: Selecting a subset from a larger set of features

.. important:: 

    Most of the stuffs can be found in:

    - https://wtak23.github.io/pyspark/generated/ml.feature.html
    - https://github.com/apache/spark/tree/master/examples/src/main/python/ml

    Turned out not much explanation is provided in this page...(only the
    first few examples)

.. contents:: `Contents`
   :depth: 2
   :local:

##################
Feature Extractors
##################
******
TF-IDF
******
- https://wtak23.github.io/pyspark/generated/generated/ml.feature.HashingTF.html
- https://github.com/apache/spark/blob/master/examples/src/main/python/ml/tf_idf_example.py

.. code-block:: python

    >>> from pyspark.ml.feature import HashingTF, IDF, Tokenizer
    >>> 
    >>> sentenceData = spark.createDataFrame([
    >>>     (0, "Hi I heard about Spark"),
    >>>     (0, "I wish Java could use case classes"),
    >>>     (1, "Logistic regression models are neat")
    >>> ], ["label", "sentence"])
    >>> tokenizer = Tokenizer(inputCol="sentence", outputCol="words")
    >>> wordsData = tokenizer.transform(sentenceData)
    >>> hashingTF = HashingTF(inputCol="words", outputCol="rawFeatures", numFeatures=20)
    >>> featurizedData = hashingTF.transform(wordsData)
    >>> # alternatively, CountVectorizer can also be used to get term frequency vectors
    >>> 
    >>> idf = IDF(inputCol="rawFeatures", outputCol="features")
    >>> idfModel = idf.fit(featurizedData)
    >>> rescaledData = idfModel.transform(featurizedData)
    >>> for features_label in rescaledData.select("features", "label").take(3):
    >>>     print(features_label)


********
Word2Vec
********
.. code-block:: python

    >>> from pyspark.ml.feature import Word2Vec
    >>> 
    >>> # Input data: Each row is a bag of words from a sentence or document.
    >>> documentDF = spark.createDataFrame([
    >>>     ("Hi I heard about Spark".split(" "), ),
    >>>     ("I wish Java could use case classes".split(" "), ),
    >>>     ("Logistic regression models are neat".split(" "), )
    >>> ], ["text"])
    >>> # Learn a mapping from words to Vectors.
    >>> word2Vec = Word2Vec(vectorSize=3, minCount=0, inputCol="text", outputCol="result")
    >>> model = word2Vec.fit(documentDF)
    >>> result = model.transform(documentDF)
    >>> for feature in result.select("result").take(3):
    >>>     print(feature)

***************
CountVectorizer
***************
.. code-block:: python

    >>> from pyspark.ml.feature import CountVectorizer
    >>> 
    >>> # Input data: Each row is a bag of words with a ID.
    >>> df = spark.createDataFrame([
    >>>     (0, "a b c".split(" ")),
    >>>     (1, "a b b c a".split(" "))
    >>> ], ["id", "words"])
    >>> 
    >>> # fit a CountVectorizerModel from the corpus.
    >>> cv = CountVectorizer(inputCol="words", outputCol="features", vocabSize=3, minDF=2.0)
    >>> model = cv.fit(df)
    >>> result = model.transform(df)
    >>> result.show()

####################
Feature Transformers
####################

*********
Tokenizer
*********

****************
StopWordsRemover
****************

******
n-gram
******

*********
Binarizer
*********

***
PCA
***
- https://wtak23.github.io/pyspark/generated/generated/ml.feature.PCA.html
- https://github.com/apache/spark/blob/master/examples/src/main/python/ml/pca_example.py

.. code-block:: python

    from pyspark.ml.feature import PCA
    from pyspark.ml.linalg import Vectors

    data = [(Vectors.sparse(5, [(1, 1.0), (3, 7.0)]),),
            (Vectors.dense([2.0, 0.0, 3.0, 4.0, 5.0]),),
            (Vectors.dense([4.0, 0.0, 0.0, 6.0, 7.0]),)]
    df = spark.createDataFrame(data, ["features"])
    pca = PCA(k=3, inputCol="features", outputCol="pcaFeatures")
    model = pca.fit(df)
    result = model.transform(df).select("pcaFeatures")
    result.show(truncate=False)

*******************
PolynomialExpansion
*******************

*******************************
Discrete Cosine Transform (DCT)
*******************************


*************
StringIndexer
*************

*************
IndexToString
*************

*************
OneHotEncoder
*************

*************
VectorIndexer
*************

**********
Normalizer
**********

**************
StandardScaler
**************

************
MinMaxScaler
************


************
MaxAbsScaler
************

**********
Bucketizer
**********

***********************
ElementwiseProduct (bm)
***********************
- https://wtak23.github.io/pyspark/generated/generated/ml.feature.ElementwiseProduct.html
- https://github.com/apache/spark/blob/master/examples/src/main/python/ml/elementwise_product_example.py

.. code-block:: python

    from pyspark.ml.feature import ElementwiseProduct
    from pyspark.ml.linalg import Vectors

    # Create some vector data; also works for sparse vectors
    data = [(Vectors.dense([1.0, 2.0, 3.0]),), (Vectors.dense([4.0, 5.0, 6.0]),)]
    df = spark.createDataFrame(data, ["vector"])
    transformer = ElementwiseProduct(scalingVec=Vectors.dense([0.0, 1.0, 2.0]),
                                     inputCol="vector", outputCol="transformedVector")
    # Batch transform the vectors to create new column:
    transformer.transform(df).show()


*******************
SQLTransformer (bm)
*******************
- https://wtak23.github.io/pyspark/generated/generated/ml.feature.SQLTransformer.html

.. code-block:: python

    from pyspark.ml.feature import SQLTransformer

    df = spark.createDataFrame([
        (0, 1.0, 3.0),
        (2, 2.0, 5.0)
    ], ["id", "v1", "v2"])
    sqlTrans = SQLTransformer(
        statement="SELECT *, (v1 + v2) AS v3, (v1 * v2) AS v4 FROM __THIS__")
    sqlTrans.transform(df).show()

***************
VectorAssembler
***************
- https://wtak23.github.io/pyspark/generated/generated/ml.feature.VectorAssembler.html
- https://github.com/apache/spark/blob/master/examples/src/main/python/ml/vector_assembler_example.py

.. code-block:: python

    from pyspark.ml.linalg import Vectors
    from pyspark.ml.feature import VectorAssembler

    dataset = spark.createDataFrame(
        [(0, 18, 1.0, Vectors.dense([0.0, 10.0, 0.5]), 1.0)],
        ["id", "hour", "mobile", "userFeatures", "clicked"])
    assembler = VectorAssembler(
        inputCols=["hour", "mobile", "userFeatures"],
        outputCol="features")
    output = assembler.transform(dataset)
    print(output.select("features", "clicked").first())

*******************
QuantileDiscretizer
*******************
- https://wtak23.github.io/pyspark/generated/generated/ml.feature.QuantileDiscretizer.html


#################
Feature Selectors
#################

************
VectorSlicer
************
- https://wtak23.github.io/pyspark/generated/generated/ml.feature.VectorSlicer.html
- https://github.com/apache/spark/blob/master/examples/src/main/python/ml/vector_slicer_example.py

.. code-block:: python

    from pyspark.ml.feature import VectorSlicer
    from pyspark.ml.linalg import Vectors
    from pyspark.sql.types import Row

    df = spark.createDataFrame([
        Row(userFeatures=Vectors.sparse(3, {0: -2.0, 1: 2.3}),),
        Row(userFeatures=Vectors.dense([-2.0, 2.3, 0.0]),)])

    slicer = VectorSlicer(inputCol="userFeatures", outputCol="features", indices=[1])

    output = slicer.transform(df)

    output.select("userFeatures", "features").show()

********
RFormula
********
- https://wtak23.github.io/pyspark/generated/generated/ml.feature.RFormula.html
- https://github.com/apache/spark/blob/master/examples/src/main/python/ml/rformula_example.py

.. code-block:: python

    from pyspark.ml.feature import RFormula

    dataset = spark.createDataFrame(
        [(7, "US", 18, 1.0),
         (8, "CA", 12, 0.0),
         (9, "NZ", 15, 0.0)],
        ["id", "country", "hour", "clicked"])
    formula = RFormula(
        formula="clicked ~ country + hour",
        featuresCol="features",
        labelCol="label")
    output = formula.fit(dataset).transform(dataset)
    output.select("features", "label").show()

*************
ChiSqSelector
*************
- https://wtak23.github.io/pyspark/generated/generated/ml.feature.ChiSqSelector.html
- https://wtak23.github.io/pyspark/generated/generated/ml.feature.ChiSqSelectorModel.html
- https://github.com/apache/spark/blob/master/examples/src/main/python/ml/chisq_selector_example.py

.. code-block:: python

    from pyspark.ml.feature import ChiSqSelector
    from pyspark.ml.linalg import Vectors

    df = spark.createDataFrame([
        (7, Vectors.dense([0.0, 0.0, 18.0, 1.0]), 1.0,),
        (8, Vectors.dense([0.0, 1.0, 12.0, 0.0]), 0.0,),
        (9, Vectors.dense([1.0, 0.0, 15.0, 0.1]), 0.0,)], ["id", "features", "clicked"])

    selector = ChiSqSelector(numTopFeatures=1, featuresCol="features",
                             outputCol="selectedFeatures", labelCol="clicked")

    result = selector.fit(df).transform(df)
    result.show()