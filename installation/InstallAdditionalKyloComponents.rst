=============================
Install Additional Components
=============================

Now that Kylo has been installed you have a few different option to install the database scripts, ActiveMQ, Elasticsearch, Java, NiFi and Vault

.. note:: The setup wizard currently doesn't autodetect that its on a SUSE. Therefore you should skip the Elasticsearch installation step and download/install the DEB distribution manually.

Database Preparation
--------------------
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