Bunch of stuffs from the official doc
"""""""""""""""""""""""""""""""""""""

- https://www.sqlite.org/docs.html
- https://www.sqlite.org/cli.html (command-line shell)

.. contents:: `Table of contents`
   :depth: 2
   :local:

##########################################
Command Line Shell for SQLite (incomplete)
##########################################
https://www.sqlite.org/cli.html

**sqlite3** -- commandline utility from the SQLite projec

- ``CTRL-D`` -- terminate the program (end-of-file character)
- ``CTRL-C`` -- stop a long-running SQL statement (interrupt char)

Example: create a new SQLite dabase "ex1" with a single table named "tbl1":

.. code-block:: bash

    # create SQLite database "ex1" with table "tbl1"
    $ sqlite3 ex1
    sqlite> create table tbl1(one varchar(10), two smallint);
    sqlite> insert into tbl1 values('hello!',10);
    sqlite> insert into tbl1 values('goodbye', 20);
    sqlite> select * from tbl1;
    hello!|10
    goodbye|20
    sqlite>

****************************************
Semicolon to indicate end of SQL command
****************************************
Make sure you type a semicolon at the end of each SQL command!

- The sqlite3 program looks for a semicolon to know when your SQL command is complete. 
- w/o the semicolon, sqlite3 will give you a **continuation prompt** and wait for you to enter more text to be added to the current SQL command. 
- This feature allows you to enter SQL commands that span multiple lines.

.. code-block:: bash

    sqlite> CREATE TABLE tbl2 (
       ...>   f1 varchar(30) primary key,
       ...>   f2 text,
       ...>   f3 real
       ...> );
    sqlite>

******************************************
dot-commands (special commands to sqlite3)
******************************************
- stuffs that show up from ``sqlite> .help``
- these **dot commands** are typically used to:

  - change the output format of queries
  - execute certain prepackage query commands
- **dot commands** syntax is more restrictive than ordinary SQL statements
 
  - no preceding whitespace allowed before the ``.``
  - must be in **single input line**
  - cannot occur in the middle of an ordinary SQL statement
  - do not recognize comments
- in contrast, SQL statements are **free-form** (can span multiple lines, can have whitespace and comments anywhere)

.. code-block:: none

    sqlite> .help
    .auth ON|OFF           Show authorizer callbacks
    .backup ?DB? FILE      Backup DB (default "main") to FILE
    .bail on|off           Stop after hitting an error.  Default OFF
    .binary on|off         Turn binary output on or off.  Default OFF
    ...

****
todo
****
.. todo:: continue from https://www.sqlite.org/cli.html#section_5

######################
SQL Syntax (link only)
######################
SQL As Understood By SQLite -- https://www.sqlite.org/lang.html

########################
SQL Keywords (link only)
########################
For list of reserved key words, go to https://www.sqlite.org/lang_keywords.html

::

    ABORT    ACTION    ADD    AFTER    ALL    ALTER    ANALYZE    AND    AS    ASC    ATTACH    AUTOINCREMENT    
    BEFORE    BEGIN    BETWEEN    BY    
    CASCADE    CASE    CAST    CHECK    COLLATE    COLUMN    COMMIT    CONFLICT    CONSTRAINT   CREATE    CROSS    CURRENT_DATE    CURRENT_TIME    CURRENT_TIMESTAMP
    DATABASE    DEFAULT   DEFERRABLE    DEFERRED    DELETE    DESC    DETACH    DISTINCT    DROP  
    EACH    ELSE    END    ESCAPE    EXCEPT    EXCLUSIVE    EXISTS    EXPLAIN    
    FAIL    FOR    FOREIGN        FROM    FULL
    GLOB    GROUP    HAVING    
    IF    IGNORE    IMMEDIATE    IN    INDEX    INDEXED    INITIALLY    INNER    INSERT    INSTEAD    INTERSECT    INTO    ISNULL    
    JOIN    KEY    LEFT    LIKE    LIMIT    MATCH        
    NATURAL     NO    NOT    NOTNULL    NULL    
    OF    OFFSET    ON    OR    ORDER    OUTER    
    PLAN    PRAGMA    PRIMARY    QUERY    
    RAISE    RECURSIVE    REFERENCES    REGEXP    REINDEX    RELEASE    RENAME    REPLACE    RESTRICT    RIGHT  ROLLBACK    ROW    
    SAVEPOINT    SELECT    SET    
    TABLE    TEMP    TEMPORARY    THEN    TO    TRANSACTION    TRIGGER    
    UNION    UNIQUE    UPDATE    USING    
    VACUUM    VALUES    VIEW    VIRTUAL    
    WHEN    WHERE    WITH    WITHOUT

