
=====================
Deployment Guide
=====================

About
=====

This document provides procedures for installing the Kylo framework, as well as Elasticsearch, NiFi, and ActiveMQ.
Installation options allow new users to choose the method best suited to their interests and installation environments:

  - **Setup Wizard** - For local development and single node development boxes, the :doc:`../installation/KyloSetupWizardDeploymentGuide` can be used to quickly bootstrap your environment to get you up and running.
  - **Manual** - In a test and production environment, you will likely be installing on multiple nodes. The :doc:`../installation/KyloManualDeploymentGuide` provides detailed instructions on how to install each individual component.

For advanced users, there are additional installation options:

  - **Cloudera EC2 Docker Sandbox** – The :doc:`../installation/ClouderaDockerSandboxDeploymentGuide` details options for those who want to deploy Kylo to a single node Cloudera sandbox in AWS. This is useful when you need to get a quick Cloudera instance running to test Kylo but don’t have the resources to install a Cloudera cluster.
  - **TAR File** – The previous install options are Red-Hat Package Manager (RPM) installations, but TAR File installation is available for those who want to install Kylo in a folder other than /opt/kylo, or want to run Kylo as a different user. See the :doc:`../installation/KyloTARFileInstallation`.
  - **HDP 2.5 Cluster Ranger/Kerberos with 2 Edge Nodes** - Kylo may also be installed, with minimal admin privileges, on an HDP 2.5 cluster. A procedure is provided for configuring an installation with NiFi on a separate edge node. See the :doc:`../installation/HDP25ClusterDeploymentGuide`.

Whichever installation option you choose, refer to the System Requirements and Prerequisites sections of this Kylo Deployment Guide to verify that your system is prepared for a Kylo Installation.

System Requirements
===================

**Dependencies**

Kylo services should be installed on an edge node.
The following should be available prior to the installation.

See the Dependencies section in the deployment checklist: :doc:`KyloDependencies`

+-----------------------+-------------------------------------------------------------+----------------+
| **Platform**          | **URL**                                                     | **Version**    |
+-----------------------+-------------------------------------------------------------+----------------+
| Hortonworks Sandbox   | http://hortonworks.com/products/hortonworks-sandbox/        | HDP 2.3,2.4,2.5|
+-----------------------+-------------------------------------------------------------+----------------+
| Cloudera Sandobx      | http://www.cloudera.com/downloads/quickstart_vms/5-7.html   | 5.7            |
+-----------------------+-------------------------------------------------------------+----------------+

Prerequisites
=============

Hortonworks Sandbox
-------------------

If installing in a new Hortonworks sandbox make sure to do the following
first before running through the installation steps below.

:doc:`HortonworksSandboxConfiguration`

Java Requirements
-----------------

Kylo requires Java 8 for NiFi, kylo-ui, and
kylo-services. If you already have Java 8 installed as the system
level Java you have the option to leverage that.

In some cases, such as with an HDP install, Java 7 is the system version
and you likely will not want to change it to Java 8. In this case you
can leverage the mentioned scripts below to download and configure Java
8 in the /opt/java directory. The scripts will also modify the startup
scripts for NiFi, kylo-ui and kylo-services to reference the
/opt/java JAVA_HOME.

If you already have Java 8 installed in a different location you will
have the option to use that as well.

+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Note**   | When installing the RPM the applications are defaulted to use the /opt/java/current location. This default saves a step for developers so that they can uninstall and re-install the RPM without having to run any other scripts.   |
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Linux Users
-----------

If you will be creating Linux users as part of the install the commands
will be documented. If using an external user management system for
adding users to a linux box you must have those users created before
installing the Kylo stack. You will need a user/group including:

-  activemq

-  elasticsearch

-  kylo

-  nifi

+------------+--------------------------------------------------------+
| **Note**   | Those exact names are required (note the lowercase).   |
+------------+--------------------------------------------------------+

Configuration
=============

Configuration for Kylo services are located under the following files:

.. code-block:: shell

  /opt/kylo/kylo-ui/conf/application.properties
  /opt/kylo/kylo-services/conf/application.properties

..

Ranger / Sentry
---------------

If you’ve changed the default Ranger or Sentry permissions then you will
need to add permissions for Kylo and NiFi.

:doc:`../security/EnableRangerAuthorizationGuide`

:doc:`../security/EnableSentryAuthorizationGuide`

Kerberos
--------

If you are installing Kylo on a kerberos cluster you will need to
configure the applications before certain features will work

Optional: Configure Kerberos For Your Local HDP Sandbox
-------------------------------------------------------

This guide will help you enabled kerberos for your local development
sandbox for development and testing:

:doc:`KerberosInstallationExample-Cloudera`

Step 1: Configure Kerberos for NiFi
-----------------------------------

Some additional configuration is required for allowing the NiFi
components to work with a Kerberos cluster.

:doc:`NiFiConfigurationforaKerberosCluster`

Step 2: Configure Kerberos for Kylo Applications
------------------------------------------------

Additional configuration is required for allowing some features in the
Kylo applications to work with a Kerberos cluster.

:doc:`KylosConfigurationforaKerborosCluster`

SUSE Configuration
------------------

If you are installing Kylo on SUSE please read the following document to work around ActiveMQ and Elasticsearch issues.

:doc:`../how-to-guides/SuseConfigurationChanges`

Encrypting Configuration Property Values
----------------------------------------

