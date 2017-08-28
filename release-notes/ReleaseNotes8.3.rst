Release 0.8.3 (Aug, 2017)
=========================

Highlights
----------

- Pluggable JMS implementation with out-of-the-box support for ActiveMQ and Amazon SQS. Refer to :doc:`../how-to-guides/JmsProviders` for details
- Pluggable REST client for :doc:`Elasticsearch <../how-to-guides/ConfigureKyloForGlobalSearch>`. This is now used by default in lieu of transport client.
- Cloudera Services Monitor as Kylo plugin. Refer to :doc:`../how-to-guides/ServiceMonitorPlugins` for details
- Business domain types for columns. Define rules to auto-apply domain types during feed creation or manually select the domain type to apply predefined standardization and validation rules.
- Column-level tagging. Apply tags to columns and search column tags using Global Search.
- Schema changes for column descriptions. The Hive schema is updated when modifying the column description of a feed. The column description is also available on the Visual Query page when hovering over a column name.
- Alerts improvement. User Interface enhancements and additional alerts capabilities.  The Alerts page has been improved and the alerts on the dashboard are now in sync with the alerts page and adhere to entity access controls
- Ability to query/filter Service Level Assessments against the Service Level Agreements
- IE & Safari browser support
- :doc:`Elasticsearch 5 <../how-to-guides/ConfigureKyloForGlobalSearch>` support
- New angular UI module plugin support.  Ability to create entirely new user interface modules and plug them into the UI navigation. Refer to |KyloModuleLink|
- Spark Jobserver processors for NiFi. Reuse a SparkContext between multiple Spark jobs for increased performance. Requires an existing |SparkJobserverLink|.
- Pluggable Spark functions. Custom Spark functions can be added to the Visual Query page by providing a json file with the function definitions. Refer to :doc:`Writing Spark Function Definitions <../developer-guides/SparkFunctionDefinitions>`.

Download Links
--------------

 - RPM :

 - Debian :

 - TAR :

Upgrade Instructions from v0.8.2
--------------------------------

1. Stop NiFi:

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

4. Copy the application.properties file from the 0.8.2 install.  If you have customized the application.properties file you will want to copy the 0.8.2 version and add the new properties that were added for this release.

     4.1 Find the /bkup-config/TIMESTAMP/kylo-services/application.properties file

        - Kylo will backup the application.properties file to the following location, */opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties*, replacing the "YYYY_MM_DD_HH_MM_millis" with a valid time:

     4.2 Copy the backup file over to the /opt/kylo/kylo-services/conf folder

        .. code-block:: shell

          ### move the application.properties shipped with the .rpm to a backup file
          mv /opt/kylo/kylo-services/conf/application.properties /opt/kylo/kylo-services/conf/application.properties.0_8_3_template
          ### copy the backup properties  (Replace the YYYY_MM_DD_HH_MM_millis  with the valid timestamp)
          cp /opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties /opt/kylo/kylo-services/conf

        ..

     4.3 Add in the new properties to the /opt/kylo/kylo-services/application.properties file

        - The following properties allow Kylo to inspect the database schema when creating database feeds

            .. code-block:: properties

              #Kylo MySQL controller service configuration
              nifi.service.kylo_mysql.database_user=root
              nifi.service.kylo_mysql.password=hadoop

            ..

        - Flow Aggregation Stats

            .. code-block:: properties

	      ##when getting aggregate stats back for flows if errors are detected kylo will query NiFi in attempt to capture matching bulletins.
              ## by default this data is stored in memory.  Setting this to true will store the data in the MySQL table
              kylo.ops.mgr.stats.nifi.bulletins.persist=false
              ## if not perisiting (above flag is false) this is the limit to the number of error bulletins per feed.
              ## this is a rolling queue that will keep the last # of errors per feed
              kylo.ops.mgr.stats.nifi.bulletins.mem.size=30

            ..

        - New NiFi version 1.1 profile

           Previous versions of Kylo were compatible with Nifi v110 when using the nifiv1.0 profile.  If you are using NiFi v1.1 in your environment then going forward you should use the nifi-1.1 profile.

           .. code-block:: properties

             spring.profiles.include=<other-profiles-as-required>,nifi-v1.1

           ..

     4.4 Ensure the property ``security.jwt.key`` in both kylo-services and kylo-ui application.properties file match.  They property below needs to match in both of these files:

        - */opt/kylo/kylo-ui/conf/application.properties*
        - */opt/kylo/kylo-services/conf/application.properties*

          .. code-block:: properties

            security.jwt.key=

          ..

5. Update the NiFi nars.  Run the following shell script to copy over the new NiFi nars/jars to get new changes to NiFi processors and services.

   .. code-block:: shell

      /opt/kylo/setup/nifi/update-nars-jars.sh <NIFI_HOME> <KYLO_SETUP_FOLDER> <NIFI_LINUX_USER> <NIFI_LINUX_GROUP>

      Example:  /opt/kylo/setup/nifi/update-nars-jars.sh /opt/nifi /opt/kylo/setup nifi users
   ..

