.. contents:: **Table of contents**
   :depth: 2
   :local:

########################
SQLite commands overview
########################
- CREATE, SELECT, INSERT, UPDATE, DELETE and DROP
- these commands an be classified into groups based on their operational nature.

******************************
DDL (data definition language)
******************************
.. csv-table:: 
    :header: Command, Description
    :widths: 20,70
    :delim: |

    CREATE  | Creates a new table/view of a table/other object
    ALTER   | Modifies an existing database object, such as a table.
    DROP    | Deletes an entire table, a view of a table or other object in the database.

********************************
DML (Data manipulation language)
********************************
.. csv-table:: 
    :header: Command, Description
    :widths: 20,70
    :delim: |

    INSERT  | Creates a record
    UPDATE  | Modifies records
    DELETE  | Deletes records

*************************
DQL (data query language)
*************************
.. csv-table:: 
    :header: Command, Description
    :widths: 20,70
    :delim: |

    SELECT | Retrieves certain records from one or more tables

##############################
Unsupported features in SQLite
##############################
Unsupported features in SQL92 of SQLite

.. csv-table:: 
    :header: Feature, Description
    :widths: 20,70
    :delim: |

    RIGHT OUTER JOIN  | Only LEFT OUTER JOIN is implemented.
    FULL OUTER JOIN   | Only LEFT OUTER JOIN is implemented.
    ALTER TABLE       | The RENAME TABLE and ADD COLUMN variants of the ALTER command are supported. 
                      | The DROP COLUMN, ALTER COLUMN, ADD CONSTRAINT not supported.
    Trigger support   | FOR EACH ROW triggers are supported but not FOR EACH STATEMENT triggers.
    VIEWs             | VIEWs in SQLite are read-only. 
                      | You may not execute a DELETE, INSERT, or UPDATE statement on a view.
    GRANT and REVOKE  |   The only access permissions that can be applied are the normal file access permissions of the underlying operating system.  

###############
sqlite commands
###############

.. code-block:: none
    :linenos:
    :emphasize-lines: 4-5,9,14,16-17,19-22,26-28,38,41-45,49-57,60,66

    sqlite>.help -- print out bunch of SQLit *dot* commands

    .auth ON|OFF           Show authorizer callbacks
    .backup ?DB? FILE      Backup DB (default "main") to FILE
    .bail on|off           Stop after hitting an error.  Default OFF
    .binary on|off         Turn binary output on or off.  Default OFF
    .changes on|off        Show number of rows changed by SQL
    .clone NEWDB           Clone data into NEWDB from the existing database
    .databases             List names and files of attached databases
    .dbinfo ?DB?           Show status information about the database
    .dump ?TABLE? ...      Dump the database in an SQL text format
                             If TABLE specified, only dump tables matching
                             LIKE pattern TABLE.
    .echo on|off           Turn command echo on or off
    .eqp on|off|full       Enable or disable automatic EXPLAIN QUERY PLAN
    .exit                  Exit this program
    .explain ?on|off|auto? Turn EXPLAIN output mode on or off or to automatic
    .fullschema ?--indent? Show schema and the content of sqlite_stat tables
    .headers on|off        Turn display of headers on or off
    .help                  Show this message
    .import FILE TABLE     Import data from FILE into TABLE
    .indexes ?TABLE?       Show names of all indexes
                             If TABLE specified, only show indexes for tables
                             matching LIKE pattern TABLE.
    .limit ?LIMIT? ?VAL?   Display or change the value of an SQLITE_LIMIT
    .load FILE ?ENTRY?     Load an extension library
    .log FILE|off          Turn logging on or off.  FILE can be stderr/stdout
    .mode MODE ?TABLE?     Set output mode where MODE is one of:
                             ascii    Columns/rows delimited by 0x1F and 0x1E
                             csv      Comma-separated values
                             column   Left-aligned columns.  (See .width)
                             html     HTML <table> code
                             insert   SQL insert statements for TABLE
                             line     One value per line
                             list     Values delimited by .separator strings
                             tabs     Tab-separated values
                             tcl      TCL list elements
    .nullvalue STRING      Use STRING in place of NULL values
    .once FILENAME         Output for the next SQL command only to FILENAME
    .open ?FILENAME?       Close existing database and reopen FILENAME
    .output ?FILENAME?     Send output to FILENAME or stdout
    .print STRING...       Print literal STRING
    .prompt MAIN CONTINUE  Replace the standard prompts
    .quit                  Exit this program
    .read FILENAME         Execute SQL in FILENAME
    .restore ?DB? FILE     Restore content of DB (default "main") from FILE
    .save FILE             Write in-memory database into FILE
    .scanstats on|off      Turn sqlite3_stmt_scanstatus() metrics on or off
    .schema ?PATTERN?      Show the CREATE statements matching PATTERN
                              Add --indent for pretty-printing
    .separator COL ?ROW?   Change the column separator and optionally the row
                             separator for both the output mode and .import
    .shell CMD ARGS...     Run CMD ARGS... in a system shell
    .show                  Show the current values for various settings
    .stats ?on|off?        Show stats or turn stats on or off
    .system CMD ARGS...    Run CMD ARGS... in a system shell
    .tables ?TABLE?        List names of tables
                             If TABLE specified, only list tables matching
                             LIKE pattern TABLE.
    .timeout MS            Try opening locked tables for MS milliseconds
    .timer on|off          Turn SQL timer on or off
    .trace FILE|off        Output each SQL statement as it is run
    .vfsinfo ?AUX?         Information about the top-level VFS
    .vfslist               List all available VFSes
    .vfsname ?AUX?         Print the name of the VFS stack
    .width NUM1 NUM2 ...   Set column widths for "column" mode
                             Negative values right-justify

****************************
show -- see default settings
****************************
.. code-block:: none
    
    sqlite> .show
            echo: off
             eqp: off
         explain: auto
         headers: off
            mode: list
       nullvalue: ""
          output: stdout
    colseparator: "|"
    rowseparator: "\n"
           stats: off
           width: 

****************************************
Format output with (header, mode, timer)
****************************************
.. code-block:: sql

    sqlite>.header on
    sqlite>.mode column
    sqlite>.timer on
    
    -- above gives formatting like below

    ID          NAME        AGE         ADDRESS     SALARY
    ----------  ----------  ----------  ----------  ----------
    1           Paul        32          California  20000.0
    2           Allen       25          Texas       15000.0
    3           Teddy       23          Norway      20000.0
    4           Mark        25          Rich-Mond   65000.0
    5           David       27          Texas       85000.0
    6           Kim         22          South-Hall  45000.0
    7           James       24          Houston     10000.0
    CPU Time: user 0.000000 sys 0.000000

***********************
The sqlite_master Table
***********************
``sqlite_master`` = **master table** that holds the key information baout your database tables

.. code-block:: sql

    -- you can see the schema of the master table as follows
    sqlite> .schema sqlite_master
    CREATE TABLE sqlite_master (
      type text,
      name text,
      tbl_name text,
      rootpage integer,
      sql text
    );