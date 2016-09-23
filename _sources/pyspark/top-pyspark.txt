.. _pyspark_notes:

PySpark Notes (``top-pyspark.rst``)
"""""""""""""""""""""""""""""""""""

.. toctree::
    :maxdepth: 1
    :numbered:
    :caption: Contents
    :name: top-pyspark

    pyspark-snippet
    pyspark-practice
    pyspark-overflow
    apache-prog-guide-df
    databricks

This note from mit on `mapreduce <http://nil.csail.mit.edu/6.824/2015/notes/l-mapreduce.txt>`__  and `spark <http://nil.csail.mit.edu/6.824/2015/notes/l-spark.txt>`__ is a nice refresher (from 2015, so prior to Spark 2.0): http://nil.csail.mit.edu/6.824/2015/schedule.html

In Databricks, these come preloaded

>>> print sc.version
>>> print type(sc)
>>> print type(sqlContext)
1.6.2
<class '__main__.RemoteContext'>
<class 'pyspark.sql.context.HiveContext'>

.. todo::

  To read

  - https://databricks.com/blog/2016/06/22/apache-spark-key-terms-explained.html (great refresher)
  - https://databricks.com/blog/2015/12/22/the-best-of-databricks-blog-most-read-posts-of-2015.html
  - https://databricks.com/blog/2015/02/17/introducing-dataframes-in-spark-for-large-scale-data-science.html

  Bunch of exercises

  - https://databricks.com/blog/2015/08/12/from-pandas-to-apache-sparks-dataframe.html
  - https://databricks.com/blog/2016/02/08/auto-scaling-scikit-learn-with-apache-spark.html

    - http://go.databricks.com/hubfs/notebooks/Samples/Miscellaneous/blog_post_cv.html
    - https://pypi.python.org/pypi/spark-sklearn

  Run PySpark with my local computer as the Driver, and with ipython

  - https://districtdatalabs.silvrback.com/getting-started-with-spark-in-python
  - http://spark.apache.org/examples.html
  - http://www.cloudera.com/documentation/enterprise/5-5-x/topics/spark_ipython.html
  - https://datasciencemadesimpler.wordpress.com/2016/06/23/develop-spark-code-with-jupyter-notebook/
  - http://ramhiser.com/2015/02/01/configuring-ipython-notebook-support-for-pyspark/
  - chrome://bookmarks/#17280 --- Running Spark on cluster like EC2 (2016-08-02)
  - http://stackoverflow.com/questions/33064031/link-spark-with-ipython-notebook/33065359#33065359

  Anaconda and Pyspark?

  - https://www.continuum.io/blog/developer-blog/using-anaconda-pyspark-distributed-language-processing-hadoop-cluster
  - https://www.dataquest.io/blog/pyspark-installation-guide/  

  PySpark with Windows?

  - http://www.ithinkcloud.com/tutorials/tutorial-on-how-to-install-apache-spark-on-windows/

  .. important::

    This looks promising:
    
    - http://jmdvinodjmd.blogspot.com/2015/08/installing-ipython-notebook-with-apache.html    