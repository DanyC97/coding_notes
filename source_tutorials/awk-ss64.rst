########################
Whirlwind tour from ss64
########################
http://ss64.com/bash/awk.html

************
Basic syntax
************
.. code-block:: bash

    # program in single quote (if not Input-File is given, awk applies Program to stdin
    $ awk <options> 'Program' Input-File1 Input-File2 ...

    # '-f' option to run via awk script
    $ awk -f PROGRAM-FILE <options> Input-File1 Input-File2 ...

For each of reading, each line in awk program is normally a separate **Program** statement like this::

    pattern { action }
    pattern { action }
    ...

.. code-block:: bash

    # Display lines from samplefile containing the string "123" or "abc" or "some text":
    # (remember, single quote indicates awk Program)
    # below regexp is enclosed in slashes (/)
    awk '/123/ { print $0 } 
         /abc/ { print $0 }
         /some text/ { print $0 }' samplefile

************
awk-patterns
************
awk-patterns can be one of the following:

::

    /Regular Expression/        - Match =
    Pattern && Pattern          - AND
    Pattern || Pattern          - OR
    ! Pattern                   - NOT
    Pattern ? Pattern : Pattern - If, Then, Else
    Pattern1, Pattern2          - Range Start - end
    BEGIN                       - Perform action BEFORE input file is read
    END                         - Perform action AFTER input file is read

**********************************
Variable names that are predefined
**********************************
.. http://docutils.sourceforge.net/docs/ref/rst/directives.html#id4        
.. csv-table:: 
    :header: Name, Description
    :widths: 20,70
    :delim: |

    **CONVFMT**  | conversion  format  used  when  converting  numbers (default %.6g)
    **FS**       | regular  expression  used  to separate fields; also settable by option -Ffs.
    **NF**       | number of fields in the current record
    **NR**       | ordinal number of the current record
    **FNR**      | ordinal number of the current record in the current file
    **FILENAME** | the name of the current input file
    **RS**       | input record separator (default newline)
    **OFS**      | output field separator (default blank)
    **ORS**      | output record separator (default newline)
    **OFMT**     | output format for numbers (default %.6g)
    **SUBSEP**   | separates multiple subscripts (default 034)
    **ARGC**     | argument count, assignable
    **ARGV**     | argument  array,  assignable;  non-null members are taken as filenames
    **ENVIRON**  | array  of  environment  variables;  subscripts  are names.

