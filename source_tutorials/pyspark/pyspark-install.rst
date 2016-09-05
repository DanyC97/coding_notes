Install PySpark (``pyspark-install``)
"""""""""""""""""""""""""""""""""""""

http://spark.apache.org/downloads.html

########
windows?
########
09-05-2016 (15:36)

.. admonition:: References

  - http://www.ithinkcloud.com/tutorials/tutorial-on-how-to-install-apache-spark-on-windows/
  - http://jmdvinodjmd.blogspot.com/2015/08/installing-ipython-notebook-with-apache.html    


#. Download tgz from http://spark.apache.org/downloads.html  
#. Unzip the folder ``spark-2.0.0-bin-hadoop2.7`` under ``C:\spark-2.0.0-bin-hadoop2.7``
#. Set env-var by:

  - Start Menu -> My Computer (Right Click and select ``Properties``) -> Advanced System Settings (see screenshot)
  - Create an Environment variable named ``SPARK_HOME`` with value equal to ``C:\spark-2.0.0-bin-hadoop2.7``


.. important::

  - http://stackoverflow.com/questions/31962862/ipython-ipython-notebook-config-py-missing

  ``ipython_notebook_config.py`` no longer around after ``jupyter``, so above instruction no longer applies...

  Do this to create jupyter profile under ``~/.jupyter``
  
  .. code-block:: bash
  
      $ jupyter notebook --generate-config
      Writing default config to: C:\Users\takanori\.jupyter\jupyter_notebook_config.py

  For more info, see:

  - http://jupyter.readthedocs.io/en/latest/migrating.html
  - http://jupyter.readthedocs.io/en/latest/migrating.html#profiles

.. image:: /_static/img/pyspark_install_win_pic1.png
   :align: center

.. image:: /_static/img/pyspark_install_win_pic2.png
   :align: center


#############################
Retry, above is a clusterfuck
#############################
http://stackoverflow.com/questions/32948743/cant-start-apache-spark-on-windows-using-cygwin

http://spark.apache.org/docs/latest/spark-standalone.html

http://stackoverflow.com/questions/17465581/how-to-set-up-spark-cluster-on-windows-machines

I first need java: 

- https://www.java.com/en/download/faq/win10_faq.xml
- https://www.java.com/en/download/help/windows_manual_download.xml

Else i got the message:

.. code-block:: bash
    
    takanori@DESKTOP-FJQ41I1 /home/takanori
    $ pyspark
    Error: Could not find or load main class org.apache.spark.launcher.Main

    takanori@DESKTOP-FJQ41I1 /home/takanori
    $ which pyspark
    /home/takanori/\spark-2.0.0-bin-hadoop2.7\bin/pyspark

.. admonition:: ...maybe cygwin isn't the way to go...

  http://stackoverflow.com/questions/34483855/installing-spark-for-python-through-cgwin

  See comment by Josh Rosen, one of PySpark's original authors.

    As one of PySpark's original authors, I do not recommend using it in Cygwin.