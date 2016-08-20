Parameters
""""""""""
#####
Basic
#####

*******************************************************
Always double-quote when doing PE (parameter expansion)
*******************************************************
Reminder on why we need to **double quotes** parameter expansions:

.. code-block:: bash

    $ song="My song.mp3"
    $ rm $song
    #>rm: My: No such file or directory
    #>rm: song.mp3: No such file or directory

    # above is the same as:
    $ rm My song.mp3

    # so do this
    $ rm "$song"

**************************************
char needed with dealing with numerics
**************************************
.. code-block:: bash

    # defining and undefining variables
    $ a=5; a+=2; echo "$a"; unset a
    52 # <- note that this is a string concatenation

    # this will actually do number addition; ``let`` is the same as ((...))
    $ a=5; let a+=2; echo "$a"; unset a
    7

    # i prefer arithmetic expansion ((...))
    $ a=5; ((a+=10)); echo "$a"; unset a
    15

################################
Special Parameters and Variables
################################
.. code-block:: bash

    $ echo "My shell is $0, and has these options set: $-"
    #> My shell is bash, and has these options set: himBH

    $ echo "I am $LOGNAME, and I live at $HOME."
    #> I am takanori, and I live at /home/takanori.

.. _special_param:

******************
Special Parameters
******************
.. list-table:: 
    :header-rows: 1
    :widths: 20,20,70

    * - Name
      - Usage
      - Description

    * - ``0``
      - ``"$0"``
      - Name or Path of the script (not always reliable)

    * - ``1,2,etc``
      - ``"$1"``
      - **Positional Parameters** --- arguments that were passed to the script/function (like ``argv``)
      
    * - ``*``
      - ``"$*"``
      - Expands all positional parameters. 
    * - 
      - ``"${arrayname[*]}"``
      - When **double-quoted**, it expands to a single string containing them all, separated by the first character of the IFS variable (typically space) (only usecase I can think of: convert arrays into a single string)

    * - ``@``
      - ``"$@"``
      - Expands all positional parameters. 
    * - 
      - ``"${arrayname[@]}"``
      - When **double-quoted**, it expands to a list of them all as individual words. (I use these for ``for loop``)
      
    * - ``#``
      - ``echo ${#array[@]}``
      - Number of positional parameters (like ``argc``)

    * - ``?``
      - ``echo "$?"``
      - Exit code of most recent foreground command (0=success)

    * - ``$``
      - ``echo "$$"``
      - PID of current shell

    * - ``!``
      - ``echo "$!"``
      - PID of the most recent command executed in the bg (eg, my spyder pid)

    * - ``_``
      - ``echo "$_"``
      - Last argument of the last command executed


***************************************
Special variables provided by the shell
***************************************
Only a subset

.. code-block:: bash
    :linenos:
      
    $ echo "BASH_VERSION = ${BASH_VERSION}"
    #>BASH_VERSION = 4.3.11(1)-release
    
    $ echo "HOSTNAME = ${HOSTNAME}"
    #>HOSTNAME = sbia-pc125

    $ echo "LOGNAME = ${LOGNAME}"
    #LOGNAME = takanori

    # PID of the parent process of this shell
    $ echo "PPID = ${PPID}"       
    #>PPID = 15290

    $ echo "PWD = ${PWD}"
    #>PWD = /home/takanori/Dropbox/git/snippet/source/tutorials

    # random number between 0-32767
    $ echo "RANDOM = ${RANDOM}"   
    #>RANDOM = 24644

    # number of char that'll fit in one line in your terminal window (changes as i adjust window size)
    $ echo "COLUMNS = ${COLUMNS}" 
    #>COLUMNS = 147

    # number of lines that'll fit in one line in your terminal window (changes as i adjust window size)
    $ echo "LINES = ${LINES}"     
    #>LINES = 31

    $ echo "HOME = ${HOME}"
    #>HOME = /home/takanori

    # A colon-separated list of paths that will be searched to find a command
    $ echo "PATH = ${PATH}"       
    #>PATH = /home/takanori/anaconda2/bin:/usr/local/bin/protoc:/usr/local/cuda-6.5/bin:/home/takanori/anaconda2/bin:/usr/local/bin/protoc:/usr/local/cuda-6.5/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/takanori/Dropbox/git/configs_master/bin:/home/takanori/mybin/itksnap-3.2.0-20141023-Linux-x86_64/bin/:/usr/local/MATLAB/R2013a/bin:/home/takanori/abin:/usr/local/cuda-6.5/bin:/home/takanori/mybin/Slicer-4.4.0-linux-amd64:/home/takanori/mybin/ImageJ:/home/takanori/mybin/spark-2.0.0-bin-hadoop2.7/bin:/home/takanori/Dropbox/git/configs_master/bin:/home/takanori/mybin/itksnap-3.2.0-20141023-Linux-x86_64/bin/:/usr/local/MATLAB/R2013a/bin:/home/takanori/abin:/usr/local/cuda-6.5/bin:/home/takanori/mybin/Slicer-4.4.0-linux-amd64:/home/takanori/mybin/ImageJ:/home/takanori/mybin/spark-2.0.0-bin-hadoop2.7/bin
    
    # prompt string1 (formatting of shell prompt)
    $ echo "PS1 = ${PS1}"         
    #>PS1 = $ 

    # prompt string2 (formatting of line warap in shell prompt)
    $ echo "PS2 = ${PS2}"         
    #>PS2 = > 

    # the directory that is used to store temporary files (by the shell).
    $ echo "TMPDIR = ${TMPDIR}"   
    #>TMPDIR = 
    
    
#############################
PE tricks (some I rarely use)
#############################
*************
Summary table
*************
.. list-table:: 
    :header-rows: 1
    :widths: 20,70

    * - Syntax
      - Description

    * - ``${var}`` (:ref:`link <${var}>`)
      - **Standard substitution** -- substitute the value of ``var``

    * - ``${var:-word}`` (:ref:`link <${var:-word}>`)
      - **Use default value** -- if ``var`` is null, use ``word``. Value of ``var`` remains unchanged (so a temporary substituion).
    
    * - ``${var:=word}`` (:ref:`link <${var:=word}>`)
      - **Assign default** -- if ``var`` is null, use ``word``. The value of 'vareter' is then substituted. 
    
    * - ``${var:+word}`` (:ref:`link <${var:+word}>`)
      - **Use Alternate Value** -- If ``var`` is set, substitute it with ``word``.  If ``var`` is null, do not substitute (so remains null..I never encountered a situation where I wanna do this)
        
    * - ``${var:offset:length}`` (:ref:`link <${var:offset:length}>`)
      - **Substring Expansion** --  Expands to up to ``length`` characters of ``var`` starting at the character specified by ``offset`` (0-indexed). If ``length`` is omitted, goes all the way until the end.        
    * - ``${var[@]:offset:length}`` (:ref:`link <${var:offset:length}>`)
      - Same as above, but item-wise (see demo below)
        
    * - ``${#var}`` (:ref:`link <${#var}>`)
      - **Number of chars** -- number of characters in var.       

    * - ``${#var[@]}`` (:ref:`link <${#var}>`)
      - **Number of array items** -- number of items if ``var`` is an array. Same for ``${var[*]}`` syntax.
        
    * - ``${var#pattern}`` (:ref:`link <${var#pattern}>`)
      - The 'pattern' is matched against the beginning of 'var'. The result is the expanded value of 'var' with the shortest match deleted.    

    * - ``${var[@]#pattern}`` (:ref:`link <${var#pattern}>`)
      - Same as above, but applied on array items (see example below)
        
    * - ``${var##pattern}``
      - same as above, but **longest match** is deleted
            
    * - ``${var%pattern}``
      - same as ``${var#pattern}``, but applied to the **end** of the string (shortest match at tail of the string deleted)
            
    * - ``${var%%pattern}``
      - Same as above, but **longest** match gets deleted.

    * - ``${var/pat/string}``
      - **fill in later**
            
    * - ``${var//pat/string}``
      - 
                
    * - ``${var/#pat/string}``
      - 
                
    * - ``${var/%pat/string}``
      - 
                
    * - ``${var:?message}`` (:ref:`link <${var:?msg}>`)
      - If ``var`` is null, print ``message`` to standard error.

.. _${var}:

**********
``${var}``
**********
substitute the value of ``var``

.. code-block:: bash

    # === ${var} ===
    $ unset var; printf "${var}" # print null....nothing

    $ var="I am $USER"; printf "${var}\n"
    I am takanori

.. _${var:-word}:

************************************
``${var:-word}`` (use default value)
************************************
- :ref:`${var}`

**Use default value**

- if ``var`` is null, use ``word``. Value of ``var`` remains unchanged
- (so a temporary substituion)

.. code-block:: bash

    # === ${var:-word}: sub temporarily if null ===
    $ var="I am $USER"; word="Harbaugh"
    $ printf "${var:-"${word}"}\n"
    I am takanori
    $ unset var; printf "${var:-"${word}"}\n"
    Harbaugh
    $ printf "${var}\n"  # value remains null

.. _${var:=word}:

*********************************
``${var:=word}`` (assign default)
*********************************
**Assign default** 

- if ``var`` is null, use ``word``. 
- The value of 'var' is then substituted by ``word``
    
.. code-block:: bash

    # === ${var:=word}: sub permanently if null ===
    $ var="I am $USER"; word="Harbaugh"
    $ printf "${var:="${word}"}\n"
    I am takanori
    $ unset var; printf "${var:="${word}"}\n"
    Harbaugh
    $ printf "${var}\n" # below we see the value of `var` got replaced with `word`
    Harbaugh

.. _${var:+word}:

**************************************
``${var:+word}`` (use alternate value)
**************************************
**Use Alternate Value**

- If ``var`` is set, substitute it with ``word``.  
- If ``var`` is null, do not substitute (so remains null..I never encountered a situation where I wanna do this)
        
.. _${var:offset:length}:

**********************************************
``${var:offset:length}`` (substring expansion)
**********************************************
**Substring Expansion**

- Expands to up to ``length`` characters of ``var`` starting at the character specified by ``offset`` (0-indexed). 
- If ``length`` is omitted, goes all the way until the end.
- if ``offset`` is negative, count backward from end of ``param`` (use parantheses)

.. code-block:: bash

    # === demo on ${var:offset:length} syntax (like slicing in python) ===
    var="0123456789"
    echo ${var:1:5}
    #> 12345
    echo ${var:2}
    #> 23456789 #(goes until end)

    # -- count backwards (paranthesis is needed!) --
    echo ${var:(-5)}
    #> 56789
    echo ${var:(-5):2}
    #> 56 

    #-- in case of array, above will be done item wise --
    var_array=("0.Tak " "1.Wata " "2.Mike " "3.Jim ")
    echo ${var_array[@]:1}
    #> 1.Wata 2.Mike 3.Jim
    echo ${var_array[@]:0:2}
    #> 0.Tak 1.Wata


.. _${#var}:

*****************************************************************
``${#var}``, ``${#var[@]}`` (number of characters or array items)
*****************************************************************
``${#var}`` = number of characters in ``var``.
``${#var[@]}`` = number of items in ``var`` if ``var`` is an array. Same for ``${var[*]}`` syntax.

.. code-block:: bash

    # === demo on ${#var} ===
    var="I am tired of this"
    echo "${#var}"
    #> 18 # (number of charcters)
    echo "${#var[@]}"
    #> 1
    echo "${#var[*]}"
    #> 1

    var=(I am "an array")
    echo "${#var}"
    #> 1 # (not 100% sure why...)
    echo "${#var[@]}"
    #> 3 # number of list items
    echo "${#var[*]}"
    #> 3 # number of list ittems

.. _${var#pattern}:

*****************************************************
``${var#pattern}`` (delete beginning of str if match)
*****************************************************
.. code-block:: bash

    # === demo on ${var#pattern} ===
    var="I love Michgian Football"
    echo "${var#I love M}"  # delete if beginning matches
    #> ichgian Football
    echo "${var#love}"    # nothing happens if no matching occurs
    #> I love Michgian Football

    #-- if var is an array, this will be done for each item --
    var_array=("I love Michigan" "I love Stanford" "I hate *SU")
    echo "${var_array#I love}" # <- only applies to the first item
    #>  Michigan
    echo "${var_array[@]#I love}"
    #>  Michigan  Stanford I hate *SU


.. _${var:?msg}:

*************************************
``${var:?msg}`` (print msg to stderr)
*************************************
If ``var`` is null, print ``message`` to standard error.
    
.. code-block:: bash

    # === ${var:?msg} send stderr if null ===
    $ ERR_MSG="OH NO!"
    $ a='hello'; echo "${a:?"${ERR_MSG}"}"
    hello
    $ unset a; echo "${a:?"${ERR_MSG}"}"
    bash: a: OH NO!
    $ unset a; $ echo "${a:?ERR_MSG}"
    bash: a: ERR_MSG




    

