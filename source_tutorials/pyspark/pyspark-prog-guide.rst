Pyspark Programming Guide (from official page) ``pyspark-prog-guide``
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
http://spark.apache.org/docs/latest/sql-programming-guide.html

:TimeStamp: 09-05-2016 (00:55)

.. contents:: `Contents`
   :depth: 1
   :local:

.. note::

  Below is incomplete; I only took out codes that are informative.

  I did create a *skeleton* of TOC though.

########
Overview
########
- Spark SQL is a Spark module for **structured** data processing.
- Spark SQL uses the extra information from the **structure** to perform extra optimizations (so more optimized the basic ``Spark RDD API``).
- Spark SQL also has an API that's portable over languages (Scala, Java, Python, R)
All of the examples on this page use sample data included in the Spark distribution and can be run in the ``spark-shell``, ``pyspark shell``, or ``sparkR shell``.

***
SQL
***
One use of Spark SQL is to execute **SQL queries**. 

- Spark SQL can also be used to read data from an **existing Hive installation**. 

  - See the :ref:`Hive Tables section <pyspark_proguide_hive_tables>` for details on how to configure this feature. 
- When running SQL from within another programming language the results will be returned as a Dataset/DataFrame. 
- You can also interact with the SQL interface using the command-line or over JDBC/ODBC.

***********************
Datasets and DataFrames
***********************

Datasets
========
A **Dataset** is a distributed collection of data. 

- Dataset is a new interface added in Spark 1.6 that provides the benefits of RDDs with the benefits of Spark SQL's optimized execution engine. 

  - **Pros of RDDs**: strong typing, ability to use powerful lambda functions
- A Dataset can be constructed from **JVM objects** and then manipulated using **functional transformations** (map, flatMap, filter, etc.). 
- The ``Dataset API`` is available in Scala and Java. 

.. important:: Python does not have the support for the Dataset API. 

  But due to Python's dynamic nature, many of the benefits of the Dataset API are already available (i.e. you can access the field of a row by name naturally row.columnName). The case for R is similar.

DataFrame
=========
A **DataFrame** is a Dataset organized into named columns. 

- It is conceptually equivalent to a table in a relational database or a data frame in R/Python, but with **richer optimizations under the hood**. 
- DataFrames can be constructed from a wide array of sources such as: 

  - structured data files, 
  - tables in **Hive**, 
  - external databases, or 
  - existing RDDs. 

- The ``DataFrame API`` is available in Scala, Java, Python, and R. 
- In **Scala and Java**, a DataFrame is represented by a Dataset of Rows. 
  
  - In the Scala API, DataFrame is simply a type alias of ``Dataset[Row]``. 
  - In the Java API, users need to use ``Dataset<Row>`` to represent a DataFrame.
  - Throughout this document, we will often refer to Scala/Java Datasets of Rows as DataFrames.

###############
Getting Started
###############

.. important::

  Find full example code at "``examples/src/main/python/sql.py``" in the Spark repo.

********************************
Starting Point: ``SparkSession``
********************************
The entry point into all functionality in Spark is the ``SparkSession`` class. 

- To create a basic SparkSession, just use ``SparkSession.builder()``:
- SparkSession in Spark 2.0 provides **builtin support for Hive features** including:

  - the ability to write queries using **HiveQL**, 
  - access to **Hive UDFs**, and 
  - the ability to **read data from Hive tables**. 
- you do not need to have an existing Hive setup to use these features (nice!).

.. code-block:: python

    from pyspark.sql import SparkSession

    spark = SparkSession\
        .builder\
        .appName("PythonSQL")\
        .config("spark.some.config.option", "some-value")\
        .getOrCreate()

*******************
Creating DataFrames
*******************
With a ``SparkSession``, applications can create DataFrames from:

- an existing RDD, 
- from a Hive table, or 
- from Spark data sources (see :ref:`pyspark_proguide_data_sources`).

Below is an JSON file example

.. code-block:: python

    # spark is an existing SparkSession
    df = spark.read.json("examples/src/main/resources/people.json")

    # Displays the content of the DataFrame to stdout
    df.show()


