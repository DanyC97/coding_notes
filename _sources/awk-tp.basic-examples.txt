#####################
AWK -- Basic Examples
#####################
marks.txt

::

    1) Amit     Physics   80
    2) Rahul    Maths     90
    3) Shyam    Biology   87
    4) Kedar    English   85
    5) Hari     History   89


.. code-block:: bash
    
    # print 3rd, 4th field, tab separated
    $ awk '{print $3 "\t" $4}' marks.txt
    #>Physics 80
    #>Maths   90
    #>Biology 87
    #>English 85
    #>History 89

    $ awk '{print $4 $3}' marks.txt 
    80Physics
    90Maths
    87Biology
    85English
    89History

    # same, but with white-space
    $ awk '{print $4 " " $3}' marks.txt 
    80 Physics
    90 Maths
    87 Biology
    85 English
    89 History

