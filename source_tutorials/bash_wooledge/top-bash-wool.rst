Bash wooledge
=============
Some refrehsers from http://mywiki.wooledge.org/BashGuide

Content adapted according to my needs

.. toctree::

    3_param.rst

.. contents:: **Contents**
   :local:
   :depth: 1

Commands and arguments
""""""""""""""""""""""
Not much


Special Characters
""""""""""""""""""
.. list-table:: 
    :header-rows: 1
    :widths: 20,70

    * - Char.
      - Description   

    * - ``" "``
      - **Whitespace** — this is a tab, newline, vertical tab, form feed, carriage return, or space. Bash uses whitespace to determine where words begin and end. The first word is the command name and additional words become arguments to that command.

    * - ``$``
      - **Expansion** — introduces various types of expansions
    * - 
      - *parameter expansion* (``$var`` or ``${var}``)
    * - 
      - *command substitution* (``$(command)``)
    * - 
      - *arithmetic expansion* (``$((expression))``)

    * - ``''``
      - **Single quotes** — protect the text inside them so that it has a literal meaning.

    * - ``""``
      - **Double quotes** — protect the text inside them from being split into multiple words or arguments, yet allow substitutions to occur

    * - ``\``
      - Escape — (backslash) prevents the next character from being interpreted as a special character. This works outside of quoting, inside double quotes, and generally ignored in single quotes

    * - ``#``
      - **Comment**

    * - ``[[]]``
      - **Test** — conditional expression to test "true" or "false". 
      
    * - ``!``
      - **Negate** — negate/reverse a test or exit status. Example: ``! grep text file; exit $?`` 

    * - ``><`` 
      - **Redirection** — redirect a command's output or input.

    * - ``|``
      - **Pipe** — redirect output from a initial command to the input of secondary command.

    * - ``;``
      - **Command separator** — a representation of a newline. Used to separate multiple commands that are on the same line. 

    * - ``{}``
      - **Inline group** — commands inside the curly braces are treated as if they were one command. 
    * - 
      - Convenient to use these when Bash syntax requires only one command and a function doesn't feel warranted. 

    * - ``()``
      - **Subshell group** — similar to the above but where commands within are executed in subshell. Used much like a sandbox, if a command causes side effects (like changing variables), it will have no effect on the current shell. 

    * - ``(())``
      - **Arithmetic expression** — here characters such as ``+, -, *, /`` are mathematical operators used for calculations. 
    * - 
      - Can be used for variable assignments like ``(( a = 1 + 4 ))``
    * - 
      - Can be used for tests like if ``(( a < b ))``

    * - ``$(())``
      - **Arithmetic expansion** — Comparable to the above, but the expression is replaced with the result of its arithmetic evaluation. 
    * - 
      - Example: ``echo "The average is $(( (a+b)/2 ))"``. 

.. code-block:: bash

    $ echo "I am $LOGNAME"
    #> I am takanori

    $ echo 'I am $LOGNAME'
    #>I am $LOGNAME
    
    $ echo An open\ \ \ space
    #>An open   space
    
    $ echo "My computer is $(hostname)"
    #>My computer is sbia-pc125
    
    $ echo $(( 5 + 5 ))
    #>10
    
    $ (( 5 > 0 )) && echo "Five is greater than zero."
    #>Five is greater than zero.

