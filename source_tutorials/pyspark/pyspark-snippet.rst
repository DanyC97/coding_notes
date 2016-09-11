``pyspark-snippet.rst``
"""""""""""""""""""""""
Just bunch of handy snippets for using pyspark in databricks.

#######
Modules
#######
.. code-block:: python

  >>> from pyspark import sql
  >>> from pyspark.sql import functions as F
  >>> from pprint import pprint
  >>> import os
  >>> import re
  >>> import datetime
  >>> print 'This was last run on: {0}'.format(datetime.datetime.now())
  This was last run on: 2016-09-05 03:53:21.809269

#############################################
spark_notebook_helpers library for Databricks
#############################################
- From :ref:`cs105_lab2`, :ref:`cs105_lab2.3c`
- to make more adjustments, use ``matplotlib``
- Here let's use a set of helper functions from the ``spark_notebook_helpers`` library. 


.. code-block:: python

    >>> # np is just an alias for numpy.
    >>> # cm and plt are aliases for matplotlib.cm (for "color map") and matplotlib.pyplot, respectively.
    >>> # prepareSubplot is a helper.
    >>> from spark_notebook_helpers import prepareSubplot, np, plt, cm
    >>> help(prepareSubplot)
    Help on function prepareSubplot in module spark_notebook_helpers:

    prepareSubplot(xticks, yticks, figsize=(10.5, 6), hideLabels=False, gridColor='#999999', gridWidth=1.0, subplots=(1, 1))
        Template for generating the plot layout.

##################
Create toy dataset
##################
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

##################
Print RDD per item
##################
Directly printing the ``list`` returned from ``take`` yields ugly print-out...
so print one item from the list at a time

.. code-block:: python

    def print_rdd(RDD,n=5):
      """ Directly printing the ``list`` returned from ``take`` yields ugly print-out...
         so print one item from the list at a time
      """
      for i,item in enumerate(RDD.take(n)):
        print i,item

############################################################
Databrick helper function displaying all DFs in the notebook
############################################################
Happend in lab 1

.. code-block:: python

  >>> from spark_notebook_helpers import printDataFrames
  ​>>> 
  >>> #This function returns all the DataFrames in the notebook and their corresponding column names.
  >>> printDataFrames(True)
  testPunctDF: ['_1']
  shakespeareDF: ['sentence']
  pluralLengthsDF: ['length_of_word']
  df: ['s', 'd']
  shakeWordsDF: ['word']
  sentenceDF: ['sentence']
  tmp: ['sentence']
  pluralDF: ['word']
  wordsDF: ['word']
  wordsDF2: ['word', 'tmp']
  wordCountsDF: ['word', 'count']

#######################################
Get shape of DF (gotta be a better way)
#######################################
.. code-block:: python
    
    # for ncol, take the length of the 1st row (head) 
    # for nrow, use built-in method ``count``
    print 'ncol = {},nrow = {}'.format(len(df.head()), df.count())


###############
Random snippets
###############

***********************************************
print dataframes in my workspace (super-ad-hoc)
***********************************************

>>> #assuming i have 'df' in my varname for DataFrames, print out what i got in my workspace
>>> filter(lambda _varname: 'df' in _varname,dir())
Out[59]: 
['bad_content_size_df',
 'bad_rows_df',
 'base_df',
 'cleaned_df',
 'paths_df',
 'split_df',
 'status_to_count_df',
 'throwaway_df',
 'udf']

*************
Rename column
*************
.. code-block:: python

    >>> # http://stackoverflow.com/questions/34077353/how-to-change-dataframe-column-names-in-pyspark
    >>> # Want to rename column 'count' (since i wanna join them first)
    >>> daily_hosts_df.show(n=3)
    +---+-----+
    |day|count|
    +---+-----+
    |  1| 2582|
    |  3| 3222|
    |  4| 4190|
    +---+-----+
    >>> # https://wtak23.github.io/pyspark/generated/generated/sql.DataFrame.withColumnRenamed.html
    >>> daily_hosts_df.withColumnRenamed('count','uniq_count').show(n=3)
    +---+----------+
    |day|uniq_count|
    +---+----------+
    |  1|      2582|
    |  3|      3222|
    |  4|      4190|
    +---+----------+


#######
dbutils
#######
Built-in helper for Databricks (from :ref:`cs110_lab1`)

.. code-block:: python

    >>> display(dbutils.fs.ls("/databricks-datasets/power-plant/data"))

    >>> print dbutils.fs.head("/databricks-datasets/power-plant/data/Sheet1.tsv")
    [Truncated to first 65536 bytes]
    AT  V AP  RH  PE
    14.96 41.76 1024.07 73.17 463.26
    25.18 62.96 1020.04 59.08 444.37
    5.11  39.4  1012.16 92.14 488.56
    20.86 57.32 1010.24 76.64 446.48
    10.82 37.5  1009.23 96.62 473.9
    26.27 59.44 1012.23 58.77 443.67
    15.89 43.96 1014.02 75.24 467.35
    9.48  44.71 1019.12 66.43 478.42
    14.64 45  1021.78 41.25 475.98
    11.74 43.56 1015.14 70.72 477.5
    17.99 43.72 1008.64 75.04 453.02
    20.14 46.93 1014.66 64.22 453.99
    24.34 73.5  1011.31 84.15 440.29
    25.71 58.59 1012.77 61.83 451.28
    26.19 69.34 1009.48 87.59 433.99
    21.42 43.79 1015.76 43.08 462.19
    18.21 45  1022.86 48.84 467.54
    11.04 41.74 1022.6  77.51 477.2
    14.45 52.75 1023.97 63.59 459.85

    >>> dbutils.fs.help()
    dbutils.fs provides utilities for working with FileSystems. Most methods in this package can take either a DBFS path (e.g., "/foo"), an S3 URI ("s3n://bucket/"), or another Hadoop FileSystem URI. For more info about a method, use dbutils.fs.help("methodName"). In notebooks, you can also use the %fs shorthand to access DBFS. The %fs shorthand maps straightforwardly onto dbutils calls. For example, "%fs head --maxBytes=10000 /file/path" translates into "dbutils.fs.head("/file/path", maxBytes = 10000)".
    fsutils
    cp(from: String, to: String, recurse: boolean = false): boolean -> Copies a file or directory, possibly across FileSystems
    head(file: String, maxBytes: int = 65536): String -> Returns up to the first 'maxBytes' bytes of the given file as a String encoded in UTF-8
    ls(dir: String): SchemaSeq -> Lists the contents of a directory
    mkdirs(dir: String): boolean -> Creates the given directory if it does not exist, also creating any necessary parent directories
    mv(from: String, to: String, recurse: boolean = false): boolean -> Moves a file or directory, possibly across FileSystems
    put(file: String, contents: String, overwrite: boolean = false): boolean -> Writes the given String out to a file, encoded in UTF-8
    rm(dir: String, recurse: boolean = false): boolean -> Removes a file or directory

    cache
    cacheFiles(files: Seq): boolean -> Caches a set of files on the local SSDs of this cluster
    cacheTable(tableName: String): boolean -> Caches the contents of the given table on the local SSDs of this cluster
    uncacheFiles(files: Seq): boolean -> Removes the cached version of the files
    uncacheTable(tableName: String): boolean -> Removes the cached version of the given table from SSDs

    mount
    chmod(path: String, user: String, permission: String): void -> Modifies the permissions of a mount point
    grants(path: String): SchemaSeq -> Lists the permissions associated with a mount point
    mount(source: String, mountPoint: String, encryptionType: String = "", owner: String = null): boolean -> Mounts the given source directory into DBFS at the given mount point
    mounts: SchemaSeq -> Displays information about what is mounted within DBFS
    refreshMounts: boolean -> Forces all machines in this cluster to refresh their mount cache, ensuring they receive the most recent information
    unmount(mountPoint: String): boolean -> Deletes a DBFS mount point