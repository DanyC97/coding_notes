Tables from grymoire
""""""""""""""""""""

http://www.grymoire.com/Unix/Awk.html

######################
Arithmetic expressions
######################


***************
Binary operator
***************

.. csv-table:: Binary Operator
    :header: Operator, Type, Meaning, Example, Result
    :delim: |

    ``+``         | Arithmetic  |   Addition  | 7+3 | 10
    ``-``         | Arithmetic  |   Subtraction  | 7-3 | 4
    ``*``         | Arithmetic  |   Multiplication  | 7*3 | 21
    ``/``         | Arithmetic  |   Division  | 7/3 | 2.333
    ``%``         | Arithmetic  |   Modulo  | 7%3 | 1
    ``<space>``   | String      |   Concatenation  | 7 3 | 73


*******************
Assignment operator
*******************
.. http://docutils.sourceforge.net/docs/ref/rst/directives.html#id4        
.. csv-table:: Assignment operator
    :header: Operator, Meaning
    :widths: 20,70
    :delim: |

    ``+=``  | Add result to variable
    ``-=``  | Subtract result from variable
    ``*=``  | Multiply variable by result
    ``/=``  | Divide variable by result
    ``%=``  | Apply modulo to variable

.. code-block:: bash
    
    # suppose x=4
    print -x; # prints -4

    # increment/decrement operators supported too
    print x++, " ", ++x;  # print 3 and 5

    # can be used by themselves as assignment operators
    x++;
    --y;

***********************
Conditional expressions
***********************
.. csv-table:: Relational operator
    :header: Operator, Meaning
    :widths: 20,70
    :delim: ,

    ``==``  , Is equal
    ``!=``  , Is not equal to
    ``>``   , Is greater than
    ``>=``  , Is greater than or equal to
    ``<``   , Is less than
    ``<=``  , Is less than or equal to
    ``&&``  , AND
    ``||``  , OR
    ``!``   , NOT

******
Regexp
******
.. csv-table:: 
    :header: Operator, Meaning
    :widths: 20,70
    :delim: |

    ``~``  |  Matches
    ``!~`` |  Doesn't match

#######################
Summary of AWK commands
#######################
There are only a few commands in AWK. The list and syntax follows: 

.. code-block:: bash

    if ( conditional ) statement [ else statement ]
    while ( conditional ) statement
    for ( expression ; conditional ; expression ) statement
    for ( variable in array ) statement
    break
    continue
    { [ statement ] ...}
    variable=expression
    print [ expression-list ] [ > expression ]
    printf format [ , expression-list ] [ > expression ]
    next
    exit

#######################
Build-int AWK variables
#######################
.. csv-table:: 
    :delim: -

    FS - The Input Field Separator 
    OFS - The Output Field Separator   
    NF - The Number of Fields (columns)    
    NR - The Number of Records (rows)  
    RS - The Record Separator  
    ORS - The Output Record Separator  
    FILENAME - The Current Filename    

###################
printf - formatting
###################
******
syntax
******
.. code-block:: bash

    # paranthesis and semicolon OPTIONAL!
    printf ( format);
    printf ( format, arguments...);
    printf ( format) >expression;
    printf ( format, arguments...) > expression;

****************
Escape sequences
****************
.. csv-table:: 
    :header: Sequence, Description
    :widths: 20,70
    :delim: |

    ``\a``     |  ASCII bell (NAWK/GAWK only)
    ``\b``     |  Backspace
    ``\f``     |  Formfeed
    ``\n``     |  Newline
    ``\r``     |  Carriage Return
    ``\t``     |  Horizontal tab
    ``\v``     |  Vertical tab (NAWK only)
    ``\ddd``   |  Character (1 to 3 octal digits) (NAWK only)
    ``\xdd``   |  Character (hexadecimal) (NAWK only)
    ``\<Any other character>``  | That character

