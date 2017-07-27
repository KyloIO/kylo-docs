
=======================
Manual Deployment Guide
=======================

Preface
=======

This document explains how to install each component of the Kylo framework
manually. This is useful when you are installing across multiple
edge nodes. Use this link to the install wizard (:doc:`../installation/KyloSetupWizardDeploymentGuide`)
if you would prefer not to do the installation manually.

.. note:: Many of the steps below are similar to running the wizard-based install. If you want to take advantage of the same scripts as the wizard, you can tar up the /opt/kylo/setup folder and untar it to a temp directory on each node.

Audience
========

This guide provides step-by-step instruction for installing Kylo.
The reader is assumed to be a systems administrator, with knowledge of Linux.

Refer to the Kylo Operations Guide (:doc:`../user-guides/KyloOperationsGuide`) for detailed
instructions on how to effectively manage:

- Production processing

- Ongoing maintenance

- Performance monitoring

For enterprise support options, please visit:

    `http://kylo.io/ <http://kylo.io/>`__

Installation Components
=======================

Installing Kylo installs the following software:

-  **Kylo Applications**: Kylo provides services to produce Hive tables, generate a schema based on data brought into Hadoop, perform Spark-based transformations, track metadata, monitor feeds and SLA policies, and publish to target systems.

-  **Java 8**: Kylo uses the Java 8 development platform.

-  **NiFi**: Kylo uses Apache NiFi for orchestrating data pipelines.

-  **ActiveMQ**: Kylo uses Apache ActiveMQ to manage communications with clients and servers.

-  **Elasticsearch**: Kylo uses Elasticsearch, a distributed, multi-tenant capable full-text search engine.

Installation Locations
======================

Installing Kylo installs the following software at these Linux file
system locations:

-  Kylo Applications - /opt/kylo

-  Java 8 - /opt/java/current

-  NiFi - /opt/nifi/current

-  ActiveMQ - /opt/activemq

-  Elasticsearch - RPM installation default location

Installation
============

For each step below, you will need to login to the target machine with root
access permissions. Installation commands will be executed from the
command-line interface (CLI).

Step 1: Setup Directory
=======================

Kylo is most often installed on one edge node. If you are deploying
everything to one node, the setup directory would typically be:

.. code-block:: properties

    SETUP_DIR=/opt/kylo/setup

Sometimes administrators install NiFi on a second edge node to communicate with a Hortonworks or Cloudera cluster. In this case, copy
the setup folder to nodes that do not have the Kylo applications installed. In that case, use this SETUP_DIR command:

.. code-block:: properties

    SETUP_DIR=/tmp/kylo-install

Optional - Offline Mode
=======================

If an edge node has no internet access, you can generate a TAR file that contains everything in the /opt/kylo/setup folder, including the
downloaded application binaries.

1. Install the Kylo RPM on a node that has internet access.

.. code-block:: shell

    $ rpm -ivh kylo-<version>.noarch.rpm
..

2. Run the script, which will download all application binaries and put them in their respective directory in the setup folder.

.. code-block:: shell

    $ /opt/kylo/setup/generate-offline-install.sh
..

+------------+-------------------------------------------------------------------------------------------------------+
| **Note**   | If installing the Debian packages make sure to change the Elasticsearch download from RPM to DEB      |
+------------+-------------------------------------------------------------------------------------------------------+


3. Copy the /opt/kylo/setup/kylo-install.tar file to the node you install the RPM on. This can be copied to a temp directory. It doesn’t have to be put in the /opt/kylo/setup folder.

4. Run the command to tar up the setup folder.

.. code-block:: shell

    tar -xvf kylo-install.tar
..

5. Note the directory name where you untar’d the files. This will be referred to in the rest of the doc by OFFLINE_SETUP_DIR.


Step 2: Create Linux Users and Groups
=====================================

Creation of users and groups is done manually because many organizations have their own user and group management system. Therefore we cannot script it as part of the RPM install.

.. note:: Each of these should be run on the node on which the software will be installed. If a machine will run nifi, kylo and activemq, all users/groups should be created. If running individual services, only the appropriate user/group for that service should be created, not all of them. 

To create all the users and groups on a single machine, run the following command:

.. code-block:: shell

    useradd -U -r -m -s /bin/bash nifi && useradd -U -r -m -s /bin/bash kylo && useradd -U -r -m -s /bin/bash activemq

..

To create individual users, run the following commands on the appropriate machines:

.. code-block:: shell

  useradd -U -r -m -s /bin/bash nifi
  useradd -U -r -m -s /bin/bash kylo
  useradd -U -r -m -s /bin/bash activemq

