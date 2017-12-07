
=========================================
Enable Kerberos for Kylo
=========================================

The Kylo applications contain features that leverage the thrift server
connection to communicate with the cluster. In order for them to work in
a Kerberos cluster, some configuration is required. Some examples are:

-  Profiling statistics

-  Tables page

-  Wrangler

Prerequisites
=============

Below are the list of prerequisites for enabling Kerberos for the Kylo data
lake platform.

1. Running Hadoop cluster

2. Kerberos should be enabled

3. Running Kylo 0.4.0 or higher

Configuration Steps
===================

1. Create a Headless Keytab File for the Hive and Kylo User.


.. note:: Perform the following as root. Replace "sandbox.hortonworks.com" with your domain.

..

.. code-block:: shell

    [root]$ kadmin.local

    kadmin.local: addprinc -randkey "kylo@sandbox.hortonworks.com"

    kadmin.local: xst -norandkey -k /etc/security/keytabs/kylo.headless.keytab kylo@sandbox.hortonworks.com

    kadmin.local: xst -norandkey -k /etc/security/keytabs/hive-kylo.headless.keytab hive/sandbox.hortonworks.com@sandbox.hortonworks.com

    kadmin.local: exit

    [root]$ chown kylo:hadoop /etc/security/keytabs/kylo.headless.keytab

    [root]$ chmod 440 /etc/security/keytabs/kylo.headless.keytab

    [root]$ chown kylo:hadoop /etc/security/keytabs/hive-kylo.headless.keytab

    [root]$ chmod 440 /etc/security/keytabs/hive-kylo.headless.keytab

..

2. Validate that the Keytabs Work.

.. code-block:: shell

    [root]$ su – kylo

    [kylo]$ kinit -kt /etc/security/keytabs/kylo.headless.keytab kylo

    [kylo]$ klist

    [root]$ su – hive

    [hive]$ kinit -kt /etc/security/keytabs/hive-kylo.headless.keytab hive/sandbox.hortonworks.com

    [hive]$ klist

..

3. Modify the kylo-spark-shell configuration. If the `spark.shell.server` properties are set in `spark.properties` then the `run-kylo-spark-shell.sh` script will also need to be modified.

.. code-block:: shell

    [root]$ vi /opt/kylo/kylo-services/conf/spark.properties

    kerberos.spark.kerberosEnabled = true
    kerberos.spark.keytabLocation = /etc/security/keytabs/kylo.headless.keytab
    kerberos.spark.kerberosPrincipal = kylo@sandbox.hortonworks.com

    [root]$ vi /opt/kylo/kylo-services/bin/run-kylo-spark-shell.sh

    spark-submit --principal 'kylo@sandbox.hortonworks.com' --keytab /etc/security/keytabs/kylo.headless.keytab ...

..

4. Modify the kylo-services configuration.

.. tip:: Replace "sandbox.hortonworks.com" with your domain.

    To add Kerberos support to kylo-services, you must enable the
    feature and update the Hive connection URL to support Kerberos.

.. code-block:: shell

    [root]$ vi  /opt/kylo/kylo-services/conf/application.properties

    # This property is for the hive thrift connection used by kylo-services
    hive.datasource.url=jdbc:hive2://localhost:10000/default;principal=hive/sandbox.hortonworks.com@sandbox.hortonworks.com

    # This property will default the URL when importing a template using the thrift connection
    nifi.service.hive_thrift_service.database_connection_url=jdbc:hive2://localhost:10000/default;principal=hive/sandbox.hortonworks.com@sandbox.hortonworks.com

    # Set Kerberos to true for the kylo-services application and set the 3 required properties

    kerberos.hive.kerberosEnabled=true
    kerberos.hive.hadoopConfigurationResources=/etc/hadoop/conf/core-site.xml,/etc/hadoop/conf/hdfs-site.xml
    kerberos.hive.kerberosPrincipal=hive/sandbox.hortonworks.com
    kerberos.hive.keytabLocation=/etc/security/keytabs/hive-kylo.headless.keytab

    # uncomment these 3 properties to default all NiFi processors that have these fields. Saves time when importing a template

    nifi.all_processors.kerberos_principal=nifi
    nifi.all_processors.kerberos_keytab=/etc/security/keytabs/nifi.headless.keytab
    nifi.all_processors.hadoop_configuration_resources=/etc/hadoop/conf/core-site.xml,/etc/hadoop/conf/hdfs-site.xml

..

5. Restart the kylo-services and kylo-spark-shell.

.. code-block:: shell

    [root]$ service kylo-services restart
    [root]$ service kylo-spark-shell restart

..

Kylo is now configured for a Kerberos cluster. You can test that it is
configured correctly by looking at profile statistics (if applicable):
go to the Tables page and drill down into a Hive table, and go to the
Wrangler feature and test that it works.
