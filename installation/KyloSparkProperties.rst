=====================
Kylo Spark Properties
=====================

Overview
========

The kylo-spark-shell process compiles and executes Scala code for schema detection and data transformations.

Configuration
=============

The default location of the configuration file is at :code:`/opt/kylo/kylo-services/conf/spark.properties`.

The process will run in one of three modes depending on which properties are defined. The default mode is *Server* which requires the process to be started and managed separately, typically using the
included init script. In the other two modes, *Managed* and *Multi-User*, the kylo-services process will start and manage the kylo-spark-shell processes. Typically *Server* mode will only
be used in development environments and *Managed* or *Multi-User* will be used in production. The following sections further describe these modes and their configuration options.

Server Mode
-----------

The kylo-spark-shell process will run in *Server* mode when the below properties are defined in :code:`spark.properties`. In this mode the process should be started by using the included init script.
When using the Kylo sandbox it is sufficient to run :code:`service kylo-spark-shell start`.

The properties from the other sections in this document are ignored when *Server* mode is enabled. To modify the Spark options, edit the :code:`run-kylo-spark-shell.sh` file and add them to the
:code:`spark-submit` call on the last line. Note that only the local Spark master is supported in this configuration.

+-------------------------+----------+-------------+------------------------------------------------------+
| **Property**            | **Type** | **Default** | **Description**                                      |
+=========================+==========+=============+======================================================+
| server.port             | Number   | 8450        | Port for kylo-spark-shell to listen on.              |
+-------------------------+----------+-------------+------------------------------------------------------+
| spark.shell.server.host | String   |             | Host name or address where the kylo-spark-shell |br| |
|                         |          |             | process is running as a server.                      |
+-------------------------+----------+-------------+------------------------------------------------------+
| spark.shell.server.port | Number   | 8450        | Port where the kylo-spark-shell process is |br|      |
|                         |          |             | listening.                                           |
+-------------------------+----------+-------------+------------------------------------------------------+
| spark.ui.port           | Number   | 8451        | Port for the Spark UI to listen on.                  |
+-------------------------+----------+-------------+------------------------------------------------------+

Advanced options are available by using |springBootPropertiesLink|.

Example :code:`spark.properties` configuration:

.. code-block:: properties

   spark.shell.server.host = localhost
   spark.shell.server.port = 8450

Managed Mode
------------

In *Managed* mode, Kylo will start one kylo-spark-shell process for schema detection and another for executing data transformations.

Once the process has started it will call back to kylo-services and register itself. This allows Spark to run in yarn-cluster mode as the driver can run on any node in the cluster.

The `auth-spark` Spring profile must be enabled for the Spark client to start.

+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| **Property**                | **Type** | **Default** | **Description**                                                        |
+=============================+==========+=============+========================================================================+
| spark.shell.appResource     | String   |             | Path to the kylo-spark-shell-client jar file. This |br|                |
|                             |          |             | is only needed if Kylo is unable to determine |br|                     |
|                             |          |             | the location automatically. The default location |br|                  |
|                             |          |             | for Spark 1.x is :code:`/opt/kylo/kylo-services/lib/` |br|             |
|                             |          |             | :code:`app/kylo-spark-shell-client-v1-*.jar`. There is a |br|          |
|                             |          |             | v2 jar for Spark 2.x.                                                  |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.deployMode      | String   |             | Whether to launch a kylo-spark-shell process |br|                      |
|                             |          |             | locally (:code:`client`) or on one of the worker |br|                  |
|                             |          |             | machines inside the cluster (:code:`cluster`). Set to |br|             |
|                             |          |             | :code:`cluster` when enabling user impersonation.                      |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.files           | String   |             | Additional files to be submitted with the Spark |br|                   |
|                             |          |             | application. Multiple files should be separated |br|                   |
|                             |          |             | with a comma.                                                          |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.javaHome        | String   |             | The :code:`JAVA_HOME` for launching the Spark |br|                     |
|                             |          |             | application.                                                           |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.idleTimeout     | Number   | 900         | Indicates the amount of time in seconds to |br|                        |
|                             |          |             | wait for a user request before terminating a |br|                      |
|                             |          |             | kylo-spark-shell process. Any user request |br|                        |
|                             |          |             | sent to the process will reset this timeout. This |br|                 |
|                             |          |             | is only used in :code:`yarn-cluster` mode.                             |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.jars            | String   |             | Additional jars to be submitted with the Spark |br|                    |
|                             |          |             | application. Multiple jars should be separated |br|                    |
|                             |          |             | with a comma.                                                          |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.master          | String   |             | Where to run Spark executors locally (:code:`local`) |br|              |
|                             |          |             | or inside a YARN cluster (:code:`yarn`). Set to :code:`yarn` |br|      |
|                             |          |             | when enabling user impersonation.                                      |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.portMin         | Number   | 45000       | Minimum port number that a kylo-spark-shell |br|                       |
|                             |          |             | process may listen on.                                                 |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.portMax         | Number   | 45999       | Maximum port number that a kylo-spark-shell |br|                       |
|                             |          |             | process may listen on.                                                 |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.propertiesFile  | String   |             | A custom properties file with Spark |br|                               |
|                             |          |             | configuration for the application.                                     |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.registrationUrl | String   |             | Kylo Services URL for registering the Spark |br|                       |
|                             |          |             | application once it has started. This defaults to |br|                 |
|                             |          |             | :code:`http://<server-address>:8400/proxy/v1/spark/` |br|              |
|                             |          |             | :code:`shell/register`                                                 |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.sparkArgs       | String   |             | Additional arguments to include in the Spark |br|                      |
|                             |          |             | invocation.                                                            |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.sparkHome       | String   |             | A custom Spark installation location for the |br|                      |
|                             |          |             | application.                                                           |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+
| spark.shell.verbose         | Boolean  | false       | Enables verbose reporting for Spark Submit.                            |
+-----------------------------+----------+-------------+------------------------------------------------------------------------+

