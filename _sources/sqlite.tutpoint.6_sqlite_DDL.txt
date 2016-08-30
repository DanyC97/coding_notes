##########
SQLite DDL
##########
**Data Description Language (DDL)** 

- `DDL <https://en.wikipedia.org/wiki/Data_definition_language>`__  (``CREATE, DROP, ALTER, RENAME``)= a syntax similar to a computer programming language for defining data structures, especially database schemas.
- `Data Definition Language (DDL) Statements (Transact-SQL) (MSDN) <https://msdn.microsoft.com/en-us/library/ff848799.aspx>`__

.. contents:: `Contents`
   :depth: 2
   :local:

***************
CREATE Database
***************
http://www.tutorialspoint.com/sqlite/sqlite_create_database.htm

.. code-block:: bash

    $ sqlite3 testDB.db
    SQLite version 3.13.0 2016-05-18 10:57:30
    Enter ".help" for usage hints.

.. code-block:: sql

    sqlite> .databases -- check if the database is int hte list of databases in SQLite
    seq  name             file                                                      
    ---  ---------------  ----------------------------------------------------------
    0    main             /home/takanori/Dropbox/git/tutorials/sql_play/testDB.db   

    sqlite> .quit -- exit. can also do ctrl+D (end-of-file char)

.. code-block:: bash

    $ ls
    testDB.db

    # use the .dump command to expore comlete database in a text file
    $ sqlite3 testDB.db .dump > testDB.sql

    # the contents of testDB.db database is converted into SQLite statements and dumped 
    # into an ASCII text file testDB.sql
    $ ls
    testDB.db  testDB.sql

    $ cat testDB.sql 
    PRAGMA foreign_keys=OFF;
    BEGIN TRANSACTION;
    COMMIT;

    # the database can be restored from the generated *.sql file simply by redirecting the stdin
    $ sqlite3 testDB.db < testDB.sql


At this moment the database is empty, so you can try above two procedures once you have few tables and data in your database. 

***************
ATTACH Database
***************
http://www.tutorialspoint.com/sqlite/sqlite_attach_database.htm

Suppose you have multiple databases at hand and you want to use any of them at a time.

``ATTACH DATABASE`` statement is used to select a particular database.

- after this command, all SQLite statements will be executed under the attached database.

Basic syntax
============
- The following command will also create a database in case database isn't yet created.
- otherwise, it'll just attached db filename with logical database 'Alias-Name'

.. code-block:: sql

    ATTACH DATABASE 'DatabaseName' As 'Alias-Name';


Demo
====
Start sqlite3 ``$ sqlite3``

.. code-block:: sql

    -- initially, everything is empty
    sqlite> .database
    seq  name             file                                                      
    ---  ---------------  ----------------------------------------------------------
    0    main             

    -- attach database we just created           
    sqlite> ATTACH DATABASE 'testDB.db' as 'TEST'; 
    sqlite> .database
    seq  name             file                                                      
    ---  ---------------  ----------------------------------------------------------
    0    main                                                                       
    2    TEST             /home/takanori/Dropbox/git/tutorials/sql_play/testDB.db   

.. note:: 

    db-names **main** and **temp** are reserved names

    - **main** = primary database
    - **temp** = holds temporary tables and other temporary data objects
    - so never use these names for attachment (sqlite won't allow you to do so anyways)

.. code-block:: sql

    sqlite>  ATTACH DATABASE 'testDB.db' as 'TEMP';
    Error: database TEMP is already in use
    sqlite>  ATTACH DATABASE 'testDB.db' as 'main';
    Error: database TEMP is already in use

    

***************
DETACH Database
***************
http://www.tutorialspoint.com/sqlite/sqlite_detach_database.htm

``DETACH`` command will disconnect only given name and rest of the attachement will still continue. 

- You cannot detach the main or temp databases.
- if the DB is in-memory or temporary db, the db will be destroyed and the contents will be lost

**syntax**

.. code-block:: sql

    DETACH DATABASE 'Alias-Name';

Example
=======
.. code-block:: sql
    
    sqlite> ATTACH DATABASE 'testDB.db' as 'test';
    sqlite> ATTACH DATABASE 'testDB.db' as 'currentDB';
    sqlite> .databases
    seq  name             file                                                      
    ---  ---------------  ----------------------------------------------------------
    0    main                                                                       
    2    test             /home/takanori/Dropbox/git/tutorials/sql_play/testDB.db   
    3    currentDB        /home/takanori/Dropbox/git/tutorials/sql_play/testDB.db    

    sqlite> DETACH DATABASE 'currentDB';
    sqlite> .database
    seq  name             file                                                      
    ---  ---------------  ----------------------------------------------------------
    0    main                                                                       
    2    test             /home/takanori/Dropbox/git/tutorials/sql_play/testDB.db

************
CREATE Table
************
http://www.tutorialspoint.com/sqlite/sqlite_create_table.htm

**********
DROP Table
**********
http://www.tutorialspoint.com/sqlite/sqlite_drop_table.htm