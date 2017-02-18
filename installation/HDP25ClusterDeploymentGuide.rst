
================================================
HDP 2.5 Kerberos/Ranger Cluster Deployment Guide
================================================

About
=====

This guide will help you understand the steps involved with deploying
Kylo to a Kerberos cluster with minimal admin privileges. No super user
privileges will be provided to the "nifi" or "kylo" user. The only
usage for an administrative account will be for kylo-services to
access the Ranger REST API.

There are two ways you can configure hive to manage users on the
cluster.

  1. You can configure it to run hive jobs as the end user, but all HDFS access is done as the hive user.

  2. Run hive jobs and HDFS commands as the end user:

.. code-block:: html

    *http://hortonworks.com/blog/best-practices-for-hive-authorization-using-apache-ranger-in-hdp-2-2/*

..

This document will configure option #2 to show how you can configure Kylo to grant appropriate access to both hive and HDFS for the end user.

Cluster Topography
==================

The cluster used in this example contains the following:

  -  3 master nodes

  -  3 data nodes

  -  1 Kylo edge node

  -  1 NiFi edge node

There are a couple of things to notes about the cluster:

  -  The cluster is leveraging the MIT KDC for Kerberos.

  -  The cluster uses Linux file system-based authorization (not LDAP or AD).

Known Issues
============

Kylo does not support Hive HA Thrift URL connections yet. If the cluster
is configured for HA and zookeeper, you will need to connect directly to
the thrift server.

You may see an error similar to the following:

.. error:: Requested user nifi is not whitelisted and has id 496, which is below the minimum allowed 500".  

If you do, do the following to change the user ID or lower the minimum ID:

1. Login to Ambari and edit the yarn "Advanced yarn-env".

2. Set the "Minimum user ID for submitting job" = 450.

Prepare a Checklist
===================

Leverage the deployment checklist to take note of information you will need to speed up configuration.

:doc:`../installation/KyloDeploymentChecklist`

Prepare the HDP Cluster
=======================

Before installing the Kylo stack, prepare the cluster by doing the following:

1. Ensure that Kerberos is enabled.

2. Enable Ranger, including the HDFS and Hive plugin.

3. Change Hive to run both Hive and HDFS as the end user.

   a. Login to Ambari.

   b. Go to Hive -→ Config.

   c. Change "Run as end user instead of Hive user" to true.

   d. Restart required applications.

4. Create an Ambari user for Kylo to query the status REST API’s.

   a. Login to Ambari.

   b. Got to "Manage Ambari" → Users.

   c. Click on "Create Local User".

   d. Create a user called "kylo" and save the password for later.

   e. Go to the "Roles" screen.

   f. Assign the "kylo" user to the "Cluster User" role.

5. If your spark job fails when running in HDP 2.4.2 while interacting with an empty ORC table, you will get this error message:

.. code-block:: shell

   "ExecuteSparkJob[id=1fb1b9a0-e7b5-4d85-87d2-90d7103557f6] java.util.NoSuchElementException: next on empty iterator "

..

   This is due to a change Hortonworks added to change how it loads the schema for the table. To fix the issue you can modify the following properties:

   a. On the edge node edit /usr/hdp/current/spark-client/conf/spark-defaults.conf.

   b. Add this line to the file "spark.sql.hive.convertMetastoreOrc false"

   Optionally, rather than editing the configuration file you can add this property in Ambari:

   a. Login to Ambari.

   b. Go to the Spark config section.

   c. Go to "custom spark defaults".

   d. Add the property "spark.sql.hive.convertMetastoreOrc" and set to "false".

6. Create the "nifi" and "kylo" user on the master and data nodes. 

   +---------+-----------------------------------------------------------------------------------+
   |**NOTE:**| If the operations team uses a user management tool then create the users that way.|
   +---------+-----------------------------------------------------------------------------------+   

   If you are using linux /etc/group based authorization in your cluster you are required to create any users that will have access to HDFS or Hive on the following:   

   **Master Nodes:**

