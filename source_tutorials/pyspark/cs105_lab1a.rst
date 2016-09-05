cs105_lab1a
"""""""""""
https://raw.githubusercontent.com/spark-mooc/mooc-setup/master/cs105_lab1a_spark_tutorial.py

#############
Spark Context
#############
In Spark, communication occurs between a **driver** and **executors**.  

- The **driver** has Spark jobs and these jobs are split into *tasks* that are submitted to the **executors** for completion.  
- The results from these tasks are delivered back to the **driver**.
- In **Databricks**, the code gets executed in the **Spark driver's JVM** and not in an executor's JVM
- In **Jupyter notebook** it is executed within the kernel associated with the notebook. Since no Spark functionality is actually being used, no tasks are launched on the executors.

To use Spark and its DataFrame API we will need to use a ``SQLContext``.  

- When running Spark, you start a new Spark application by creating a ``SparkContext``. 
- You can then create a ``SQLContext``from the ``SparkContext``. 
- When the ``SparkContext`` is created, it asks the **master** for some **cores** to use to do work.  
- The **master** sets these **cores** aside just for you; they won't be used for other applications. 
- In Databricks, both a ``SparkContext`` and a ``SQLContext`` are created for you automatically.

  - ``sc`` = ``SparkContext``
  - ``sqlContext`` is your ``SQLContext``.

#######################################################
SparkContext and the Driver Program (Cluster Structure)
#######################################################
.. admonition:: Example cluster

  - purple-outline = **slots** (threads available to perform parallel work for Spark)
  - **Spark web UI** provides details about your Spark application 
    
    - in DB, go to *Clusters* and click *Spark UI* link (`link <https://community.cloud.databricks.com/?o=3468350985695707#setting/clusters/0905-023830-choir105/sparkUi>`__)
    - there you can see under the **jobs** tab a list of jobs scheduled to run

  .. image:: http://spark-mooc.github.io/web-assets/images/cs105x/diagram-2a.png
     :align: center

************************
About the Driver Program
************************
Every **Spark application** consists of a **driver program (DP)**

- The **driver program** launches parallel operations on the executor **JVMs** running either in a cluster or locally on the same machine. 

  - In Databricks, "**Databricks Shell**" is the **driver program**. 
  - When running locally, **pyspark** is the **driver program**. 
- The driver program contains the main loop for the program and creates **distributed datasets** on the cluster, then applies **operations** (transformations & actions) to those datasets. 
- Driver programs access Spark through a **SparkContext** object

  - ``SparkContext`` represents a connection to a computing cluster. 
- A **Spark SQL context object** (``sqlContext``) is the main entry point for Spark DataFrame and SQL functionality. 

  - A ``SQLContext`` can be used to create DataFrames, which allows you to direct the operations on your data.

*************************************************
About HiveContext (the type of sqlContext for DB)
*************************************************
>>> type(sqlContext)
pyspark.sql.context.HiveContext

Note that the type is ``HiveContext``. 

- This means we're working with a version of Spark that has **Hive support**. 

  - Compiling Spark with Hive support is a good idea, even if you don't have a Hive metastore. 
- A ``HiveContext`` "provides a superset of the functionality provided by the basic ``SQLContext``. 
- Additional features include:

  - the ability to write queries using the more complete **HiveQL parser**
  - access to **Hive UDFs** [user-defined functions], and 
  - the ability to **read data from Hive tables**. 
- To use a HiveContext, you do not need to have an existing Hive setup, and all of the data sources available to a SQLContext are still available."

************
SparkContext
************
Outside of ``pyspark`` or a notebook, ``SQLContext`` is created from the **lower-level** ``SparkContext``, which is usually used to create **RDDs**. 

- ``SparkContext`` is preloaded as ``sc`` in DB
- An RDD is the way Spark actually represents data internally; 
- DataFrames are actually implemented in terms of RDDs.
- While you can interact directly with RDDs, DataFrames are preferred. 
- They're generally faster, and they perform the same no matter what language (Python, R, Scala or Java) you use with Spark.

#############################################
Using DataFrames and chaining transformations
#############################################

********************
DataFrame and Schema
********************
.. important::

  A DataFrame is **immutable**, so once it is created, it cannot be changed. 

  - As a result, **each transformation creates a new DataFrame**. 

- A **DataFrame** consists of a series of ``Row`` objects; 
- each ``Row`` object has a set of **named columns**. 
- More formally, a DataFrame must have a **schema**
  
  - this means it must consist of **columns**
  - each columns has a **name** and a **type**. 
- Some data sources have schemas built into them. Examples include:

  - RDBMS databases, 
  - Parquet files, and 
  - NoSQL databases like Cassandra. 
- Other data sources don't have computer-readable schemas, but you can often apply a schema programmatically.

**********************
Ways to define schemas
**********************
We'll use a Python ``tuple`` to help us define the Spark DataFrame schema. 

- There are other ways to define schemas, though; 
- For instance, we could also use a Python ``namedtuple`` or a Spark ``Row`` object.
- see the Spark Programming Guide's discussion of schema inference for more information (`link <http://spark.apache.org/docs/latest/sql-programming-guide.html#inferring-the-schema-using-reflection>`__).  Also see :ref:`pyspark_proguide_schema_refl`


*************************************************************
Distributed Data and using a collection to create a DataFrame
*************************************************************
In Spark, datasets are represented as a **list of entries** called **RDDs**

- here the list is broken up into many **different partitions** that are each stored on a **different machine**. 
- Each **partition** holds a unique subset of the entries in the list. 
- DataFrames are ultimately represented as RDDs, with additional meta-data.

One of the defining features of Spark, compared to other data analytics frameworks (e.g., **Hadoop**), is that it **stores data in memory** rather than on disk. This allows Spark applications to run much more quickly, because they are not slowed down by needing to read data from disk. 

.. admonition:: Spark breaks a **list of data entries** into **partitions** that are **each stored in memory on a worker**

  .. image:: http://spark-mooc.github.io/web-assets/images/cs105x/diagram-3b.png
      :align: center


Let's now create a DataFrame using ``sqlContext.createDataFrame()`` (`link <https://wtak23.github.io/pyspark/generated/generated/sql.SQLContext.createDataFrame.html>`__)

- we'll pass our array of data in as an argument to that function. 
- Spark will create a new set of input data based on data that is passed in. 

.. admonition:: DataFrame and Schema

  - A **DataFrame requires a schema**
  - **schema** is **a list of ``columns``**
  - each ``column`` has a **name** and a **type**. 
  - The schema and the column names are passed as the second argument to ``createDataFrame()``.

.. _cs105_lab1a_queryplan:

******************************************
Query plans and the ``Catalyst Optimizer``
******************************************
When you use DataFrames or Spark SQL, you are building up a ``query plan``. 

Each ``transformation`` you apply to a DataFrame adds *some information to the query plan*. 

.. admonition:: (unoptimized) logical query plan -> (optimized) logical plan -> physical plan

  When you finally call an ``action``, which triggers the execution of your Spark job, the following occurs:

  - Spark's ``Catalyst optimizer`` analyzes the ``query plan`` (called an **unoptimized logical query plan**) and attempts to optimize it. 
  - Optimizations includes: (but aren't limited to) 

    - rearranging and combining ``filter()`` operations for efficiency
    - converting Decimal operations to more efficient long integer operations
    - pushing some operations down into the data source (e.g., a ``filter()`` operation might be translated to a ``SQL WHERE`` clause, if the data source is a traditional SQL RDBMS). 
  - The result of this optimization phase is an **optimized logical plan**.
  - Once Catalyst has an **optimized logical plan**, it constructs multiple **physical plans** from it.
    
    - Specifically, it implements the query in terms of lower level Spark RDD operations. 
  - Catalyst chooses which physical plan to use via cost optimization (it determines which physical plan is the most efficient and uses that one).
  - Finally, once the physical RDD execution plan is established, Spark actually executes the job.

You can examine the query plan using the ``explain()`` function on a DataFrame. 

- By default, ``explain()`` only shows you the **final physical plan**; 
- if you pass it an argument of ``True``, it will show you **all phases**.
- (If you want to take a deeper dive into how Catalyst optimizes DataFrame queries, this blog post, while a little old, is an excellent overview: `Deep Dive into Spark SQL's Catalyst Optimizer <https://databricks.com/blog/2015/04/13/deep-dive-into-spark-sqls-catalyst-optimizer.html>`__.)

See :ref:`cs105_lab1a_queryplancode` for the coding part.

##################
Actual coding part
##################

*****************
Exercise Overview
*****************
What the following exercise does:

* Create a Python collection of 10,000 integers
* Create a Spark DataFrame from that collection
* Subtract one from each value using ``map``
* Perform **action** ``collect`` to view results
* Perform **action** ``count`` to view counts
* Apply **transformation** ``filter`` and view results with ``collect``
* Learn about **lambda functions**
* Explore how **lazy evaluation** works and the **debugging challenges** that it introduces


*******************
Create list of Data
*******************
.. code-block:: python

    >>> from faker import Factory
    >>> fake = Factory.create()
    >>> fake.seed(4321)

    >>> # Each entry consists of last_name, first_name, ssn, job, and age (at least 1)
    >>> from pyspark.sql import Row
    >>> def fake_entry():
    >>>   name = fake.name().split()
    >>>   return (name[1], name[0], fake.ssn(), fake.job(), abs(2016 - fake.date_time().year) + 1)

    >>> # Create a helper function to call a function repeatedly
    >>> def repeat(times, func, *args, **kwargs):
    >>>     for _ in xrange(times):
    >>>         yield func(*args, **kwargs)
    
    >>> data = list(repeat(10000, fake_entry))

    >>> data[0]
    Out[15]: (u'Harvey', u'Tracey', u'160-37-9051', 'Agricultural engineer', 39)
    >>> len(data)
    Out[16]: 10000

****************************
Create DataFrame from a list
****************************
Remember, we need to pass a schema as the 2nd argument to ``sqlContext.createDataFrame``

.. code-block:: python

    >>> dataDF = sqlContext.createDataFrame(data, ('last_name', 'first_name', 'ssn', 'occupation', 'age'))
    >>> print 'type of dataDF: {0}'.format(type(dataDF))
    type of dataDF: <class 'pyspark.sql.dataframe.DataFrame'>
    >>> # let's take a look at the DF's schema and some of its rows
    >>> dataDF.printSchema()
    root
     |-- last_name: string (nullable = true)
     |-- first_name: string (nullable = true)
     |-- ssn: string (nullable = true)
     |-- occupation: string (nullable = true)
     |-- age: long (nullable = true)
     
    >>> # How many partitions will the DataFrame be split into?
    >>> dataDF.rdd.getNumPartitions()
    Out[57]: 8
    >>> # *register* this DF as a named table (so we can use sql functions on it)
    >>> sqlContext.registerDataFrameAsTable(dataDF, 'dataframe')

    >>> # show content of DF
    >>> dataDF.show(5,truncate=False)
    (1) Spark Jobs
    +----------+----------+-----------+--------------------------------+---+
    |last_name |first_name|ssn        |occupation                      |age|
    +----------+----------+-----------+--------------------------------+---+
    |Harvey    |Tracey    |160-37-9051|Agricultural engineer           |39 |
    |Green     |Leslie    |361-94-4342|Teacher, primary school         |26 |
    |Lewis     |Tammy     |769-27-5887|Scientific laboratory technician|21 |
    |Cunningham|Kathleen  |175-24-7915|Geophysicist/field seismologist |42 |
    |Marquez   |Joshua    |310-69-7326|Forensic psychologist           |26 |
    +----------+----------+-----------+--------------------------------+---+
    only showing top 5 rows

************************************
Subtract one from each the *age* row
************************************
>>> # Transform dataDF through a select transformation and rename the newly created '(age -1)' column to 'age'
>>> # Because select is a transformation and Spark uses lazy evaluation, no jobs, stages,
>>> # or tasks will be launched when we run this code.
>>> subDF = dataDF.select('last_name', 'first_name', 'ssn', 'occupation', (dataDF.age - 1).alias('age'))

>>> # ``show`` is an action, so here job gets launched (so DB shows Spark Jobs dropdown menu)
>>> subDF.show(5)
(1) Spark Jobs
Job 53 View(Stages: 1/1)
+----------+----------+-----------+--------------------+---+
| last_name|first_name|        ssn|          occupation|age|
+----------+----------+-----------+--------------------+---+
|    Harvey|    Tracey|160-37-9051|Agricultural engi...| 38|
|     Green|    Leslie|361-94-4342|Teacher, primary ...| 25|
|     Lewis|     Tammy|769-27-5887|Scientific labora...| 20|
|Cunningham|  Kathleen|175-24-7915|Geophysicist/fiel...| 41|
|   Marquez|    Joshua|310-69-7326|Forensic psycholo...| 25|
+----------+----------+-----------+--------------------+---+

.. _cs105_lab1a_queryplancode:

*********************************************
Apply transformations, and examine query plan
*********************************************
Query plan can be examined by callined ``df.explain`` method (see :ref:`cs105_lab1a_queryplan`)

.. code-block:: python

    >>> # apply a transformation
    >>> newDF = dataDF.distinct().select('*')
    >>> # examine query plan (True = show all stages. Default is to just show the final plan)
    >>> newDF.explain(True)
    >>> # the output below may look gibberish, but with more experience, you'll get a handle of these (at least what the tutorial told me...)
    == Parsed Logical Plan ==
    'Project [*]
    +- Aggregate [last_name#8,first_name#9,ssn#10,occupation#11,age#12L], [last_name#8,first_name#9,ssn#10,occupation#11,age#12L]
       +- LogicalRDD [last_name#8,first_name#9,ssn#10,occupation#11,age#12L], MapPartitionsRDD[8] at applySchemaToPythonRDD at NativeMethodAccessorImpl.java:-2

    == Analyzed Logical Plan ==
    last_name: string, first_name: string, ssn: string, occupation: string, age: bigint
    Project [last_name#8,first_name#9,ssn#10,occupation#11,age#12L]
    +- Aggregate [last_name#8,first_name#9,ssn#10,occupation#11,age#12L], [last_name#8,first_name#9,ssn#10,occupation#11,age#12L]
       +- LogicalRDD [last_name#8,first_name#9,ssn#10,occupation#11,age#12L], MapPartitionsRDD[8] at applySchemaToPythonRDD at NativeMethodAccessorImpl.java:-2

    == Optimized Logical Plan ==
    Aggregate [last_name#8,first_name#9,ssn#10,occupation#11,age#12L], [last_name#8,first_name#9,ssn#10,occupation#11,age#12L]
    +- LogicalRDD [last_name#8,first_name#9,ssn#10,occupation#11,age#12L], MapPartitionsRDD[8] at applySchemaToPythonRDD at NativeMethodAccessorImpl.java:-2

    == Physical Plan ==
    TungstenAggregate(key=[last_name#8,first_name#9,ssn#10,occupation#11,age#12L], functions=[], output=[last_name#8,first_name#9,ssn#10,occupation#11,age#12L])
    +- TungstenExchange hashpartitioning(last_name#8,first_name#9,ssn#10,occupation#11,age#12L,200), None
       +- TungstenAggregate(key=[last_name#8,first_name#9,ssn#10,occupation#11,age#12L], functions=[], output=[last_name#8,first_name#9,ssn#10,occupation#11,age#12L])
          +- Scan ExistingRDD[last_name#8,first_name#9,ssn#10,occupation#11,age#12L]

Repeat by examining query plan for ``subDF`` after subtraction

.. code-block:: python

    >>> subDF.explain(True)
    == Parsed Logical Plan ==
    'Project [unresolvedalias('last_name),unresolvedalias('first_name),unresolvedalias('ssn),unresolvedalias('occupation),(age#12L - 1) AS age#13]
    +- LogicalRDD [last_name#8,first_name#9,ssn#10,occupation#11,age#12L], MapPartitionsRDD[8] at applySchemaToPythonRDD at NativeMethodAccessorImpl.java:-2

    == Analyzed Logical Plan ==
    last_name: string, first_name: string, ssn: string, occupation: string, age: bigint
    Project [last_name#8,first_name#9,ssn#10,occupation#11,(age#12L - cast(1 as bigint)) AS age#13L]
    +- LogicalRDD [last_name#8,first_name#9,ssn#10,occupation#11,age#12L], MapPartitionsRDD[8] at applySchemaToPythonRDD at NativeMethodAccessorImpl.java:-2

    == Optimized Logical Plan ==
    Project [last_name#8,first_name#9,ssn#10,occupation#11,(age#12L - 1) AS age#13L]
    +- LogicalRDD [last_name#8,first_name#9,ssn#10,occupation#11,age#12L], MapPartitionsRDD[8] at applySchemaToPythonRDD at NativeMethodAccessorImpl.java:-2

    == Physical Plan ==
    Project [last_name#8,first_name#9,ssn#10,occupation#11,(age#12L - 1) AS age#13L]
    +- Scan ExistingRDD[last_name#8,first_name#9,ssn#10,occupation#11,age#12L]

*******************************
Use ``collect`` to view results
*******************************
.. admonition:: Execution of ``collect`` with four partitions

  - Here the dataset is broken into four partitions, so four ``collect()`` tasks are launched. 
  - Each **task** collects the entries in its **partition** and sends the result to the **driver**, which creates a list of the values.

  .. image:: http://spark-mooc.github.io/web-assets/images/cs105x/diagram-3d.png
     :align: center

- To see a list of elements decremented by one, we need to create a new list on the driver from the the data distributed in the executor nodes. 
- To do this we can call the ``collect()`` method on our DataFrame. 
- ``collect()`` is often used after transformations to ensure that we are only returning a small amount of data to the driver. 
  
  - This is done because the data returned to the driver must fit into the driver's available memory. If not, the driver will crash.
- ``collect`` is a Spark ``Action``
- ``Action`` operations cause Spark to perform the (lazy) transformation operations that are required to compute the values returned by the action. 
- In our example, this means that tasks will now be launched to perform the createDataFrame, select, and collect operations.   

.. code-block:: python

  >>> # Let's collect the data
  >>> results = subDF.collect()
  >>> print results
  (1) Spark Jobs
  [Row(last_name=u'Harvey', first_name=u'Tracey', ssn=u'160-37-9051', occupation=u'Agricultural engineer', age=38), Row(last_name=u'Green', first_name=u'Leslie', ssn=u'361-94-4342', occupation=u'Teacher, primary                               school', age=25), Row(last_name=u'Lewis', first_name=u'Tammy', ssn=u'769-27-5887', occupation=u'Scientific laboratory technician', age=20), Row(last_name=u'Cunningham', first_name=u'Kathleen', ssn=u'175-24-7915', occupation=u'Geophysicist/field seismologist', age=41), Row(last_name=u'Marquez', first_name=u'Joshua', ssn=u'310-69-7326', occupation=u'Forensic psychologist', age=25), Row(last_name=u'Summers', first_name=u'Beth', ssn=u'099-90-9730', occupation=u'Best boy', age=42), Row(last_name=u'Jessica', first_name=u'Mrs.', ssn=u'476-06-5497', occupation=u'English as a foreign language teacher', age=42), Row(last_name=u'Turner', first_name=u'Diana', ssn=u'722-09-8354', occupation=u'Psychologist, prison and probation services', age=6), Row(last_name=u'Johnson', first_name=u'Ryan', ssn=u'715-56-1708', occupation=u'Sales executive', age=4), Row(last_name=u'Lewis', first_name=u'Melissa', ssn=u'123-48-8354', occupation=u'Engineer, broadcasting (operations)', age=16), Row(last_name=u'Hernandez', first_name=u'Benjamin', ssn=u'293-22-0265', occupation=u'Scientist, product/process deve
  ...

*********************************
``display`` helper function in DB
*********************************

>>> display(subDF) 

.. image:: /_static/img/db_display_df.png
   :align: center

************************************
More actions: ``count`` to get total
************************************
The ``count()`` action will count the number of elements in a DataFrame.

- Because ``count()`` is an action operation, if we had not already performed an action with ``collect()``, then Spark would now perform the transformation operations when we executed ``count()``.
- Each task counts the entries in its partition and sends the result to your SparkContext, which adds up all of the counts. 

>>> # two actions here, so 2 spark jobs
>>> print dataDF.count()
>>> print subDF.count()
(2) Spark Jobs
10000
10000

.. admonition:: Figure shows what would happen if we ran ``count()`` on a small example dataset with just four partitions

  .. image:: http://spark-mooc.github.io/web-assets/images/cs105x/diagram-3e.png
     :align: center

*****************************************************************
Apply transformation ``filter`` and view results with ``collect``
*****************************************************************
.. image:: https://databricks.com/wp-content/uploads/2016/07/displaying-a-dataset-in-databricks.gif
   :align: center