*****************************************************
Untyped Dataset Operations (aka DataFrame Operations)
*****************************************************
.. code-block:: python
    :linenos:

    >>> # Create the DataFrame
    >>> df = spark.read.json("examples/src/main/resources/people.json")

    >>> # Show the content of the DataFrame
    >>> df.show()
    age  name
    null Michael
    30   Andy
    19   Justin

    >>> # Print the schema in a tree format
    >>> df.printSchema()
    root
    |-- age: long (nullable = true)
    |-- name: string (nullable = true)

    >>> # Select only the "name" column
    >>> df.select("name").show()
    name
    Michael
    Andy
    Justin

    >>> # Select everybody, but increment the age by 1
    >>> df.select(df['name'], df['age'] + 1).show()
    name    (age + 1)
    Michael null
    Andy    31
    Justin  20

    >>> # Select people older than 21
    >>> df.filter(df['age'] > 21).show()
    age name
    30  Andy

    >>> # Count people by age
    >>> df.groupBy("age").count().show()
    age  count
    null 1
    19   1
    30   1

************************************
Running SQL Queries Programmatically
************************************
.. code-block:: python

    df = spark.sql("SELECT * FROM table")

**************************************
Creating Datasets (only in Scala/Java)
**************************************
.. note:: Skipped...no python support

************************
Interoperating with RDDs
************************
Spark SQL supports two methods for converting existing RDDs into Datasets. 

The first method uses **reflection** to infer the schema of an RDD that contains specific types of objects. 

- This reflection based approach leads to **more concise code** and works well when you already know the schema while writing your Spark application.

The second method for creating Datasets is through a **programmatic interface** that allows you to construct a schema and then apply it to an existing RDD. 

- While this method is **more verbose**, it allows you to construct Datasets when the columns and their **types are not known until runtime**.


.. _pyspark_proguide_schema_refl:

Inferring the Schema Using Reflection
=====================================
Spark SQL can convert an RDD of ``Row`` objects to a DataFrame, **inferring the datatypes**.

- ``Rows`` are constructed by passing a **list of key/value pairs** as ``kwargs`` to the Row class (ie, pass a ``dict``). 
  
  - **keys**: define the column names of the table
  - **types**: inferred by sampling the whole datase, similar to the inference that is performed on JSON files.

.. code-block:: python
    :linenos:

    # spark is an existing SparkSession.
    from pyspark.sql import Row
    sc = spark.sparkContext

    # Load a text file and convert each line to a Row.
    lines = sc.textFile("examples/src/main/resources/people.txt")
    parts = lines.map(lambda l: l.split(","))
    people = parts.map(lambda p: Row(name=p[0], age=int(p[1])))

    # Infer the schema, and register the DataFrame as a table.
    schemaPeople = spark.createDataFrame(people)
    schemaPeople.createOrReplaceTempView("people")

    # SQL can be run over DataFrames that have been registered as a table.
    teenagers = spark.sql("SELECT name FROM people WHERE age >= 13 AND age <= 19")

    # The results of SQL queries are RDDs and support all the normal RDD operations.
    teenNames = teenagers.map(lambda p: "Name: " + p.name)
    for teenName in teenNames.collect():
      print(teenName)

Programmatically Specifying the Schema
======================================

When a dictionary of kwargs cannot be defined ahead of time, a DataFrame can be created programmatically with **three steps**.

#. **Create an RDD of tuples or lists** from the original RDD;
#. Create the schema represented by a ``StructType`` matching the structure of ``tuples`` or ``lists`` in the RDD created in the step 1.
#. Apply the schema to the RDD via ``createDataFrame`` method provided by ``SparkSession``.

For Example:

.. code-block:: python
    :linenos:

    # Import SparkSession and data types
    from pyspark.sql.types import *

    # spark is an existing SparkSession.
    sc = spark.sparkContext

    # Load a text file and convert each line to a tuple.
    lines = sc.textFile("examples/src/main/resources/people.txt")
    parts = lines.map(lambda l: l.split(","))
    people = parts.map(lambda p: (p[0], p[1].strip()))

    # The schema is encoded in a string.
    schemaString = "name age"

    fields = [StructField(field_name, StringType(), True) for field_name in schemaString.split()]
    schema = StructType(fields)

    # Apply the schema to the RDD.
    schemaPeople = spark.createDataFrame(people, schema)

    # Creates a temporary view using the DataFrame
    schemaPeople.createOrReplaceTempView("people")

    # SQL can be run over DataFrames that have been registered as a table.
    results = spark.sql("SELECT name FROM people")

    # The results of SQL queries are RDDs and support all the normal RDD operations.
    names = results.map(lambda p: "Name: " + p.name)
    for name in names.collect():
      print(name)

.. _pyspark_proguide_data_sources:

############
Data Sources
############
Spark SQL supports operating on a variety of data sources through the **DataFrame interface**. 

A DataFrame can be operated on using **relational transformations** and can also be used to create a **temporary view**. 

.. important:: Registering a DataFrame as a temporary view allows you to run SQL queries over its data. 


