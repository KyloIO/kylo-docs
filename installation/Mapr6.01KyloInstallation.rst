
================================================
MapR 6.0.1 Kylo Installation Guide
================================================

About
=====

This guide provides an end to end example of installing Kylo on a single MapR 6.0.1 in AWS. Kylo is generally installed
on an edge node in a Hadoop cluster.

Two things are required before installing Kylo

1. You need to provide a MapR cluster
2. You need an edge node in the same VPC and subnet that can communicate with the cluster. This document assumes the edge node is Centos 7.

Let get started !!

Provide a MapR Cluster
=======================

This guide assumes you have a MapR cluster running in AWS. If one doesn't exist please create one. This example is configured for a cluster
running in secure mode using MapR security

Create an Edge Node
===================

Kylo is generally installed on an edge node in a Hadoop cluster. Follow the MapR documentation to create an edge node that can communicate with the cluster. The
following should be on the edge node:

- Beeline client
- Spark 2
- Hadoop client

.. note:: In the below example, Kylo was installed on a single node MapR instance and the client libraries were already there. I believe you need to install the MapR Client. You will want the 3 above clients on the edge node.

Configure Security Groups
=========================

For this installation we will open up all ports between the MapR master, slave, and Kylo edge node. If you prefer to open up
only the required ports please see the :doc:`dependencies page <../installation/Dependencies>`

1. Modify the Master and Slave security groups to allow access from the Kylo EC2 instance.
2. Modify the security group for the Kylo edge node to allow access from the master and slave nodes.

Install MariaDB
===============

In this example we will use MariaDB to store the Kylo database on the edge node.

.. code-block:: console

    # Run the following commands as root
    yum install -y zip unzip mariadb mariadb-server lsof
    systemctl enable mariadb
    systemctl start mariadb

    # Note: Replace <PASSWORD> with the root password you want to use
    printf "\nY\n<PASSWORD>\n<PASSWORD>\nY\nY\nY" | mysql_secure_installation

    # Test that the password works
    mysql -p

..

Install Java 8
==============

.. code-block:: console

    yum install -y java-1.8.0-openjdk-devel

    vi /etc/profile.d/java.sh
        export JAVA_HOME=/etc/alternatives/java_sdk_1.8.0
        export PATH=$JAVA_HOME/bin:$PATH

    source /etc/profile.d/java.sh
..

Download the Kylo RPM
=====================

.. code-block:: console

    # Run as root
    wget http://bit.ly/2KDX4cy -O /opt/kylo-#.#.#.#.rpm

..

Create the Linux Users
======================

1. Create the following users on the Kylo edge node.

.. code-block:: console

    # Run as root
    useradd -r -m -s /bin/bash nifi && useradd -r -m -s /bin/bash kylo && useradd -r -m -s /bin/bash activemq

..

2. Create the kylo and nifi users on the EMR Master Node

.. code-block:: console

    # Run as root on the master node
    useradd -r -m -s /bin/bash nifi
    useradd -r -m -s /bin/bash kylo

..

Install the Kylo RPM
=====================

.. code-block:: console

    # Run as root
    rpm -ivh kylo-#.#.#.#.rpm

..

Set the Spark Home
=====================

The setup wizard and Kylo needs spark in the path

.. code-block:: console

    vi /etc/profile.d/spark.sh

        export SPARK_HOME=/opt/mapr/spark/spark-2.2.1
        export PATH=$SPARK_HOME/bin:$PATH

    source /etc/profile.d/spark.sh
..

Test Spark in Yarn Mode
=======================

