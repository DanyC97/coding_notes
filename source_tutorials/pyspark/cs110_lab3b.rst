cs110_lab3b_text_analysis_and_entity_resolution
"""""""""""""""""""""""""""""""""""""""""""""""
https://raw.githubusercontent.com/spark-mooc/mooc-setup/master/cs110_lab3b_text_analysis_and_entity_resolution.py

.. important:: 

  This is an actual homework program submitted to EdX. To adhere to the honor code, 
  the ``<FILL IN>`` is kept in my personal private `github repos <https://github.com/wtak23/private_repos/blob/master/cs105_lab2_solutions.rst>`__.

.. contents:: `Contents`
   :depth: 2
   :local:


- **Entity Resolution (ER)**, or **Record linkage** (`wiki <https://en.wikipedia.org/wiki/Record_linkage>`__) describes the process of joining records from one data source with another that describe the same entity. 
- Other synonymous terms include:

  - **"entity disambiguation/linking"**
  - **"duplicate detection"**, 
  - **"deduplication"**, 
  - **"record matching"**, 
  - **"(reference) reconciliation"**, 
  - **"object identification"**, 
  - **"data/information integration"**, 
  - **"conflation"**.
- ER refers to the task of finding records in a dataset that refer to the same entity across different data sources (e.g., data files, books, websites, databases). 
- ER is necessary when joining datasets based on entities that may or may not share a **common identifier** (e.g., database key, URI, National identification number), as may be the case due to differences in record shape, storage location, and/or curator style or preference. 
- A dataset that has undergone ER may be referred to as being **cross-linked**.

##########
Data files
##########
https://github.com/spark-mooc/mooc-setup/tree/master/metric-learning/data/3-amazon-googleproducts

The directory contains the following files:

- **Google.csv**, the Google Products dataset, named as targets.csv in the repository
- **Amazon.csv**, the Amazon dataset, named as sources.csv in the repository
- **Google_small.csv**, 200 records sampled from the Google data, subset of targets.csv
- **Amazon_small.csv**, 200 records sampled from the Amazon data, subset of sources.csv
- **Amazon_Google_perfectMapping.csv**, the "gold standard" mapping, named as mapping.csv in the repository
- **stopwords.txt**, a list of common English words

The "gold standard" file contains all of the true mappings between entities in the two datasets. 

- Every row in the gold standard file has a pair of record IDs (one Google, one Amazon) that belong to two records that describe the same thing in the real world. 
- We will use the gold standard to evaluate our algorithms.

#############
Preliminaries
#############


.. code-block:: python
    :linenos:

    import re
    DATAFILE_PATTERN = '^(.+),"(.+)",(.*),(.*),(.*)'

    def removeQuotes(s):
        """ Remove quotation marks from an input string
        Args:
            s (str): input string that might have the quote "" characters
        Returns:
            str: a string without the quote characters
        """
        return ''.join(i for i in s if i!='"')


    def parseDatafileLine(datafileLine):
        """ Parse a line of the data file using the specified regular expression pattern
        Args:
            datafileLine (str): input string that is a line from the data file
        Returns:
            str: a string parsed using the given regular expression and without the quote characters
        """
        match = re.search(DATAFILE_PATTERN, datafileLine)
        if match is None:
            print 'Invalid datafile line: %s' % datafileLine
            return (datafileLine, -1)
        elif match.group(1) == '"id"':
            print 'Header datafile line: %s' % datafileLine
            return (datafileLine, 0)
        else:
            product = '%s %s %s' % (match.group(2), match.group(3), match.group(4))
            return ((removeQuotes(match.group(1)), product), 1)

.. code-block:: python

    >>> # display(dbutils.fs.ls('/databricks-datasets/cs100/lab3/data-001'))
    >>> for _i,file_info in enumerate(dbutils.fs.ls('/databricks-datasets/cs100/lab3/data-001')):
    >>>   print _i,file_info
    0 FileInfo(path=u'dbfs:/databricks-datasets/cs100/lab3/data-001/Amazon.csv', name=u'Amazon.csv', size=1853189L)
    1 FileInfo(path=u'dbfs:/databricks-datasets/cs100/lab3/data-001/Amazon_Google_perfectMapping.csv', name=u'Amazon_Google_perfectMapping.csv', size=102234L)
    2 FileInfo(path=u'dbfs:/databricks-datasets/cs100/lab3/data-001/Amazon_small.csv', name=u'Amazon_small.csv', size=155487L)
    3 FileInfo(path=u'dbfs:/databricks-datasets/cs100/lab3/data-001/Google.csv', name=u'Google.csv', size=1070774L)
    4 FileInfo(path=u'dbfs:/databricks-datasets/cs100/lab3/data-001/Google_small.csv', name=u'Google_small.csv', size=64413L)
    5 FileInfo(path=u'dbfs:/databricks-datasets/cs100/lab3/data-001/stopwords.txt', name=u'stopwords.txt', size=622L)
    Command took 0.17s 

***************
Load data files
***************
.. code-block:: python

    >>> import sys
    >>> import os
    >>> from databricks_test_helper import Test
    ​>>> 
    >>> data_dir = os.path.join('databricks-datasets', 'cs100', 'lab3', 'data-001')
    ​>>> 
    >>> def parseData(filename):
    >>>     """ Parse a data file
    >>>     Args:
    >>>         filename (str): input file name of the data file
    >>>     Returns:
    >>>         RDD: a RDD of parsed lines
    >>>     """
    >>>     return (sc
    >>>             .textFile(filename, 4, 0)
    >>>             .map(parseDatafileLine)
    >>>             .cache())
    ​>>> 
    >>> def loadData(path):
    >>>     """ Load a data file
    >>>     Args:
    >>>         path (str): input file name of the data file
    >>>     Returns:
    >>>         RDD: a RDD of parsed valid lines
    >>>     """
    >>>     filename = 'dbfs:/' + os.path.join(data_dir, path)
    >>>     raw = parseData(filename).cache()
    >>>     failed = (raw
    >>>               .filter(lambda s: s[1] == -1)
    >>>               .map(lambda s: s[0]))
    >>>     for line in failed.take(10):
    >>>         print '%s - Invalid datafile line: %s' % (path, line)
    >>>     valid = (raw
    >>>              .filter(lambda s: s[1] == 1)
    >>>              .map(lambda s: s[0])
    >>>              .cache())
    >>>     print '%s - Read %d lines, successfully parsed %d lines, failed to parse %d lines' % (path,
    >>>                                                                                         raw.count(),
    >>>                                                                                         valid.count(),
    >>>                                                                                         failed.count())
    >>>     assert failed.count() == 0
    >>>     assert raw.count() == (valid.count() + 1)
    >>>     return valid
    >>> 
    >>> GOOGLE_PATH = 'Google.csv'
    >>> GOOGLE_SMALL_PATH = 'Google_small.csv'
    >>> AMAZON_PATH = 'Amazon.csv'
    >>> AMAZON_SMALL_PATH = 'Amazon_small.csv'
    >>> GOLD_STANDARD_PATH = 'Amazon_Google_perfectMapping.csv'
    >>> STOPWORDS_PATH = 'stopwords.txt'
    >>> 
    >>> googleSmall = loadData(GOOGLE_SMALL_PATH)
    >>> google = loadData(GOOGLE_PATH)
    >>> amazonSmall = loadData(AMAZON_SMALL_PATH)
    >>> amazon = loadData(AMAZON_PATH)
    (32) Spark Jobs
    Google_small.csv - Read 201 lines, successfully parsed 200 lines, failed to parse 0 lines
    Google.csv - Read 3227 lines, successfully parsed 3226 lines, failed to parse 0 lines
    Amazon_small.csv - Read 201 lines, successfully parsed 200 lines, failed to parse 0 lines
    Amazon.csv - Read 1364 lines, successfully parsed 1363 lines, failed to parse 0 lines
    Command took 4.14s 

************************
Examine the lines loaded
************************
We read in each of the files and create an RDD consisting of lines. 

- For each of the data files ("Google.csv", "Amazon.csv", and the samples), we want to **parse the IDs out of each record**. 
- The IDs are the first column of the file (they are URLs for Google, and alphanumeric strings for Amazon). 
- Omitting the headers, we load these data files into **pair RDDs** where:

  - ``key`` = the **mapping ID**
  - ``value`` = a string consisting of the name/title, description, and manufacturer from the record.

The file format of an Amazon line is:
``"id","title","description","manufacturer","price"``

The file format of a Google line is:
``"id","name","description","manufacturer","price"``



.. code-block:: python

    >>> for line in googleSmall.take(3):
    >>>     print 'google: %s: %s' % (line[0], line[1])
    google: http://www.google.com/base/feeds/snippets/11448761432933644608: spanish vocabulary builder "expand your vocabulary! contains fun lessons that both teach and entertain you'll quickly find yourself mastering new terms. includes games and more!" 
    google: http://www.google.com/base/feeds/snippets/8175198959985911471: topics presents: museums of world "5 cd-rom set. step behind the velvet rope to examine some of the most treasured collections of antiquities art and inventions. includes the following the louvre - virtual visit 25 rooms in full screen interactive video detailed map of the louvre ..." 
    google: http://www.google.com/base/feeds/snippets/18445827127704822533: sierrahome hse hallmark card studio special edition win 98 me 2000 xp "hallmark card studio special edition (win 98 me 2000 xp)" "sierrahome"

.. code-block:: python

    >>> for line in amazonSmall.take(3):
    >>>     print 'amazon: %s: %s' % (line[0], line[1])
    amazon: b000jz4hqo: clickart 950 000 - premier image pack (dvd-rom)  "broderbund"
    amazon: b0006zf55o: ca international - arcserve lap/desktop oem 30pk "oem arcserve backup v11.1 win 30u for laptops and desktops" "computer associates"
    amazon: b00004tkvy: noah's ark activity center (jewel case ages 3-8)  "victory multimedia"

#####################################
ER as Text Similarity - Bags of Words
#####################################
A simple approach to ER is to **treat all records as strings** and compute their similarity with a **string distance function**. 

- In this part, we will build some components for performing **bag-of-words text-analysis**, and then use them to compute **record similarity**. 
- Bag-of-words is a conceptually simple yet powerful approach to text analysis. 
- The idea is to treat strings, a.k.a. **documents**, as *unordered collections of words*, or **tokens**, i.e., as bags of words.

.. admonition:: Note on terminology

    - a "**token**" is the result of parsing the document down to the elements we consider "**atomic**" for the task at hand. 
    
      - Tokens can be things like words, numbers, acronyms, or other exotica like word-roots or fixed-length character strings. 
    - Bag of words techniques all apply to any sort of token, so when we say "**bag-of-words**" we really mean "**bag-of-tokens**," strictly speaking. 
    - **Tokens** become the atomic unit of text comparison. 

      - **To compare two documents**, we count how many tokens they share in common. 
      - **To search for documents** with keyword queries (what Google does), then we *turn the keywords into tokens* and find documents that contain them. 
    - The power of this approach is that it **makes string comparisons insensitive to small differences** that probably do not affect meaning much, for example, punctuation and word order.
   
*******************************
Exercise 1(a) Tokenize a String
*******************************
- Note that ``\W`` includes the "``_``" character.
- You should use ``re.split()`` to perform the string split. 
- Also:
  
  - make sure you remove any empty tokens
  - make sure you convert the string to lower case.

(`solution <https://github.com/wtak23/private_repos/blob/master/cs110_lab3b_solutions.rst#exercise-1-a-tokenize-a-string>`__)

.. code-block:: python

    >>> # TODO: Replace <FILL IN> with appropriate code
    >>> quickbrownfox = 'A quick brown fox jumps over the lazy dog.'
    >>> split_regex = r'\W+'
    >>> 
    >>> def simpleTokenize(string):
    >>>     """ A simple implementation of input string tokenization
    >>>     Args:
    >>>         string (str): input string
    >>>     Returns:
    >>>         list: a list of tokens
    >>>     """
    >>>     return <FILL IN>
    >>> 
    >>> print simpleTokenize(quickbrownfox) # Should give ['a', 'quick', 'brown', ... ]
    ['a', 'quick', 'brown', 'fox', 'jumps', 'over', 'the', 'lazy', 'dog']

    >>> # TEST Tokenize a String (1a)
    >>> Test.assertEquals(simpleTokenize(quickbrownfox),
    >>>                   ['a','quick','brown','fox','jumps','over','the','lazy','dog'],
    >>>                   'simpleTokenize should handle sample text')
    >>> Test.assertEquals(simpleTokenize(' '), [], 'simpleTokenize should handle empty string')
    >>> Test.assertEquals(simpleTokenize('!!!!123A/456_B/789C.123A'), ['123a','456_b','789c','123a'],
    >>>                   'simpleTokenize should handle punctuations and lowercase result')
    >>> Test.assertEquals(simpleTokenize('fox fox'), ['fox', 'fox'],
    >>>                   'simpleTokenize should not remove duplicates')
    1 test passed.
    1 test passed.
    1 test passed.
    1 test passed.