********
Examples
********
.. code-block:: bash

    $ ls -l | head -5
    total 116K
    drwxr-xr-x 4 takanori takanori 4.0K Aug 19 23:46 build
    drwxr-xr-x 8 takanori takanori 4.0K Aug 19 21:42 build_published
    drwxr-xr-x 8 takanori takanori 4.0K Aug 19 23:40 source_tutorials
    -rw-rw-rw- 1 takanori takanori   81 Aug 19 23:25 awkprof.out

    # print 5th column
    $ ls -l | head -5 | awk '{print $5}' 

    4.0K
    4.0K
    4.0K
    81

    # print 5th and 9th column, with "-" char in between
    # (need a way to programatically skip first line here...)
    $ ls -l | head -5 | awk '{print $9 ": filesize =" $5}' 
    : filesize =
    build: filesize =4.0K
    build_published: filesize =4.0K
    source_tutorials: filesize =4.0K
    awkprof.out: filesize =81

    # print number of fields in the current record (ie, current line)
    $ ls -l | head -5 | awk '{print NF}' 
    2
    9
    9
    9

    # only print if NF==9 (number of fields)
    $ ls -l | head -5 | awk 'NF == 9 {print $9 " -> filesize =" $5}' 
    build -> filesize =4.0K
    build_published -> filesize =4.0K
    source_tutorials -> filesize =4.0K
    awkprof.out -> filesize =81


    # print column 5,9, prepended with line number (NR)
    $ ls -l | head -5 | awk '{print NR ": " $9 "-" $5}' 
    1: -
    2: build-4.0K
    3: build_published-4.0K
    4: source_tutorials-4.0K
    5: awkprof.out-81


    # print 1st item and 2nd from last item $(NF-1)
    $ ls -l | head -5 | awk '{print $1, $(NF-1)}' # , seems to add whitespace
    total total
    drwxr-xr-x 23:46
    drwxr-xr-x 21:42
    drwxr-xr-x 23:40
    -rw-rw-rw- 23:25

    # print if 6 field equals Nov (different from grep, which will map at any part of the line)
    $ ls -l | awk '$6 == "Nov"'
    drwxr-xr-x  6 takanori takanori 4.0K Nov  9  2015 CytoscapeConfiguration
    drwxr-xr-x  5 takanori takanori 4.0K Nov  9  2015 Cytoscape_v3.2.1
    -rw-r--r--  1 takanori takanori 1.8M Nov 26  2010 libwx-perl_0.9702-1_i386.deb
    -rw-r--r--  1 takanori takanori 4.4K Nov 11  2015 matlab_crash_dump.20697-1
    -rw-r--r--  1 takanori takanori 4.4K Nov  1  2015 matlab_crash_dump.4175-1
    -rw-r--r--  1 takanori takanori 4.4K Nov 19  2015 matlab_crash_dump.8347-1
    -rw-rw-rw-  1 takanori takanori 100K Nov  4  2015 python.sublime-workspace
    -rw-r--r--  1 takanori takanori  13K Nov  8  2015 test.txt

    # same, but just print the final field (so just the filename here)
    $ ls -l | awk '$6 == "Nov" {print $(NF)}'
    CytoscapeConfiguration
    Cytoscape_v3.2.1
    libwx-perl_0.9702-1_i386.deb
    matlab_crash_dump.20697-1
    matlab_crash_dump.4175-1
    matlab_crash_dump.8347-1
    python.sublime-workspace
    test.txt

    # line counts (hmm, one more than wc?)
    $ awk 'END { print NR }' util_0711.py
    410
    $ wc -l util_0711.py
    409 util_0711.py

    # print even lines only (together with line numbers)
    $ awk 'NR%2 == 0 {print NR,$0}' util_0711.py | head -10
    2 import numpy as np
    4 
    6 
    8 from sklearn.cross_validation import KFold
    10 from os.path import join
    12 import matplotlib.pyplot as plt
    14 import scipy as sp        
    16 #%%
    18     """
    20     """

    # you're getting the hang of this now Tak!
    ls -l *.py | head -5 | awk '\
    BEGIN   { print "Owner\t\tFile" } \
            { print $3, "\t", $9}   \
    END     { print " - DONE -" } \
    '
    #>Owner       File
    #>takanori     t_0711a_pnc_conn_agereg_fs_corrwithage.py
    #>takanori     t_0711b_pnc_conn_agereg_fs_variance.py
    #>takanori     t_0711c_pnc_bct_nmf.py
    #>takanori     t_0712_pnc_bct_ensemble.py
    #>takanori     t_0713b_pnc_supervised_nmf.py
    #> - DONE -


****************
Complex examples
****************
.. code-block:: bash

    # print length of the longest input line
    $ ls -l | awk '{if (length($0) > max) max = length($0)} END {print max}' 
    93

    # print the average file size of all png files in a directory
    $ cd ~/Dropbox/work/sbia_work/python/now/results/t_0813_bct_pnc_interhemi_particp_coeff
    $ ls -l *.png | gawk '{sum += $5; n++;} END {print sum/n;}' 
    188.61

    # print sorted list of login names of all users
    $ cat /etc/passwd | head -5
    root:x:0:0:root:/root:/bin/bash
    daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
    bin:x:2:2:bin:/bin:/usr/sbin/nologin
    sys:x:3:3:sys:/dev:/usr/sbin/nologin
    sync:x:4:65534:sync:/bin:/bin/sync

    $  awk -F: '{ print $1 }' /etc/passwd | sort | head -5
    avahi
    avahi-autoipd
    backup
    bin
    colord
