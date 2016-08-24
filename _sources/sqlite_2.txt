#############
SQLite syntax
#############
http://www.tutorialspoint.com/sqlite/sqlite_syntax.htm

All SQLite statements:

- start with any of the keywords like ``SELECT, INSERT, UPDATE, DELETE, ALTER, DROP``
- end with a semicolon ``;``

.. csv-table:: 
    :header: name,,description
    :widths: 20,15,70
    :delim: ^

    ANALYZE             ^ Statement ^ ``ANALYZE database_name;`` or ``ANALYZE database_name.table_name;``
    AND/OR              ^ Clause    ^ ``SELECT col1,col2 FROM table_name WHERE CONDITION1 {AND|OR} CONDITION2;``
    ALTER TABLE         ^ Statement ^ ``ALTER TABLE table_name ADD COLUMN column_def...;``
                        ^ Statement ^ ``ALTER TABLE table_name RENAME TO new_tbl_name``
    ATTACH DATABASE     ^ Statement ^ ``ALTER DABASE 'DBName' As 'Alias-Name'``
    BEGIN TRANSACTION   ^ Statement ^ ``BEGIN;`` or ``BEGIN EXCLUSIVE TRANSACTION``
    BETWEEN             ^ Clause    ^ ``SELECTION col FROM tbl_name WHERE col_name BETWEEN val1 AND val2``
    COMMIT              ^ Statement ^ ``COMMIT;``
    CREATE INDEX        ^ Statement ^ ``CREATE INDEX index_name ON tbl_name ( col_name COLLATE NOCASE )``
    CREATE UNIQUE INDEX ^ Statement ^ ``CREATE UNIQUE INDEX index_name ON tbl_name (col1, col2, ...colN)``
    CREATE TABLE        ^ Statement ^ see below
    CREATE TRIGGER      ^ Statement ^ see below
    CREATE VIEW         ^ Statement ^ ``CREATE VIEW db_name.view_name AS SELECT statement...;``
    CREATE VIRTUAL TABLE^ Statement ^ ``CREATE VIRTUAL TABLE dbname.tbl_name USING weblog( access.log );``
                        ^ Statement ^ or ``CREATE VIRTUAL TABLE dbname.tbl_name USING fts3( );``
    COMMIT TRANSACTION  ^ Statement ^ ``COMMIT;``
    COUNT               ^ Clause    ^ ``SELECTION COUNT(col_name) FROM tbl_name WHERE CONDITION;``
    DELETE              ^ Statement ^ ``DELETE FROM tbl_name WHERE {CONDITION};``
    DETACH DATABASE     ^ Statement ^ ``DETACH DATABASE 'Alias-Name';``
    DISTINCT            ^ Clause    ^ ``DETACH DATABASE 'Alias-Name';``
    DROP INDEX          ^ Statement ^ ``DROP INDEX db_name.index_name;``
    DROP TABLE          ^ Statement ^ ``DROP TABLE db_name.tbl_name;``
    DROP VIEW           ^ Statement ^ ``DROP INDEX db_name.view_name;``
    DROP TRIGGER        ^ Statement ^ ``DROP INDEX db_name.trigger_name;``
    EXISTS              ^ Clause    ^ ``SELECT col FROM tbl WHERE colname EXISTS (...);``
    GLOB                ^ Clause    ^ ``SELECT col FROM tbl WHERE colname GLOB { PATTERN };``
    GROUP BY            ^ Clause    ^ ``SELECT SUM(colname) FROM tbl WHERE CONDITION GROUP BY colname``
    HAVING              ^ Clause    ^ see below
    INSERT INTO         ^ Clause    ^ ``INSERT INTO tblname( col1, col2) VALUES ( val1, val2);``
    IN                  ^ Clause    ^ ``SELECT col1, col2 FROM tbl WHERE colname IN (val1, val2)``
    NOT IN              ^ Clause    ^ ``SELECT col1, col2 FROM tbl WHERE colname NOT IN (val1, val2)``
    LIKE                ^ Clause    ^ ``SELECT ... FROM tbl WHERE ... LIKE { PATTERN };``
    ORDER BY            ^ Clause    ^ ``SELECT ... FROM tbl WHERE ... ORDER BY col_name {ASD|DESC};``
    PRAGMA              ^ Statement ^ See below
    RELEASE SAVEPOINT   ^ Statement ^ ``RELEASE savepoint_name;``
    REINDEX             ^ Statement ^ ``REINDEX collation_name;``
                        ^ Statement ^ ``REINDEX dbname.index_name;``
                        ^ Statement ^ ``REINDEX dbname.table_name;``
    ROLLBACK            ^ Statement ^ ``ROLLBACK;`` or ``ROLLBACK TO SAVEPOINT savepoint_name;``
    SELECT              ^ Statement ^ ``SELECT col1, col2, ... colN FROM table_name;``
    UPDATE              ^ Statement ^ ``UPDATE tbl_name SET column1 = value1, column2 .. [ WHERE CONDITION ];``
    VACUUM              ^ Statement ^ ``VACUUM;``
    WHERE               ^ Clause    ^ ``SELECT col1, col2,...colN FROM table_name WHERE CONDITION;``


.. note:: Some more notables ones listed below

************
CREATE TABLE
************
.. code-block:: sql

    CREATE TABLE table_name(
       column1 datatype,
       column2 datatype,
       column3 datatype,
       .....
       columnN datatype,
       PRIMARY KEY( one or more columns )
    );

**************
CREATE TRIGGER
**************
.. code-block:: sql

    CREATE TRIGGER database_name.trigger_name 
    BEFORE INSERT ON table_name FOR EACH ROW
    BEGIN 
       stmt1; 
       stmt2;
       ....
    END;

********
GROUP BY
********
.. code-block:: sql

    SELECT SUM(column_name)
    FROM   table_name
    WHERE  CONDITION
    GROUP BY column_name;

******
HAVING
******
.. code-block:: sql

    SELECT SUM(column_name)
    FROM   table_name
    WHERE  CONDITION
    GROUP BY column_name
    HAVING (arithematic function condition);

******
PRAGMA
******
.. code-block:: sql

    PRAGMA pragma_name;

    -- For example:
    PRAGMA page_size;
    PRAGMA cache_size = 1024;
    PRAGMA table_info(table_name);

******
UPDATE
******
.. code-block:: sql

    UPDATE table_name
    SET column1 = value1, column2 = value2....columnN=valueN
    [ WHERE  CONDITION ];