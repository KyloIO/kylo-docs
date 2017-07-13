
=============================
Setup Wizard Deployment Guide
=============================

About
=====

Follow the steps below to install Kylo using the installation wizard
script. This is convenient for local sandboxes (HDP/Cloudera) and single node
development boxes. The WGET command is used to download binaries so
internet access is required.

.. note:: The setup wizard is designed for easy installation of all components on one node.

Installation Locations
----------------------

Installing Kylo installs the following software at these Linux file
system locations:

-  Kylo Applications - /opt/kylo

-  Java 8 - /opt/java/current

-  NiFi - /opt/nifi/current

-  ActiveMQ - /opt/activemq

-  Elasticsearch - RPM installation default location

Installation
============

The steps below require root access.

Step 1: Download the RPM
------------------------

Download the RPM and place it on the host Linux machine that you want to install Kylo services on.

.. note:: To use wget instead, right-click the download link and copy the url.


**Download the Latest RPM**

.. code-block:: html

    http://bit.ly/2uT8bTo
..

Step 2: Create the Linux Users/Groups
-------------------------------------

Creation of users and groups is done manually because many organizations
have their own user and group management system. Therefore, it cannot be
scripted as part of the RPM install. Here is an example of how to create
the users and groups:

.. code-block:: shell

    $ useradd -r -m -s /bin/bash nifi
    $ useradd -r -m -s /bin/bash kylo
    $ useradd -r -m -s /bin/bash activemq


Validate that the above commands created a group by looking at
/etc/group. Some operating systems may not create them by default.

.. code-block:: shell

    $ cat /etc/group

If the groups are missing then run the following:

.. code-block:: shell

    $ groupadd kylo
    $ groupadd nifi
    $ groupadd activemq


Step 3: Run the Kylo RPM Install
--------------------------------

.. code-block:: shell

    $ rpm -ivh kylo-<version>.noarch.rpm

..

.. note:: The RPM is hard coded at this time to install to /opt/kylo.


Step 4: Optional - Generate TAR file for Offline Mode
-----------------------------------------------------

To run the wizard on an edge node with no internet access, generate a
TAR file that contains everything in the /opt/kylo/setup folder
including the downloaded application binaries.

a. Install the Kylo RPM on a node that has internet
   access.

b. Run the offline install:

.. code-block:: shell

    $ /opt/kylo/setup/generate-offline-install.sh

+------------+-------------------------------------------------------------------------------------------------------+
| **Note**   | If installing the Debian packages make sure to change the Elasticsearch download from RPM to DEB      |
+------------+-------------------------------------------------------------------------------------------------------+

..

c. Copy the /opt/kylo/setup/kylo-install.tar file to the node
   you install the RPM on. This can be copied to a temp directory. It
   doesn’t have to be put in the /opt/kylo/setup folder

d. Run the Kylo TAR install:

.. code-block:: shell

    tar -xvf kylo-install.tar

..

The script downloads all application binaries and puts them in their
respective directory in the setup folder. Last it will TAR up the setup
folder.

Step 5: Run the Setup Wizard
----------------------------


.. note:: If installing in an HDP or Cloudera sandbox, choose option #2 on the Java step to download and install Java in the /opt/java/current directory.

a. From the /opt/kylo/setup directory

.. code-block:: shell

    $ /opt/kylo/setup/setup-wizard.sh

b. Offline mode from another directory (using TAR file)

.. code-block:: shell

    $ <PathToSetupFolder>/setup/setup-wizard.sh -o


.. note:: Both -o and -O work.

..

    Follow the directions to install the following:

    -  MySQL or Postgres scripts into the local database

    -  Elasticsearch

    -  ActiveMQ

    -  Java 8 (If the system Java is 7 or below)

    -  NiFi and the Kylo dependencies

    The Elasticsearch, NiFi, and ActiveMQ services start when the wizard
    is finished.

Step 6: Add "nifi" and "kylo" Users
-----------------------------------

In this step, add “nifi” and “kylo” users to the HDFS supergroup, or
to the group defined in hdfs-site.xml. For example:

**Hortonworks**

.. code-block:: shell

    $ usermod -a -G hdfs nifi
    $ usermod -a -G hdfs kylo

**Cloudera**

.. code-block:: shell

    $ groupadd supergroup
    # Add nifi and hdfs to that group:
    $ usermod -a -G supergroup nifi
    $ usermod -a -G supergroup hdfs

**Optional:** If you want to perform actions as a root user in a development environment run the below command:

.. code-block:: shell

    $ usermod -a -G supergroup root

Step 7: Additional Cluster Configuration
----------------------------------------

In addition to adding the nifi/kylo user to the supergroup on the
edge node, add the users/groups to the name nodes on a cluster.

**Hortonworks**

.. code-block:: shell

    $ useradd kylo
    $ useradd nifi
    $ usermod -G hdfs nifi
    $ usermod -G hdfs kylo

**Cloudera**

.. code-block:: shell

    TBD (need to test this out)

Step 8: Create a Dropzone Folder
--------------------------------

For example:

.. code-block:: shell

    $ mkdir -p /var/dropzone
    $ chown nifi /var/dropzone


.. note:: Files should be copied into the dropzone such that user nifi can read and remove.


Step 9: Cloudera Configuration (Cloudera Only)
----------------------------------------------

See the appendix section below "Cloudera Configuration File Changes".

Step 10: Edit the Properties Files
----------------------------------

Step 11: Start the Three Kylo Services and NiFi
------------------------------------------------

.. code-block:: shell

    $ /opt/kylo/start-kylo-apps.sh
    $ service nifi start

At this point, all services should be running. Note that services are
started automatically on boot.

Appendix: Cloudera Configuration File Changes
=============================================

The configuration is setup to work out of the box with the Hortonworks
sandbox. There are a few differences that require configuration changes
for Cloudera.

1. /opt/kylo/kylo-services/conf/application.properties

   a. Update the 3 MySQL password values to "cloudera":

.. code-block:: properties

        spring.datasource.password=cloudera
        metadata.datasource.password=cloudera
        hive.metastore.datasource.password=cloudera
        modeshape.datasource.password=cloudera

..

    b. Update the Hive username:

.. code-block:: properties

        hive.datasource.username=hive

..

    c. Update the Hive Metastore URL:

.. code-block:: properties

        hive.metastore.datasource.url=jdbc:mysql://localhost:3306/metastore

..

    d. Update the following parameters:

.. code-block:: properties

        config.hive.schema=metastore
        nifi.executesparkjob.sparkhome=/usr/lib/spark

..