.. code-block:: console

        $ useradd -r -m -s /bin/bash nifi
        $ useradd -r -m -s /bin/bash kylo   

..

   **Data Nodes:** In some cases this is not required on data nodes.

.. code-block:: console

        $ useradd -r -m -s /bin/bash nifi
        $ useradd -r -m -s /bin/bash kylo  

..

Prepare the Kylo Edge Node
==========================

1. Install the MySQL client on the edge node, if not already there: 

.. code-block:: console

        $ yum install mysql  

..

2. Create a MySQL admin user or use root user to grant "create schema"
   access from the Kylo edge node. 

   This is required to install the "kylo" schema during Kylo installation.   

.. code-block:: console

        Example:   
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'KYLO_EDGE_NODE_HOSTNAME'
        IDENTIFIED BY 'abc123' WITH GRANT OPTION; FLUSH PRIVILEGES;  

..

3. Create the "kylo" MySQL user. 

.. code-block:: console

        CREATE USER 'kylo'@'<KYLO_EDGE_NODE>' IDENTIFIED BY 'abc123';
        grant create, select, insert, update, delete, execute ON kylo.* to kylo'@'KYLO_EDGE_NODE_HOSTNAME';
        FLUSH PRIVILEGES;  

..

4. Grant kylo user access to the hive MySQL metadata. 

.. code-block:: console

        GRANT select ON hive.SDS TO 'kylo'@'KYLO_EDGE_NODE_HOSTNAME';
        GRANT select ON hive.TBLS TO 'kylo'@'KYLO_EDGE_NODE_HOSTNAME';
        GRANT select ON hive.DBS TO 'kylo'@'KYLO_EDGE_NODE_HOSTNAME';
        GRANT select ON hive.COLUMNS_V2 TO 'kylo'@'KYLO_EDGE_NODE_HOSTNAME';   

..

+----------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|**NOTE:** | If the hive database is installed in a separate MySQL instance then you will need to create the "kylo" non privileged user in that database before running the grants.|
+----------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+

5. Make sure the spark client and hive client is installed.

6. Create the "kylo" user on edge node. 

.. code-block:: console

        Kylo Edge Node:
        $ useradd -r -m -s /bin/bash kylo
        $ useradd -r -m -s /bin/bash activemq  

..

7. Optional - Create offline TAR file for an offline Kylo installation. 

.. code-block:: console

        [root]# cd /opt/kylo/setup/
        [root setup]# ./generate-offline-install.sh   

..

   Copy the TAR file to both the Kylo edge node as well as the NiFi edge node.  

8. Prepare a list of feed categories you wish to create.

   This is required due to the fact that we are installing Kylo without privileged access. We will create Ranger policies ahead of time to all Kylo access to the Hive Schema and HDFS folders.  

9. Create "kylo" home folder in HDFS. This is required for hive queries to work in HDP.

.. code-block:: console

           [root]$ su - hdfs
        [hdfs]$ kinit -kt /etc/security/keytabs/hdfs.headless.keytab <hdfs_principal_name>
        [hdfs]$ hdfs dfs -mkdir /user/kylo
        [hdfs]$ hdfs dfs -chown kylo:kylo /user/kylo
        [hdfs]$ hdfs dfs -ls /user   

..


**TIP:** If you do not know the HDFS Kerberos principal name run "klist -kt/etc/security/keytabs/hdfs.headless.keytab". 


Prepare the NiFi Edge Node
==========================

1. Install the MySQL client on the edge node, if not already there. 

.. code-block:: console

        $ yum install mysql  

..

2. Grant MySQL access from the NiFi edge node. 

   Example:   

.. code-block:: console

        GRANT ALL PRIVILEGES ON *.* TO 'kylo'@'nifi_edge_node' IDENTIFIED BY 'abc123';
        FLUSH PRIVILEGES;  

..

3. Make sure the spark client and hive client is installed.

4. Create the "nifi" user on edge node, master nodes, and data nodes. 

   Edge Nodes:

.. code-block:: console

        $ useradd -r -m -s /bin/bash nifi  

..

5. Optional - Copy the offline TAR file created above to this edge node, if necessary.

