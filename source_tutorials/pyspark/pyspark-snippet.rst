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