###################################
Datatypes in SQLite Version3 (todo)
###################################
https://www.sqlite.org/datatype3.html

#####################
Core functions (todo)
#####################
https://www.sqlite.org/lang_corefunc.html

- The **core functions** below are available by default
-  Date & Time functions, aggregate functions, and JSON functions are documented separately.
- An application may define additional functions written in C and added to the database engine using the ``sqlite3_create_function()`` API (`link <https://www.sqlite.org/c3ref/create_function.html>`__).

.. csv-table:: 
    :header: Function,Description
    :widths: 20,70
    :delim: |

    abs(X)              | The abs(X) function returns the absolute value of the numeric argument X. Abs(X) returns NULL if X is NULL. Abs(X) returns 0.0 if X is a string or blob that cannot be converted to a numeric value. If X is the integer -9223372036854775808 then abs(X) throws an integer overflow error since there is no equivalent positive 64-bit two complement value.
    changes()           | The changes() function returns the number of database rows that were changed or inserted or deleted by the most recently completed INSERT, DELETE, or UPDATE statement, exclusive of statements in lower-level triggers. The changes() SQL function is a wrapper around the sqlite3_changes() C/C++ function and hence follows the same rules for counting changes.
    char(X1,X2,...,XN)  | The char(X1,X2,...,XN) function returns a string composed of characters having the unicode code point values of integers X1 through XN, respectively.
    coalesce(X,Y,...)   | The coalesce() function returns a copy of its first non-NULL argument, or NULL if all arguments are NULL. Coalesce() must have at least 2 arguments.
    glob(X,Y)           | The glob(X,Y) function is equivalent to the expression "Y GLOB X". Note that the X and Y arguments are reversed in the glob() function relative to the infix GLOB operator. If the sqlite3_create_function() interface is used to override the glob(X,Y) function with an alternative implementation then the GLOB operator will invoke the alternative implementation.
    ifnull(X,Y)         | The ifnull() function returns a copy of its first non-NULL argument, or NULL if both arguments are NULL. Ifnull() must have exactly 2 arguments. The ifnull() function is equivalent to coalesce() with two arguments.
    instr(X,Y)          | The instr(X,Y) function finds the first occurrence of string Y within string X and returns the number of prior characters plus 1, or 0 if Y is nowhere found within X. Or, if X and Y are both BLOBs, then instr(X,Y) returns one more than the number bytes prior to the first occurrence of Y, or 0 if Y does not occur anywhere within X. If both arguments X and Y to instr(X,Y) are non-NULL and are not BLOBs then both are interpreted as strings. If either X or Y are NULL in instr(X,Y) then the result is NULL.
    hex(X)              | The hex() function interprets its argument as a BLOB and returns a string which is the upper-case hexadecimal rendering of the content of that blob.
    last_insert_rowid() | The last_insert_rowid() function returns the ROWID of the last row insert from the database connection which invoked the function. The last_insert_rowid() SQL function is a wrapper around the sqlite3_last_insert_rowid() C/C++ interface function.
    length(X)           | For a string value X, the length(X) function returns the number of characters (not bytes) in X prior to the first NUL character. Since SQLite strings do not normally contain NUL characters, the length(X) function will usually return the total number of characters in the string X. For a blob value X, length(X) returns the number of bytes in the blob. If X is NULL then length(X) is NULL. If X is numeric then length(X) returns the length of a string representation of X.
    like(X,Y)           |    
    like(X,Y,Z)         | The like() function is used to implement the "Y LIKE X [ESCAPE Z]" expression. If the optional ESCAPE clause is present, then the like() function is invoked with three arguments. Otherwise, it is invoked with two arguments only. Note that the X and Y parameters are reversed in the like() function relative to the infix LIKE operator. The sqlite3_create_function() interface can be used to override the like() function and thereby change the operation of the LIKE operator. When overriding the like() function, it may be important to override both the two and three argument versions of the like() function. Otherwise, different code may be called to implement the LIKE operator depending on whether or not an ESCAPE clause was specified.
    likelihood(X,Y)     | The likelihood(X,Y) function returns argument X unchanged. The value Y in likelihood(X,Y) must be a floating point constant between 0.0 and 1.0, inclusive. The likelihood(X) function is a no-op that the code generator optimizes away so that it consumes no CPU cycles during run-time (that is, during calls to sqlite3_step()). The purpose of the likelihood(X,Y) function is to provide a hint to the query planner that the argument X is a boolean that is true with a probability of approximately Y. The unlikely(X) function is short-hand for likelihood(X,0.0625). The likely(X) function is short-hand for likelihood(X,0.9375).
    likely(X)           | The likely(X) function returns the argument X unchanged. The likely(X) function is a no-op that the code generator optimizes away so that it consumes no CPU cycles at run-time (that is, during calls to sqlite3_step()). The purpose of the likely(X) function is to provide a hint to the query planner that the argument X is a boolean value that is usually true. The likely(X) function is equivalent to likelihood(X,0.9375). See also: unlikely(X).
    load_extension(X)   | 
    load_extension(X,Y) | The load_extension(X,Y) function loads SQLite extensions out of the shared library file named X using the entry point Y. The result of load_extension() is always a NULL. If Y is omitted then the default entry point name is used. The load_extension() function raises an exception if the extension fails to load or initialize correctly.
                        | The load_extension() function will fail if the extension attempts to modify or delete an SQL function or collating sequence. The extension can add new functions or collating sequences, but cannot modify or delete existing functions or collating sequences because those functions and/or collating sequences might be used elsewhere in the currently running SQL statement. To load an extension that changes or deletes functions or collating sequences, use the sqlite3_load_extension() C-language API.
                        | For security reasons, extension loaded is turned off by default and must be enabled by a prior call to sqlite3_enable_load_extension().
    lower(X)            | The lower(X) function returns a copy of string X with all ASCII characters converted to lower case. The default built-in lower() function works for ASCII characters only. To do case conversions on non-ASCII characters, load the ICU extension.
    ltrim(X)            | 
    ltrim(X,Y)          | The ltrim(X,Y) function returns a string formed by removing any and all characters that appear in Y from the left side of X. If the Y argument is omitted, ltrim(X) removes spaces from the left side of X.
    max(X,Y,...)        | The multi-argument max() function returns the argument with the maximum value, or return NULL if any argument is NULL. The multi-argument max() function searches its arguments from left to right for an argument that defines a collating function and uses that collating function for all string comparisons. If none of the arguments to max() define a collating function, then the BINARY collating function is used. Note that max() is a simple function when it has 2 or more arguments but operates as an aggregate function if given only a single argument.
    min(X,Y,...)        | The multi-argument min() function returns the argument with the minimum value. The multi-argument min() function searches its arguments from left to right for an argument that defines a collating function and uses that collating function for all string comparisons. If none of the arguments to min() define a collating function, then the BINARY collating function is used. Note that min() is a simple function when it has 2 or more arguments but operates as an aggregate function if given only a single argument.
    nullif(X,Y)         | The nullif(X,Y) function returns its first argument if the arguments are different and NULL if the arguments are the same. The nullif(X,Y) function searches its arguments from left to right for an argument that defines a collating function and uses that collating function for all string comparisons. If neither argument to nullif() defines a collating function then the BINARY is used.
    printf(FORMAT,...)  | The printf(FORMAT,...) SQL function works like the sqlite3_mprintf() C-language function and the printf() function from the standard C library. The first argument is a format string that specifies how to construct the output string using values taken from subsequent arguments. If the FORMAT argument is missing or NULL then the result is NULL. The %n format is silently ignored and does not consume an argument. The %p format is an alias for %X. The %z format is interchangeable with %s. If there are too few arguments in the argument list, missing arguments are assumed to have a NULL value, which is translated into 0 or 0.0 for numeric formats or an empty string for %s.
    quote(X)            | The quote(X) function returns the text of an SQL literal which is the value of its argument suitable for inclusion into an SQL statement. Strings are surrounded by single-quotes with escapes on interior quotes as needed. BLOBs are encoded as hexadecimal literals. Strings with embedded NUL characters cannot be represented as string literals in SQL and hence the returned string literal is truncated prior to the first NUL.
    random()            | The random() function returns a pseudo-random integer between -9223372036854775808 and +9223372036854775807.
    randomblob(N)       | The randomblob(N) function return an N-byte blob containing pseudo-random bytes. If N is less than 1 then a 1-byte random blob is returned.
                        | Hint: applications can generate globally unique identifiers using this function together with hex() and/or lower() like this:        hex(randomblob(16))        lower(hex(randomblob(16))) 
    replace(X,Y,Z)      | The replace(X,Y,Z) function returns a string formed by substituting string Z for every occurrence of string Y in string X. The BINARY collating sequence is used for comparisons. If Y is an empty string then return X unchanged. If Z is not initially a string, it is cast to a UTF-8 string prior to processing.
    round(X)            | 
    round(X,Y)          | The round(X,Y) function returns a floating-point value X rounded to Y digits to the right of the decimal point. If the Y argument is omitted, it is assumed to be 0.
    rtrim(X)            | 
    rtrim(X,Y)          | The rtrim(X,Y) function returns a string formed by removing any and all characters that appear in Y from the right side of X. If the Y argument is omitted, rtrim(X) removes spaces from the right side of X.
    soundex(X)          | The soundex(X) function returns a string that is the soundex encoding of the string X. The string "?000" is returned if the argument is NULL or contains no ASCII alphabetic characters. This function is omitted from SQLite by default. It is only available if the SQLITE_SOUNDEX compile-time option is used when SQLite is built.
    sqlite_compileoption_get(N)  | The sqlite_compileoption_get() SQL function is a wrapper around the sqlite3_compileoption_get() C/C++ function. This routine returns the N-th compile-time option used to build SQLite or NULL if N is out of range. See also the compile_options pragma.
    sqlite_compileoption_used(X) | The sqlite_compileoption_used() SQL function is a wrapper around the sqlite3_compileoption_used() C/C++ function. When the argument X to sqlite_compileoption_used(X) is a string which is the name of a compile-time option, this routine returns true (1) or false (0) depending on whether or not that option was used during the build.
    sqlite_source_id()  | The sqlite_source_id() function returns a string that identifies the specific version of the source code that was used to build the SQLite library. The string returned by sqlite_source_id() is the date and time that the source code was checked in followed by the SHA1 hash for that check-in. This function is an SQL wrapper around the sqlite3_sourceid() C interface.
    sqlite_version()    | The sqlite_version() function returns the version string for the SQLite library that is running. This function is an SQL wrapper around the sqlite3_libversion() C-interface.
    substr(X,Y,Z)       |
    substr(X,Y)         | The substr(X,Y,Z) function returns a substring of input string X that begins with the Y-th character and which is Z characters long. If Z is omitted then substr(X,Y) returns all characters through the end of the string X beginning with the Y-th. The left-most character of X is number 1. If Y is negative then the first character of the substring is found by counting from the right rather than the left. If Z is negative then the abs(Z) characters preceding the Y-th character are returned. If X is a string then characters indices refer to actual UTF-8 characters. If X is a BLOB then the indices refer to bytes.
    total_changes()     | The total_changes() function returns the number of row changes caused by INSERT, UPDATE or DELETE statements since the current database connection was opened. This function is a wrapper around the sqlite3_total_changes() C/C++ interface.
    trim(X)             |    
    trim(X,Y)           | The trim(X,Y) function returns a string formed by removing any and all characters that appear in Y from both ends of X. If the Y argument is omitted, trim(X) removes spaces from both ends of X.
    typeof(X)           | The typeof(X) function returns a string that indicates the datatype of the expression X: "null", "integer", "real", "text", or "blob".
    unlikely(X)         | The unlikely(X) function returns the argument X unchanged. The unlikely(X) function is a no-op that the code generator optimizes away so that it consumes no CPU cycles at run-time (that is, during calls to sqlite3_step()). The purpose of the unlikely(X) function is to provide a hint to the query planner that the argument X is a boolean value that is usually not true. The unlikely(X) function is equivalent to likelihood(X, 0.0625).
    unicode(X)          | The unicode(X) function returns the numeric unicode code point corresponding to the first character of the string X. If the argument to unicode(X) is not a string then the result is undefined.
    upper(X)            | The upper(X) function returns a copy of input string X in which all lower-case ASCII characters are converted to their upper-case equivalent.
    zeroblob(N)         | The zeroblob(N) function returns a BLOB consisting of N bytes of 0x00. SQLite manages these zeroblobs very efficiently. Zeroblobs can be used to reserve space for a BLOB that is later written using incremental BLOB I/O. This SQL function is implemented using the sqlite3_result_zeroblob() routine from the C/C++ interface. 