.. admonition:: Section overview

    This section describes the general methods for loading and saving data using the Spark Data Sources and then goes into specific options that are available for the built-in data sources.


######################
Generic Load Functions
######################

*****************
Default (parquet)
*****************
The default data source (``parquet`` unless otherwise configured by ``spark.sql.sources.default``) will be used for all operations.

.. note::
  
  From https://parquet.apache.org/

    Apache Parquet is a columnar storage format available to any project in the Hadoop ecosystem, regardless of the choice of data processing framework, data model or programming language.

  Also see :ref:`pyspark_proguide_parquet_files`

.. code-block:: python

    df = spark.read.load("examples/src/main/resources/users.parquet")
    df.select("name", "favorite_color").write.save("namesAndFavColors.parquet")

***************************
Manually Specifying Options
***************************
- Data sources are specified by their fully qualified name (i.e., ``org.apache.spark.sql.parquet``), but for built-in sources you can also use their short names (``json, parquet, jdbc``)
- DataFrames loaded from any data source type can be converted into other types using this syntax.

.. code-block:: python

    df = spark.read.load("examples/src/main/resources/people.json", format="json")
    df.select("name", "age").write.save("namesAndAges.parquet", format="parquet")

*************************
Run SQL on files directly
*************************
Instead of using read API to load a file into DataFrame and query it, you can also query that file directly with SQL.

.. code-block:: python

    df = spark.sql("SELECT * FROM parquet.`examples/src/main/resources/users.parquet`")

######################
Generic Save Functions
######################

**********
Save Modes
**********
Save operations can optionally take a ``SaveMode``, that specifies how to handle existing data if present. 

- It is important to realize that these save modes **do not utilize any locking** and are **not atomic**. 
- Additionally, when performing an Overwrite, the data will be deleted before writing out the new data.

.. csv-table:: 
    :header: Scala/JAVA, Any Language, Meaning
    :delim: |

    ``SaveMode.ErrorIfExists`` (default) | ``"error"`` (default) | When saving a DataFrame to a data source, if data already exists, an exception is expected to be thrown.
    ``SaveMode.Append`` | ``"append"`` | When saving a DataFrame to a data source, if data or table already exists, contents of the DataFrame are expected to be appended to existing data.
    ``SaveMode.Overwrite`` | ``"overwrite"`` |Overwrite mode means that when saving a DataFrame to a data source, if data/table already exists, existing data is expected to be overwritten by the contents of the DataFrame.
    ``SaveMode.Ignore`` | ``"ignore"`` | Ignore mode means that when saving a DataFrame to a data source, if data already exists, the save operation is expected to not save the contents of the DataFrame and to not change the existing data. This is similar to a CREATE TABLE IF NOT EXISTS in SQL.
    

*****************************
__Saving to Persistent Tables
*****************************
.. todo:: todo


.. _pyspark_proguide_parquet_files:

#############
Parquet Files
#############
`Parquet <http://parquet.io/>`__ is a columnar format that is supported by many other data processing systems. 

- Spark SQL provides support for both reading and writing Parquet files that automatically preserves the schema of the original data. 
- When writing Parquet files, all columns are automatically converted to be nullable for compatibility reasons. 

*****************************
Loading Data Programmatically
*****************************
Using the data from the above example:

.. code-block:: python
    :linenos:

    # spark from the previous example is used in this example.

    schemaPeople # The DataFrame from the previous example.

    # DataFrames can be saved as Parquet files, maintaining the schema information.
    schemaPeople.write.parquet("people.parquet")

    # Read in the Parquet file created above. Parquet files are self-describing so the schema is preserved.
    # The result of loading a parquet file is also a DataFrame.
    parquetFile = spark.read.parquet("people.parquet")

    # Parquet files can also be used to create a temporary view and then used in SQL statements.
    parquetFile.createOrReplaceTempView("parquetFile");
    teenagers = spark.sql("SELECT name FROM parquetFile WHERE age >= 13 AND age <= 19")
    teenNames = teenagers.map(lambda p: "Name: " + p.name)
    for teenName in teenNames.collect():
      print(teenName)

*********************
__Partition Discovery
*********************

**************
Schema Merging
**************
Like ProtocolBuffer, Avro, and Thrift, Parquet also supports schema evolution. Users can start with a simple schema, and gradually add more columns to the schema as needed. In this way, users may end up with multiple Parquet files with different but mutually compatible schemas. The Parquet data source is now able to automatically detect this case and merge schemas of all these files.

