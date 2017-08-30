==================
Log Files
==================

Configuring Log Output
----------------------

Log output for the services mentioned above are configured at:

.. code-block:: shell

    /opt/kylo/kylo-ui/conf/log4j.properties
    /opt/kylo/kylo-services/conf/log4j.properties
    /opt/kylo/kylo-services/conf/log4j-spark.properties

..

You may place logs where desired according to the
'log4j.appender.file.File' property. Note the configuration line:

.. code-block:: shell

    log4j.appender.file.File=/var/log/<app>/<app>.log

..

The default log locations for the various applications are located at:

.. code-block:: shell

    /var/log/<service_name>

..
