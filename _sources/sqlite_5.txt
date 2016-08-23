#########################
SQLite - useful functions
#########################
from http://www.tutorialspoint.com/sqlite/sqlite_useful_functions.htm

************************
Summary of key functions
************************
.. csv-table:: 
    :widths: 20,70
    :delim: |

    COUNT   |    (agg fcn) count the number of rows in a database table.
    MAX     |    (agg fcn) select the highest (maximum) value for a certain column.
    MIN     |    (agg fcn) select the lowest (minimum) value for a certain column.
    AVG     |    (agg fcn) average value for certain table column.
    SUM     |    (agg fcn) total for a numeric column.
    RANDOM  |    returns a pseudo-random integer between -9223372036854775808 and +9223372036854775807.
    ABS     |    returns the absolute value of the numeric argument.
    UPPER   |    converts a string into upper-case letters.
    LOWER   |    converts a string into lower-case letters.
    LENGTH  |    returns the length of a string.
    sqlite_version      |    The SQLite sqlite_version function returns the version of the SQLite library.

********
Examples
********
Suppose we have the following table called COMPANY

.. code-block:: sql
    
    ID          NAME        AGE         ADDRESS     SALARY
    ----------  ----------  ----------  ----------  ----------
    1           Paul        32          California  20000.0
    2           Allen       25          Texas       15000.0
    3           Teddy       23          Norway      20000.0
    4           Mark        25          Rich-Mond   65000.0
    5           David       27          Texas       85000.0
    6           Kim         22          South-Hall  45000.0
    7           James       24          Houston     10000.0


.. code-block:: sql

    -- count
    sqlite> SELECT count(*) FROM COMPANY;
    count(*)
    ----------
    7

    -- MAX
    sqlite> SELECT max(salary) FROM COMPANY;
    max(salary)
    -----------
    85000.0

    -- AVG
    sqlite> SELECT avg(salary) FROM COMPANY;
    avg(salary)
    ----------------
    37142.8571428572

    -- SUM
    sqlite> SELECT sum(salary) FROM COMPANY;
    sum(salary)
    -----------
    260000.0

    --RANDOM
    sqlite> SELECT random() AS Random;
    Random
    -------------------
    5876796417670984050

    -- ABS
    sqlite> SELECT abs(5), abs(-15), abs(NULL), abs(0), abs("ABC");
    abs(5)      abs(-15)    abs(NULL)   abs(0)      abs("ABC")
    ----------  ----------  ----------  ----------  ----------
    5           15                      0           0.0

    -- UPPER
    sqlite> SELECT upper(name) FROM COMPANY;
    upper(name)
    -----------
    PAUL
    ALLEN
    TEDDY
    MARK
    DAVID
    KIM
    JAMES

    -- lower
    sqlite> SELECT lower(name) FROM COMPANY;
    lower(name)
    -----------
    paul
    allen
    teddy
    mark
    david
    kim
    james

    -- LENGTH
    sqlite> SELECT name, length(name) FROM COMPANY;
    NAME        length(name)
    ----------  ------------
    Paul        4
    Allen       5
    Teddy       5
    Mark        4
    David       5
    Kim         3
    James       5

    -- sqlite_version
    sqlite> SELECT sqlite_version() AS 'SQLite Version';