6. Create the "nifi" home folders in HDFS. 

   This is required for hive queries to work in HDP.   

.. code-block:: console

        [root]$ su - hdfs
        [hdfs]$ kinit -kt /etc/security/keytabs/hdfs.headless.keytab <hdfs_principal_name>
        [hdfs]$ hdfs dfs -mkdir /user/nifi
        [hdfs]$ hdfs dfs -chown nifi:nifi /user/nifi
        [hdfs]$ hdfs dfs -ls /user   

..

   **TIP:** If you don't know the HDFS Kerberos principal name, run:

.. code-block:: console

        "klist -kt /etc/security/keytabs/hdfs.headless.keytab"  

..

Create the Keytabs for "nifi" and "kylo" Users
==============================================

1. Login to the host that is running the KDC and create the keytabs.

.. code-block:: console

        [root]# kadmin.local
        kadmin.local: addprinc -randkey "kylo/<KYLO_EDGE_HOSTNAME>@US-WEST-2.COMPUTE.INTERNAL"
        kadmin.local: addprinc -randkey "nifi/<NIFI_EDGE_HOSTNAME>@US-WEST-2.COMPUTE.INTERNAL"
        kadmin.local: xst -k /tmp/kylo.service.keytab kylo/<KYLO_EDGE_HOSTNAME>@US-WEST-2.COMPUTE.INTERNAL
        kadmin.local: xst -k /tmp/nifi.service.keytab nifi/<NIFI_EDGE_HOSTNAME>@US-WEST-2.COMPUTE.INTERNAL  

..

2. Note the hive principal name for the thrift connection later. 

.. code-block:: console

        # Write down the principal name for hive for the KDC node
        kadmin.local: listprincs   

        kadmin.local: exit  

..

3. Move the keytabs to the correct edge nodes.

4. Configure the Kylo edge node. This step assumes that, to configure the keytab, you SCP'd the files to:

.. code-block:: console

        /tmp   

..

   Configure the edge node:

.. code-block:: console

        [root opt]# mv /tmp/kylo.service.keytab /etc/security/keytabs/
        [root keytabs]# chown kylo:kylo/etc/security/keytabs/kylo.service.keytab
        [root opt]# chmod 400/etc/security/keytabs/kylo.service.keytab  

..

5. Test the keytab on the Kylo edge node. 

.. code-block:: console

        [root keytabs]# su - kylo
        [kylo ~]$ kinit -kt /etc/security/keytabs/kylo.service.keytab kylo/<KYLO_EDGE_HOSTNAME>@US-WEST-2.COMPUTE.INTERNAL
        [kylo ~]$ klist
        [kylo ~]$ klist
        Ticket cache: FILE:/tmp/krb5cc_496
        Default principal: kylo/ip-172-31-42-133.us-west-2.compute.internal@US-WEST-2.COMPUTE.INTERNAL
        Valid starting Expires Service principal
        11/29/2016 22:37:57 11/30/2016 22:37:57 krbtgt/US-WEST-2.COMPUTE.INTERNAL@US-WEST-2.COMPUTE.INTERNAL   

        [kylo ~]$ hdfs dfs -ls /
        Found 10 items ....   

        # Now try hive
        [kylo ~]$ hive  

..

6. Configure the NiFi edge node.

.. code-block:: console

    root opt]# mv /tmp/nifi.service.keytab /etc/security/keytabs/
    [root keytabs]# chown nifi:nifi /etc/security/keytabs/nifi.service.keytab
    [root opt]# chmod 400 /etc/security/keytabs/nifi.service.keytab  

..

7. Test the keytab on the NiFi edge node. 

