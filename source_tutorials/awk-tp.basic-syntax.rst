################
AWK Basic Syntax
################
**********
awk --help
**********
::

    Usage: awk [POSIX or GNU style options] -f progfile [--] file ...
    Usage: awk [POSIX or GNU style options] [--] 'program' file ...
    POSIX options:      GNU long options: (standard)
        -f progfile     --file=progfile
        -F fs           --field-separator=fs
        -v var=val      --assign=var=val
    Short options:      GNU long options: (extensions)
        -b          --characters-as-bytes
        -c          --traditional
        -C          --copyright
        -d[file]        --dump-variables[=file]
        -e 'program-text'   --source='program-text'
        -E file         --exec=file
        -g          --gen-pot
        -h          --help
        -L [fatal]      --lint[=fatal]
        -n          --non-decimal-data
        -N          --use-lc-numeric
        -O          --optimize
        -p[file]        --profile[=file]
        -P          --posix
        -r          --re-interval
        -S          --sandbox
        -t          --lint-old
        -V          --version

***********************************
AWK in the terminal or Program file
***********************************
.. code-block:: bash
    

    # basically a cat command here (print each line)
    $ awk '{print}' marks.txt
    1)  Amit    Physics  80
    2)  Rahul   Maths    90
    3)  Shyam   Biology  87
    4)  Kedar   English  85
    5)  Hari    History  89

    # invoke awk script with the '-f' option
    # (command.awk contains {print})
    $ awk -f command.awk marks.txt
    1)  Amit    Physics  80
    2)  Rahul   Maths    90
    3)  Shyam   Biology  87
    4)  Kedar   English  85
    5)  Hari    History  89

*********
-v option
*********
Below some basic options are covered

- ``-v`` for variable assignment


.. code-block:: bash

    # === -v for variable assignment prior to program execution ===
    $ awk -v name=Harbaugh 'BEGIN{printf "Name = %s\n", name}'
    #>Name=Harbaugh

*********************
dump global variables
*********************
- ``--dump-variables[=file]`` prints a sorted list of global variables and their final values to file
- default filename: ``awkvars.out``

.. code-block:: bash

    # === --dump-variables ===
    # dumps a sorted list of global-variables (default filename: awkvars.out)
    $ awk --dump-variables ''
    $ cat awkvars.out 
    ARGC: 1
    ARGIND: 0
    ARGV: array, 1 elements
    BINMODE: 0
    CONVFMT: "%.6g"
    ERRNO: ""
    FIELDWIDTHS: ""
    FILENAME: ""
    FNR: 0
    FPAT: "[^[:space:]]+"
    FS: " "
    IGNORECASE: 0
    LINT: 0
    NF: 0
    NR: 0
    OFMT: "%.6g"
    OFS: " "
    ORS: "\n"
    RLENGTH: 0
    RS: "\n"
    RSTART: 0
    RT: ""
    SUBSEP: "\034"
    TEXTDOMAIN: "messages"


*****************************************************
--profile[=file] to create pretty-printed script file
*****************************************************
.. code-block:: bash

    # === --profile option to create pretty-printed file ===
    # --profile[=file] (default output filename: awkprof.out)
    $ awk --profile='pretty.awk' 'BEGIN{printf"---|Header|--\n"} {print} END{printf"---|Footer|---\n"}' marks.txt > /dev/null 
    cat pretty.awk

Content of the outputted ``pretty.awk`` file

.. code-block:: awk

    # gawk profile, created Fri Aug 19 23:12:41 2016

    # BEGIN block(s)

    BEGIN {
        printf "---|Header|--\n"
    }

    # Rule(s)

    {
        print $0
    }

    # END block(s)

    END {
        printf "---|Footer|---\n"
    }