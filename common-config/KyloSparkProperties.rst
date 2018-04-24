=====================
Kylo Spark Properties
=====================

Overview
========

The kylo-spark-shell process compiles and executes Scala code for schema detection and data transformations. It is started in the background by kylo-services as needed.

There will be at least two processes. The first process is used for schema detection of sample files. The second process is used for executing data transformations and may start additional processes if user impersonation is enabled.

Once the process has started it will call back to kylo-services and register itself. This allows Spark to run in yarn-cluster mode as the driver can run on any node in the cluster.

The `auth-spark` Spring profile must be enabled in kylo-services for the Spark client to start.

Configuration
=============

The default location of the configuration file is at :code:`/opt/kylo/kylo-services/conf/spark.properties`.

Spark Properties
----------------

The default property values should work on most systems. An error will be logged if Kylo is unable to determine the correct value from the environment.

+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| **Property**                             | **Type** | **Default** | **Description**                                                        |
+==========================================+==========+=============+========================================================================+
| spark.shell.appResource                  | String   |             | Path to the kylo-spark-shell-client jar file. |br|                     |
|                                          |          |             | This is only needed if Kylo is unable to |br|                          |
|                                          |          |             | determine the location automatically. The |br|                         |
|                                          |          |             | default location for Spark 1.x is :code:`/opt/` |br|                   |
|                                          |          |             | :code:`kylo/kylo-services/lib/app/kylo-spark-` |br|                    |
|                                          |          |             | :code:`shell-client-v1-*.jar`. There is a v2 jar for |br|              |
|                                          |          |             | Spark 2.x.                                                             |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.deployMode                   | String   |             | Whether to launch a kylo-spark-shell |br|                              |
|                                          |          |             | process locally (:code:`client`) or on one of the |br|                 |
|                                          |          |             | worker machines inside the cluster |br|                                |
|                                          |          |             | (:code:`cluster`). Set to :code:`cluster` when enabling |br|           |
|                                          |          |             | user impersonation.                                                    |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.files                        | String   |             | Additional files to be submitted with the |br|                         |
|                                          |          |             | Spark application. Multiple files should be |br|                       |
|                                          |          |             | separated with a comma.                                                |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.javaHome                     | String   |             | The :code:`JAVA_HOME` for launching the Spark |br|                     |
|                                          |          |             | application.                                                           |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.idleTimeout                  | Number   | 900         | Indicates the amount of time in seconds |br|                           |
|                                          |          |             | to wait for a user request before |br|                                 |
|                                          |          |             | terminating a kylo-spark-shell process. |br|                           |
|                                          |          |             | Any user request sent to the process will |br|                         |
|                                          |          |             | reset this timeout. This is only used in |br|                          |
|                                          |          |             | :code:`yarn-cluster` mode.                                             |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.jars                         | String   |             | Additional jars to be submitted with the |br|                          |
|                                          |          |             | Spark application. Multiple jars should be |br|                        |
|                                          |          |             | separated with a comma.                                                |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.master                       | String   |             | Where to run Spark executors locally |br|                              |
|                                          |          |             | (:code:`local`) or inside a YARN cluster (:code:`yarn`). |br|          |
|                                          |          |             | Set to :code:`yarn` when enabling user |br|                            |
|                                          |          |             | impersonation.                                                         |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.portMin                      | Number   | 45000       | Minimum port number that a |br|                                        |
|                                          |          |             | kylo-spark-shell process may listen on.                                |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.portMax                      | Number   | 45999       | Maximum port number that a  |br|                                       |
|                                          |          |             | kylo-spark-shell process may listen on.                                |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.propertiesFile               | String   |             | A custom properties file with Spark |br|                               |
|                                          |          |             | configuration for the application.                                     |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.proxyUser                    | Boolean  | false       | Set to :code:`true` to enable *Multi-User* mode.                       |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell |br|                         | String   |             | Password to keystore when |br|                                         |
| .registrationKeystorePassword            |          |             | registrationUrl uses SSL.                                              |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell |br|                         | String   |             | Path to keystore when registrationUrl |br|                             |
| .registrationKeystorePath                |          |             | uses SSL.                                                              |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.registrationUrl              | String   |             | Kylo Services URL for registering the |br|                             |
|                                          |          |             | Spark application once it has started. This |br|                       |
|                                          |          |             | defaults to :code:`http://<server-address>:8400/` |br|                 |
|                                          |          |             | :code:`proxy/v1/spark/shell/register`                                  |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.sparkArgs                    | String   |             | Additional arguments to include in the |br|                            |
|                                          |          |             | Spark invocation.                                                      |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.sparkHome                    | String   |             | A custom Spark installation location for |br|                          |
|                                          |          |             | the application.                                                       |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.verbose                      | Boolean  | false       | Enables verbose reporting for Spark |br|                               |
|                                          |          |             | Submit.                                                                |
+------------------------------------------+----------+-------------+------------------------------------------------------------------------+

