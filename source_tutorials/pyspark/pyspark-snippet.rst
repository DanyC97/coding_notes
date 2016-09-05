``pyspark-snippet.rst``
"""""""""""""""""""""""
Just bunch of handy snippets for using pyspark in databricks.

#######
Modules
#######
.. code-block:: python

  >>> from pyspark import sql
  >>> from pprint import pprint
  >>> import os
  >>> import re
  >>> import datetime
  >>> print 'This was last run on: {0}'.format(datetime.datetime.now())
  This was last run on: 2016-09-05 03:53:21.809269

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