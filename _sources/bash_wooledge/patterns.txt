Patterns
""""""""

#############
Glob patterns
#############
- ``*`` : Matches any string, including the null string.
- ``?`` : Matches any single character.
- ``[...]`` : Matches any one of the enclosed characters.


.. todo:: read more about globs at http://mywiki.wooledge.org/glob

.. code-block:: bash

    $ ls
    a  abc  b  c

    $ echo *
    a abc b c

    $ echo a*
    a abc


***************************************
Use glob, not ls for looping over files
***************************************
Say we have a file called "do this.txt", with white space.

.. code-block:: bash

    # white space from `ls` breaks array items into pieces! do not want!
    for file in $(ls); do rm "$file"; done
    #> rm: cannot remove `do ': No such file or directory
    #> rm: cannot remove `this.txt': No such file or directory

    # this work as expected
    for file in *; do rm "$file"; done

.. code-block:: bash

    # This is safe even if a filename contains whitespace:
    for f in *.tar; do
        tar tvf "$f"
    done

    # But this one is not:
    for f in $(ls | grep '\.tar$'); do
        tar tvf "$f"
    done

####################################
Extended Globs (I rather use regexp)
####################################
- turned **off by default**
- turn on via ``shopt`` command: ``$ shopt -s extglob``
- Here's a quote: "technically, they are equivalent to regular expressions, although the syntax looks different than most people are used to" => I'd rather stick with regexp...

.. code-block:: bash

    #?(list): Matches zero or one occurrence of the given patterns.
    #*(list): Matches zero or more occurrences of the given patterns.
    #+(list): Matches one or more occurrences of the given patterns.
    #@(list): Matches one of the given patterns.
    #!(list): Matches anything but the given patterns. 

    # === yeah, at this point, i'd rather just use grep ===
    $ ls
    names.txt  tokyo.jpg  california.bmp
    $ echo !(*jpg|*bmp)
    names.txt

###################
Regular expressions
###################
- Regular expressions (regex) are similar to Glob Patterns, but **can only be used for pattern matching**, not for filename matching. 
- Since 3.0, Bash supports the ``=~`` operator to the ``[[`` keyword.
- Bash uses the Extended Regular Expression (ERE) dialect

Syntax

.. code-block:: bash

    $ langRegex='(..)_(..)'
    $ if [[ $LANG =~ $langRegex ]]
    > then
    >     echo "Your country code (ISO 3166-1-alpha-2) is ${BASH_REMATCH[2]}."
    >     echo "Your language code (ISO 639-1) is ${BASH_REMATCH[1]}."
    > else
    >     echo "Your locale was not recognised"
    > fi

**Some advices from wooledge**

- we highly recommend you just **never quote your regex**
- for cross-compatibility, use a **variable to store your regex**
  
  - eg, ``re='^\*( >| *Applying |.*\.diff|.*\.patch)'; [[ $var =~ $re ]]``

###############
Brace Expansion
###############
- Brace expansions can only be used to generate **list of words** (not for pattern matching)
- Brace expansion happens **before** filename expansion

.. code-block:: bash

    $ echo {/home/*,/root}/.*profile
    # -> brace expansion goes before filename expansion, so will expand to this:
    $ echo /home/*/.*profile /root/.*profile
    # after this, the globs get expanded.


**Glob vs Brace expansion**

- Globs only expand to actual filenames
- Brace expansions will expand to any possible permutation of their contents.

.. code-block:: bash

    $ echo th{e,a}n
    then than
    $ echo {/home/*,/root}/.*profile
    /home/axxo/.bash_profile /home/lhunath/.profile /root/.bash_profile /root/.profile

    # oh i didn't know this was brace expansion. neat
    $ echo {1..9}
    1 2 3 4 5 6 7 8 9

    # this one is interesting
    $ echo {0,1}{0..9}
    00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19

My actual use-case

.. code-block:: bash
    
    # rename files with either .png or .pkl extension (see link on brack expansion above)
    # (-n will do a dry run, letting me check the rename will do what i want it to do )
    rename -n 's/normalized/test/' *.{png,pkl}    


    # use brace expansion to allow multiple extension
    grep -r --include=*.{py,m} test .