Run as the mapr user (root can't run it)

.. code-block:: console

 spark-submit --class org.apache.spark.examples.SparkPi --master yarn --driver-memory 512m --executor-memory 512m --executor-cores 1 /opt/mapr/spark/spark-2.2.1/examples/jars/spark-examples_2.11-2.2.1-mapr-1803.jar

..

Run the Kylo Setup Wizard
=========================

.. code-block:: console

    # Run as root
    /opt/kylo/setup/setup-wizard.sh

        Welcome to the Kylo setup wizard. Lets get started !!!

        Please enter Y/y or N/n to the following questions:

        Enter the kylo home folder location, hit Enter for '/opt/kylo':

        Would you like to install the database scripts in a database instance? Please enter y/n: y

        Would you like Kylo to manage installing and upgrading the database automatically? Please enter y/n: y

        Which database (Enter the number)?

        1) MySQL

        2) PostgresSQL

        3) SQL Server

        > 1

        Please enter the database hostname or IP, hit Enter for 'localhost'

        >

        Please enter the database ADMIN username

        > root

        Please enter the database ADMIN password

        > Creating MySQL database 'kylo'

        Please enter the password for the dladmin user

        >

        Please re-enter the password for the dladmin user

        >

        Please choose an option to configure Java for Kylo, ActiveMQ, and NiFi

        1) I already have Java 8 or higher installed as the system Java and want to use that

        2) Install Java 8 in the /opt/java folder for me and use that one

        3) I have Java 8 or higher installed in another location already. I will provide the location

        4) Java is already setup. No changes necessary

        > 1



        Would you like me to install a local elasticsearch instance? Please enter y/n: y

        Would you like me to install a local activemq instance?  Please enter y/n: y

        Enter the Activemq home folder location, hit Enter for '/opt/activemq':

        Enter the user Activemq should run as, hit Enter for 'activemq':

        Enter the linux group Activemq should run as, hit Enter for 'activemq':



        Would you like me to install a local nifi instance? Please enter y/n: y

        Enter Nifi version you wish to install, hit Enter for '1.6.0':

        Enter the NiFi home folder location, hit Enter for '/opt/nifi':

        Enter the user NiFi should run as, hit Enter for 'nifi':

        Enter the linux group NiFi should run as, hit Enter for 'nifi':

..


Generate a MapR Service Ticket
==============================

A service ticket is required for Kylo and NiFi to connect to the cluster

.. code-block:: console

    # Leave off duration and renewal so ticket doesn’t expire
    # Run as the mapr user

    maprlogin generateticket -type service -out /tmp/kylo-service-ticket  -user kylo
    maprlogin generateticket -type service -out /tmp/nifi-service-ticket  -user nifi

    # su to root user
    su -

    mv /tmp/kylo-service-ticket /opt/kylo
    chown kylo:kylo /opt/kylo/kylo-service-ticket
    mv /tmp/nifi-service-ticket /opt/nifi
    chown nifi:nifi /opt/nifi/nifi-service-ticket

    # Add the service ticket to the kylo-services application
    vi /opt/kylo/kylo-services/bin/run-kylo-services.sh

        export MAPR_TICKETFILE_LOCATION=/opt/kylo/kylo-service-ticket

    # Add teh service ticket to NiFi
    vi /opt/nifi/current/bin/nifi-env.sh

        export MAPR_TICKETFILE_LOCATION=/opt/nifi/nifi-service-ticket

..

Build the MapR NiFi NAR Files
=============================

The NiFi and Kylo HDFS processors will not work without rebuliding the NAR files using the MapR maven profile. You will need
to do the following to rebuild the NAR's.

.. note:: This was tested with NiFi 1.7

1. Download the NiFi release source code from the NiFi github site.

2. Add the following dependency to the nifi-hadoop-libaries-nar pom.xml file.

.. code-block:: console

    vi <NIFI_HOME>/nifi-nar-bundles/nifi-hadooop-libraries-bundle/nifi-hadoop-libraries-nar/pom.xml

        <dependency>
            <groupId>org.apache.hadoop</groupId>
            <artifactId>hadoop-mapreduce-client-contrib</artifactId>
            <version>${hadoop.version}</version>
        </dependency>

..

3. Build the NiFi project with the "mapr" profile.

.. code-block:: console

    # This example is to build using the MapR 6.0.1 build
    mvn clean install -Pmapr -Dhadoop.version=2.7.0-mapr-1803

..

4. Copy the following two NAR files to the server where NiFi is installed.

