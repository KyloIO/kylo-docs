================
Cleanup Scripts
================

For development and sandbox environments you can leverage the cleanup
script to remove all of the Kylo services as well as Elasticsearch,
ActiveMQ, and NiFi.

.. code-block:: shell

    $ /opt/kylo/setup/dev/cleanup-env.sh

..


.. important:: Only run this in a DEV environment. This will delete all application and the MySQL schema.

..

In addition there is a script for cleaning up the Hive schema and HDFS
folders that are related to a specific "category" that is defined in the
UI.

.. code-block:: shell

    $ /opt/kylo/setup/dev/cleanupCategory.sh [categoryName]

    Example: /opt/kylo/setup/dev/cleanupCategory.sh customers

..