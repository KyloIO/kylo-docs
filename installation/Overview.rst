========
Overview
========
The best way to get started with Kylo is to keep it simple at first. Get Kylo up and running with a single node and test a simple feed
before enabling features such as clustering, SSL, encryption,etc. This installation section will help you get Kylo up and running, then
give you some guidance on where to go from there.

Installation Methods
====================
Kylo has 3 build distributions:

  - **RPM** - An easy and opinionated way of installing Kylo on Redhat based systems
  - **DEB** - An easy and opinionated way of installing Kylo on Debian based systems
  - **TAR File** – Available for those who want to install Kylo in a folder other than /opt/kylo, or want to run Kylo as a different user.

Once the binary is installed Kylo can be configured a few different ways:

  - **Setup Wizard** - For local development and single node development boxes, the :doc:`../installation/SetupWizardDeploymentGuide` can be used to quickly bootstrap your environment to get you up and running.
  - **Manually Run Shell Scripts** - In a test and production environment, you will likely be installing on multiple nodes. The :doc:`../installation/ManualDeploymentGuide` provides detailed instructions on how to install each individual component.
  - **Configuration Management Tools** – Kylo installation is designed to be automated. You can leverage tools such as Ansible, Chef, Puppet, and Salt Stack

Installation Components
=======================

Installing Kylo inlcudes the following software:

-  **Kylo Applications**: Kylo provides services to produce Hive tables, generate a schema based on data brought into Hadoop, perform Spark-based transformations, track metadata, monitor feeds and SLA policies, and publish to target systems.

-  **Java 8**: Kylo uses the Java 8 development platform.

-  **NiFi**: Kylo uses Apache NiFi for orchestrating data pipelines.

-  **ActiveMQ**: Kylo uses Apache ActiveMQ to manage communications with clients and servers.

-  **Elasticsearch/SOLR**: Kylo can use either Elasticsearch or SOLR, as a distributed, multi-tenant capable full-text search engine.

Default Installation Locations
==============================

Installing Kylo installs the following software at these Linux file
system locations:

-  Kylo Applications - /opt/kylo

-  Java 8 - /opt/java/current

-  NiFi - /opt/nifi/current

-  ActiveMQ - /opt/activemq

-  Elasticsearch - RPM installation default location

Demo Sandbox
============
If you are interested in running a working example of Kylo you might consider running one of our demo sandboxes located on the http://kylo.io/quickstart.html website