*****************
Format specifiers
*****************
.. csv-table:: 
    :header: Specifier, Meaning
    :widths: 20,70
    :delim: |

    ``%c`` | ASCII Character
    ``%d`` | Decimal integer
    ``%e`` | Floating Point number (engineering format)
    ``%f`` | Floating Point number (fixed point format)
    ``%g`` | The shorter of e or f, with trailing zeros removed
    ``%o`` | Octal
    ``%s`` | String
    ``%x`` | Hexadecimal
    ``%%`` | Literal %

.. csv-table:: Example of format conversion
    :header: Format, Value, Result
    :widths: 20,20,70   
    :delim: |

    ``%c``  | 100.0  | d
    ``%c``  | "100.0"| 1
    ``%c``  | 42     | \"
    ``%d``  | 100.0  | 100
    ``%e``  | 100.0  | 1.000000e+02
    ``%f``  | 100.0  | 100.000000
    ``%g``  | 100.0  | 100
    ``%o``  | 100.0  | 144
    ``%s``  | 100.0  | 100.0
    ``%s``  | \"13f\"  | 13f
    ``%d``  | \"13f\"  | 0 (AWK)
    ``%d``  | \"13f\"  | 13 (NAWK)
    ``%x``  | 100.0  | 64

**********************************
Width - specify minimum field size
**********************************
Give a number after ``%`` to specify **field size** := mininum number of character to print

.. code-block:: bash

    # if string length doesn't match, this gets jumbled up
    printf("%st%d\n", s, d);

    # so give width 0f 20 chars
    printf("%20s%d\n", s, d);

You can do things like this:

.. code-block:: bash

    #!/usr/bin/awk -f
    BEGIN {
        printf("%10s %6sn", "String", "Number");
    }
    {
        printf("%10s %6d\n", $1, $2);
    }


    # even better, use variables!
    #!/usr/bin/awk -f
    BEGIN {
        format1 ="%10s %6sn";
        format2 ="%10s %6dn";
        printf(format1, "String", "Number");
    }
    {
        printf(format2, $1, $2);
    }


*****************************************************
my own example (use "-" to left justify string in %s)
*****************************************************
.. code-block:: bash

    $ ls -l *.py | head -5 | awk 'NF==9 {print  $9, $5}'
    t_0711a_pnc_conn_agereg_fs_corrwithage.py 4.3K
    t_0711b_pnc_conn_agereg_fs_variance.py 4.4K
    t_0711c_pnc_bct_nmf.py 5.1K
    t_0712_pnc_bct_ensemble.py 4.7K
    t_0713b_pnc_supervised_nmf.py 3.2K

    # awww, better!
    $ ls -l *.py | head -5 | awk 'NF==9 {printf("%-45s",$9)}{print $5}'
    t_0711a_pnc_conn_agereg_fs_corrwithage.py    4.3K
    t_0711b_pnc_conn_agereg_fs_variance.py       4.4K
    t_0711c_pnc_bct_nmf.py                       5.1K
    t_0712_pnc_bct_ensemble.py                   4.7K
    t_0713b_pnc_supervised_nmf.py                3.2K

    # needed the backslash after *pattern* (NF == 9) below...
    # to be on the safe side, i should always just include a backslash
    # when writing on the terminal    
    $ ls -l *.py | head -5 | awk '\
    NF ==9 \
    {printf("%-45s",$9)}
    {print $5}'
    t_0711a_pnc_conn_agereg_fs_corrwithage.py    4.3K
    t_0711b_pnc_conn_agereg_fs_variance.py       4.4K
    t_0711c_pnc_bct_nmf.py                       5.1K
    t_0712_pnc_bct_ensemble.py                   4.7K
    t_0713b_pnc_supervised_nmf.py                3.2K


    # (%-45s means 45 spaces, left justified)
    $ ls -l *.py | head -5 | awk '\
              BEGIN{printf("%-45s","Filename"); print "filsize"} \
              NF ==9 \
              {printf("%-45s",$9)}
              {print $5}'
    Filename                                     filsize
    t_0711a_pnc_conn_agereg_fs_corrwithage.py    4.3K
    t_0711b_pnc_conn_agereg_fs_variance.py       4.4K
    t_0711c_pnc_bct_nmf.py                       5.1K
    t_0712_pnc_bct_ensemble.py                   4.7K
    t_0713b_pnc_supervised_nmf.py                3.2K


