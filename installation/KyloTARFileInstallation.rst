
==================================
TAR File Installation and Upgrade
==================================

Introduction
============

An RPM installation is meant to be an opinionated way of installing an
application, and it reduces the number of steps required to complete the
installation. However, many organizations have strict requirements as to where
they need to install Kylo, and the user that Kylo must be run under. These
instructions will guide you through an alternative way to install Kylo.

Determine Service Account and Kylo Install Location
---------------------------------------------------

Let’s assume, for this example, that Kylo will run under an account name
"ad_kylo", and it will be installed in /apps/.

Step 1: Create the Kylo, NiFi, and ActiveMQ User
------------------------------------------------------------------------------

.. code-block:: shell

    $ sudo useradd -r -m -s /bin/bash ad_nifi
    $ sudo useradd -r -m -s /bin/bash ad_kylo
    $ sudo useradd -r -m -s /bin/bash ad_activemq


..

Step 2: Untar Kylo in the /apps folder
-----------------------------------------------------------

.. code-block:: shell

    $ sudo mkdir /apps/kylo
    $ sudo tar -xvf /tmp/kylo-0.8.2-dependencies.tar.gz -C /apps/kylo

..


Step 3: Run the post install script
-----------------------------------------

This script will set the user permissions, create the init.d scripts and create the log directories in /var/log


.. code-block:: shell

    $ sudo /apps/kylo/setup/install/post-install.sh /apps/kylo ad_kylo users

..

Step 4: Run the setup wizard
------------------------------

Run the setup wizard to install NiFi, ActiveMQ and Elasticsearch


.. code-block:: shell

    $ sudo /apps/kylo/setup/setup-wizard.sh

..

[root@sandbox dropzone]# usermod -a -G hdfs ad_nifi
[root@sandbox dropzone]# usermod -a -G hdfs ad_kylo

nifi.service.mysql.database_driver_location(s)=file:///apps/nifi/mysql/mariadb-java-client-1.5.7.jar
nifi.service.kylo_hive_metastore_service.database_driver_location(s)=file:///apps/nifi/mysql/mariadb-java-client-1.5.7.jar
nifi.service.jmsconnectionfactoryprovider.mq_client_libraries_path_(i.e.,_/usr/jms/lib)=/apps/nifi/activemq
nifi.service.hive_thrift_service.database_user=ad_nifi

applicationjar=/opt/nifi/current/lib/app/kylo-spark-validate-cleanse-jar-with-dependencies.jar

Step 8: Start up Kylo and nifi and test.
----------------------------------------------

.. code-block:: shell

    $ sudo kylo-service start
    $ sudo service nifi start

..


TAR file upgrade
================

Below are instructions on how to upgrade using a TAR file

Step 1: Backup and Delete the Kylo folder
------------------------------------------------------------------------------

.. code-block:: shell

    $ sudo kylo-service stop
    $ sudo cp -R /apps/kylo/ /apps/kylo-0.8.1-bk
    $ sudo rm -rf /apps/kylo
    $ sudo chkconfig --del kylo-ui
    $ sudo chkconfig --del kylo-spark-shell
    $ sudo chkconfig --del kylo-services
    $ sudo rm -rf /etc/init.d/kylo-ui
    $ sudo rm -rf /etc/init.d/kylo-services
    $ sudo rm -rf /etc/init.d/kylo-spark-shell
    $ sudo rm -rf /var/log/kylo-*


..

Step 2: Stop NiFi
------------------------------------------------------------------------------

Step 3: Untar the new file
------------------------------------------------------------------------------

.. code-block:: shell

    $ sudo mkdir /apps/kylo
    $ sudo tar -xvf /tmp/kylo-0.8.2-dependencies.tar.gz -C /apps/kylo

..

Step 4: Run the post install script
------------------------------------------------------------------------------

.. code-block:: shell

    $ sudo /apps/kylo/setup/install/post-install.sh /apps/kylo ad_kylo users

..

Step 5: Update the NiFi JARS and NARS
------------------------------------------------------------------------------

.. code-block:: shell

    $ sudo rm -rf /apps/nifi/data/lib/*.nar
    $ sudo rm -rf /apps/nifi/data/lib/app/*.jar

    $ sudo /apps/kylo/setup/nifi/update-nars-jars.sh /apps/nifi /apps/kylo/setup ad_nifi users

..


Step 6: Start NiFi
------------------------------------------------------------------------------


Step 7: Copy custom configuration files to the new installation
------------------------------------------------------------------------------

For example:

.. code-block:: shell

    $ sudo cp /apps/kylo-0.8.1-bk/kylo-services/bin/run-kylo-spark-shell.sh /apps/kylo/kylo-services/bin
    $ sudo cp /apps/kylo-0.8.1-bk/kylo-services/conf/spark.properties /apps/kylo/kylo-services/conf
    $ sudo cp /apps/kylo-0.8.1-bk/kylo-services/conf/application.properties /apps/kylo/kylo-services/conf
    $ sudo cp /apps/kylo-0.8.1-bk/kylo-ui/conf/application.properties /apps/kylo/kylo-ui/conf
    $ sudo cp /apps/kylo-0.8.1-bk/encrypt.key /apps/kylo/
    $ sudo cp /apps/kylo-0.8.1-bk/kylo-services/lib/postgresql-42.0.0.jar /apps/kylo/kylo-services/lib/

    $ sudo cp /apps/kylo-0.8.1-bk/kylo-services/conf/ambari.properties /apps/kylo/kylo-services/conf/
    $ sudo cp /apps/kylo/setup/plugins/kylo-service-monitor-ambari-0.8.1.1-SNAPSHOT.jar /apps/kylo/kylo-services/plugin/
    $ sudo chown ad_kylo:ad_kylo /apps/kylo/kylo-services/plugin/kylo-service-monitor-ambari-0.8.1.1-SNAPSHOT.jar

..

Step 8: Start Kylo
------------------------------------------------------------------------------

.. code-block:: shell

    $ sudo kylo-service start

..
