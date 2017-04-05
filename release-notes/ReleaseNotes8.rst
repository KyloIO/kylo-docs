Release 0.8.0 (Mid Apr, 2017)
=============================

Highlights
----------

-  Automatic and manual database upgrades. See :doc:`../how-to-guides/DatabaseUpgrades`

-  Support for PostgreSQL as Kylo database

-  Join Hive and JDBC tables in Data Transformation feeds by creating a new Data Source.

-  Data Transformation feeds can now use standardization and validation functions, and be merged, profiled, and indexed.


Upgrade Instructions from v0.7.1
--------------------------------

Build or download the rpm.

1. Shut down NiFi:

 .. code-block:: shell

    service nifi stop

 ..

2. Uninstall Kylo:

 .. code-block:: shell

   /opt/kylo/remove-kylo.sh

 ..

3. Install the new RPM:

 .. code-block:: shell

     rpm –ivh <RPM_FILE>

 ..

4. Upgrade Kylo database:

 .. code-block:: shell

    /opt/kylo/setup/sql/mysql/kylo/0.8.0/update.sh localhost root <password or blank>

 ..

 If you opt for automatic upgrades there is nothing else you need to do, otherwise:

 Edit ``/opt/kylo/kylo-services/conf/application.properties`` and change from ``liquibase.enabled=true`` to ``liquibase.enabled=false`` and
 also make sure your database connection properties are correct:

 .. code-block:: properties

    liquibase.enabled=false

    spring.datasource.url=
    spring.datasource.username=
    spring.datasource.password=
    spring.datasource.driverClassName=

 ..

 Run ``/opt/kylo/setup/sql/generate-update-sql.sh``

 .. code-block:: shell

    /opt/kylo/setup/sql/generate-update-sql.sh

 ..

 This will generate ``kylo-db-update-script.sql`` in current directory.
 Now run ``kylo-db-update-script.sql`` on your database.

5. Add your database driver jars to kylo-spark-shell if you'll be using JDBC tables in your Data Transformation feeds. Edit ``/opt/kylo/kylo-services/bin/run-kylo-spark-shell.sh``:

.. code-block:: shell

    KYLO_DRIVER_CLASS_PATH=/opt/kylo/kylo-services/conf:/opt/nifi/mysql/*

6. If you import the new Data Transformation template, be sure to re-initialize your existing Data Transformation feeds if you update them.
