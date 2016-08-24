########################
SQLite commands overview
########################
- CREATE, SELECT, INSERT, UPDATE, DELETE and DROP
- these commands an be classified into groups based on their operational nature.

.. contents:: **Contents**
   :depth: 2
   :local:

******************************
DDL (data definition language)
******************************
- https://en.wikipedia.org/wiki/Data_definition_language
- https://msdn.microsoft.com/en-us/library/ff848799.aspx

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
- https://en.wikipedia.org/wiki/Data_manipulation_language
- https://msdn.microsoft.com/en-us/library/ff848766.aspx

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