..

The following command can be used to confirm if the user and group creation was successful:

.. code-block:: shell

  grep 'nifi\|kylo\|activemq' /etc/group /etc/passwd
..

This command should give two results per user, one for the user in /etc/passwd and one in /etc/group. For example, if you added all the users to an individual machine, there should be six lines of output. If you just added an individual user, there will be two lines of output.

If the groups are missing, they can be added individually:

.. code-block:: shell

   groupadd -f kylo
   groupadd -f nifi
   groupadd -f activemq
..

If all groups are missing, they can be all added with the following command:

.. code-block:: shell

  groupadd -f kylo && groupadd -f nifi && groupadd -f activemq
..

Step 3: Install Kylo Services
=============================

1. Download the RPM and place it on the host Linux machine that you want to install Kylo services on.

.. note:: To use wget instead, right-click the download link and copy the url.

    `Download the latest Kylo RPM <http://bit.ly/2uT8bTo>`_


2. Run the Kylo RPM install.

.. code-block:: shell

    $ rpm -ivh kylo-<version>.noarch.rpm
..

.. note:: The RPM is hard coded at this time to install to /opt/kylo.

Step 4: Run the database scripts
================================

For database scripts you may either choose to let liquibase automatically install the scripts for you or you can generate and run the SQL scripts yourself.

1. Liquibase - Create the "kylo" database in MySQL

.. code-block:: shell

    MariaDB [(none)]> create database kylo;
..


2. To generate SQL scripts manually
please refer to section #2 in the :doc:`../how-to-guides/DatabaseUpgrades` document to see how to generate the scripts


.. note:: If db_user does not have password, the *db_password* can be provided as ''. (For example, if using HDP 2.4 sandbox)

Step 5: Install and Configure Elasticsearch
===========================================

To get Kylo installed and up and running quickly, a script is provided
to stand up a single node Elasticsearch instance. You can also leverage
an existing Elasticsearch instance. For example, if you stand up an ELK
stack you will likely want to leverage the same instance.

**Option 1**: Install Elasticsearch from our script.

.. note:: The included Elasticsearch script was meant to speed up installation in a sandbox or DEV environment.

a. Online Mode

.. code-block:: shell

        $ <SETUP_DIR>/elasticsearch/install-elasticsearch.sh <KYLO_SETUP_FOLDER>

..

b. Offline Mode

.. code-block:: shell

        $ <OFFLINE_SETUP_DIR>/elasticsearch/install-elasticsearch.sh <OFFLINE_SETUP_DIR> -o

          Example:  /tmp/kylo-install/setup/elasticsearch/install-elasticsearch.sh /tmp/kylo-install/setup -o

..


**Option 2**: Use an existing Elasticsearch.
To leverage an existing Elasticsearch instance, you must update all feed templates that you created with the correct Elasticsearch URL.You can do this by going to the "Additional Properties" tab for that feed. If you added any reusable flow templates you will need to modify the Elasticsearch processors in NiFI.

.. note:: Tip: To test that Elasticsearch is running type "curl localhost:9200". You should see a JSON response.

Step 6: Install ActiveMQ
========================

Another script has been provided to stand up a single node ActiveMQ
instance. You can also leverage an existing ActiveMQ instance.

**Option 1**: Install ActiveMQ from the script

.. note:: The included ActiveMQ script was meant to speed up installation in a sandbox or DEV environment. It is not a production ready configuration.

a. Online Mode

.. code-block:: shell

        $ <SETUP_DIR>/activemq/install-activemq.sh <INSTALLATION_FOLDER> <LINUX_USER> <LINUX_GROUP>

..

b. Offline Mode

.. code-block:: shell

        $ <OFFLINE_SETUP_DIR>/activemq/install-activemq.sh <INSTALLATION_FOLDER> <LINUX_USER> <LINUX_GROUP> <OFFLINE_SETUP_DIR> -o

       Example: /tmp/kylo-install/setup/activemq/install-activemq.sh /opt/activemq activemq activemq /tmp/kylo-install/setup -o

..

.. note:: If installing on a different node than NiFi and kylo-services you will need to update the following properties

