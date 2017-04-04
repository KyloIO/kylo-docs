Release 0.8.0 (Mid Apr, 2017)
=============================

Highlights
----------

-  Automatic and manual database upgrades. See :doc:`../how-to-guides/DatabaseUpgrades`

-  Support for PostgreSQL as Kylo database


Upgrade Instructions from v0.7.1
--------------------------------

Build or download the rpm.

1. Shut down NiFi:

 .. code-block:: shell

    service nifi stop

 ..

2. Run:

 .. code-block:: shell

    useradd -r -m -s /bin/bash kylo

 ..

3. Run:

 .. code-block:: shell

    usermod -a -G hdfs kylo

 ..

4. Run:

 .. code-block:: shell

   /opt/thinkbig/remove-kylo-datalake-accelerator.sh to uninstall
   the RPM

 ..

5. Install the new RPM:

 .. code-block:: shell

     rpm –ivh <RPM_FILE>

 ..

6. Upgrade "kylo" database.

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