.. code-block:: console

    <NIFI_HOME>/nifi-nar-bundles/nifi-hadoop-libraries-bundle/nifi-hadoop-libraries-nar/target/nifi-hadoop-libraries-nar-1.6.0.nar
    <NIFI_HOME>/nifi-nar-bundles/nifi-hadoop-bundle/nifi-hadoop-nar/target/nifi-hadoop-nar-1.6.0.nar
..

5. SSH to the node where you copied the NAR files and run the following command

.. code-block:: console

    # From the folder where you copied the two NAR files
    cp nifi-hadoop-* /opt/nifi/current/lib/

..

6. Checkout the release branch of the Kylo project from github (for the version of Kylo you are using.

7. Build Kylo with the "mapr" profile. This example is to build using the MapR 6.0.1 build

.. code-block:: console

    cd <KYLO_HOME>
    export MAVEN_OPTS="-Xms2g -Xmx4g"
    mvn clean install -DskipTests -Dlicense.skipCheckLicense=true -Pmapr -Dhadoop.version=2.7.0-mapr-1803

..

8. Copy the hadoop NAR file to the Kylo edge node

.. code-block:: console

    <KYLO_HOME>/integrations/nifi/nifi-nar-bundles/nifi-hadoop-bundle/nifi-hadoop-bundle-v1.2-nar/target/kylo-nifi-hadoop-v1.2-nar-<VERSION>.nar

..

9. On the Kylo edge node move the NAR file to the NiFi Kylo NAR folder

.. code-block:: console

    mv  kylo-nifi-hadoop-v1.2-nar-<VERSION>.nar /opt/nifi/data/lib/
    chown nifi:nifi /opt/nifi/data/lib/kylo-nifi-hadoop-v1.2-nar-<VERSION>.nar
..

10. Update the symbolic links to the Kylo NARS

.. code-block:: console

    /opt/kylo/setup/nifi/update-nars-jars.sh /opt/nifi /opt/kylo/setup nifi nifi

..


Add the MapR Properties to NiFi
===============================

1. Add the following to the core-site.xml file if it isn't already there.

.. code-block:: console

    vi /opt/mapr/hadoop/hadoop-2.7.0/etc/hadoop/core-site.xml

        <property>

          <name>fs.defaultFS</name>

          <value>maprfs:///</value>

        </property>

..

2. Add the following to the nifi-env.sh.

.. code-block:: console

    vi /opt/nifi/current/bin/nifi-env.sh

        export YARN_CONF_DIR=/opt/mapr/hadoop/hadoop-2.7.0/etc/hadoop/
        export HADOOP_CONF_DIR=/opt/mapr/hadoop/hadoop-2.7.0/etc/hadoop/

..

3. Add the following to the bootstrap.conf File.

.. code-block:: console

    vi /opt/nifi/current/conf/bootstrap.conf

        # Make sure the java.arg.<NUMBER> isn't already used
        java.arg.18=-Djava.security.auth.login.config=/opt/mapr/conf/mapr.login.conf
        java.arg.19=-Dfs.hdfs.impl=com.mapr.fs.MapRFileSystem
        java.arg.20=-Dfs.maprfs.impl=com.mapr.fs.MapRFileSystem

..

Start NiFi and Test
===================

1. Start NiFi

.. code-block:: console

    service nifi start

    # Watch the logs to make sure nifi starts up correctly
    tail -500f /var/log/nifi/nifi-app.log
..

2. Open up a browser and go to http://<KYLO_EDGE_NODE>:8079/nifi

Configure Kylo
==============

You will need to modify some of the Kylo properties to communicate with the cluster

.. code-block:: console

    # as root
    vi /opt/kylo/kylo-services/conf/application.properties

        spring.datasource.username=root
        spring.datasource.password=<password>

        # uncomment the following 4 fields
        metadata.datasource.username=${spring.datasource.username}
        metadata.datasource.password=${spring.datasource.password}
        modeshape.datasource.username=${spring.datasource.username}
        modeshape.datasource.password=${spring.datasource.password}

        hive.datasource.url=jdbc:hive2://<HIVE_SERVER2_NODE>:10000/default
        hive.datasource.username=<MAPR_HIVE_USERNAME>
        hive.datasource.password=<PASSWORD>

        hive.metastore.datasource.url=jdbc:mysql://<MAPR_DATABASE_NODE>:3306/hive
        hive.metastore.datasource.username=<HIVE_METASTORE_USERNAME
        hive.metastore.datasource.password=<PASSWORD>

        nifi.service.hive_thrift_service.database_connection_url=jdbc:hive2://<MASTER_DNS_NAME>:10000/default
        nifi.service.hive_thrift_service.database_user=mapr
        nifi.service.hive_thrift_service.password=mapr

        nifi.service.mysql.database_user=root
        nifi.service.mysql.password=<PASSWORD>

        nifi.service.kylo_mysql.database_user=root
        nifi.service.kylo_mysql.password=<PASSWORD>

        nifi.service.kylo_metadata_service.rest_client_password=<DLADMIN_PASSWORD>

        nifi.executesparkjob.sparkhome=/opt/mapr/spark/spark-2.2.1
        nifi.executesparkjob.sparkmaster=yarn-cluster

        config.spark.validateAndSplitRecords.extraJars=/opt/mapr//hive/hive-2.1/hcatalog/share/hcatalog/hive-hcatalog-core-2.1.1-mapr-1803.jar

        config.spark.version=2

        nifi.all_processors.hadoop_configuration_resources=/opt/mapr/hadoop/hadoop-2.7.0/etc/hadoop/core-site.xml,/opt/mapr/hadoop/hadoop-2.7.0/etc/hadoop/hdfs-site.xml


..

Start Kylo
==========

.. code-block:: console

    # as root
    kylo-service start

..

Create the Dropzone Folder
==========================

To test a feed we need to create a dropzone folder to stage files in

.. code-block:: console

    # as root
    mkdir -p /var/dropzone

    chown nifi:users /var/dropzone

..

Create the HDFS Folders
=======================

These folders are required for the standard ingest template. We want to prepare them ahead of time with the correct permissions
so that MapR does not create them as the mapr user.

.. code-block:: console

    # as the mapr user

    hadoop dfs -mkdir /etl
    hadoop dfs -chown nifi:nifi /etl
    hadoop dfs -mkdir /model.db
    hadoop dfs -chown nifi:nifi /model.db
    hadoop dfs -mkdir /archive
    hadoop dfs -chown nifi:nifi /archive
    hadoop dfs -mkdir -p /app/warehouse
    hadoop dfs -chown nifi:nifi /app/warehouse
    hadoop dfs -ls /

    hadoop dfs -mkdir /user/nifi
    hadoop dfs -chown nifi:nifi /user/nifi
    hadoop dfs -mkdir /user/kylo
    hadoop dfs -chown kylo:kylo /user/kylo

..


Create a Category
=================

Go to the Categories page in Kylo and create a new Category

Import the Standard Ingest Template
===================================

Follow the instructions on the Import Template page to import the :doc:`standard-ingest template <../installation/ImportTemplates>`


Create sample feed
==================

Drop a file in the drop zone and watch Kylo to make sure the feed runs successfully.

.. code-block:: console

    cp -p /opt/kylo/setup/data/sample-data/csv/userdata1.csv /var/dropzone/

..

Troubleshooting
===============

1. Error in merge processor

    You may see an error similar to this:

        Error: java.lang.RuntimeException: java.lang.IllegalStateException: Ambiguous input path maprfs:///app/warehouse/users/test5/_scratchdir_hive_2018-08-14_16-18-12_360_8258087974302232995-7/-mr-10002/000000_0

    This is due to an |Hive Directories Optimization| that might need to be changed.

    Do the following on the master node:

    .. code-block:: console


        vi /opt/mapr/hive/hive-2.1/conf/hive-site.xml

            <property>

                <name>hive.optimize.insert.dest.volume</name>

                <value>false</value>

                <description>

                  For CREATE TABLE AS and INSERT queries create the scratch directory under

                  the destination directory. This avoids the data move across volumes and improves performance.

                </description>

              </property>



    Restart HiveServer2 in the MCS console

.. |Hive Directories Optimization| raw:: html

    <a href="https://mapr.com/docs/60/Hive/Config-HiveDirectories.html " target="_blank">optimization</a>