#############
Agg functions
#############
https://www.sqlite.org/lang_aggfunc.html

- The aggregate functions shown below are available by default. 
- Additional aggregate functions written in C may be added using the ``sqlite3_create_function()`` API (`link <https://www.sqlite.org/c3ref/create_function.html>`__).

.. rubric:: DISTINCT keyword

- In any aggregate function that takes a single argument, that argument can be preceded by the keyword ``DISTINCT``. 
- In such cases, duplicate elements are filtered before being passed into the aggregate function. 
- Example: ``count(distinct X)`` -- return the number of distinct values of column X instead of the total number of non-null values in column X. 

.. csv-table:: 
    :header: function, description
    :widths: 20,70
    :delim: |

    ``avg(X)`` | returns the average value of all non-NULL X within a group. 
               | String and BLOB values that do not look like numbers are interpreted as 0. 
               | The result of avg() is always a floating point value as long as at there is at least one non-NULL input even if all inputs are integers. 
               | The result of avg() is NULL if and only if there are no non-NULL inputs.
    ``count(X)``  |  returns a count of the number of times that X is not NULL in a group. 
    ``count(*)`` | The count(*) function (with no arguments) returns the total number of rows in the group.
    ``group_concat(X)`` |  returns a string which is the concatenation of all non-NULL values of X.
    ``group_concat(X,Y)`` | if Y is present then it is used as the separator between instances of X. 
        | A comma (",") is used as the separator if Y is omitted. 
        | The order of the concatenated elements is arbitrary.
    ``max(X)`` | returns the maximum value of all values in the group. 
               | The maximum value is the value that would be returned last in an ``ORDER BY`` on the same column. 
               | Aggregate max() returns NULL if and only if there are no non-NULL values in the group.
    ``min(X)`` | returns the minimum non-NULL value of all values in the group. The minimum value is the first non-NULL value that would appear in an ORDER BY of the column. Aggregate min() returns NULL if and only if there are no non-NULL values in the group.
    ``sum(X),total(X)`` | sum() and total() aggregate functions return sum of all non-NULL values in the group. 
                        | If there are no non-NULL input rows then sum() returns NULL but total() returns 0.0. NULL is not normally a helpful result for the sum of no rows but the SQL standard requires it and most other SQL database engines implement sum() that way so SQLite does it in the same way in order to be compatible. The non-standard total() function is provided as a convenient way to work around this design problem in the SQL language.
    sum vs total | The result of total() is always a floating point value. 
                 | The result of sum() is an integer value if all non-NULL inputs are integers. 
                 | If any input to sum() is neither an integer or a NULL then sum() returns a floating point value which might be an approximation to the true sum.
                | Sum() will throw an "integer overflow" exception if all inputs are integers or NULL and an integer overflow occurs at any point during the computation. 
                | Total() never throws an integer overflow. 
    
