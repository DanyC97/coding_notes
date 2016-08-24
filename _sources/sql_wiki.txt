Random jumbles from wikipedia pertaining to Database concepts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
I love wikipedia, but I do this way too often:

.. image:: https://imgs.xkcd.com/comics/dfs.png

That said, having the hierarchical TOC on the LHS helps 
(even just sorting them conceptally helps me get a rough understanding of the field)

.. contents:: `Table of contents`
   :depth: 2
   :local:



##############
Data Integrity
##############
https://en.wikipedia.org/wiki/Data_integrity

Summary for **Databases** (`link <https://en.wikipedia.org/wiki/Data_integrity#Types_of_integrity_constraints>`__)

3 types of contraints for Relational data model:

1. **Entity integrity** - every table must have a primary key and the columns chosen as the primary key must be unique
2. **Referential integrity** - any *foreign-key* value can only be in one of two states (usually states that the foreign-key-value referrs to a primary key value of some table in the database)
3. **Domain integrity** - all columns must be declared upon a defined domain (domain is a set of values of the same type)

There's also **user-defined integrity**

#############
DDL, DML, DCL
#############
https://en.wikipedia.org/wiki/SQL

SQL consists of:

- DDL **data definition language**
- DML **data manipulation language**, and 
- DCL **Data Control Language**.

##############################
Data definition language (DDL)
##############################
`DDL <https://en.wikipedia.org/wiki/Data_definition_language>`__  (``CREATE, DROP, ALTER, RENAME``)
= a syntax similar to a computer programming language for defining data structures, especially database schemas.

********************************
Data Manipulation Language (DML)
********************************
`DML <https://en.wikipedia.org/wiki/Data_manipulation_language>`__ (``SELECT, INSERT, UPDATE, DELETE``) - a family of syntax elements similar to a computer programming language used for selecting, inserting, deleting and updating data in a database

.. code-block:: sql
    
    SELECT ... FROM ... WHERE ...
    INSERT INTO ... VALUES ...
    UPDATE ... SET ... WHERE ...
    DELETE FROM ... WHERE ...

***************************
Data Control Language (DCL)
***************************
`DCL <https://en.wikipedia.org/wiki/Data_control_language>`__ (``GRANT, REVOKE``) -- a syntax similar to a computer programming language used to control access to data stored in a database (Authorization)

- Oracle Database -- cannot roll back the command
- PostgreSQL -- can be rolled back
- SQLite does not have any DCL commands as it does not have usernames or logins

####
ACID
####
https://en.wikipedia.org/wiki/ACID

ACID (Atomicity, Consistency, Isolation, Durability)

- a set of properties of `database transactions <https://en.wikipedia.org/wiki/Database_transaction>`__

*********
Atomicity
*********
https://en.wikipedia.org/wiki/Atomicity_%28database_systems%29

***********
Consistency
***********
https://en.wikipedia.org/wiki/Consistency_%28database_systems%29

*********
Isolation
*********
https://en.wikipedia.org/wiki/Isolation_%28database_systems%29

**********
Durability
**********
https://en.wikipedia.org/wiki/Durability_%28database_systems%29



################
Jumpled articles
################
Stuffs I donno enough to categorize...

*****************
Consistency model
*****************
https://en.wikipedia.org/wiki/Consistency_model

**********************************
CAP Theorem (aka Brewer's Theorem)
**********************************
https://en.wikipedia.org/wiki/CAP_theorem

states that it is impossible for a distributed computer system to simultaneously provide all three of the following guarantees

#. `Consistency <https://en.wikipedia.org/wiki/Consistency_%28database_systems%29>`__ (all nodes see the same data at the same time)
#. `Availability <https://en.wikipedia.org/wiki/Availability>`__ (every request receives a response about whether it succeeded or failed)
#. `Partition tolerance <https://en.wikipedia.org/wiki/Network_partition>`__ (the system continues to operate despite arbitrary partitioning due to network failures)

********************
Database transaction
********************
https://en.wikipedia.org/wiki/Database_transaction

######################
Database normalization
######################
- https://en.wikipedia.org/wiki/Database_normalization
- https://simple.wikipedia.org/wiki/Database_normalisation


###############
Database Schema
###############
- https://en.wikipedia.org/wiki/Database_schema

Some SO threads

- http://stackoverflow.com/questions/2674222/what-is-purpose-of-database-schema
- http://stackoverflow.com/questions/298739/what-is-the-difference-between-a-schema-and-a-table-and-a-database

**************
Logical schema
**************
https://en.wikipedia.org/wiki/Logical_schema

***************
Physical schema
***************
https://en.wikipedia.org/wiki/Physical_schema

*****************
Conceptual schema
*****************
https://en.wikipedia.org/wiki/Conceptual_schema

*********************
Three-schema approach
*********************
https://en.wikipedia.org/wiki/Three-schema_approach


######################
Bunch of jumbled links
######################
..note:: 

    Don't expect myself to dive in too deeply with some of these, but just be aware that these concepts exist.


- https://en.wikipedia.org/wiki/Relational_database
- https://en.wikipedia.org/wiki/Relational_model
- https://en.wikipedia.org/wiki/Relation_(database)
- https://en.wikipedia.org/wiki/Data_retention
- https://en.wikipedia.org/wiki/Relational_database_management_system
- https://en.wikipedia.org/wiki/Database_design
- https://en.wikipedia.org/wiki/Foreign_key
- https://en.wikipedia.org/wiki/Data_model
- https://en.wikipedia.org/wiki/View_model
- https://en.wikipedia.org/wiki/Entity%E2%80%93relationship_model
- https://en.wikipedia.org/wiki/Data_structure_diagram
- https://en.wikipedia.org/wiki/Check_constraint
- https://en.wikipedia.org/wiki/Database_trigger
- https://en.wikipedia.org/wiki/Cursor_(databases)
- https://en.wikipedia.org/wiki/Data_domain
- https://en.wikipedia.org/wiki/View_(SQL)
- https://en.wikipedia.org/wiki/Materialized_view
- https://en.wikipedia.org/wiki/Query_optimization
- https://en.wikipedia.org/wiki/Query_plan