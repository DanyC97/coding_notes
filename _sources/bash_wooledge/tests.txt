Tests
"""""

###################################
Exit status (0 = success)....use $?
###################################
- Recall special variable ``$?`` (see :ref:`special_param`)
- This indicates exit status (0 = success, else fail)

.. code-block:: bash

    $ ping God
    ping: unknown host God

    # nonzero, so last command failed
    $ echo $?
    2



#############################
Control operators (&& and ||)
#############################
Handy for simple error checking

.. code-block:: bash

    #=========================================================================#
    # semicolon -> sequential execution of commands
    #=========================================================================#
    # this will execute commands sequentially
    mkdir d; cd d;

    #=========================================================================#
    # cmd1 && cmd2 (run cmd2 only if cmd1 succeeds)
    #=========================================================================#
    # so this will only ``cd`` to new_dir if it gets created successfully
    $ mkdir new_dir && cd new_dir

    #=========================================================================#
    # cmd1 || cmd2 (run cmd2 only if cmd1 fails)
    #=========================================================================#
    # so here, ``echo`` only runs when ``rm`` fails
    $ rm /etc/some_file.conf || echo "I couldn't remove the file"

.. note:: Advice from Wooledge

    It's best not to get overzealous when dealing with conditional operators. They can make your script hard to understand    

.. code-block:: bash
    
    # good practice: make sure that your scripts always return a non-zero exit code if something unexpected happened
    rm file || { echo 'Could not delete file!' >&2; exit 1; }

##########################
Grouping statements {...;}
##########################
.. warning:: you need a **newline** or **semicolor (;)** at the end of the curly braces!

    I'm guessing this is to distinguish **brace expansion** syntax from **grouping** syntax

    .. code-block:: bash

        # semicolon at end
        $ test_condition && { rm "$file" || echo "Couldn't delete: $file" >&2; }
    
        # newline at end
        {
            do_something
            do_another_thing
        } < file


*******************************************
Use-case1: reporting stderr on complex test
*******************************************
Suppose we want to delete a file if it contains a "good" word but not a "bad" word.

.. code-block:: bash

    #=========================================================================#
    # use-case: reporting error with a more complex test condition
    #=========================================================================#
    # if test1 and test2 succeeds, remove file (group together the ``rm`` and ``echo`` command)
    $ test1 && test2 && { rm "$file" || echo "Couldn't delete: $file" >&2; }

    #=========================================================================#
    # a little more practical example:
    # Suppose we want to delete a file if it contains a "good" word but not a "bad" word.
    #=========================================================================#
    #| NOTE: -q (quiet) used since we just want the exit status for the tests below

    # exit status 0 (success) if "$file" contains 'goodword'
    grep -q goodword "$file"            

    # exit status 0 (success) if "$file" does not contain 'badword'
    ! grep -q "badword" "$file"         

    # so using conditional operator, we can check if the desired test succeeds
    $ grep -q goodword "$file" && ! grep -q badword "$file" && rm "$file"

    #=========================================================================#
    # if the test fails, want to report error to stderr
    #=========================================================================#
    # this one is dangerous!
    $ grep -q goodword "$file" && ! grep -q badword "$file" && rm "$file" || echo "Couldn't delete: $file" >&2

    # use grouping with curly braces (we want the ``rm`` and ``echo`` together)
    $ grep -q goodword "$file" && ! grep -q badword "$file" && { rm "$file" || echo "Couldn't delete: $file" >&2; }

**************************************************
Use-case2: redirect input to a group of statements
**************************************************
.. code-block:: bash

    # redirect file to a group of commands that read input.
    # The file will be opened when the command group starts, 
    # stay open for the duration of it, and be closed when the command group finishes.
    {
        read firstLine
        read secondLine
        while read otherLine; do
            something
        done
    } < file

*************************
Use-case3: error handling
*************************
.. code-block:: bash

    # Check if we can go into appdir.  If not, output an error and exit the script.
    cd "$appdir" || { echo "Please create the appdir and try again" >&2; exit 1; }