#######################
Data and time functions
#######################
https://www.sqlite.org/lang_datefunc.html

 SQLite supports five date and time functions:

#. ``date(timestring, modifier, modifier, ...)`` (uses part of `ISO 8601 <https://en.wikipedia.org/wiki/ISO_8601>`__ time format)
#. ``time(timestring, modifier, modifier, ...)`` --- returns the date in this format: YYYY-MM-DD
#. ``datetime(timestring, modifier, modifier, ...)`` -- returns ``YYYY-MM-DD HH:MM:SS``
#. ``julianday(timestring, modifier, modifier, ...)`` (`wiki <http://en.wikipedia.org/wiki/Julian_day>`__)
#. ``strftime(format, timestring, modifier, modifier, ...)`` ---  returns the date formatted according to the format string specified as the first argument. **See below** for valid ``strftime`` substitutions.

.. code-block:: none
    :linenos:
    :emphasize-lines: 2,5
            
    %d      day of month: 00
    %f      fractional seconds: SS.SSS
    %H      hour: 00-24
    %j      day of year: 001-366
    %J      Julian day number
    %m      month: 01-12
    %M      minute: 00-59
    %s      seconds since 1970-01-01
    %S      seconds: 00-59
    %w      day of week 0-6 with Sunday==0
    %W      week of year: 00-53
    %Y      year: 0000-9999
    %%      % 

