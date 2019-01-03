
=============================
Setup Wizard Deployment Guide
=============================

Note that you will need a database user with schema create privileges if allowing the setup wizard to create the database. If you prefer to create the "kylo" database yourself and/or create a "kylo" user please refer to :doc:`../installation/CreateKyloDatabaseUser` first


Step 1: Run the Setup Wizard
----------------------------


.. warning:: If Java 8 is not the system Java choose option #2 on the Java step to download and install Java in the /opt/java/current directory.

a. From the /opt/kylo/setup directory

.. code-block:: shell

    $ /opt/kylo/setup/setup-wizard.sh

b. Offline mode from another directory (using offline setup TAR file)

.. code-block:: shell

    $ <PathToSetupFolder>/setup/setup-wizard.sh -o

..

.. note:: Both -o and -O work.

Follow the directions to install the following:

-  MySQL or Postgres scripts into the local database

-  Elasticsearch

-  ActiveMQ

-  Java 8 (If the system Java is 7 or below)

-  NiFi and the Kylo dependencies

The Elasticsearch and ActiveMQ services start when the wizard is finished.
