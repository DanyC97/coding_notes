############
awk-workflow
############
http://www.tutorialspoint.com/awk/awk_workflow.htm

**************************
The BEGIN, body, END block
**************************
- The BEGIN block gets executed at program start-up (upper-case). 
- It executes only once, and is **optional**
- This is good place to initialize variables

.. code-block:: bash

    # BEGIN block (optional)
    BEGIN {awk-commands}

    # Body block - applies awk commands on every input line (default)
    /pattern/ {awk-commands}

    # END block (optional)
    END {awk-commands}

*******************************
First example on marks.txt file
*******************************
Suppose we have a file called ``marks.txt`` with the following content

::

    1)  Amit    Physics  80
    2)  Rahul   Maths    90
    3)  Shyam   Biology  87
    4)  Kedar   English  85
    5)  Hari    History  89

Look at this

.. code-block:: bash

    awk 'BEGIN{printf "Sr No\tName\tSub\tMarks\n"} {print}' marks.txt

    Sr No   Name    Sub Marks
    1)  Amit    Physics  80
    2)  Rahul   Maths    90
    3)  Shyam   Biology  87
    4)  Kedar   English  85
    5)  Hari    History  89