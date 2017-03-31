=================
Database Upgrades
=================

Overview
========

This guide provides details on how to update your database with each new Kylo version.
Kylo supports two ways to upgrade your database:

    1. Automatic upgrades
    2. Manual upgrades


1. Automatic Upgrades
---------------------

By default Kylo is set up to automatically upgrade its database on Kylo services startup. As such,
there isn't anything specific an end user has to do. Just start Kylo services as normal and
your database will be automatically upgraded to latest version if required.


2. Manual Upgrades
------------------

By default Kylo is set up to automatically upgrade its database. To manually upgrades your database:

    1. Turn off automatic database upgrades
    2. Generate update SQL script
    3. Run generated SQL manually on your database

2.1 Turn off automatic database upgrades
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Set ``liquibase.enabled`` to ``false`` in ``/opt/kylo/kylo-services/conf/application.properties`` if you don't
want to automatically upgrade Kylo database. Also make sure your database connection properties are correct:

.. code-block:: properties

    liquibase.enabled=false

    spring.datasource.url=
    spring.datasource.username=
    spring.datasource.password=
    spring.datasource.driverClassName=

..


2.2 Generate upgrade SQL script
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Make sure that required database driver is on classpath in ``/opt/kylo/kylo-services/lib`` directory and
run ``/opt/kylo/setup/sql/generate-update-script.sh``.

.. code-block:: shell

    /opt/kylo/setup/sql/generate-update-script.sh

..

This will generate database update SQL in your current directory called ``kylo-db-update-script.sql``.
This SQL script will contain all required SQL statements to update your database to next Kylo version.


2.3 Run generated SQL manually on your database
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The process of executing ``kylo-db-update-script.sql`` SQL script will differ for each database vendor.
Please consult documentation for your database on how to execute an SQL script.