.. code-block:: console

    [root keytabs]# su - nifi
    [nifi ~]$ kinit -kt /etc/security/keytabs/nifi.service.keytab nifi/i<NIFI_EDGE_HOSTNAME>@US-WEST-2.COMPUTE.INTERNAL
    [nifi ~]$ klist
    Ticket cache: FILE:/tmp/krb5cc_497
    Default principal: nifi/<NIFI_EDGE_HOSTNAME>@US-WEST-2.COMPUTE.INTERNAL
    Valid starting Expires Service principal
    11/29/2016 22:40:08 11/30/2016 22:40:08 krbtgt/US-WEST-2.COMPUTE.INTERNAL@US-WEST-2.COMPUTE.INTERNAL   

    [nifi ~]$ hdfs dfs -ls /
    Found 10 items   

    [nifi ~]$ hive  

..

8. Test with Kerberos test client. 

   Kylo provides a kerberos test client to ensure the keytabs work in the JVM. There have been cases where kinit works on the command line but getting a kerberos ticket breaks in the JVM.

.. code-block:: html

        https://github.com/kyloio/kylo/tree/master/core/kerberos/kerberos-test-client  

..

9. Optional - Test Beeline connection.

Install NiFi on the NiFi Edge Node
==================================

1. SCP the kylo-install.tar tar file to /tmp (if running in offline mode).

2.  Run the setup wizard (example uses offline mode) [root tmp]# cd /tmp.

.. code-block:: console

    [root tmp]# mkdir tba-install
    [root tmp]# mv kylo-install.tar tba-install/
    [root tmp]# cd tba-install/
    [root tba-install]# tar -xvf kylo-install.tar   

    [root tba-install]# /tmp/tba-install/setup-wizard.sh -o  

..

