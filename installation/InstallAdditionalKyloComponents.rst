=============================
Install Additional Components
=============================

Now that Kylo has been installed you have a few different option to install the database scripts, ActiveMQ, Elasticsearch, Java and NiFi

.. note:: The setup wizard currently doesn't autodetect that its on a SUSE. Therefore you should skip the Elasticsearch installation step and download/install the DEB distribution manually.

Database Preparation
--------------------

Kylo supports MySQL, PostgreSQL, and MS SQL Server for storing Kylo metadata. The default configuration is for Kylo to create the necessary tables automatically but the database must be created manually.

**MySQL**

.. code-block:: shell

    mysql -h ${hostname} -u "${username}" -p -e "create database if not exists kylo character set utf8 collate utf8_general_ci;"

**PostgreSQL**

.. code-block:: shell

    PGPASSWORD="${password}" createdb -U kylo -h ${hostname} -E UTF8 -e kylo

**MS SQL Server**

.. code-block:: shell

    sqlcmd -S ${hostname} -U "${username}" -P "${password}" -Q "CREATE DATABASE kylo ${azure_options}"

If you would like to run Kylo as a non-privileged user you should create a kylo database user and configure the appropriate permissions.

.. toctree::
    :maxdepth: 1

    CreateKyloDatabaseUser

If you plan to generate and run the SQL scripts manually (turn off liquibase), please see the "Manual Upgrades" section in :doc:`../how-to-guides/DatabaseUpgrades`

Option 1: Setup Wizard Installation
-----------------------------------
This is the easiest method and will allow you to choose which components to install on that node.

.. toctree::
    :maxdepth: 1

    SetupWizardDeploymentGuide

Option 2: Manual Installation
-----------------------------
This option shows you how to run the scripts manually and will allow you to make customizations as you go.

.. toctree::
    :maxdepth: 1

    ManualDeploymentGuide
