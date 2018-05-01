==============================
Enable Hive User Impersonation
==============================

Overview
========

Users in Kylo have access to all Hive tables accessible to the :code:`kylo` user by default. By configuring Kylo for a secure Hadoop cluster and enabling user impersonation, users will only have
access to the Hive tables accessible to their specific account. A local spark shell process is still used for schema detection when uploading a sample file.

Requirements
============

This guide assumes that Kylo has already been setup with Kerberos authentication and that each user will have an account in the Hadoop cluster.

Kylo Configuration
==================

Kylo will need to launch a separate spark shell process for each user that is actively performing data transformations. This means that the :code:`kylo-spark-shell` service should no longer be managed by
the system.

1. Stop and disable the system process.

.. code-block:: shell

    $ service kylo-spark-shell stop
    $ chkconfig kylo-spark-shell off

..

2. Add the auth-spark profile in :code:`application.properties`. This will enable Kylo to create temporary credentials for the spark shell processes to communicate with the kylo-services process. Also, kylo must be informed to impersonate users when querying hive.  To do so, configure the `hive.userImperonation.*` properties below.

Edit the application.properties file:

.. code-block:: shell

    $ vim /opt/kylo/kylo-services/conf/application.properties

..

Add, or ensure, the following properties:

.. code-block:: properties


    spring.profiles.include = auth-spark, ...
    
    hive.userImpersonation.enabled=true
    hive.userImpersonation.cache.expiry.duration=4
    hive.userImpersonation.cache.expiry.time-unit=HOURS

..

3. Enable user impersonation in :code:`spark.properties`. It is recommended that the yarn-cluster master be used to ensure that both the Spark driver and executors run under the user's account. Using the local or yarn-client masters are possible but not recommended due the Spark driver running as the kylo user.

Edit the spark.properties file:

.. code-block:: shell

   vim /opt/kylo/kylo-services/conf/spark.properties

..

Add, or ensure, the following properties:

.. code-block:: properties

    # Ensure these two properties are commented out
    #spark.shell.server.host
    #spark.shell.server.port

    # Executes both driver and executors as the user
    spark.shell.deployMode = cluster
    spark.shell.master = yarn
    # Enables user impersonation
    spark.shell.proxyUser = true
    # Reduces memory requirements and allows Kerberos user impersonation
    spark.shell.sparkArgs = --driver-memory 512m --executor-memory 512m --driver-java-options -Djavax.security.auth.useSubjectCredsOnly=false

    kerberos.spark.kerberosEnabled = true
    kerberos.spark.kerberosPrincipal = kylo
    kerberos.spark.keytabLocation = /etc/security/keytabs/kylo.headless.keytab

..

4. Redirect logs to :code:`kylo-spark-shell.log`. By default the logs will be written to :code:`kylo-services.log` and include the output of every spark shell process. The below configuration instead redirects this output to the :code:`kylo-spark-shell.log` file.

Edit the log4j.properties file:

.. code-block:: shell

    $ vim /opt/kylo/kylo-services/conf/log4j.properties

..

Add the following properties:

.. code-block:: properties

    log4j.additivity.org.apache.spark.launcher.app.SparkShellApp=false
    log4j.logger.org.apache.spark.launcher.app.SparkShellApp=INFO, sparkShellLog

    log4j.appender.sparkShellLog=org.apache.log4j.DailyRollingFileAppender
    log4j.appender.sparkShellLog.File=/var/log/kylo-services/kylo-spark-shell.log
    log4j.appender.sparkShellLog.append=true
    log4j.appender.sparkShellLog.layout=org.apache.log4j.PatternLayout
    log4j.appender.sparkShellLog.Threshold=INFO
    log4j.appender.sparkShellLog.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %-5p %t:%c{1}:%L - %m%n

..

5. Configure Hadoop to allow Kylo to proxy users.

Edit via Ambari at (HDFS-> Configs -> Advanced -> Custom core-site), or manually edit the hadoop configuration file /etc/hadoop/conf/core-site.xml

.. code-block:: xml

    <property>
      <name>hadoop.proxyuser.kylo.groups</name>
      <value>*</value>
    </property>
    <property>
      <name>hadoop.proxyuser.kylo.hosts</name>
      <value>*</value>
    </property>

..