Example :code:`spark.properties` configuration for `yarn-cluster` mode:

.. code-block:: properties

   spark.shell.deployMode = cluster
   spark.shell.master = yarn
   spark.shell.files = /opt/kylo/kylo-services/conf/log4j-spark.properties,/opt/kylo/kylo-services/conf/spark.properties
   spark.shell.jars = /opt/kylo/kylo-services/lib/mariadb-java-client-1.5.7.jar
   spark.shell.sparkArgs = --driver-memory 512m --executor-memory 512m --driver-java-options -Dlog4j.configuration=log4j-spark.properties

Example :code:`spark.properties` configuration for `local` mode:

.. code-block:: properties

   spark.shell.master = local[1]
   spark.shell.sparkArgs = --driver-memory 512m --executor-memory 512m --driver-class-path /opt/kylo/kylo-services/conf:/opt/kylo/kylo-services/lib/mariadb-java-client-1.5.7.jar --driver-java-options -Dlog4j.configuration=log4j-spark.properties

If user impersonation (:code:`spark.shell.proxyUser`) is enabled then Hadoop must be configured to allow the kylo user to proxy users:

.. code-block:: shell

    $ vim /etc/hadoop/conf/core-site.xml

    <property>
      <name>hadoop.proxyuser.kylo.groups</name>
      <value>*</value>
    </property>
    <property>
      <name>hadoop.proxyuser.kylo.hosts</name>
      <value>*</value>
    </property>

Kerberos
--------

If user impersonation (:code:`spark.shell.proxyUser`) is disabled then the Kerberos principal and keytab are passed to Spark which will acquire the Kerberos ticket.

If user impersonation is enabled then Kylo will periodically execute `kinit` to ensure there is an active Kerberos ticket. This prevents the impersonated user from having access to the keytab file. See :doc:`../security/KyloUserImpersonation` for more information on configuring user impersonation in a Kerberized environment.

+----------------------------------+--------------------------------------------------------------------------+
| **Property**                     | **Description**                                                          |
+==================================+==========================================================================+
| kerberos.spark.kerberosEnabled   | Indicates that an active Kerberos ticket is needed to start a |br|       |
|                                  | kylo-spark-shell process. |br|                                           |
|                                  | **Type**: Boolean |br|                                                   |
|                                  | **Default**: false                                                       |
+----------------------------------+--------------------------------------------------------------------------+
| kerberos.spark.kerberosPrincipal | Name of the principal for acquiring a Kerberos ticket. |br|              |
|                                  | **Type**: String                                                         |
+----------------------------------+--------------------------------------------------------------------------+
| kerberos.spark.keytabLocation    | Local path to the keytab for acquiring a Kerberos ticket. |br|           |
|                                  | **Type**: String                                                         |
+----------------------------------+--------------------------------------------------------------------------+
| kerberos.spark.initInterval      | Indicates the amount of time in seconds to cache a Kerberos ticket |br|  |
|                                  | before acquiring a new one. Only used when user impersonation is |br|    |
|                                  | enabled. A value of 0 disables calling `kinit`. |br|                     |
|                                  | **Type**: Number |br|                                                    |
|                                  | **Default**: 43200                                                       |
+----------------------------------+--------------------------------------------------------------------------+
| kerberos.spark.initTimeout       | Indicates the amount of time in seconds to wait for `kinit` to |br|      |
|                                  | acquire a ticket before killing the process. Only used when user |br|    |
|                                  | impersonation is enabled. |br|                                           |
|                                  | **Type**: Number |br|                                                    |
|                                  | **Default**: 10                                                          |
+----------------------------------+--------------------------------------------------------------------------+
| kerberos.spark.retryInterval     | Indicates the amount of time in seconds to wait before retrying to |br|  |
|                                  | acquire a Kerberos ticket if the last try failed. Only used when |br|    |
|                                  | user impersonation is enabled. |br|                                      |
|                                  | **Type**: Number |br|                                                    |
|                                  | **Default**: 120                                                         |
+----------------------------------+--------------------------------------------------------------------------+
| kerberos.spark.realm             | Name of the Kerberos realm to append to usernames. |br|                  |
|                                  | **Type**: String                                                         |
+----------------------------------+--------------------------------------------------------------------------+

Example :code:`spark.properties` configuration:

.. code-block:: properties

   spark.shell.deployMode = cluster
   spark.shell.master = yarn
   spark.shell.proxyUser = true
   spark.shell.sparkArgs = --driver-java-options -Djavax.security.auth.useSubjectCredsOnly=false

   kerberos.spark.kerberosEnabled = true
   kerberos.spark.kerberosPrincipal = kylo
   kerberos.spark.keytabLocation = /etc/security/keytabs/kylo.headless.keytab

Logging
-------

Spark application logs are written to the kylo-services.log file by default. This can be customized with the following properties added to /opt/kylo/kylo-services/conf/log4j.properties:

.. code-block:: properties

    log4j.additivity.org.apache.spark.launcher.app.SparkShellApp=false
    log4j.logger.org.apache.spark.launcher.app.SparkShellApp=INFO, sparkShellLog

    log4j.appender.sparkShellLog=org.apache.log4j.DailyRollingFileAppender
    log4j.appender.sparkShellLog.File=/var/log/kylo-services/kylo-spark-shell.log
    log4j.appender.sparkShellLog.append=true
    log4j.appender.sparkShellLog.layout=org.apache.log4j.PatternLayout
    log4j.appender.sparkShellLog.Threshold=INFO
    log4j.appender.sparkShellLog.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %-5p %t:%c{1}:%L - %m%n

Deprecated Properties
---------------------

The kylo-spark-shell process can be run independently of kylo-services by setting the :code:`spark.shell.server.host` and :code:`spark.shell.server.port` properties. In this mode, the other :code:`spark.shell.` properties are ignored and should be passed to :code:`spark-submit` when starting kylo-spark-shell.

+----------------------------------+--------------------------------------------------------------------------+
| **Property**                     | **Description**                                                          |
+==================================+==========================================================================+
| server.port                      | Port for kylo-spark-shell to listen on. |br|                             |
|                                  | **Type**: Number |br|                                                    |
|                                  | **Default**: 8450                                                        |
+----------------------------------+--------------------------------------------------------------------------+
| spark.shell.server.host          | Host name or address where the kylo-spark-shell process is running  |br| |
|                                  | as a server. |br|                                                        |
|                                  | **Type**: String                                                         |
+----------------------------------+--------------------------------------------------------------------------+
| spark.shell.server.port          | Port where the kylo-spark-shell process is listening. |br|               |
|                                  | **Type**: Number |br|                                                    |
|                                  | **Default**: 8450                                                        |
+----------------------------------+--------------------------------------------------------------------------+
| spark.ui.port                    | Port for the Spark UI to listen on. |br|                                 |
|                                  | **Type**: Number |br|                                                    |
|                                  | **Default**: 8451                                                        |
+----------------------------------+--------------------------------------------------------------------------+

Advanced options are available by using |springBootPropertiesLink|.

Example :code:`spark.properties` configuration:

.. code-block:: properties

   spark.shell.server.host = localhost
   spark.shell.server.port = 8450

Wrangler Properties
===================

These properties are used by the Data Transformation feed and the Visual Query page.

+-------------------------------------------+--------------------------------------------------------------+
| **Property**                              | **Description**                                              |
+===========================================+==============================================================+
| spark.shell.datasources.exclude           | A comma-separated list of Spark datasources to exclude |br|  |
|                                           | when saving a Visual Query transformation. May either |br|   |
|                                           | be the short name or the class name. |br|                    |
|                                           | **Type**: String                                             |
+-------------------------------------------+--------------------------------------------------------------+
| spark.shell.datasources.include           | A comma-separated list of Spark datasource classes to |br|   |
|                                           | include when saving a Visual Query transformation. |br|      |
|                                           | **Type**: String                                             |
+-------------------------------------------+--------------------------------------------------------------+
| spark.shell.datasources.exclude.downloads | A comma-separated list used to fine tune the |br|            |
|                                           | datasources available for download by excluding from |br|    |
|                                           | the master set of sources specified with the |br|            |
|                                           | spark.shell.datasources root properties above. |br|          |
|                                           | Uses short name only. |br|                                   |
|                                           | **Type**: String                                             |
+-------------------------------------------+--------------------------------------------------------------+
| spark.shell.datasources.include.tables    | A comma-separated list used to fine tune the |br|            |
|                                           | datasources available for saving to a table by |br|          |
|                                           | excluding from the master set of sources specified with |br| |
|                                           | ithe spark.shell.datasources root properties above. |br|     |
|                                           | **Type**: String                                             |
+-------------------------------------------+--------------------------------------------------------------+

.. |br| raw:: html

   <br/>

.. |springBootPropertiesLink| raw:: html

   <a href="https://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html" target="_blank">Spring Boot properties</a>