Since schema merging is a relatively expensive operation, and is not a necessity in most cases, we turned it off by default starting from 1.5.0. You may enable it by
setting data source option mergeSchema to true when reading Parquet files (as shown in the examples below), or
setting the global SQL option spark.sql.parquet.mergeSchema to true.

.. code-block:: python
    :linenos:

    # Create a simple DataFrame, stored into a partition directory
    df1 = spark.createDataFrame(sc.parallelize(range(1, 6))\
                                       .map(lambda i: Row(single=i, double=i * 2)))
    df1.write.parquet("data/test_table/key=1")

    # Create another DataFrame in a new partition directory,
    # adding a new column and dropping an existing column
    df2 = spark.createDataFrame(sc.parallelize(range(6, 11))
                                       .map(lambda i: Row(single=i, triple=i * 3)))
    df2.write.parquet("data/test_table/key=2")

    # Read the partitioned table
    df3 = spark.read.option("mergeSchema", "true").parquet("data/test_table")
    df3.printSchema()

::

    # The final schema consists of all 3 columns in the Parquet files together
    # with the partitioning column appeared in the partition directory paths.
    # root
    # |-- single: int (nullable = true)
    # |-- double: int (nullable = true)
    # |-- triple: int (nullable = true)
    # |-- key : int (nullable = true)

***********************************
__Hive metastore Parquet Conversion
***********************************

*************
Configuration
*************
Configuration of Parquet can be done using the ``setConf`` method on ``SparkSession`` or by running ``SET key=value`` commands using ``SQL``.

.. csv-table:: 
    :header: Property Name, Default, Meaning
    :delim: |

    ``spark.sql.parquet.binaryAsString`` | false | Some other Parquet-producing systems, in particular Impala, Hive, and older versions of Spark SQL, do not differentiate between binary data and strings when writing out the Parquet schema. This flag tells Spark SQL to interpret binary data as a string to provide compatibility with these systems.
    ``spark.sql.parquet.int96AsTimestamp``  | true | Some Parquet-producing systems, in particular Impala and Hive, store Timestamp into INT96. This flag tells Spark SQL to interpret INT96 data as a timestamp to provide compatibility with these systems.
    ``spark.sql.parquet.cacheMetadata`` | true |  Turns on caching of Parquet schema metadata. Can speed up querying of static data.
    ``spark.sql.parquet.compression.codec`` | gzip |  Sets the compression codec use when writing Parquet files. Acceptable values include: uncompressed, snappy, gzip, lzo.
    ``spark.sql.parquet.filterPushdown`` | true |  Enables Parquet filter push-down optimization when set to true.
    ``spark.sql.hive.convertMetastoreParquet``  | true | When set to false, Spark SQL will use the Hive SerDe for parquet tables instead of the built in support.
    ``spark.sql.parquet.mergeSchema`` | false | When true, the Parquet data source merges schemas collected from all data files, otherwise the schema is picked from the summary file or a random data file if no summary file is available.
#############
JSON Datasets
#############
::

  Spark SQL can automatically infer the schema of a JSON dataset and load it as a DataFrame. This conversion can be done using SparkSession.read.json on a JSON file.

  Note that the file that is offered as a json file is not a typical JSON file. Each line must contain a separate, self-contained valid JSON object. As a consequence, a regular multi-line JSON file will most often fail.

.. code-block:: python
    :linenos:

    >>> # A JSON dataset is pointed to by path.
    >>> # The path can be either a single text file or a directory storing text files.
    >>> people = spark.read.json("examples/src/main/resources/people.json")

    >>> # The inferred schema can be visualized using the printSchema() method.
    >>> people.printSchema()
    root
    |-- age: long (nullable = true)
    |-- name: string (nullable = true)

    >>> # Creates a temporary view using the DataFrame.
    >>> people.createOrReplaceTempView("people")

    >>> # SQL statements can be run by using the sql methods provided by `spark`.
    >>> teenagers = spark.sql("SELECT name FROM people WHERE age >= 13 AND age <= 19")

    >>> # Alternatively, a DataFrame can be created for a JSON dataset represented by
    >>> # an RDD[String] storing one JSON object per string.
    >>> anotherPeopleRDD = sc.parallelize([
    >>>   '{"name":"Yin","address":{"city":"Columbus","state":"Ohio"}}'])
    >>> anotherPeople = spark.jsonRDD(anotherPeopleRDD)

.. _pyspark_proguide_hive_tables:

###########
Hive Tables
###########
http://spark.apache.org/docs/latest/sql-programming-guide.html#hive-tables