6. Backup the Kylo database.  Run the following code against your kylo database to export the 'kylo' schema to a file.  Replace the  PASSWORD with the correct login to your kylo database.

  .. code-block:: shell

     mysqldump -u root -pPASSWORD --databases kylo > kylo-0_8_2_backup.sql

  ..

7. Database updates.  Kylo uses liquibase to perform database updates.  Two modes are supported.

 - Automatic updates

     By default Kylo is set up to automatically upgrade its database on Kylo services startup. As such,
     there isn't anything specific an end user has to do. When Kylo services startup the kylo database will be automatically upgraded to latest version if required.
     This is configured via an application.properties setting

     .. code-block:: properties

         liquibase.enabled=true
     ..

 - Manual updates

     Sometimes, however you may choose to disable liquibase and manually apply the upgrade scripts.  By disabling liquibase you are in control of how the scripts are applied.  This is needed if the kylo database user doesnt have priviledges to make schema changes to the kylo database.
     Please follow this :doc:`../how-to-guides/DatabaseUpgrades` on how to manually apply the additional database updates.

8. Update NiFi to use default ActiveMQ JMS provider. Kylo now supports two JMS providers out-of-the-box: ActiveMQ and Amazon SQS. A particular provider is selected by active Spring profile in ``/opt/nifi/ext-config/config.properties``.

   8.1. Edit ``/opt/nifi/ext-config/config.properties``

   8.2. Add following line to enable ActiveMQ ``spring.profiles.active=jms-activemq``

   Please follow this :doc:`../how-to-guides/JmsProviders` on how to switch active JMS Provider.

..

9.  If using Elasticsearch as the search engine, go through steps 9.1 to 9.5. If using Solr, go to step 10 and also refer to :doc:`Solr plugin section <../how-to-guides/ConfigureKyloForGlobalSearch>`.

    9.1. Modify Elasticsearch rest client configuration (if required) in ``/opt/kylo/kylo-services/conf/elasticsearch-rest.properties``. The defaults are provided below.

    .. code-block:: shell

      search.rest.host=localhost
      search.rest.port=9200

    ..

    9.2. Verify ``search-esr`` profile in existing list of profiles in ``/opt/kylo/kylo-services/conf/application.properties``

    .. code-block:: properties

      spring.profiles.include=<other-profiles-as-required>,search-esr

    ..

    9.3 Create Kylo Indexes

    Execute a script to create kylo indexes. If these already exist, Elasticsearch will report an ``index_already_exists_exception``. It is safe to ignore this and continue.
    Change the host and port if necessary.

    .. code-block:: shell

        /opt/kylo/bin/create-kylo-indexes-es.sh localhost 9200 1 1
    ..

    9.4 Import updated Index Text Service feed. This step will be available once Kylo services are started and Kylo is up and running.

        9.4.1. **[Elasticsearch version 2]** Import the feed ``index_text_service_elasticsearch.feed.zip`` file available at ``/opt/kylo/setup/data/feeds/nifi-1.0``

        9.4.2. **[Elasticsearch version 5] [This requires NiFi 1.3 or later]** Import the feed ``index_text_service_v2.feed.zip`` file available at ``/opt/kylo/setup/data/feeds/nifi-1.3``


    9.5. For additional details, refer to :doc:`this document <../how-to-guides/ConfigureKyloForGlobalSearch>` under Rest Client section.

..

10. If using Solr as the search engine, go through steps 10.1 to 10.5. Also refer to :doc:`Solr plugin section <../how-to-guides/ConfigureKyloForGlobalSearch>`

    10.1. Create the collection in Solr

    .. code-block:: shell

        bin/solr create -c kylo-datasources -s 1 -rf 1

    ..

    10.2. Navigate to Solr's |SolrAdminLink|

    10.3. Select the ``kylo-datasources`` collection from the drop down in the left nav area

    10.4. Click *Schema* on bottom left of nav area

    10.5. Click *Add Field* on top of right nav pane

        - name: *kylo_collection*

        - type: *string*

        - default value: *kylo-datasources*

        - index: *no*

        - store: *yes*

..

11. Start NiFi and Kylo

 .. code-block:: shell

   service nifi start

   /opt/kylo/start-kylo-apps.sh

 ..


12. Migrate Hive schema indexing to Kylo. The indexing of Hive schemas is now handled internally by Kylo instead of using a special feed.

   12.1. Remove the Register Index processor from the ``standard_ingest`` and ``data_transformation`` reusable templates

   12.2. Delete the Index Schema Service feed

.. |SolrAdminLink| raw:: html

   <a href="http://localhost:8983/solr" target="_blank">Admin UI</a>

.. |KyloModuleLink| raw:: html

   <a href="https://github.com/Teradata/kylo/tree/master/samples/plugins/example-module" target="_blank">Custom Kylo Module</a>

.. |SparkJobserverLink| raw:: html

   <a href="https://github.com/spark-jobserver/spark-jobserver" target="_blank">Spark Jobserver</a>