.. code-block:: shell

           1. /opt/nifi/ext-config/config.properties

                 spring.activemq.broker-url
                 (Perform this configuration update after installing NiFi, which is step 9 in this guide)

           2. /opt/kylo/kylo-services/conf/application.properties

                 jms.activemq.broker.url
                 (By default, its value is tcp://localhost:61616)
..

**Option 2**: Leverage an existing ActiveMQ instance

Update the below properties so that NiFI and kylo-services can communicate with the existing server.

.. code-block:: shell

   1. /opt/nifi/ext-config/config.properties

        spring.activemq.broker-url

   2. /opt/kylo/kylo-services/conf/application.properties

        jms.activemq.broker.url

..

**Installing on SUSE**

The deployment guide currently addresses installation in a Red Hat based environment. There are a couple of issues installing Elasticsearch and ActiveMQ on SUSE. Below are some instructions on how to install these two on SUSE.

-  **ActiveMQ**

When installing ActiveMQ, you might see the following error:

.. warning:: ERROR: Configuration variable JAVA_HOME or JAVACMD is not defined correctly. (JAVA_HOME='', JAVACMD='java')

This indicates that ActiveMQ isn’t properly using Java as it is set in the system. To fix this issue, use the following steps to set the JAVA_HOME directly:

1. Edit /etc/default/activemq and set JAVA_HOME at the bottom.

.. code-block:: properties

    JAVA_HOME=<location_of_java_home>

..

2. Restart ActiveMQ

.. code-block:: shell

    $ service activemq restart
..

-  **Elasticsearch**

RPM installation isn’t supported on SUSE. To work around this issue, we created a custom init.d service script and wrote up a manual procedure to install Elasticsearch on a single node.

    |Install_Elasticsearch_Link|


We have created a service script to make it easy to start and stop Elasticsearch, as well as leverage chkconfig to automatically start Elasticsearch when booting up the machine. Below are the instructions on how we installed Elasticsearch on a SUSE box.

.. code-block:: shell

    1. Make sure Elasticsearch service user/group exists

    2. mkdir /opt/elasticsearch

    3. cd /opt/elasticsearch

    4. mv /tmp/elasticsearch-2.3.5.tar.gz

    5. tar -xvf elasticsearch-2.3.5.tar.gz

    6. rm elasticsearch-2.3.5.tar.gz

    7. ln -s elasticsearch-2.3.5 current

    8. cp elasticsearch.yml elasticsearch.yml.orig

    9. Modify elasticsearch.yml if you want to change the cluster name. The standard Kylo installation scripts have this file in directory: /opt/kylo/setup/elasticsearch

    10. chown -R elasticsearch:elasticsearch /opt/elasticsearch/

    11. Uncomment and set the JAVA_HOME on line 44 of the file: /opt/kylo/setup/elasticsearch/init.d/sles/elasticsearch

    12. vi /etc/init.d/elasticsearch - paste in the values from /opt/kylo/setup/elasticsearch/init.d/sles/elasticsearch

    13. chmod 755 /etc/init.d/elasticsearch

    14. chkconfig elasticsearch on

    15. service elasticsearch start

..

Step 7: Install Java 8
======================

.. note:: If you are installing NiFi and the kylo services on two separate nodes, you may need to perform this step on each node.

There are 3 scenarios for configuring the applications with Java 8.

**Scenario 1**: Java 8 is installed on the system and is already in the classpath.

In this case you need to remove the default JAVA_HOME used as part of the install. Run the following script:

.. code-block:: shell

    For kylo-ui and kylo-services
    $ <SETUP_DIR>/java/remove-default-kylo-java-home.sh

To test this you can look at each file referenced in the scripts for kylo-ui and kylo-services to validate the 2 lines setting and exporting the JAVA_HOME are gone.

**Scenario 2**: Install Java in the default /opt/java/current location.

.. note:: You can modify and use the following script to unstall Java 8:

..

    **Online Mode**

.. code-block:: shell

         $ <SETUP_DIR>/java/install-java8.sh

..

    **Offline Mode**

.. code-block:: shell

         $ <OFFLINE_SETUP_DIR>/java/install-java8.sh  <KYLO_HOME_DIR> <OFFLINE_SETUP_DIR> -o

         Example: /tmp/kylo-install/setup/java/install-java8.sh  /opt/kylo /tmp/kylo-install/setup -o

..

**Scenario 3**: Java 8 is installed on the node, but it’s not in the default JAVA_HOME path.

If you already have Java 8 installed, and want to reference that installation, there is a script to remove the existing path and another script to set the new path for the kylo apps.

.. code-block:: shell

        For kylo-ui and kylo-services
        $ /opt/kylo/setup/java/remove-default-kylo-java-home.sh <KYLO_HOME>
        $ /opt/kylo/setup/java/change-kylo-java-home.sh <JAVA_HOME> <KYLO_HOME>

Step 8: Install Java Cryptographic Extension
============================================

The Java 8 install script above will automatically download and install the `Java Cryptographic Extension <http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html>`__.
This extension is required to allow encrypted property values in the Kylo configuration files. If you already have a Java 8 installed on the
system, you can install the Java Cryptographic Extension by running the following script:

.. code-block:: shell

    $ <SETUP_DIR>/java/install-java-crypt-ext.sh <PATH_TO_JAVA_HOME>

This script downloads the extension zip file and extracts the replacement jar files into the JRE security directory ($JAVA_HOME/jre/lib/security). It will first make backup copies of the original jars it is replacing.

Step 9: Install NiFi
====================

You can leverage an existing NiFi installation or follow the steps in the setup directory that are used by the wizard.

.. note:: Note that Java 8 is required to run NiFi with our customizations. Make sure Java 8 is installed on the node.

**Option 1**: Install NiFi from our scripts.

This method downloads and installs NiFi, and also installs and configures the Kylo-specific libraries. This instance of NiFi is configured to store persistent data outside of the NiFi installation folder in /opt/nifi/data. This makes it easy to upgrade since you can change the version of NiFi without migrating data out of the old version.

a. Install NiFi in either online or offline mode:

  **Online Mode**

.. code-block:: shell

          $ <SETUP_DIR>/nifi/install-nifi.sh <NIFI_BASE_FOLDER> <NIFI_LINUX_USER> <NIFI_LINUX_GROUP>

..

    **Offline Mode**

.. code-block:: shell

          $ <OFFLINE_SETUP_DIR>/nifi/install-nifi.sh  <NIFI_BASE_FOLDER> <NIFI_LINUX_USER> <NIFI_LINUX_GROUP> <OFFLINE_SETUP_DIR> -o

..

b. Update JAVA_HOME (default is /opt/java/current).

.. code-block:: shell

          $ <SETUP_DIR>/java/change-nifi-java-home.sh <JAVA_HOME> <NIFI_BASE_FOLDER>/current

..

c. Install Kylo specific components.

.. code-block:: shell

          $ <SETUP_DIR>/nifi/install-kylo-components.sh <NIFI_BASE_FOLDER> <KYLO_HOME> <NIFI_LINUX_USER> <NIFI_LINUX_GROUP>

..

**Option 2**: Leverage an existing NiFi instance

In some cases you may want to leverage separate instances of NiFi or Hortonworks Data Flow. Follow the steps below to include the Kylo resources.

.. note:: If Java 8 isn't being used for the existing instance, then you will be required to change it.

1.  Copy the <SETUP_DIR>/nifi/kylo-*.nar and kylo-spark-*.jar files to the node NiFi is running on. If it’s on the same node you can skip this step.

2.  Shutdown the NiFi instance.

3.  Create folders for the jar files. You may choose to store the jars in another location if you want.

.. code-block:: shell

           $ mkdir -p <NIFI_HOME>/kylo/lib

..

4.  Copy the kylo-\*.nar files to the <NIFI_HOME>/kylo/lib directory.

..

5.  Create a directory called "app" in the <NIFI_HOME>/kylo/lib directory.

.. code-block:: shell

           $ mkdir <NIFI_HOME>/kylo/lib/app

..

6.  Copy the kylo-spark-\*.jar files to the <NIFI_HOME>/kylo/lib/app directory.

..

7.  Create symbolic links for all of the .NARs and .JARs. Below is an example of how to create it for one NAR file and one JAR file. At the time of this writing there are eight NAR files and three spark JAR files.

.. code-block:: shell

           $ ln -s <NIFI_HOME>/kylo/lib/kylo-nifi-spark-nar-*.nar <NIFI_HOME>/lib/kylo-nifi-spark-nar.nar

           $ ln -s <NIFI_HOME>/kylo/lib/app/kylo-spark-interpreter-*-jar-with-dependencies.jar
                     <NIFI_HOME>/lib/app/kylo-spark-interpreter-jar-with-dependencies.jar

..

8.  Modify <NIFI_HOME>/conf/nifi.properties and update the port NiFi runs on.

.. code-block:: shell

           nifi.web.http.port=8079
..

.. note:: If you decide to leave the port number set to the current value, you must update the "nifi.rest.port" property in the kylo-services application.properties file.

9.  There is a controller service that requires a MySQL database connection. You will need to copy the driver jar to a location on the NiFi node. The pre-defined templates have the default location set to /opt/nifi/mysql.

           1. Create a folder to store the driver jar in.

           2. Copy the /opt/kylo/kylo-services/lib/mariadb-java-client-<version>.jar to the folder in step #1.

           3. If you created a folder name other than the /opt/nifi/mysql default folder you will need to update the "MySQL" controller service and set the new location. You can do this by logging into NiFi and going to the Controller Services section at root process group level.

10.  Create an ext-config folder to provide JMS information and location of cache to store running feed flowfile data if NiFi goes down.

.. note:: Right now the plugin is hard coded to use the /opt/nifi/ext-config directory to load the properties file.

Configure the ext-config folder
-------------------------------

1. Create the folder.

.. code-block:: shell

                  $ mkdir /opt/nifi/ext-config
..

2. Copy the /opt/kylo/setup/nifi/config.properties file to the /opt/nifi/ext-config folder.

3. Change the ownership of the above folder to the same owner that nifi runs under. For example, if nifi runs as the "nifi" user:

.. code-block:: shell

                  $ chown -R nifi:users /opt/nifi

..

11.  Create an activemq folder to provide JARs required for the JMS processors.

Configure the activemq folder
-----------------------------

1. Create the folder.

.. code-block:: shell

                $ mkdir /opt/nifi/activemq

..

2. Copy the /opt/kylo/setup/nifi/activemq/\*.jar files to the /opt/nifi/activemq folder.

.. code-block:: shell

                $ cp /opt/kylo/setup/nifi/activemq/*.jar /opt/nifi/activemq

..

3. Change the ownership of the folder to the same owner that nifi runs under. For example, if nifi runs as the "nifi" user:

.. code-block:: shell

                  $ chown -R nifi:users /opt/nifi/activemq

..

OPTIONAL: The /opt/kylo/setup/nifi/install-kylo-components.sh contains steps to install NiFi as a service so that NiFi can startup automatically if you restart the node. This might be useful to add if it doesn't already exist for the NiFi instance.

Step 10: Set Permissions for HDFS
=================================

This step is required on the node that NiFi is installed on to set the
correct permissions for the "nifi" user to access HDFS.

1. NiFi Node - Add nifi user to the HDFS supergroup or the group defined in hdfs-site.xml, for example:

   **Hortonworks (HDP)**

.. code-block:: shell

        $ usermod -a -G hdfs nifi

..

    **Cloudera (CDH)**

.. code-block:: shell

        $ groupadd supergroup
        # Add nifi and hdfs to that group:
        $ usermod -a -G supergroup nifi
        $ usermod -a -G supergroup hdfs

..

.. note:: If you want to perform actions as a root user in a development environment, run the below command.

.. code-block:: shell

        $ usermod -a -G supergroup root

..

2. kylo-services node - Add kylo user to the HDFS supergroup or the group defined in hdfs-site.xml, for example:

   **Hortonworks (HDP)**

.. code-block:: shell

        $ usermod -a -G hdfs kylo

..

    **Cloudera (CDH)**

.. code-block:: shell

        $ groupadd supergroup
        # Add nifi and hdfs to that group:
        $ usermod -a -G supergroup hdfs

..

.. note:: If you want to perform actions as a root user in a development environment run the below command.

.. code-block:: shell

        $ usermod -a -G supergroup root

..

3. For Clusters:

   In addition to adding the nifi and kylo users to the supergroup on the edge node you also need to add the users/groups to the **NameNodes** on a cluster.

   **Hortonworks (HDP)**

.. code-block:: shell

        $ useradd kylo

        $ useradd nifi

        $ usermod -G hdfs nifi

        $ usermod -G hdfs kylo

..

    **Cloudera (CDH)** - <Fill me in after testing >

Step 11: Create a dropzone folder on the edge node for file ingest
==================================================================

Perform the following step on the node on which NiFI is installed:

.. code-block:: shell

    $ mkdir -p /var/dropzone

    $ chown nifi /var/dropzone

..

.. note:: Files should be copied into the dropzone such that user nifi can read and remove. Do not copy files with permissions set as root.

Complete this step for Cloudera installations ONLY
--------------------------------------------------

Please check the `Cloudera specific changes <../installation/KyloSetupWizardDeploymentGuide-Cloudera.html>`_


Step 12: (Optional) Edit the Properties Files
=============================================

If required for any specific customization, edit the properties files for Kylo services:

.. code-block:: shell

    $ vi /opt/kylo/kylo-services/conf/application.properties

    $ vi /opt/kylo/kylo-ui/conf/application.properties

..


Step 13: Final Step: Start the 3 Kylo Services
==============================================

.. code-block:: shell

    $ /opt/kylo/start-kylo-apps.sh

At this point all services should be running. Verify by running:

.. code-block:: shell

    $ /opt/kylo/status-kylo-apps.sh
..

.. |Install_Elasticsearch_Link| raw:: html

    <a href="https://www.elastic.co/support/matrix" target="_blank">Install_Elasticsearch</a>