******************************
Examples of complex formatting
******************************
.. csv-table:: 
    :header: Format, Variable, Result
    :widths: 20,20, 70
    :delim: |

    ``%c``     |   100      | ``"d"``
    ``%10c``   |     100    | ``" d"``
    ``%010c``  |    100     | ``"000000000d"``
    ||
    ``%d``     |   10       | ``"10"``
    ``%10d``   |    10     | ``" 10"``
    ``%10.4d`` |   10.123456789   | ``" 0010"``
    ``%10.8d`` | 10.123456789    | ``" 00000010"``
    ``%.8d``   |     10.123456789   | ``"00000010"``
    ``%010d``  |    10.123456789   | ``"0000000010"``
    ||
    ``%e``     |   987.1234567890  | ``"9.871235e+02"``
    ``%10.4e`` |   987.1234567890  | ``"9.8712e+02"``
    ``%10.8e`` |   987.1234567890  | ``"9.87123457e+02"``
    ||
    ``%f``     |   987.1234567890  | ``"987.123457"``
    ``%10.4f`` |  987.1234567890   | ``" 987.1235"``
    ``%010.4f``| 987.1234567890    | ``"00987.1235"``
    ``%10.8f`` |  987.1234567890   | ``"987.12345679"``
    ||
    ``%g``     |   987.1234567890   | ``"987.123"``
    ``%10g``   |     987.1234567890 | ``" 987.123"``
    ``%10.4g`` | 987.1234567890     |  ``" 987.1"``
    ``%010.4g``|  987.1234567890    | ``"00000987.1"``
    ``%.8g``   |     987.1234567890 |  ``"987.12346"``
    ||
    ``%o``     |   987.1234567890   | ``"1733"``
    ``%10o``   |   987.1234567890   | ``" 1733"``
    ``%010o``  |    987.1234567890  | ``"0000001733"``
    ``%.8o``   |     987.1234567890 | ``"00001733"``
    ||
    ``%s``     |   987.123    | ``"987.123"``
    ``%10s``   |     987.123  | ``" 987.123"``
    ``%10.4s`` |   987.123 | ``" 987."``
    ``%010.8s``|  987.123 | ``"000987.123"``
    ||
    ``%x``     |   987.1234567890  | ``"3db"``
    ``%10x``   |     987.1234567890|  ``" 3db"``
    ``%010x``  |    987.1234567890 |  ``"00000003db"``
    ``%.8x``   |     987.1234567890|   ``"000003db"``

********************
Explicit file output
********************
subtle difference between output stream ``>`` and ``>>`` for writing output in shell as
overwrite or concatenation (little difference with how awk program behaves...i skipped it for now)

###############################
Flow Control with next and exit
###############################
Like shell script, you can exit awk script using ``exit``

.. code-block:: bash

    #!/usr/bin/awk -f
    {
        # lots of code here, where you may find an error
        if ( numberOfErrors > 0 ) {
            exit
        }
    }

You can also exit with error condition    

.. code-block:: bash

    #!/usr/bin/awk -f
    #| here, we expect all lines to be 60 char-long. use exit status as direction of violation
    {
        if ( length($0) > 60) {
            exit 1
        } else if ( length($0) < 60) {
            exit 2
        }
        print
    }

#######################
AWK Numerical Functions
#######################
.. csv-table:: Numeric Functions
    :header: Name,Function,Variant
    :delim: |

    cos     | cosine                |  GAWK,AWK,NAWK
    exp     | Exponent              |    GAWK,AWK,NAWK
    int     | Integer               | GAWK,AWK,NAWK
    log     | Logarithm             |   GAWK,AWK,NAWK
    sin     | Sine              |    GAWK,AWK,NAWK
    sqrt    |    Square             | Root GAWK,AWK,NAWK
    atan2   |   Arctangent              |  GAWK,NAWK
    rand    |    Random             |  GAWK,NAWK
    srand   |   Seed                | Random GAWK,NAWK

