.. __edx_course_notes:

EdX Course Notes (``top-edx.rst``)
""""""""""""""""""""""""""""""""""
Notes I took when completing EdX's program series on `Data Science and Engineering with Spark <https://courses.edx.org/dashboard/programs/21/data-science-and-engineering-with-spark>`__.

.. important:: 

  To adhere to the honor code, I kept the content of ``<FILL IN>`` for the HW problems 
  in a separate personal private `github repos <https://github.com/wtak23/private_repos/>`__
  that only I have access to.

.. toctree::
    :maxdepth: 1
    :caption: Contents
    :name: top-edx
    :numbered:

    cs105_lab0
    cs105_lab1a
    cs105_lab1a_coding
    cs105_lab1b
    cs105_lab2
    cs110_lab1
    cs110_lab2
    cs110_lab3a
    cs110_lab3b
    cs120_lab1a
    cs120_lab1b
    cs120_lab2
    cs120_lab3
    cs120_lab4

In Databricks, these come preloaded

>>> print sc.version
>>> print type(sc)
>>> print type(sqlContext)
1.6.2
<class '__main__.RemoteContext'>
<class 'pyspark.sql.context.HiveContext'>