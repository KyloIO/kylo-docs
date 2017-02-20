
======================================
Setup A NiFi Cluster in a Kylo Sandbox
======================================

Purpose
=======

This document is intended for advanced NiFi users who wish to run a NiFi cluster in their Kylo sandbox. The NiFi cluster is intended for testing of failover scenarios only.

Prerequisite
============

You will need to have set up a Kylo sandbox according to the :doc:`../installation/KyloSetupWizardDeploymentGuide.html>`__.

Install a Second NiFi Node
==========================

Each new node in a NiFi cluster should be a fresh install to ensure that the new node starts with an empty repository. You will then configure the new node and enable NiFi clustering.

1.	Rename the existing NiFi directory to make room for the new install:

.. code-block:: shell

    service nifi stop
    mv /opt/nifi /opt/nifi-temp

..

2.	Reinstall NiFi using the Kylo install wizard:

.. code-block:: shell

    /opt/kylo/setup/nifi/install-nifi.sh
    /opt/kylo/setup/java/change-nifi-java-home.sh /opt/java/current
    /opt/kylo/setup/nifi/install-kylo-components.sh

..

3.	Rename the new NiFi directory and restore the old NiFi directory:

.. code-block:: shell

    service nifi stop
    mv /opt/nifi /opt/nifi-2
    mv /opt/nifi-temp /opt/nifi

..

4.	Create a new init.d script for nifi-2 by changing the NiFi path:

.. code-block:: shell

    sed 's#/opt/nifi#/opt/nifi-2#' /etc/init.d/nifi > /etc/init.d/nifi-2
    chmod 744 /etc/init.d/nifi-2

..

5.	Create a log directory for nifi-2:

.. code-block:: shell

    mkdir /var/log/nifi-2
    chown nifi:nifi /var/log/nifi-2
    sed -i 's#NIFI_LOG_DIR=".*"#NIFI_LOG_DIR="/var/log/nifi-2"#' /opt/nifi-2/current/bin/nifi-env.sh

..

6.	Edit /opt/nifi-2/current/conf/nifi.properties and replace all references to /opt/nifi with /opt/nifi-2:

.. code-block:: shell

    sed -i 's#/opt/nifi#/opt/nifi-2#' /opt/nifi-2/current/conf/nifi.properties

..

Enable NiFi Clustering
======================

Each node in the NiFi cluster will need to be configured to connect to the cluster.

1.	Edit the /opt/nifi/current/conf/nifi.properties file:

.. code-block:: shell

    nifi.cluster.is.node=true
    nifi.cluster.node.address=localhost
    nifi.cluster.node.protocol.port=8078
    nifi.zookeeper.connect.string=localhost:2181

..

2.	Edit the /opt/nifi-2/current/conf/nifi.properties file:

.. code-block:: shell

    nifi.web.http.port=8077
    nifi.cluster.is.node=true
    nifi.cluster.node.address=localhost
    nifi.cluster.node.protocol.port=8076
    nifi.zookeeper.connect.string=localhost:2181

..

Start Each Node
===============

Now that your cluster is created and configured, start the services:

.. code-block:: shell

    service nifi start
    service nifi-2 start

..

Don’t forget to open up the nifi.web.http.port property's port number in your VM.

You should be able to open the NiFi UI under either http://localhost:8079 or http://localhost:8077 and see in the upper left a cluster icon and 2/2.