By default, a new Kylo installation does not have any of its
configuration properties encrypted. Once you have started Kylo for the
first time, the easiest way to derive encrypted versions of property
values is to post values to the Kylo services /encrypt endpoint to have
it generate an encrypted form for you. You could then paste the
encrypted value back into your properties file and mark it as encrypted
by prepending the values with {cipher}. For instance, if you wanted to
encrypt the Hive datasource password specified in
applicaition.properties (assuming the password is “mypassword”), you can
get it’s encrypted form using the curl command like this:

.. code-block:: shell

    $ curl localhost:8420/encrypt –d mypassword
    29fcf1534a84700c68f5c79520ecf8911379c8b5ef4427a696d845cc809b4af0

..

You would then copy that value and replace the clear text password
string in the properties file with the encrypted value:

.. code-block:: shell

    hive.datasource.password={cipher}29fcf1534a84700c68f5c79520ecf8911379c8b5ef4427a696d845cc809b4af0

..

The benefit of this approach is that you will be getting a value that is
guaranteed to work with the encryption settings of the server where that
configuration value is being used. Once you have replaced all properties
you wish encrypted in the properties files you can restart the Kylo the
services to use them.

Optimizing Performance
======================

You can adjust the memory setting for each services using the below
environment variables:

.. code-block:: shell

    /opt/kylo/kylo-ui/bin/run-kylo-ui.sh
    export KYLO_UI_OPTS= -Xmx4g

    /opt/kylo/kylo-services/bin/run-kylo-services.sh
    export KYLO_SERVICES_OPTS= -Xmx4g

..

The setting above would set the Java maximum heap size to 4 GB.

Change the Java Home
--------------------

By default the kylo-services and kylo-ui application set the
JAVA_HOME location to /opt/java/current. This can easily be changed by
editing the JAVA_HOME environment variable in the following two files:

.. code-block:: shell

    /opt/kylo/kylo-ui/bin/run-kylo-ui.sh
    /opt/kylo/kylo-services/bin/run-kylo-services.sh

..

In addition, if you run the script to modify the NiFI JAVA_HOME
variable you will need to edit:

.. code-block:: shell

    /opt/nifi/current/bin/nifi.sh

..

S3 Support For Data Transformations
-----------------------------------

Spark requires additional configuration in order to read Hive tables
located in S3. Please see the :doc:`../how-to-guides/AccessingS3fromtheDataWrangler` how-to article.

Starting and Stopping the Services Manually
===========================================

If you follow the instructions for the installations steps above all of
the below applications will be set to startup automatically if you
restart the server. In the Hortonworks sandbox the services for Kylo
and NiFI are set to start after all of the services managed by Ambari
start up.

For starting and stopping the 3 Kylo services there you
can run the following scripts.

.. code-block:: shell

    /opt/kylo/start-kylo-apps.sh
    /opt/kylo/stop-kylo-apps.sh

..

1. To Start Individual Services:

.. code-block:: shell

  $ service activemq start
  $ service elasticsearch start
  $ service nifi start
  $ service kylo-spark-shell start
  $ service kylo-services start
  $ service kylo-ui start  

..

2.  To Stop individual services:

.. code-block:: shell

  $ service activemq stop
  $ service elasticsearch stop
  $ service nifi stop
  $ service kylo-spark-shell stop
  $ service kylo-services stop
  $ service kylo-ui stop  

..

3. To get the status of individual services $ service activemq status:

.. code-block:: shell

  $ service elasticsearch status
  $ service nifi status
  $ service kylo-spark-shell status
  $ service kylo-services status
  $ service kylo-ui status  

..

Log Output
==========

Configuring Log Output
----------------------

Log output for the services mentioned above are configured at:

.. code-block:: shell

    /opt/kylo/kylo-ui/conf/log4j.properties
    /opt/kylo/kylo-services/conf/log4j.properties

..

You may place logs where desired according to the
'log4j.appender.file.File' property. Note the configuration line:

.. code-block:: shell

    log4j.appender.file.File=/var/log/<app>/<app>.log

..

Viewing Log Output
------------------

The default log locations for the various applications are located at:

.. code-block:: shell

    /var/log/<service_name>

..

Web and REST Access
===================

Below are the default URL’s and ports for the services:

.. code-block:: shell

    Feed Manager and Operations UI
    http://127.0.0.1:8400
    username: dladmin
    password: thinkbig

    NiFi UI
    http://127.0.0.1:8079/nifi

    Elasticsearch REST API
    http://127.0.0.1:9200

    ActiveMQ Admin
    http://127.0.0.1:8161/admin

..

Appendix: Cleanup scripts
=========================

For development and sandbox environments you can leverage the cleanup
script to remove all of the Kylo services as well as Elasticsearch,
ActiveMQ, and NiFi.

.. code-block:: shell

    $ /opt/kylo/setup/dev/cleanup-env.sh

..

+---------------+-------------------------------------------------------------------------------------------+
|**IMPORTANT!** | Only run this in a DEV environment. This will delete all application and the MySQL schema.|
+---------------+-------------------------------------------------------------------------------------------+


In addition there is a script for cleaning up the hive schema and HDFS
folders that are related to a specific "category" that is defined in the
UI.

.. code-block:: shell

    $ /opt/kylo/setup/dev/cleanupCategory.sh [categoryName]

    Example: /opt/kylo/setup/dev/cleanupCategory.sh customers

..

Appendix: Postgres Integration
==============================

:doc:`Postgres Hive Metadata Configuration <Postgres_Hive_Metadata_Configuration>`
