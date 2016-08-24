################
SQLite Data Type
################

.. contents:: `Contents`
   :depth: 2
   :local:

**********************
SQLite Storage Classes
**********************
Each value stored in an SQLite database has one of the following storage classes:

.. csv-table:: 
    :header: Storage Class, Description
    :widths: 20,70
    :delim: |

    **NULL**    | The value is a NULL value.
    **INTEGER** | The value is a signed integer, stored in 1, 2, 3, 4, 6, or 8 bytes depending on the magnitude of the value.
    **REAL**    | The value is a floating point value, stored as an 8-byte IEEE floating point number.
    **TEXT**    | The value is a text string, stored using the database encoding (UTF-8, UTF-16BE or UTF-16LE)
    **BLOB**    | The value is a blob of data, stored exactly as it was input.

********************
SQLite Affinity Type
********************
SQLite supports the concept of **type affinity** on columns. 

- Any column can still store any type of data but the preferred storage class for a column is called its **affinity**. 


Each table column in an SQLite3 database is assigned one of the following type affinities:

.. csv-table:: 
    :header: Affinity, Description
    :widths: 20,70
    :delim: |

    **TEXT**    | This column stores all data using storage classes NULL, TEXT or BLOB.
    **NUMERIC** | This column may contain values using all five storage classes.
    **INTEGER** | Behaves the same as a column with NUMERIC affinity with an exception in a CAST expression.
    **REAL**    | Behaves like a column with NUMERIC affinity except that it forces integer values into floating point representation
    **NONE**    | A column with affinity NONE does not prefer one storage class over another and no attempt is made to coerce data from one storage class into another.

******************************
SQLite Affinity and Type Names
******************************
Following table lists down various **data type names** which can be used while creating SQLite3 tables and corresponding applied **affinity** also has been shown:

.. csv-table:: 
    :header: Affinity, Data Type
    :widths: 25,750
    :delim: |

    **INTEGER** | ``INT``, ``INTEGER``, ``TINYINT``, ``SMALLINT``, ``BIGINT``, ``UNSIGNED BIG INT``, ``INT2``, ``INT8``
    **TEXT**    | ``CHARACTER(20)``, ``VARCHAR(255)``, ``VARYING CHARACTER(255)``, ``NCHAR(55)``,
            | ``NATIVE CHARACTER(70)``, ``NVARCHAR(100)``, ``TEXT``, ``CLOB``
    **NONE**    | ``BLOB``, ``no datatype specified``
    **REAL**    | ``REAL``, ``DOUBLE``, ``DOUBLE PRECISION``, ``FLOAT``
    **NUMERIC** | ``NUMERIC``, ``DECIMAL(10,5)``, ``BOOLEAN``, ``DATE``, ``DATETIME``


**********************
Date and Time Datatype
**********************
SQLite does not have a separate storage class for storing dates and/or times, 

- howeva, SQLite is capable of storing dates and times as TEXT, REAL or INTEGER values.

.. csv-table:: 
    :header: Storage Class, Data Format
    :widths: 20,70
    :delim: |

    **TEXT**    | A date in a format like "YYYY-MM-DD HH:MM:SS.SSS".
    **REAL**    | The number of days since noon in Greenwich on November 24, 4714 B.C.
    **INTEGER** | The number of seconds since 1970-01-01 00:00:00 UTC.