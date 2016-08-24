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

