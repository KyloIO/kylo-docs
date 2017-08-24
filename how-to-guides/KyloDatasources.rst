========================
Kylo Datasources Guide
========================

Introduction
====================

Kylo can manage the creation and usage of Nifi RDBMS data source configurations, through a simple `Data Source UI <http://localhost:8400/index.html#!/datasources>`_.

JDBC
=============

.. note:: Permissions for the jars are separate per the type of process running.

Locations
-----------

    +----------------------------------+------------------------------------------------------------------------------------------------------------------+
    | $NIFI_HOME/data/lib or           | Needed by Nifi for the DBCPConnectionPool.                                                                       |
    | any path accesible by NiFi       | The path might be erased at Nifi upgrade time.                                                                   |
    +----------------------------------+------------------------------------------------------------------------------------------------------------------+
    | $KYLO_HOME/kylo-services/plugin  | Needed by Kylo in the schema discovery (Data Ingestion). Need to restart Kylo if added post-start                |
    +----------------------------------+------------------------------------------------------------------------------------------------------------------+
    | $KYLO_HOME/kylo-services/lib     | Needed by Kylo wrangler (Visual Query / Data Transformation)                                                     |
    +----------------------------------+------------------------------------------------------------------------------------------------------------------+

Spark configuration
----------------------
While using the Visual Query / Data Transformation, you will need to make available the datasource jar.
Recommended is to keep the datasource jar with the application (Kylo/Nifi), and pass it along to spark.

Depending on the Spark setup (server mode or the others), you will need to do different changes.

Server mode / Sandbox
~~~~~~~~~~~~~~~~~~~~~~~~

- edit `$KYLO_HOME/kylo-services/bin/run-kylo-spark-shell.sh`

- update `KYLO_DRIVER_CLASS_PATH` with the path to the datasource jar (can be under $NIFI_HOME)

OR (not so recommended)

- update/append `$SPARK_HOME/conf/spark-defaults.conf` with the path value. Values can be appended with ":" .This file should be referenced by spark-submit, or it's referenced by `/opt/kylo/kylo-services/bin/run-kylo-spark-shell.sh`, which passes the values like `spark-submit ... --driver-class-path /path-to-oracle-jdbc/:/path-to-other-jars/`


Non-server mode
~~~~~~~~~~~~~~~~~~~~~~~~

- edit `$KYLO_HOME/kylo-services/spark.properties`

- add to `spark.shell.sparkArgs` the `--jar /path-to-datasource-jdbc/`

You can find more `information here <http://kylo.readthedocs.io/en/latest/installation/KyloSparkProperties.html>`

Configuration examples
=======================

Oracle
-------

::

    Database Connection URL = jdbc:oracle:thin:@oracle:1521
    Database Driver Class Name =  oracle.jdbc.OracleDriver
    User = <user>
    Password = <password>
    Database Driver Location = /opt/nifi/oracle/oracle-jdbc.jar (needs to be accesible by Nifi)

..

.. note:: Oracle tables are only in UPPERCASE

MariaDB / MySQL
----------------

::

    Database Connection URL = jdbc:mariadb://mariadb:3306	
    Database Driver Class Name =  org.mariadb.jdbc.Driver
    User = <user>
    Password = <password>
    Database Driver Location = /opt/nifi/mysql/maria-jdbc.jar (needs to be accesible by Nifi)

..

(OPT) Specify the password in the Kylo application properties file
Update /opt/kylo/kylo-services/conf/application.properties with
nifi.service.<datasource_name>.password=<password>

Perfomance considerations while importing data
==================================================

Consider to use the Sqoop import processor for `performance gains <../tips-tricks/TroubleshootingandTips.html#gettabledata-vs-importsqoop-processor>`_