####################
AWK String functions
####################
.. csv-table:: String funcitons
    :header: Name, Example Usage, Explanation
    :delim: |

    length(string)          | ``if (length($0) < 80) {...}`` | length of string
    index(string,search)    | ``if (index(sentence, ",") > 0) {...}`` | search for substring index
    substr(string,position)         |  | length = number of car to extract (default=1)
    substr(string,position,length)  | ``{print substr($0,40,10)}``  | print col 40 to 50
    split(string,array,separator)   |  ``n=split(string,array," ");``  | count words assuming white-space separates them
    |**below only in NAWK GAWK**| 
    sub(regex,replacement,string)   |  ``sub(/old/, "new", string)``  | (only the 1st occurence) replace `"old`" with `"new`". returns 1 if substitution occured, 0 elsewise
    sub(regex,replacement)          |  ``sub(/old/, "new")``  | same, but ``$0`` assumed for ``string``
    gsub(regex,replacement)         |   ``gsub(/old/, "new", string)`` | same as ``sub``, but for all occurences (not just the fisrt)
    gsub(regex,replacement,string)  |   ``gsub(/old/, "new", string)`` |
    match(string,regex)             | ``if (match($0,regex)) {...}``   |  when regexp is found, sets special variable ``RSTART`` and ``RLENGTH`` (see example below)
    |**below only in GAWK**|     
    tolower(string)                 | ``print tolower($0);``   |   lowercase
    toupper(string)                 |  ``print toupper($0);``  |   uppercase
    asort(string,[d])               |    |   
    asorti(string,[d])              |    |   
    gensub(r,s,h [,t])              |    |   
    strtonum(string)                |    |   

More Examples

.. code-block:: bash
    
    # search for the string "HELLO" at position 20
    substr($0,20,5) == "HELLO" {print}    

**********
split demo
**********
.. code-block:: bash

    #!/usr/bin/awk -f
    BEGIN {
    # this script breaks up the sentence into words, using 
    # a space as the character separating the words
        string="This is a string, is it not?";
        search=" ";
        n=split(string,array,search);
        for (i=1;i<=n;i++) {
            printf("Word[%d]=%s\n",i,array[i]);
        }
        exit;
    }

*********
gsub demo
*********
Below prints out: ``Substitution occurred: ANother sample of AN example sentence``

.. code-block:: bash

    #!/usr/bin/nawk -f
    BEGIN {
        string = "Another sample of an example sentence";
        pattern="[Aa]n";
        if (gsub(pattern,"AN",string)) {
            printf("Substitution occurred: %s\n", string);
        }

        exit;
    }

**********
match demo
**********
.. code-block:: bash

    #!/usr/bin/nawk -f
    # demonstrate the match function

    BEGIN {
        regex="[a-zA-Z0-9]+";
    }
    {
        if (match($0,regex)) {
    #           RSTART is where the pattern starts
    #           RLENGTH is the length of the pattern
                before = substr($0,1,RSTART-1);
                pattern = substr($0,RSTART,RLENGTH);
                after = substr($0,RSTART+RLENGTH);
                printf("%s<%s>%s\n", before, pattern, after);
        }
    }


.. todo:: Continue from below

::

     AWK Table 11
    Miscellaneous Functions
    Name    Variant
    getline AWK, NAWK, GAWK
    getline <file   NAWK, GAWK
    getline variable    NAWK, GAWK
    getline variable <file  NAWK, GAWK
    "command" | getline NAWK, GAWK
    "command" | getline variable    NAWK, GAWK
    system(command) NAWK, GAWK
    close(command)  NAWK, GAWK
    systime()   GAWK
    strftime(string)    GAWK
    strftime(string, timestamp) GAWK