3. Install the following using the wizard.

    -  NiFi
    -  Java (Option #2 most likely)

4. Stop NiFi. 

.. code-block:: console

    $ service nifi stop  

..

5. Edit nifi.properties to set Kerberos setting.

.. code-block:: console

    [root]# vi /opt/nifi/current/conf/nifi.properties   
    nifi.kerberos.krb5.file=/etc/krb5.conf  

..

6. Edit the config.properties file. 

.. code-block:: console

    [root]# vi /opt/nifi/ext-config/config.properties   
    jms.activemq.broker.url=tcp://<KYLO_EDGE_HOST>:61616  

..

7. Start NiFi.

.. code-block:: console

    [root]# service nifi start  

..

8. Tail the logs to look for errors.

.. code-block:: console

     tail -f /var/log/nifi/nifi-app.log  

..

Install the Kylo Application on the Kylo Edge Node
==================================================

1. Install the RPM. 

.. code-block:: console

    $ rpm -ivh /tmp/kylo-<VERSION>.noarch.rpm  

..

2. SCP the kylo-install.tar tar file to /tmp (if running in offline mode).

3. Run the setup wizard (example uses offline mode) 

.. code-block:: console

    [root tmp]# cd /tmp.
    [root tmp]# mkdir tba-install
    [root tmp]# mv kylo-install.tar tba-install/
    [root tmp]# cd tba-install/
    [root tba-install]# tar -xvf kylo-install.tar   

    [root tba-install]# /tmp/tba-install/setup-wizard.sh -o  

..

4. Install the following using the wizard (everything but NiFi).

      -  MySQL database scripts
      -  Elasticsearch
      -  ActiveMQ
      -  Java (Option #2 most likely)

5. Update Elasticsearch configuration. 

   In order for Elasticsearch to allow access from an external server you need to specify the hostname in addition to localhost.   

.. code-block:: console

    $ vi /etc/elasticsearch/elasticsearch.yml
    network.host: localhost,<KYLO_EDGE_HOST>  

..

6. Edit the thinbig-spark-shell configuration file. 

.. code-block:: console

    [root kylo]# vi /opt/kylo/kylo-services/conf/spark.properties   

    kerberos.kylo.kerberosEnabled=true
    kerberos.kylo.hadoopConfigurationResources=/etc/hadoop/conf/core-site.xml,/etc/hadoop/conf/hdfs-site.xml
    kerberos.kylo.kerberosPrincipal=<kylo_principal_name>
    kerberos.kylo.keytabLocation=/etc/security/keytabs/kylo.service.keytab  

..

7. Edit the kylo-services configuration file. 

.. code-block:: console

    [root /]# vi /opt/kylo/kylo-services/conf/application.properties   

    spring.datasource.url=jdbc:mysql://<MYSQL_HOSTNAME>:3306/kylo?noAccessToProcedureBodies=true
    spring.datasource.username=kylo
    spring.datasource.password=password   

    ambariRestClientConfig.host=<AMBARI_SERVER_HOSTNAME>
    ambariRestClientConfig.username=kylo
    ambariRestClientConfig.password=password   

    metadata.datasource.url=jdbc:mysql://<MYSQL_HOSTNAME>:3306/kylo?noAccessToProcedureBodies=true
    metadata.datasource.username=kylo
    metadata.datasource.password=password   

    hive.datasource.url=jdbc:hive2://<HIVE_SERVER2_HOSTNAME>:10000/default;principal=<HIVE_PRINCIPAL_NAME>   

    hive.metastore.datasource.url=jdbc:mysql://<MYSQL_HOSTNAME>:3306/hive
    hive.metastore.datasource.username=kylo
    hive.metastore.datasource.password=password   

    modeshape.datasource.url=jdbc:mysql://<MYSQL_HOSTNAME>:3306/kylo?noAccessToProcedureBodies=true
    modeshape.datasource.username=kylo
    modeshape.datasource.password=password   

    nifi.rest.host=<NIFI_EDGE_HOST>   

    kerberos.hive.kerberosEnabled=true
    kerberos.hive.hadoopConfigurationResources=/etc/hadoop/conf/core-site.xml,/etc/hadoop/conf/hdfs-site.xml
    kerberos.hive.kerberosPrincipal=<KYLO_PRINCIPAL_NAME>
    kerberos.hive.keytabLocation=/etc/security/keytabs/kylo.service.keytab   

    nifi.service.mysql.database_user=kylo
    nifi.service.mysql.password=password
    nifi.service.mysql.database_connection_url=jdbc:mysql://<MYSQL_HOSTNAME>   

    nifi.service.hive_thrift_service.database_connection_url=jdbc:hive2://<HIVE_SERVER2_HOSTNAME>:10000/default;principal=<HIVE_PRINCIPAL_NAME>
    nifi.service.hive_thrift_service.kerberos_principal=<NIFI_PRINCIPAL_NAME>
    nifi.service.hive_thrift_service.kerberos_keytab=/etc/security/keytabs/nifi.service.keytab
    nifi.service.hive_thrift_service.hadoop_configuration_resources=/etc/hadoop/conf/core-site.xml,/etc/hadoop/conf/hdfs-site.xml

       nifi.service.think_big_metadata_service.rest_client_url=http://<KYLO_EDGE_HOSTNAME>:8400/proxy/metadata   

    nifi.executesparkjob.sparkmaster=yarn-cluster
    nifi.executesparkjob.extra_jars=/usr/hdp/current/spark-client/lib/datanucleus-api-jdo-3.2.6.jar,/usr/hdp/current/spark-client/lib/datanucleus-core-3.2.10.jar,/usr/hdp/current/spark-client/lib/datanucleus-rdbms-3.2.9.jar
    nifi.executesparkjob.extra_files=/usr/hdp/current/spark-client/conf/hive-site.xml   

    nifi.all_processors.kerberos_principal=<NIFI_PRINCIPAL_NAME>
    nifi.all_processors.kerberos_keytab=/etc/security/keytabs/nifi.service.keytab
    nifi.all_processors.hadoop_configuration_resources=/etc/hadoop/conf/core-site.xml,/etc/hadoop/conf/hdfs-site.xml   

    Set the JMS server hostname for the Kylo hosted JMS server
    config.elasticsearch.jms.url=tcp://<KYLO_EDGE_HOST>:61616  

..

8. Install the Ranger Plugin.

   a. SCP Ranger plugin to /tmp.

   b. Install the Ranger plugin.

.. code-block:: console

      [root plugin]# mv /tmp/kylo-hadoop-authorization-ranger-<VERSION>.jar /opt/kylo/kylo-services/plugi
      [root plugin]# chown kylo:kylo /opt/kylo/kylo-services/plugin/kylo-hadoop-authorization-ranger-<VERSION>.jar
      [root plugin]# touch /opt/kylo/kylo-services/conf/authorization.ranger.properties
      [root plugin]# chown kylo:kylo /opt/kylo/kylo-services/conf/authorization.ranger.properties  

..

   c. Edit the properties file.

.. code-block:: console

      vi /opt/kylo/kylo-services/conf/authorization.ranger.properties

      ranger.hostName=<RANGER_HOST_NAME>
      ranger.port=6080
      ranger.userName=admin
      ranger.password=admin  

..

9. Start the Kylo applications.

.. code-block:: console

      [root]# /opt/kylo/start-kylo-apps.sh  

..

10. Check the logs for errors.

.. code-block:: console

      /var/log/kylo-services.log
      /var/log/kylo-ui/kylo-ui.log
      /var/log/kylo-services/kylo-spark-shell.err  

..

11. Login to the Kylo UI. 

.. code-block:: console

      http://<KYLO_EDGE_HOSTNAME>:8400  

..

Create Folders for NiFi standard-ingest Feed
============================================

1. Create the dropzone directory on the NiFi edge node.

.. code-block:: console

    $ mkdir -p /var/dropzone
    $ chown nifi /var/dropzone  

..

2. Create the HDFS root folders.

   This will be required since we are running under non-privileged users.   

.. code-block:: console

    [root]# su - hdfs
    [hdfs ~]$ kinit -kt /etc/security/keytabs/hdfs.service.keytab
    <HDFS_PRINCIPAL_NAME>
    [hdfs ~]$ hdfs dfs -mkdir /etl
    [hdfs ~]$ hdfs dfs -chown nifi:nifi /etl
    [hdfs ~]$ hdfs dfs -mkdir /model.db
    [hdfs ~]$ hdfs dfs -chown nifi:nifi /model.db
    [hdfs ~]$ hdfs dfs -mkdir /archive
    [hdfs ~]$ hdfs dfs -chown nifi:nifi /archive
    [hdfs ~]$ hdfs dfs -mkdir -p /app/warehouse
    [hdfs ~]$ hdfs dfs -chown nifi:nifi /app/warehouse
    [hdfs ~]$ hdfs dfs -ls /  

..

Create Ranger Policies
======================

1. Add the "kylo" and "nifi user to Ranger if they don’t exist.

2. Create the HDFS NiFi policy.

   a. Click into the HDFS repository

   b. Click on "Add New Policy" 

.. code-block:: console

        name: kylo-nifi-access
        Resource Path:
          /model.db/*
          /archive/*
          /etl/*
          /app/warehouse/*
        user: nifi
        permissions: all  

..

3. Create the Hive NiFi policy.

   a. Click into the Hive repository.

   b. Click on "Add New Policy". 

.. code-block:: console

        Policy Name: kylo-nifi-access
        Hive Database: userdata, default (required for access for some reason)
        table: *
        column: *
        user: nifi
        permissions: all  

..

4. Create the Hive Kylo policy.

   Grant hive access to "kylo" user for hive tables, profile, and wrangler.

+----------+------------------------------------------------------------+
|**Note:** | Kylo supports user impersonation (add doc and reference it)|
+----------+------------------------------------------------------------+

   a. Click into the Hive repository.

   b. Click on "Add New Policy".

.. code-block:: console

        Policy Name: kylo-kylo-access
        Hive Database: userdata
        table: *
        column: *
        user: kylo
        permissions: select  

..

Import Kylo Templates
=====================

1. Import Index Schema Template (For Elasticsearch).

   a. Locate the index_schema_service.zip file. You will need the file locally to upload it. You can find it in one of two places:

        1) <kylo_project>/samples/feeds/nifi-1.0/
        2) /opt/kylo/setup/data/feeds/nifi-1.0

   b. Go to the the Feeds page in Kylo.

   c. Click on the plus icon to add a feed.

   d. Select "Import from a file".

   e. Choose the index_schema_service.zip file.

   f. Click "Import Feed".

2. Update the Index Schema processors.

   a. Login to NiFi.

   b. Go to the system → index_schema_service process group

        1) Edit the "Receive Schema Index Request" processor and set the URL value to <KYLO_EDGE_HOSTNAME>.
        2) In addition to the URL field you might have to edit the jms-subscription property file as instructed above.
        3) Edit the "Index Metadata Elasticsearch" processor and set the HostName value to <KYLO_EDGE_HOSTNAME>.

3. Import Index Text Template (For Elasticsearch).

   a. Locate the index_text_service.zip file. You will need the file locally to upload it. You can find it in one of two places:

        - <kylo_project>/samples/feeds/nifi-1.0/
        - /opt/kylo/setup/data/feeds/nifi-1.0

   b. Go to the the Feeds page in Kylo.

   c. Click on the plus icon to add a feed.

   d. Select "Import from a file".

   e. Choose the index_text_service.zip file.

   f. Click "Import Feed".

4. Update the Index Text processors.

   a. Login to NiFi.

   b. Go to the system → index_text_service process group.

        1) Edit the "Receive Index Request" processor and set the URL value to <KYLO_EDGE_HOSTNAME>.

        2) In addition to the URL field you might have to edit the jms-subscription property file as instructed above.

        3) Edit the "Update Elasticsearch" processor and set the HostName value to <KYLO_EDGE_HOSTNAME>.


5. Note: An issue was found with the getJmsTopic processor URL. If you import the template using localhost and need to change it there is a bug that won’t allow the URL to be changed. The value is persisted to a file.

.. code-block:: console

        [root@ip-10-0-178-60 conf]# pwd
        /opt/nifi/current/conf
        [root@ip-10-0-178-60 conf]# ls -l
        total 48
        -rw-rw-r-- 1 nifi users 3132 Dec 6 22:05 bootstrap.conf
        -rw-rw-r-- 1 nifi users 2119 Aug 26 13:51 bootstrap-notification-services.xml
        -rw-rw-r-- 1 nifi nifi 142 Dec 7 00:36 jms-subscription-2bd64d8a-2b1f-1ef0-e961-e50680e34686
        -rw-rw-r-- 1 nifi nifi 142 Dec 7 00:54 jms-subscription-2bd64d97-2b1f-1ef0-7fc9-279eacf076dd
        -rw-rw-r-- 1 nifi users 8243 Aug 26 13:51 logback.xml
        -rw-rw-r-- 1 nifi users 8701 Dec 7 00:52 nifi.properties
        -rw-rw-r-- 1 nifi users 3637 Aug 26 13:51 state-management.xml
        -rw-rw-r-- 1 nifi users 1437 Aug 26 13:51 zookeeper.properties  

..

   a. Edit the file named named "jms-subscription-<processor_id>".

   b. Change the hostname.

   c. Restart NiFi.

6. Import the data ingest template.

   a. Go to the templates page and import the data ingest template.

   b. Manually update the spark validate processor.

      Add this variable to the ${table_field_policy_json_file}. It should look like this:

.. code-block:: console

       ${table_field_policy_json_file},/usr/hdp/current/spark-client/conf/hive-site.xml  

..

   c. Edit the "Upload to HDFS" and remove "Remote Owner" and "Remote Group" (since we aren’t using superuser).

7. Update NiFi processors for Kylo template versions prior to 0.5.0.

   We need to update a few settings in the elasticsearch and standard ingest template. This is not required with 0.5.0 or greater since they will be set during import.  

   a. Login to NiFi.

   b. Go to the reusable_templates → standard-ingest process group.

      1) Edit the "Register Index" processor and set the URL to the <KYLO_EDGE_HOSTNAME>.

      2) Edit the "Update Index" processor and set teh URL to the <KYLO_EDGE_HOSTNAME>.

8. Import the transform feed (Optional).

Create Data Ingest Feed Test
============================

1. Create a userdata feed to test.

2. Test the feed. 

.. code-block:: console

    cp -p <PATH_TO_FILE>/userdata1.csv /var/dropzone/

..
