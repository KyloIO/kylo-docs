Release 0.8.0 (Apr 19, 2017)
============================

Highlights
----------

- 90+ issues resolved

- Automatic and manual database upgrades. See :doc:`../how-to-guides/DatabaseUpgrades`

- Support for PostgreSQL as Kylo metadata store

- Join Hive and any JDBC tables in Data Transformation feeds by creating a new Data Source. (Spark 1.x only)

- Wrangler can now use standardization and validation functions, and be merged, profiled, and indexed.

- The Feed/Template import provides visual feedback and progress

- Kylo will now encrypt 'sensitive' properties and enforce 'required' properties.


Upgrade Instructions from v0.7.1
--------------------------------

Build or `download the RPM <http://bit.ly/2oVaQJE>`__

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

4. Copy the application.properties file from the 0.7.1 install.  If you have customized the application.properties file you will want to copy the 0.7.1 version and add the new properties that were added for this release.

     4.1 Find the /bkup-config/TIMESTAMP/kylo-services/application.properties file

        - Kylo will backup the application.properties file to the following location, */opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties*, replacing the "YYYY_MM_DD_HH_MM_millis" with a valid time:

     4.2 Copy the backup file over to the /opt/kylo/kylo-services/conf folder

        .. code-block:: shell

          ### move the application.properties shipped with the .rpm to a backup file
          mv /opt/kylo/kylo-services/application.properties application.properties.0_8_0_template
          ### copy the backup properties  (Replace the YYYY_MM_DD_HH_MM_millis  with the valid timestamp)
          cp /opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties /opt/kylo/kylo-services/conf

        ..

     4.3  Add in the 2 new properties to the /opt/kylo/kylo-services/conf/application.properties file

        .. code-block:: properties

         liquibase.enabled=true
         liquibase.change-log=classpath:com/thinkbiganalytics/db/master.xml

        ..

     4.4 Ensure the property ``security.jwt.key`` in both kylo-services and kylo-ui application.properties file match.  They property below needs to match in both of these files:

         - */opt/kylo/kylo-ui/conf/application.properties*
         - */opt/kylo/kylo-services/conf/application.properties*.

       .. code-block:: properties

         security.jwt.key=

       ..

     4.5 If using Spark 2 then add the following property to the /opt/kylo/kylo-services/conf/application.properties file

        .. code-block:: properties

          config.spark.version=2

        ..

5. Backup the Kylo database.  Run the following code against your kylp database to export the 'kylo' schema to a file.  Replace the  PASSWORD with the correct login to your kylo database.

  .. code-block:: shell

     mysqldump -u root -pPASSWORD --databases kylo >kylo-0_7_1_backup.sql

  ..

6. Upgrade Kylo database:


 .. code-block:: shell

    /opt/kylo/setup/sql/mysql/kylo/0.8.0/update.sh localhost root <password or blank>

 ..

7. Additional Database updates.  Kylo now uses liquibase to perform database updates.  Two modes are supported.

 - Automatic updates

     By default Kylo is set up to automatically upgrade its database on Kylo services startup. As such,
     there isn't anything specific an end user has to do. When Kylo services startup the kylo database will be automatically upgraded to latest version if required.

 - Manual updates

     Sometimes, however you may choose to disable liquibase and manually apply the upgrade scripts.  By disabling liquibase you are in control of how the scripts are applied.  This is needed if the kylo database user doesnt have priviledges to make schema changes to the kylo database.
     Please follow this :doc:`../how-to-guides/DatabaseUpgrades` on how to manually apply the additional database updates.

8. Update the NiFi nars.  Run the following shell script to copy over the new NiFi nars/jars to get new changes to NiFi processors and services.

   .. code-block:: shell

      /opt/kylo/setup/nifi/update-nars-jars.sh
   ..

9. Update the NiFi Templates.

 - The Data Transformation template now allows you to apply standardization and validation rules to the feed.  To take advantage of this you will need to import the new template.  The new data transformation template can be found:

  If you import the new Data Transformation template, be sure to re-initialize your existing Data Transformation feeds if you update them.


Data Transformation Enhancement Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

New to this release is the ability for the data wrangler to connect to various JDBC data sources, allowing you to join Hive tables with, for example, MySQL or Teradata. The JDBC drivers are automatically read from /opt/nifi/mysql/ when Kylo is starting up. When Kylo Spark Shell is run in yarn-client mode then these jars need to be added manually to the run-kylo-spark-shell.sh script:

 -  Edit ``/opt/kylo/kylo-services/bin/run-kylo-spark-shell.sh`` and append --jars to the ``spark-submit`` command-line:

    .. code-block:: shell

        spark-submit --jars /opt/nifi/mysql/mariadb-java-client-1.5.7.jar ...

    ..

    Additional driver locations can be added separating each location with a comma

    .. code-block:: shell

        spark-submit --jars /opt/nifi/mysql/mariadb-java-client-1.5.7.jar,/opt/nifi/teradata/terajdbc4.jar ...

    ..


Ambari Service Monitor Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Ambari Service Monitor is now a Kylo plugin jar.  In order for Kylo to report status on Ambari services you will need to do the following:

1. Modify/Ensure the connection properties are setup.  The ambari connection parameters need to be moved out of the main kylo-services application.properties to a new file called ``ambari.properties``

   - Create a new file ``/opt/kylo/kylo-services/conf/ambari.properties``.  Ensure the owner of the file is *kylo*
   - Add and configure the following properties in that file:

        .. code-block:: properties

            ambariRestClientConfig.host=127.0.0.1
            ambariRestClientConfig.port=8080
            ambariRestClientConfig.username=admin
            ambariRestClientConfig.password=admin
            ambari.services.status=HDFS,HIVE,MAPREDUCE2,SQOOP

        ..

2. Copy the ``/opt/kylo/setup/plugins/kylo-service-monitor-ambari-0.8.0.jar`` to ``/opt/kylo/kylo-services/plugin``

   .. code-block:: shell

    cp /opt/kylo/setup/plugins/kylo-service-monitor-ambari-0.8.0.jar /opt/kylo/kylo-services/plugin/

   ..