The default property values should work on most systems. An error will be logged if Kylo is unable to determine the correct value from the environment. Example :code:`spark.properties` configuration:

.. code-block:: properties

   #spark.shell.server.host = localhost
   #spark.shell.server.port = 8450
   spark.shell.deployMode = cluster
   spark.shell.master = yarn

Multi-User Mode
---------------

Kylo will start a separate process for each Kylo user in *Multi-User* mode. This ensures that users only have access to their own tables and cannot interfere with each other.

The `auth-spark` Spring profile must be enabled for the Spark client to start.

In a Kerberized environment Kylo will need to periodically execute `kinit` to ensure there is an active Kerberos ticket. Spark does not support supplying both a keytab and a proxy user on the
command-line. See :doc:`KyloUserImpersonation` for more information on configuring user impersonation in a Kerberized environment.

The options from `Managed Mode`_ are also supported.

+----------------------------------+----------+-------------+---------------------------------------------------+
| **Property**                     | **Type** | **Default** | **Description**                                   |
+==================================+==========+=============+===================================================+
| spark.shell.proxyUser            | Boolean  | false       | Set to :code:`true` to enable *Multi-User* mode.  |
+----------------------------------+----------+-------------+---------------------------------------------------+

Example :code:`spark.properties` configuration:

.. code-block:: properties

   #spark.shell.server.host = localhost
   #spark.shell.server.port = 8450
   spark.shell.deployMode = cluster
   spark.shell.master = yarn
   spark.shell.proxyUser = true
   spark.shell.sparkArgs = --driver-java-options -Djavax.security.auth.useSubjectCredsOnly=false

Kerberos
--------

Kerberos is supported in both *Managed* and *Multi-User* modes.

+----------------------------------+----------+-------------+---------------------------------------------------+
| **Property**                     | **Type** | **Default** | **Description**                                   |
+==================================+==========+=============+===================================================+
| kerberos.spark.kerberosEnabled   | Boolean  | false       | Indicates that an active Kerberos ticket |br|     |
|                                  |          |             | is needed to start a kylo-spark-shell |br|        |
|                                  |          |             | process.                                          |
+----------------------------------+----------+-------------+---------------------------------------------------+
| kerberos.spark.kerberosPrincipal | String   |             | Name of the principal for acquiring a |br|        |
|                                  |          |             | Kerberos ticket.                                  |
+----------------------------------+----------+-------------+---------------------------------------------------+
| kerberos.spark.keytabLocation    | String   |             | Local path to the keytab for acquiring a |br|     |
|                                  |          |             | Kerberos ticket.                                  |
+----------------------------------+----------+-------------+---------------------------------------------------+
| kerberos.spark.initInterval      | Number   | 43200       | Indicates the amount of time in seconds |br|      |
|                                  |          |             | to cache a Kerberos ticket before |br|            |
|                                  |          |             | acquiring a new one. Only used in |br|            |
|                                  |          |             | *Multi-User* mode. A value of 0 disables |br|     |
|                                  |          |             | calling :code:`kinit`.                            |
+----------------------------------+----------+-------------+---------------------------------------------------+
| kerberos.spark.initTimeout       | Number   | 10          | Indicates the amount of time in seconds |br|      |
|                                  |          |             | to wait                                           |
|                                  |          |             | for :code:`kinit` to acquire a ticket |br|        |
|                                  |          |             | before killing the process. Only used in |br|     |
|                                  |          |             | *Multi-User* mode.                                |
+----------------------------------+----------+-------------+---------------------------------------------------+
| kerberos.spark.retryInterval     | Number   | 120         | Indicates the amount of time in seconds |br|      |
|                                  |          |             | to wait before retrying to acquire a  |br|        |
|                                  |          |             | Kerberos ticket if the last try failed. |br|      |
|                                  |          |             | Only used in *Multi-User* mode.                   |
+----------------------------------+----------+-------------+---------------------------------------------------+
| kerberos.spark.realm             | String   |             | Name of the Kerberos realm to append |br|         |
|                                  |          |             | to usernames.                                     |
+----------------------------------+----------+-------------+---------------------------------------------------+

Example :code:`spark.properties` configuration:

.. code-block:: properties

   kerberos.spark.kerberosEnabled = true
   kerberos.spark.kerberosPrincipal = kylo
   kerberos.spark.keytabLocation = /etc/security/keytabs/kylo.headless.keytab

.. |br| raw:: html

   <br/>

.. |springBootPropertiesLink| raw:: html

   <a href="https://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html" target="_blank">Spring Boot properties</a>