.. note::
    
    Note the following equivalence (date, time, datetime functions are there for convenience and efficiency)

    .. csv-table:: 
            :header: Function, Equivalent ``strftime()``
            :widths: 20,70
            :delim: |
        
            ``date(...)``      | ``strftime('%Y-%m-%d', ...)``
            ``time(...)``      | ``strftime('%H:%M:%S', ...)``
            ``datetime(...)``  |     ``strftime('%Y-%m-%d %H:%M:%S', ...)``
            ``julianday(...)`` |     ``strftime('%J', ...)``

**********
timestring
**********
A time string can be in any of the following formats:

#. YYYY-MM-DD
#. YYYY-MM-DD HH:MM
#. YYYY-MM-DD HH:MM:SS
#. YYYY-MM-DD HH:MM:SS.SSS
#. YYYY-MM-DDTHH:MM
#. YYYY-MM-DDTHH:MM:SS
#. YYYY-MM-DDTHH:MM:SS.SSS
#. HH:MM
#. HH:MM:SS
#. HH:MM:SS.SSS
#. now
#. DDDDDDDDDD 

*********
modifiers
*********
- The time string can be followed by zero or more modifiers that alter date and/or time. 
- Each modifier is a transformation that is applied to the time value to its left. 
- Modifiers are applied from left to right; **order is important**. 


