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
    | $NIFI_HOME/nifi-<version>/lib    | Needed by Nifi for the DBCPConnectionPool. Can set a custom path, but need to set `Database Driver Location(s)`  |
    +----------------------------------+------------------------------------------------------------------------------------------------------------------+
    | $KYLO_HOME/kylo-services/plugin  | Needed by Kylo in the schema discovery (Data Ingestion)                                                          |
    +----------------------------------+------------------------------------------------------------------------------------------------------------------+
    | $KYLO_HOME/kylo-services/lib     | Needed by Kylo wrangler (Visual Query / Data Transformation) with Spark SQL                                      |
    +----------------------------------+------------------------------------------------------------------------------------------------------------------+
    | $SPARK_HOME/lib/                 | Needed by Spark to be distributed on the cluster, for the data wrangling                                         |
    +----------------------------------+------------------------------------------------------------------------------------------------------------------+

Spark configuration
----------------------

If you want to use Data transformation/Visual Query, update/append **$SPARK_HOME/conf/spark-defaults.conf**. 
Values can be appended with ":" .


This file should be referenced by spark-submit, or it's referenced by **/opt/kylo/kylo-services/bin/run-kylo-spark-shell.sh**, 
which passes the values like **spark-submit ... --driver-class-path /path-to-oracle-jdbc/:/path-to-other-jars/**


Configuration
=================

Oracle
-------

::

    Database Connection URL = jdbc:oracle:thin:@oracle:1521
    Database Driver Class Name =  oracle.jdbc.OracleDriver
    User = <user>
    Password = <password>
    // Optional, if you put the driver in another location which is not loaded at start-up time
    Driver Location = /opt/nifi/oracle/oracle-jdbc.jar (needs to be accesible by Nifi)

..

.. note:: Oracle tables are only in UPPERCASE

MariaDB / MySQL
----------------

::

    Database Connection URL = jdbc:mariadb://mariadb:3306	
    Database Driver Class Name =  org.mariadb.jdbc.Driver
    User = <user>
    Password = <password>
    // Optional, if you put the driver in another location which is not loaded at start-up time
    Driver Location = /opt/nifi/mysql/maria-jdbc.jar (needs to be accesible by Nifi)

..

(OPT) Specify the password in the Kylo application properties file
Update /opt/kylo/kylo-services/conf/application.properties with
nifi.service.<datasource_name>.password=<password>

Perfomance considerations while importing data
==================================================

Consider to use the Sqoop import processor for performance gains <tips-tricks/TroubleshootingandTips.html#gettabledata-vs-importsqoop-processor>

