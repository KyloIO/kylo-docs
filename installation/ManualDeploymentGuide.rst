
=======================
Manual Deployment Guide
=======================

This document explains how to install each component of the Kylo framework
manually. This is useful when you are installing across multiple
edge nodes. Use this link to the install wizard (:doc:`../installation/SetupWizardDeploymentGuide`)
if you would prefer not to do the installation manually.

.. note:: Many of the steps below are similar to running the wizard-based install. If you want to take advantage of the same scripts as the wizard, you can tar up the /opt/kylo/setup folder and untar it to a temp directory on each node.


Installation
============

For each step below, you will need to login to the target machine with root
access permissions. Installation commands will be executed from the
command line

Step 1: Setup Directory
=======================

Kylo is most often installed on one edge node. If you are deploying
everything to one node, the setup directory would typically be:

.. code-block:: properties

    SETUP_DIR=/opt/kylo/setup

You might install some of these components on a differnet edge node than where Kylo is installed. In this case, copy
the setup folder or offline TAR file to those nodes that do not have the Kylo applications installed. In that case, use this SETUP_DIR command:

.. code-block:: properties

    SETUP_DIR=/tmp/kylo-install

..

Step 2: Install Java 8
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

         $ <SETUP_DIR>/java/install-java8.sh <KYLO_HOME_DIR>

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


Step 3: Install Java Cryptographic Extension
============================================

The Java 8 install script above will automatically download and install the `Java Cryptographic Extension <http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html>`__.
This extension is required to allow encrypted property values in the Kylo configuration files. If you already have a Java 8 installed on the
system, you can install the Java Cryptographic Extension by running the following script:

.. code-block:: shell

    $ <SETUP_DIR>/java/install-java-crypt-ext.sh <PATH_TO_JAVA_HOME>

This script downloads the extension zip file and extracts the replacement jar files into the JRE security directory ($JAVA_HOME/jre/lib/security). It will first make backup copies of the original jars it is replacing.


Step 4: Install and Configure Elasticsearch
===========================================

To get Kylo installed and up and running quickly, a script is provided
to stand up a single node Elasticsearch instance. You can also leverage
an existing Elasticsearch instance. For example, if you stand up an ELK
stack you will likely want to leverage the same instance.

**Option 1**: Install Elasticsearch from our script.

.. note:: The included Elasticsearch script was meant to speed up installation in a sandbox or DEV environment.

a. Online Mode

.. code-block:: shell

        $ <SETUP_DIR>/elasticsearch/install-elasticsearch.sh <KYLO_SETUP_FOLDER> <JAVA_8_HOME>

..

b. Offline Mode

.. code-block:: shell

        $ <OFFLINE_SETUP_DIR>/elasticsearch/install-elasticsearch.sh <OFFLINE_SETUP_DIR> <JAVA_8_HOME> -o

          Example:  /tmp/kylo-install/setup/elasticsearch/install-elasticsearch.sh /tmp/kylo-install/setup /opt/java/current -o

..


**Option 2**: Use an existing Elasticsearch.
To leverage an existing Elasticsearch instance, you must update all feed templates that you created with the correct Elasticsearch URL.You can do this by going to the "Additional Properties" tab for that feed. If you added any reusable flow templates you will need to modify the Elasticsearch processors in NiFI.

.. note:: Tip: To test that Elasticsearch is running type "curl localhost:9200". You should see a JSON response.

Step 5: Install ActiveMQ
========================

Another script has been provided to stand up a single node ActiveMQ
instance. You can also leverage an existing ActiveMQ instance.

**Option 1**: Install ActiveMQ from the script

.. note:: The included ActiveMQ script was meant to speed up installation in a sandbox or DEV environment. It is not a production ready configuration.

a. Online Mode

.. code-block:: shell

        $ <SETUP_DIR>/activemq/install-activemq.sh <INSTALLATION_FOLDER> <LINUX_USER> <LINUX_GROUP> <JAVA_8_HOME>

..

b. Offline Mode

.. code-block:: shell

        $ <OFFLINE_SETUP_DIR>/activemq/install-activemq.sh <INSTALLATION_FOLDER> <LINUX_USER> <LINUX_GROUP> <JAVA_8_HOME> <OFFLINE_SETUP_DIR> -o

       Example: /tmp/kylo-install/setup/activemq/install-activemq.sh /opt/activemq activemq activemq /opt/java/current /tmp/kylo-install/setup -o

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



Step 6: Install NiFi
====================

You can leverage an existing NiFi installation or follow the steps in the setup directory that are used by the wizard.

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
           nifi.provenance.repository.implementation=com.thinkbiganalytics.nifi.provenance.repo.KyloPersistentProvenanceEventRepository
..

.. note:: If you decide to leave the port number set to the current value, you must update the "nifi.rest.port" property in the kylo-services application.properties file.

.. note:: See :doc:`../how-to-guides/NiFiKyloProvenance` for more information on provenance. 

9.  There is a controller service that requires a MySQL database connection. You will need to copy the driver jar to a location on the NiFi node. The pre-defined templates have the default location set to /opt/nifi/mysql.

           1. Create a folder to store the driver jar in.

           2. Copy the /opt/kylo/kylo-services/lib/mariadb-java-client-<version>.jar to the folder in step #1.

           3. If you created a folder name other than the /opt/nifi/mysql default folder you will need to update the "MySQL" controller service and set the new location. You can do this by logging into NiFi and going to the Controller Services section at root process group level.

10.  Create an ext-config folder to provide JMS information and location of cache to store running feed flowfile data if NiFi goes down.

.. note:: Right now the plugin is hard coded to use the /opt/nifi/ext-config directory to load the properties file.

11.  Add additional System Property to NiFi boostrap.conf for the kylo ext-config location.
           
           1. Add the next java.arg.XX in <NIFI_HOME>/conf/bootstrap.conf set to: -Dkylo.nifi.configPath=<NIFI_INSTALL>/ext-config
              
              Example: java.arg.15=-Dkylo.nifi.configPath=/opt/nifi/ext-config

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



.. |Install_Elasticsearch_Link| raw:: html

    <a href="https://www.elastic.co/support/matrix" target="_blank">Install_Elasticsearch</a>