The available modifiers are as follows.

#. NNN days
#. NNN hours
#. NNN minutes
#. NNN.NNNN seconds
#. NNN months
#. NNN years
#. start of month
#. start of year
#. start of day
#. weekday N
#. unixepoch
#. localtime
#. utc 

********
Examples
********
.. code-block:: sql

    -- Compute the current date.
    SELECT date('now');

    -- Compute the last day of the current month.
    SELECT date('now','start of month','+1 month','-1 day'); 

    -- Compute the date and time given a unix timestamp 1092941466.
    SELECT datetime(1092941466, 'unixepoch'); 

    -- Compute the date and time given a unix timestamp 1092941466, and compensate for your local timezone.
    SELECT datetime(1092941466, 'unixepoch', 'localtime'); 

    -- Compute the current unix timestamp.
    SELECT strftime('%s','now'); 

    -- Compute the number of days since the signing of the US Declaration of Independence.
    SELECT julianday('now') - julianday('1776-07-04'); 

    -- Compute the number of seconds since a particular moment in 2004:
    SELECT strftime('%s','now') - strftime('%s','2004-01-01 02:34:56'); 

    -- Compute the date of the first Tuesday in October for the current year.
    SELECT date('now','start of year','+9 months','weekday 2'); 

    -- Compute the time since the unix epoch in seconds (like strftime('%s','now') except includes fractional part):
    SELECT (julianday('now') - 2440587.5)*86400.0; 

################
JSON (just read)
################
https://www.sqlite.org/json1.html

Skim over in the future (not my immediate need at the moment 23 August 2016 (Tuesday))