.. code-block:: python

    # spark is an existing SparkSession

    spark.sql("CREATE TABLE IF NOT EXISTS src (key INT, value STRING)")
    spark.sql("LOAD DATA LOCAL INPATH 'examples/src/main/resources/kv1.txt' INTO TABLE src")

    # Queries can be expressed in HiveQL.
    results = spark.sql("FROM src SELECT key, value").collect()

*******************************************************
__Interacting with Different Versions of Hive Metastore
*******************************************************
http://spark.apache.org/docs/latest/sql-programming-guide.html#interacting-with-different-versions-of-hive-metastore

#########################
__JDBC To Other Databases
#########################
http://spark.apache.org/docs/latest/sql-programming-guide.html#jdbc-to-other-databases

.. code-block:: python

    df = spark.read.format('jdbc').options(url='jdbc:postgresql:dbserver', dbtable='schema.tablename').load()

##################
Performance Tuning
##################
.. important::
  
  For some workloads it is possible to improve performance by either:

  #. caching data in memory, or by 
  #. turning on some experimental options.

**********************
Caching Data in Memory
**********************
Spark SQL can cache tables using an in-memory columnar format by calling ``spark.cacheTable("tableName"``) or ``dataFrame.cache()``. 

- Then Spark SQL will scan only required columns and will automatically tune compression to minimize memory usage and GC pressure. 
- You can call ``spark.uncacheTable("tableName")`` to remove the table from memory.

.. note::

  Configuration of in-memory caching can be done using the ``setConf`` method on ``SparkSession`` or by running ``SET key=value`` commands using SQL.

.. csv-table:: 
    :header: Property Name, Default, Meaning
    :delim: |

    ``spark.sql.inMemoryColumnarStorage.compressed``  | true |  When set to true Spark SQL will automatically select a compression codec for each column based on statistics of the data.
    ``spark.sql.inMemoryColumnarStorage.batchSize`` | 10000 | Controls the size of batches for columnar caching. Larger batch sizes can improve memory utilization and compression, but risk OOMs when caching data

***************************
Other Configuration Options
***************************
.. note::  It is possible that these options will be deprecated in future release as more optimizations are performed automatically.

.. csv-table:: 
    :header: Property Name, Default, Meaning
    :delim: |

    ``spark.sql.files.maxPartitionBytes`` | 134217728 (128 MB) | The maximum number of bytes to pack into a single partition when reading files.
    ``spark.sql.files.openCostInBytes`` | 4194304 (4 MB) | The estimated cost to open a file, measured by the number of bytes could be scanned in the same time. This is used when putting multiple files into a partition. It is better to over estimated, then the partitions with small files will be faster than partitions with bigger files (which is scheduled first).
    ``spark.sql.autoBroadcastJoinThreshold``  | 10485760 (10 MB) | Configures the maximum size in bytes for a table that will be broadcast to all worker nodes when performing a join. By setting this value to -1 broadcasting can be disabled. Note that currently statistics are only supported for Hive Metastore tables where the command ANALYZE TABLE <tableName> COMPUTE STATISTICS noscan has been run.
    ``spark.sql.shuffle.partitions``  | 200 | Configures the number of partitions to use when shuffling data for joins or aggregations.
######################
Distributed SQL Engine
######################
Spark SQL can also act as a distributed query engine using its ``JDBC/ODBC`` or **command-line interface**. 

In this mode, end-users or applications can interact with Spark SQL directly to run SQL queries, without the need to write any code.

*************************************
__Running the Thrift JDBC/ODBC server
*************************************

*************************
Running the Spark SQL CLI
*************************
The Spark SQL CLI is a convenient tool to run the Hive metastore service in local mode and execute queries input from the command line. Note that the Spark SQL CLI cannot talk to the Thrift JDBC server.

To start the Spark SQL CLI, run the following in the Spark directory:

.. code-block:: bash

    ./bin/spark-sql

- To configure Hive, place your ``hive-site.xml``, ``core-site.xml`` and ``hdfs-site.xml`` files in ``conf/``. 
- You may run ``./bin/spark-sql --help`` for a complete list of all available options.

#########
Reference
#########

**********
Data-Types
**********
http://spark.apache.org/docs/latest/sql-programming-guide.html#data-types

*************
NaN Semantics
*************
There is specially handling for not-a-number (NaN) when dealing with float or double types that does not exactly match standard floating point semantics. 

.. important::

  - ``NaN = NaN`` returns true.
  - In aggregations all NaN values are grouped together.
  - NaN is treated as a normal value in join keys.
  - NaN values go last when in ascending order, larger than any other numeric value.