.. http://www.w3schools.com/html/html_css.asp

.. raw:: html

    <style> 
    .emph {color:red; font-weight: bold} 
    </style>

.. role:: emph

.. _cs105_lab2:

cs105_lab2_apache_log
"""""""""""""""""""""
https://github.com/spark-mooc/mooc-setup/blob/master/cs105_lab2_apache_log.py

.. important:: 

  This is an actual homework program submitted to EdX. To adhere to the honor code, 
  the ``<FILL IN>`` is kept in my personal private `github repos <https://github.com/wtak23/private_repos/blob/master/cs105_lab2_solutions.rst>`__.

.. contents:: `Contents`
   :depth: 2
   :local:

.. rubric:: During this lab we will cover:

#. Introduction and Imports
#. Exploratory Data Analysis
#. Analysis Walk-Through on the Web Server Log File
#. Analyzing Web Server Log File
#. Exploring 404 Response Codes

##########################################################
Part1: Overview: Web Server Log Analysis with Apache Spark
##########################################################
Perform **web server log analysis** with Apache Spark.

- **Server log analysis** is an ideal use case for Spark.  
- It's a very large, common data source and contains a rich set of information.  
- Spark allows you to store your logs in files on disk cheaply, while still providing a quick and simple way to perform data analysis on them.  
- :emph:`This homework` will show you how to use Apache Spark on **real-world text-based production logs** and fully harness the power of that data.  
- **Log data** comes from many sources:
  
  - web, file, and compute servers, application logs, user-generated content,  
- **Log data** can be used to:
  
  - monitor servers
  - improving business and customer intelligence
  - building **recommendation systems**, 
  - fraud detection, and much more.

*******************************
Modules used in this assignment
*******************************
.. code-block:: python

    >>> import re
    >>> import datetime
    >>> from pyspark.sql import functions as F
    >>> from databricks_test_helper import Test
    >>> 
    >>> import sys
    >>> import os
    >>> 
    >>> print 'This was last run on: {0}'.format(datetime.datetime.now())
    This was last run on: 2016-09-10 03:53:11.187741

************
Dataset used
************
Data set from **NASA Kennedy Space Center web server** in Florida. 

- The full data set is freely available at http://ita.ee.lbl.gov/html/contrib/NASA-HTTP.html, and it contains all **HTTP requests for two months**. 
- *We are using a subset* that only contains several days' worth of requests.


################################
Part2: Exploratory Data Analysis
################################
************************
2a) loading the log file
************************
.. note:: `sql.SparkSession <https://wtak23.github.io/pyspark/generated/generated/sql.SparkSession.html>`__
replaced `sql.SQLContext <https://wtak23.github.io/pyspark/generated/generated/sql.SQLContext.html>`__ as of Spark 2.0


.. note::

    Interestingly, ``sqlContext.read`` is an attribute representing a ``sql.DataFrameReader`` object

    I kept thinking it was a method until I looked up the doc.

    - https://wtak23.github.io/pyspark/generated/generated/sql.SparkSession.read.html
    - https://wtak23.github.io/pyspark/generated/generated/sql.DataFrameReader.html
    - https://wtak23.github.io/pyspark/generated/generated/sql.DataFrameReader.text.html

.. code-block:: python

    >>> log_file_path = 'dbfs:/' + os.path.join('databricks-datasets', 'cs100', 'lab2', 'data-001', 'apache.access.log.PROJECT')
    >>> print log_file_path
    dbfs:/databricks-datasets/cs100/lab2/data-001/apache.access.log.PROJECT

    >>> # I think schema inference is done here via sqlContext
    >>> base_df = sqlContext.read.text(log_file_path)
    >>> base_df.printSchema()


.. code-block:: python

    >>> base_df = sqlContext.read.text(log_file_path)
    >>> base_df.printSchema() # default from ``read.text`` gives colname *value* (see doc above)
    root
     |-- value: string (nullable = true)
    >>> print base_df.count() # number of rows
    1043177
    >>> base_df.show(n=7,truncate=False)
    (1) Spark Jobs
    +--------------------------------------------------------------------------------------------------------------------------+
    |value                                                                                                                     |
    +--------------------------------------------------------------------------------------------------------------------------+
    |in24.inetnebr.com - - [01/Aug/1995:00:00:01 -0400] "GET /shuttle/missions/sts-68/news/sts-68-mcc-05.txt HTTP/1.0" 200 1839|
    |uplherc.upl.com - - [01/Aug/1995:00:00:07 -0400] "GET / HTTP/1.0" 304 0                                                   |
    |uplherc.upl.com - - [01/Aug/1995:00:00:08 -0400] "GET /images/ksclogo-medium.gif HTTP/1.0" 304 0                          |
    |uplherc.upl.com - - [01/Aug/1995:00:00:08 -0400] "GET /images/MOSAIC-logosmall.gif HTTP/1.0" 304 0                        |
    |uplherc.upl.com - - [01/Aug/1995:00:00:08 -0400] "GET /images/USA-logosmall.gif HTTP/1.0" 304 0                           |
    |ix-esc-ca2-07.ix.netcom.com - - [01/Aug/1995:00:00:09 -0400] "GET /images/launch-logo.gif HTTP/1.0" 200 1713              |
    |uplherc.upl.com - - [01/Aug/1995:00:00:10 -0400] "GET /images/WORLD-logosmall.gif HTTP/1.0" 304 0                         |
    +--------------------------------------------------------------------------------------------------------------------------+

************************
2b) Parsing the log file
************************
If you're familiar with web servers, you'll recognize this is in :emph:`Common Log Format` (`link <https://www.w3.org/Daemon/User/Config/Logging.html#common-logfile-format>`__),
whose fields are:

.. csv-table:: 
    :header: field, meaning
    :delim: |

    remotehost  |   Remote hostname (or IP number if DNS hostname is not available).
    rfc931      |   The remote logname of the user. We don't really care about this field.
    authuser    |   The username of the remote user, as authenticated by the HTTP server.
    [date]      |   The date and time of the request.
    \"request\"   |   The request, exactly as it came from the browser or client.
    status      |   The HTTP status code the server sent back to the client.
    bytes       |   The number of bytes (Content-Length) transferred to the client.

Let's  **parse** this into individual columns. 

- use ``regexp_extract()`` function to do the parsing. 
  
  - https://wtak23.github.io/pyspark/generated/generated/sql.functions.regexp_extract.html
  - https://wtak23.github.io/pyspark/generated/generated/sql.functions.regexp_replace.html
- This function matches a column against a regexp with one or more capture groups and allows you to **extract one of the matched groups**. 
- We'll use one regular expression for each field we wish to extract. 

Some helpers

- My favorite quick-lookup for regex: http://www.rexegg.com/regex-quickstart.html
- HTTP methods: http://www.w3schools.com/tags/ref_httpmethods.asp
- HTTP message/status: http://www.w3schools.com/tags/ref_httpmessages.asp

``regexp_extract(str, pattern, idx)``

.. code-block:: python

    >>> base_df.show(n=1,truncate=False)
    +--------------------------------------------------------------------------------------------------------------------------+
    |value                                                                                                                     |
    +--------------------------------------------------------------------------------------------------------------------------+
    |in24.inetnebr.com - - [01/Aug/1995:00:00:01 -0400] "GET /shuttle/missions/sts-68/news/sts-68-mcc-05.txt HTTP/1.0" 200 1839|
    +--------------------------------------------------------------------------------------------------------------------------+

    >>> split_df = base_df.select(
    >>>   # \s = whitespace char, \d = digit char [0-9], \w = word char
    >>>   # 'host' field: ([^\s]+\s) means take group who DOESN'T begin with whitespace char, and regex stop when it encounters \s
    >>>   F.regexp_extract('value', r'^([^\s]+\s)', 1).alias('host'),
    >>>   # 'timestamp' field: capture group whose enclosed by bar bracket [] - parenthesis doesn't cover the bar-brack cuz you just want the timestamp.
    >>>   #                    it goes like: "2-dig/3-alpha/4-dig/2dig:2dig:2dig: -3dig"
    >>>   F.regexp_extract('value', r'^.*\[(\d{2}/\w{3}/\d{4}:\d{2}:\d{2}:\d{2} -\d{4})]', 1).alias('timestamp'),
    >>>   # 'path' field: ^.*" = take any char until you hit the double-quote char.  \w+\s = http request method. 
    >>>   #               Finally, ([^\s]+)\s+HTTP = keep extracing all non-whitespace char until you bump into \s followed up HTTP
    >>>   F.regexp_extract('value', r'^.*"\w+\s+([^\s]+)\s+HTTP.*"', 1).alias('path'),
    >>>   # 'status' field: http://www.w3schools.com/tags/ref_httpmessages.asp
    >>>   F.regexp_extract('value', r'^.*"\s+([^\s]+)', 1).cast('integer').alias('status'),
    >>>   # 'content_size' field: the ending series of digits 
    >>>   F.regexp_extract('value', r'^.*\s+(\d+)$', 1).cast('integer').alias('content_size'))
    >>> split_df.show(n=5,truncate=False)
    +------------------+--------------------------+-----------------------------------------------+------+------------+
    |host              |timestamp                 |path                                           |status|content_size|
    +------------------+--------------------------+-----------------------------------------------+------+------------+
    |in24.inetnebr.com |01/Aug/1995:00:00:01 -0400|/shuttle/missions/sts-68/news/sts-68-mcc-05.txt|200   |1839        |
    |uplherc.upl.com   |01/Aug/1995:00:00:07 -0400|/                                              |304   |0           |
    |uplherc.upl.com   |01/Aug/1995:00:00:08 -0400|/images/ksclogo-medium.gif                     |304   |0           |
    |uplherc.upl.com   |01/Aug/1995:00:00:08 -0400|/images/MOSAIC-logosmall.gif                   |304   |0           |
    |uplherc.upl.com   |01/Aug/1995:00:00:08 -0400|/images/USA-logosmall.gif                      |304   |0           |
    +------------------+--------------------------+-----------------------------------------------+------+------------+

*****************
2c) Data Cleaning
*****************
Issue: the above parsing generated some ``null`` rows.

Originally, we had no null columns

>>> base_df.filter(base_df['value'].isNull()).count()
Out[12]: 0

But craaaaaap, the above parsing unintentionally created some null row/col values....

>>> bad_rows_df = split_df.filter(split_df['host'].isNull() |
>>>                               split_df['timestamp'].isNull() |
>>>                               split_df['path'].isNull() |
>>>                               split_df['status'].isNull() |
>>>                              split_df['content_size'].isNull())
>>> bad_rows_df.count()
Out[13]: 8756

So something went wrong. Which columns are affected?

    >>> bad_rows_df.show(n=8)
    (1) Spark Jobs
    +--------------------+--------------------+--------------------+------+------------+
    |                host|           timestamp|                path|status|content_size|
    +--------------------+--------------------+--------------------+------+------------+
    |        gw1.att.com |01/Aug/1995:00:03...|/shuttle/missions...|   302|        null|
    |js002.cc.utsunomi...|01/Aug/1995:00:07...|/shuttle/resource...|   404|        null|
    |    tia1.eskimo.com |01/Aug/1995:00:28...|/pub/winvn/releas...|   404|        null|
    |itws.info.eng.nii...|01/Aug/1995:00:38...|/ksc.html/facts/a...|   403|        null|
    |grimnet23.idirect...|01/Aug/1995:00:50...|/www/software/win...|   404|        null|
    |miriworld.its.uni...|01/Aug/1995:01:04...|/history/history.htm|   404|        null|
    |      ras38.srv.net |01/Aug/1995:01:05...|/elv/DELTA/uncons...|   404|        null|
    | cs1-06.leh.ptd.net |01/Aug/1995:01:17...|                    |   404|        null|
    +--------------------+--------------------+--------------------+------+------------+
    only showing top 8 rows

.. note:: Approach based on this SO http://stackoverflow.com/questions/33900726/count-number-of-non-nan-entries-in-each-column-of-spark-dataframe-with-pyspark/33901312

.. code-block:: python

    >>> def count_null(col_name):
    >>>   return F.sum(F.col(col_name).isNull().cast('integer')).alias(col_name)

    >>> # Build up a list of column expressions, one per column.
    >>> exprs = [count_null(col_name) for col_name in split_df.columns]

    >>> for _i,_expr in enumerate(exprs):
    >>>   print _i,_expr
    0 Column<(sum(cast(isnull(host) as int)),mode=Complete,isDistinct=false) AS host#821>
    1 Column<(sum(cast(isnull(timestamp) as int)),mode=Complete,isDistinct=false) AS timestamp#822>
    2 Column<(sum(cast(isnull(path) as int)),mode=Complete,isDistinct=false) AS path#823>
    3 Column<(sum(cast(isnull(status) as int)),mode=Complete,isDistinct=false) AS status#824>
    4 Column<(sum(cast(isnull(content_size) as int)),mode=Complete,isDistinct=false) AS content_size#825>

    >>> # Run the aggregation. The *exprs converts the list of expressions into variable function arguments.
    >>> split_df.agg(*exprs).show()
    +----+---------+----+------+------------+
    |host|timestamp|path|status|content_size|
    +----+---------+----+------+------------+
    |   0|        0|   0|     0|        8756|
    +----+---------+----+------+------------+

- So all the ``null`` occurs in the ``content_size`` column.
- Here's the original parsing regexp used:

.. code-block:: python

    regexp_extract('value', r'^.*\s+(\d+)$', 1).cast('integer').alias('content_size')

- The ``\d+`` selects one or more digits at the end of the input line. 
- Let's see if there are any lines that do not end with one or more digits.

>>> bad_content_size_df = base_df.filter(~ base_df['value'].rlike(r'\d+$'))
>>> bad_content_size_df.count()
Out[34]: 8756

- Ah, there's the error. :emph:`the count mathces the number of rows` in ``bad_rows_df``
- Let's take a look at some of the bad column values.

>>> bad_content_size_df.select(
>>>   F.concat(bad_content_size_df['value'], F.lit('*'))
>>>  ).show(n=6,truncate=False)
+----------------------------------------------------------------------------------------------------------------------------+
|concat(value,*)                                                                                                             |
+----------------------------------------------------------------------------------------------------------------------------+
|gw1.att.com - - [01/Aug/1995:00:03:53 -0400] "GET /shuttle/missions/sts-73/news HTTP/1.0" 302 -*                            |
|js002.cc.utsunomiya-u.ac.jp - - [01/Aug/1995:00:07:33 -0400] "GET /shuttle/resources/orbiters/discovery.gif HTTP/1.0" 404 -*|
|tia1.eskimo.com - - [01/Aug/1995:00:28:41 -0400] "GET /pub/winvn/release.txt HTTP/1.0" 404 -*                               |
|itws.info.eng.niigata-u.ac.jp - - [01/Aug/1995:00:38:01 -0400] "GET /ksc.html/facts/about_ksc.html HTTP/1.0" 403 -*         |
|grimnet23.idirect.com - - [01/Aug/1995:00:50:12 -0400] "GET /www/software/winvn/winvn.html HTTP/1.0" 404 -*                 |
|miriworld.its.unimelb.edu.au - - [01/Aug/1995:01:04:54 -0400] "GET /history/history.htm HTTP/1.0" 404 -*                    |
+----------------------------------------------------------------------------------------------------------------------------+

.. admonition:: Reason for error

    - The bad rows correspond to **error results**, 

      - here no content was sent back and the server emitted a ``"-"`` for the ``content_size`` field. 
      - we don't want to discard those rows from our analysis, so let's map them to 0. 

***********************************
Fix the rows with null content_size
***********************************
- Two ways to replace null values in a DF.

  - ``fillna()``, which fills null values with specified non-null values.
  - ``na``, which returns a ``DataFrameNaFunctions`` object with many functions for operating on null columns.
- We'll use ``fillna()``, because it's simple. 
- There are several ways to invoke this function. 

  - the easiest way: replace all null columns with known values. 
  - better way (for safety): pass a dictionary containing ``(column_name, value)`` mappings. That's what we'll do.

- https://wtak23.github.io/pyspark/generated/generated/sql.DataFrame.fillna.html
- https://wtak23.github.io/pyspark/generated/generated/sql.DataFrame.na.html
- https://wtak23.github.io/pyspark/generated/generated/sql.DataFrameNaFunctions.html

.. code-block:: python

    >>> # Replace all null content_size values with 0.
    >>> cleaned_df = split_df.na.fill({'content_size': 0})

    >>> # Ensure that there are no nulls left (recall ``count_null`` is a function i defined above)
    >>> exprs = [count_null(col_name) for col_name in cleaned_df.columns]

    >>> cleaned_df.agg(*exprs).show()
    +----+---------+----+------+------------+
    |host|timestamp|path|status|content_size|
    +----+---------+----+------+------------+
    |   0|        0|   0|     0|           0|
    +----+---------+----+------+------------+


*********************
Parsing the timestamp
*********************
- we now have a clean, parsed DataFrame
- next we have to **parse the timestamp field** into an actual ``timestamp``. 
- The** Common Log Format time** is somewhat non-standard. 
  
  - A User-Defined Function (UDF) is the most straightforward way to parse it. 
  - https://wtak23.github.io/pyspark/generated/generated/sql.functions.udf.html

.. admonition:: Define UDF
   
   .. code-block:: python
   
       month_map = {
         'Jan': 1, 'Feb': 2, 'Mar':3, 'Apr':4, 'May':5, 'Jun':6, 'Jul':7,
         'Aug':8,  'Sep': 9, 'Oct':10, 'Nov': 11, 'Dec': 12
       }

       def parse_clf_time(s):
           """ Convert Common Log time format into a Python datetime object
           Args:
               s (str): date and time in Apache time format [dd/mmm/yyyy:hh:mm:ss (+/-)zzzz]
           Returns:
               a string suitable for passing to CAST('timestamp')
           """
           # NOTE: We're ignoring time zone here. In a production application, you'd want to handle that.
           return "{0:04d}-{1:02d}-{2:02d} {3:02d}:{4:02d}:{5:02d}".format(
             int(s[7:11]),
             month_map[s[3:6]],
             int(s[0:2]),
             int(s[12:14]),
             int(s[15:17]),
             int(s[18:20])
           )

       u_parse_time = F.udf(parse_clf_time)

Alright, let's use this UDF to append a column `time`.

.. code-block:: python

    >>> col_to_append = (u_parse_time(cleaned_df['timestamp'])
    >>>                  .cast('timestamp') # convert column type. https://wtak23.github.io/pyspark/generated/generated/sql.Column.cast.html
    >>>                  .alias('time')     # rename
    >>> )
    >>> print col_to_append
    Column<cast(PythonUDF#parse_clf_time(timestamp) as timestamp) AS time#1975>

    >>> # now append column to our parsed, cleaned dataframe 
    >>> logs_df = cleaned_df.select('*', col_to_append)
    >>> logs_df.show(n=5,truncate=False)
    +------------------+--------------------------+-----------------------------------------------+------+------------+---------------------+
    |host              |timestamp                 |path                                           |status|content_size|time                 |
    +------------------+--------------------------+-----------------------------------------------+------+------------+---------------------+
    |in24.inetnebr.com |01/Aug/1995:00:00:01 -0400|/shuttle/missions/sts-68/news/sts-68-mcc-05.txt|200   |1839        |1995-08-01 00:00:01.0|
    |uplherc.upl.com   |01/Aug/1995:00:00:07 -0400|/                                              |304   |0           |1995-08-01 00:00:07.0|
    |uplherc.upl.com   |01/Aug/1995:00:00:08 -0400|/images/ksclogo-medium.gif                     |304   |0           |1995-08-01 00:00:08.0|
    |uplherc.upl.com   |01/Aug/1995:00:00:08 -0400|/images/MOSAIC-logosmall.gif                   |304   |0           |1995-08-01 00:00:08.0|
    |uplherc.upl.com   |01/Aug/1995:00:00:08 -0400|/images/USA-logosmall.gif                      |304   |0           |1995-08-01 00:00:08.0|
    +------------------+--------------------------+-----------------------------------------------+------+------------+---------------------+

    >>> # drop the 'timestamp' field we originally had
    >>> logs_df = logs_df.drop('timestamp')
    >>> logs_df.show(n=5,truncate=False)
    +------------------+-----------------------------------------------+------+------------+---------------------+
    |host              |path                                           |status|content_size|time                 |
    +------------------+-----------------------------------------------+------+------------+---------------------+
    |in24.inetnebr.com |/shuttle/missions/sts-68/news/sts-68-mcc-05.txt|200   |1839        |1995-08-01 00:00:01.0|
    |uplherc.upl.com   |/                                              |304   |0           |1995-08-01 00:00:07.0|
    |uplherc.upl.com   |/images/ksclogo-medium.gif                     |304   |0           |1995-08-01 00:00:08.0|
    |uplherc.upl.com   |/images/MOSAIC-logosmall.gif                   |304   |0           |1995-08-01 00:00:08.0|
    |uplherc.upl.com   |/images/USA-logosmall.gif                      |304   |0           |1995-08-01 00:00:08.0|
    +------------------+-----------------------------------------------+------+------------+---------------------+

    >>> total_log_entries = logs_df.count()
    >>> print total_log_entries 
    1043177

    >>> logs_df.printSchema()
    root
     |-- host: string (nullable = true)
     |-- path: string (nullable = true)
     |-- status: integer (nullable = true)
     |-- content_size: integer (nullable = false)
     |-- time: timestamp (nullable = true)


Alright. We're in business.

#######################################################
Part3: Analysis Walk-Through on the Web Server Log File
#######################################################
.. important::

    Let's cache ``logs_df`` from above. We're gonna use it quite often.

    >>> logs_df.cache()
    Out[55]: DataFrame[host: string, path: string, status: int, content_size: int, time: timestamp]


************************************
3a) Example: Content Size Statistics
************************************
- This is like pandas describe method.
- https://en.wikipedia.org/wiki/Five-number_summary

>>> # Calculate statistics based on the content size.
>>> content_size_summary_df = logs_df.describe(['content_size'])
>>> content_size_summary_df.show()
+-------+------------------+
|summary|      content_size|
+-------+------------------+
|  count|           1043177|
|   mean|17531.555702435926|
| stddev| 68561.99906264187|
|    min|                 0|
|    max|           3421948|
+-------+------------------+

- For more flexibility, pass ``sql.functions`` functions to ``agg()``

  - https://wtak23.github.io/pyspark/generated/sql.functions.html
  - https://wtak23.github.io/pyspark/generated/generated/sql.DataFrame.agg.html

>>> content_size_stats =  (logs_df
>>>                        .agg(F.min(logs_df['content_size']),
>>>                             F.avg(logs_df['content_size']),
>>>                             F.max(logs_df['content_size']))
>>>                        .first())
>>> print 'Content Size Avg: {1:,.2f}; Min: {0:.2f}; Max: {2:,.0f}'.format(*content_size_stats)
Content Size Avg: 17,531.56; Min: 0.00; Max: 3,421,948

*********************************
3b) Example: HTTP Status Analysis
*********************************
Refresher on the DF structure

>>> logs_df.show(n=3,truncate=False)
+------------------+-----------------------------------------------+------+------------+---------------------+
|host              |path                                           |status|content_size|time                 |
+------------------+-----------------------------------------------+------+------------+---------------------+
|in24.inetnebr.com |/shuttle/missions/sts-68/news/sts-68-mcc-05.txt|200   |1839        |1995-08-01 00:00:01.0|
|uplherc.upl.com   |/                                              |304   |0           |1995-08-01 00:00:07.0|
|uplherc.upl.com   |/images/ksclogo-medium.gif                     |304   |0           |1995-08-01 00:00:08.0|
+------------------+-----------------------------------------------+------+------------+---------------------+

Alright, let's use ``groupBy`` to get insight in the ``status`` field

>>> status_to_count_df =(logs_df
>>>                      .groupBy('status')
>>>                      .count()  
>>>                      .sort('status') # sort by the 'status' field
>>>                      .cache())       # remember to cache if you're gonna use this DF a lot
​>>> 
>>> status_to_count_length = status_to_count_df.count()
>>> print 'Found %d response codes' % status_to_count_length
>>> status_to_count_df.show()
Found 7 response codes
+------+------+
|status| count|
+------+------+
|   200|940847|
|   302| 16244|
|   304| 79824|
|   403|    58|
|   404|  6185|
|   500|     2|
|   501|    17|
+------+------+

.. _cs105_lab2.3c:

****************************
3c) Example: Status Graphing
****************************
>>> display(status_to_count_df)

.. image:: http://spark-mooc.github.io/web-assets/images/cs105x/plot_options_1.png
   :align: center

Let's take the log since the ``200`` status dominates the count

>>> log_status_to_count_df = status_to_count_df.withColumn('log(count)', F.log(status_to_count_df['count']))
>>> display(log_status_to_count_df)

.. image:: /_static/img/105_lab2_3c.png
   :align: center

.. admonition:: note --- the use of ``withColumn`` to append column
   
   - recall the SO thread on how to append cols

     - http://stackoverflow.com/questions/33681487/how-do-i-add-a-new-column-to-spark-data-frame-pyspark
   - https://wtak23.github.io/pyspark/generated/generated/sql.DataFrame.withColumn.html

   >>> status_to_count_df.show(n=3,truncate=False)
   +------+------+
   |status|count |
   +------+------+
   |200   |940847|
   |302   |16244 |
   |304   |79824 |
   +------+------+
   >>> log_status_to_count_df = status_to_count_df.withColumn('log(count)', F.log(status_to_count_df['count']))
   >>> log_status_to_count_df.show(n=3,truncate=False)
   +------+------+------------------+
   |status|count |log(count)        |
   +------+------+------------------+
   |200   |940847|13.75453581236166 |
   |302   |16244 |9.69547888880619  |
   |304   |79824 |11.287579490100818|
   +------+------+------------------+

- k, that's a bit better.
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


Let' use the ``Set1`` colormap
http://matplotlib.org/examples/color/colormaps_reference.html

.. code-block:: python

    data = log_status_to_count_df.drop('count').collect()
    x, y = zip(*data)
    index = np.arange(len(x))
    bar_width = 0.7
    colorMap = 'Set1'
    cmap = cm.get_cmap(colorMap)
    #
    fig, ax = prepareSubplot(np.arange(0, 6, 1), np.arange(0, 14, 2))
    plt.bar(index, y, width=bar_width, color=cmap(0))
    plt.xticks(index + bar_width/2.0, x)
    display(fig)

.. image:: /_static/img/105_lab2_3c2.png
   :align: center
   
***************************
3d) Example: Frequent Hosts
***************************

******************************
3e) Example: Visualizing Paths
******************************

**********************
3f) Example: Top Paths
**********************

#############################
Analyzing Web Server Log File
#############################

******************************************
Exercise: Top Ten Error Paths (HW Problem)
******************************************

.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code
    # You are welcome to structure your solution in a different way, so long as
    # you ensure the variables used in the next Test section are defined

    # DataFrame containing all accesses that did not return a code 200
    from pyspark.sql.functions import desc
    not200DF = logs_df.<FILL IN>
    not200DF.show(10)
    # Sorted DataFrame containing all paths and the number of times they were accessed with non-200 return code
    logs_sum_df = not200DF.<FILL IN>

    print 'Top Ten failed URLs:'
    logs_sum_df.show(10, False)


*************************************
Exercise: Number of Unique Hosts (HW)
*************************************
.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code
    unique_host_count = <FILL IN>
    print 'Unique hosts: {0}'.format(unique_host_count)


**************************************
Exercise: Number of Unique Daily Hosts
**************************************
.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code
    from pyspark.sql.functions import dayofmonth

    day_to_host_pair_df = logs_df.<FILL IN>
    day_group_hosts_df = day_to_host_pair_df.<FILL IN>
    daily_hosts_df = day_group_hosts_df.<FILL IN>

    print 'Unique hosts per day:'
    daily_hosts_df.show(30, False)

******************************************************
Exercise: Visualizing the Number of Unique Daily Hosts
******************************************************
.. code-block:: python

    # TODO: Your solution goes here

    days_with_hosts = <FILL IN>
    hosts = <FILL IN>
    for <FILL IN>:
      <FILL IN>

    print(days_with_hosts)
    print(hosts)

***************************************************
Exercise: Average Number of Daily Requests per Host
***************************************************
.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code

    total_req_per_day_df = logs_df.<FILL IN>

    avg_daily_req_per_host_df = (
      total_req_per_day_df.<FILL IN>
    )

    print 'Average number of daily requests per Hosts is:\n'
    avg_daily_req_per_host_df.show()


****************************************************************
Exercise: Visualizing the Average Daily Requests per Unique Host
****************************************************************
.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code

    days_with_avg = (avg_daily_req_per_host_df.<FILL IN>)
    avgs = (avg_daily_req_per_host_df.<FILL IN>)
    for <FILL IN>:
      <FILL IN>

    print(days_with_avg)
    print(avgs)

As a comparison to the prior plot, use the Databricks display function to plot a line graph of the average daily requests per unique host by day.

.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code
    display(<FILL IN>)

##########################
Exploring 404 Status Codes
##########################

*************************************
Exercise: Counting 404 Response Codes
*************************************
.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code

    not_found_df = logs_df.<FILL IN>
    print('Found {0} 404 URLs').format(not_found_df.count())

*****************************************
Exercise: Listing 404 Status Code Records
*****************************************
.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code

    not_found_paths_df = not_found_df.<FILL IN>
    unique_not_found_paths_df = not_found_paths_df.<FILL IN>

    print '404 URLS:\n'
    unique_not_found_paths_df.show(n=40, truncate=False)

********************************************************
Exercise: Listing the Top Twenty 404 Response Code paths
********************************************************
.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code

    top_20_not_found_df = not_found_paths_df.<FILL IN>

    print 'Top Twenty 404 URLs:\n'
    top_20_not_found_df.show(n=20, truncate=False)

*************************************************************
Exercise: Listing the Top Twenty-five 404 Response Code Hosts
*************************************************************
.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code

    hosts_404_count_df = not_found_df.<FILL IN>

    print 'Top 25 hosts that generated errors:\n'
    hosts_404_count_df.show(n=25, truncate=False)

************************************
Exercise: Listing 404 Errors per Day
************************************
.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code

    errors_by_date_sorted_df = not_found_df.<FILL IN>

    print '404 Errors by day:\n'
    errors_by_date_sorted_df.show()

*******************************************
Exercise: Visualizing the 404 Errors by Day
*******************************************
.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code

    days_with_errors_404 = <FILL IN>
    errors_404_by_day = <FILL IN>
    for <FILL IN>:
      <FILL IN>

    print days_with_errors_404
    print errors_404_by_day


**************************************
Exercise: Top Five Days for 404 Errors
**************************************
.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code

    top_err_date_df = errors_by_date_sorted_df.<FILL IN>

    print 'Top Five Dates for 404 Requests:\n'
    top_err_date_df.show(5)

***************************
Exercise: Hourly 404 Errors
***************************
.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code
    from pyspark.sql.functions import hour
    hour_records_sorted_df = not_found_df.<FILL IN>

    print 'Top hours for 404 requests:\n'
    hour_records_sorted_df.show(24)

****************************************************
Exercise: Visualizing the 404 Response Codes by Hour
****************************************************
.. code-block:: python

    # TODO: Replace <FILL IN> with appropriate code
    ​
    hours_with_not_found = <FILL IN>
    not_found_counts_per_hour = <FILL IN>
    ​
    print hours_with_not_found
    print not_found_counts_per_hour



