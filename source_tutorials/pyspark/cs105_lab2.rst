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

########################
Introduction and Imports
########################
.. admonition:: tl;dr of this section
   
   When referring to column by name, always use the ``df['col']`` syntax, not the **dot syntax** ``df.col``

   - the demo here shows a case where the **dot syntax** raises an error, while the 
     bracket syntax doesn't
   - (sorta obvious...same issue when using pandas too)

   All other part of this section is sorta obvious, so skipped noting.

.. code-block:: python

    >>> throwaway_df = sqlContext.createDataFrame([('Anthony', 10), ('Julia', 20), ('Fred', 5)], ('name', 'count'))
    >>> throwaway_df.show()
    (2) Spark Jobs
    +-------+-----+
    |   name|count|
    +-------+-----+
    |Anthony|   10|
    |  Julia|   20|
    |   Fred|    5|
    +-------+-----+

    >>> # This line does not work. ``count`` is a class method in a DF
    >>> throwaway_df.select(throwaway_df.count).show()
    AttributeError: 'function' object has no attribute '_get_object_id'

    >>> # so you hae to use the bracket syntax
    >>> throwaway_df.select(throwaway_df['count']).show()
    (2) Spark Jobs
    +-----+
    |count|
    +-----+
    |   10|
    |   20|
    |    5|
    +-----+


#########################
Exploratory Data Analysis
#########################
We'll use the following modules:

.. code-block:: python

    import sys
    import os
    
    import re
    import datetime
    from databricks_test_helper import Test

.. code-block:: python

    >>> # Specify path to downloaded log file
    >>> log_file_path = 'dbfs:/' + os.path.join('databricks-datasets',
    >>>     'cs100', 'lab2', 'data-001', 'apache.access.log.PROJECT')

    >>> base_df = sqlContext.read.text(log_file_path)
    >>> # Let's look at the schema
    >>> base_df.printSchema()
    root
     |-- value: string (nullable = true)

    >>> print base_df.count()
    1043177

    >>> # Let's look at the data 
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
    only showing top 7 rows

*************************
(2b) Parsing the log file
*************************

If you're familiar with web servers at all, you'll recognize that this is in `Common Log Format <https://www.w3.org/Daemon/User/Config/Logging.html#common-logfile-format>`__. 
The fields are:

``remotehost rfc931 authuser [date] "request" status bytes``

.. csv-table:: 
    :header: field, meaning
    :delim: |

    remotehost  |   Remote hostname (or IP number if DNS hostname is not available).
    rfc931      |   The remote logname of the user. We don't really care about this field.
    authuser    |   The username of the remote user, as authenticated by the HTTP server.
    [date]      |   The date and time of the request.
    ``"request"``   |   The request, exactly as it came from the browser or client.
    status      |   The HTTP status code the server sent back to the client.
    bytes       |   The number of bytes (Content-Length) transferred to the client.

.. code-block:: python

    >>> from pyspark.sql.functions import split, regexp_extract
    >>> split_df = base_df.select(regexp_extract('value', r'^([^\s]+\s)', 1).alias('host'),
    >>>                           regexp_extract('value', r'^.*\[(\d\d/\w{3}/\d{4}:\d{2}:\d{2}:\d{2} -\d{4})]', 1).alias('timestamp'),
    >>>                           regexp_extract('value', r'^.*"\w+\s+([^\s]+)\s+HTTP.*"', 1).alias('path'),
    >>>                           regexp_extract('value', r'^.*"\s+([^\s]+)', 1).cast('integer').alias('status'),
    >>>                           regexp_extract('value', r'^.*\s+(\d+)$', 1).cast('integer').alias('content_size'))
    >>> split_df.show(n=7,truncate=False)
    (1) Spark Jobs
    +----------------------------+--------------------------+-----------------------------------------------+------+------------+
    |host                        |timestamp                 |path                                           |status|content_size|
    +----------------------------+--------------------------+-----------------------------------------------+------+------------+
    |in24.inetnebr.com           |01/Aug/1995:00:00:01 -0400|/shuttle/missions/sts-68/news/sts-68-mcc-05.txt|200   |1839        |
    |uplherc.upl.com             |01/Aug/1995:00:00:07 -0400|/                                              |304   |0           |
    |uplherc.upl.com             |01/Aug/1995:00:00:08 -0400|/images/ksclogo-medium.gif                     |304   |0           |
    |uplherc.upl.com             |01/Aug/1995:00:00:08 -0400|/images/MOSAIC-logosmall.gif                   |304   |0           |
    |uplherc.upl.com             |01/Aug/1995:00:00:08 -0400|/images/USA-logosmall.gif                      |304   |0           |
    |ix-esc-ca2-07.ix.netcom.com |01/Aug/1995:00:00:09 -0400|/images/launch-logo.gif                        |200   |1713        |
    |uplherc.upl.com             |01/Aug/1995:00:00:10 -0400|/images/WORLD-logosmall.gif                    |304   |0           |
    +----------------------------+--------------------------+-----------------------------------------------+------+------------+
    only showing top 7 rows


*************
Data Cleaning
*************
.. code-block:: python

    >>> base_df.filter(base_df['value'].isNull()).count()
    (1) Spark Jobs
    Out[12]: 0

    >>> bad_rows_df = split_df.filter(split_df['host'].isNull() |
    >>>                               split_df['timestamp'].isNull() |
    >>>                               split_df['path'].isNull() |
    >>>                               split_df['status'].isNull() |
    >>>                              split_df['content_size'].isNull())
    >>> bad_rows_df.count()
    (1) Spark Jobs
    Out[13]: 8756

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

Not good. We have some null values. Something went wrong. Which columns are affected?

.. note:: Approach based on this SO http://stackoverflow.com/questions/33900726/count-number-of-non-nan-entries-in-each-column-of-spark-dataframe-with-pyspark/33901312

.. code-block:: python

    >>> from pyspark.sql.functions import col, sum
    >>> def count_null(col_name):
    >>>   return sum(col(col_name).isNull().cast('integer')).alias(col_name)
    >>> 
    >>> # Build up a list of column expressions, one per column.
    >>> #
    >>> # This could be done in one line with a Python list comprehension, but we're keeping
    >>> # it simple for those who don't know Python very well.
    >>> exprs = []
    >>> for col_name in split_df.columns:
    >>>   exprs.append(count_null(col_name))
    >>> 
    >>> # Run the aggregation. The *exprs converts the list of expressions into
    >>> # variable function arguments.
    >>> split_df.agg(*exprs).show()
    (1) Spark Jobs
    +----+---------+----+------+------------+
    |host|timestamp|path|status|content_size|
    +----+---------+----+------+------------+
    |   0|        0|   0|     0|        8756|
    +----+---------+----+------+------------+

.. todo:: Incomplete section

***********************************
Fix the rows with null content_size
***********************************

*********************
Parsing the timestamp
*********************

################################################
Analysis Walk-Through on the Web Server Log File
################################################
********************************
Example: Content Size Statistics
********************************
*****************************
Example: HTTP Status Analysis
*****************************

************************
Example: Status Graphing
************************

***********************
Example: Frequent Hosts
***********************

**************************
Example: Visualizing Paths
**************************

******************
Example: Top Paths
******************

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



