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

4. Update the NiFi nars.  Run the following shell script to copy over the new NiFi nars/jars to get new changes to NiFi processors and services.

   .. code-block:: shell

      /opt/kylo/setup/nifi/update-nars-jars.sh <NIFI_HOME> <KYLO_SETUP_FOLDER> <NIFI_LINUX_USER> <NIFI_LINUX_GROUP>

      Example:  /opt/kylo/setup/nifi/update-nars-jars.sh /opt/nifi /opt/kylo/setup nifi users
   ..

5. Backup the Kylo database.  Run the following code against your kylo database to export the 'kylo' schema to a file.  Replace the  PASSWORD with the correct login to your kylo database.

  .. code-block:: shell

     mysqldump -u root -pPASSWORD --databases kylo > kylo-0_8_2_backup.sql

  ..

6. Database updates.  Kylo uses liquibase to perform database updates.  Two modes are supported.

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

7. Update NiFi to use default ActiveMQ JMS provider. Kylo now supports two JMS providers out-of-the-box: ActiveMQ and Amazon SQS. A particular provider is selected by active Spring profile in ``/opt/nifi/ext-config/config.properties``.

   7.1. Edit ``/opt/nifi/ext-config/config.properties``

   7.2. Add following line to enable ActiveMQ ``spring.profiles.active=jms-activemq``

   Please follow this :doc:`../how-to-guides/JmsProviders` on how to switch active JMS Provider.

..

8.  If using Elasticsearch as the search engine, go through steps 8.1 to 8.3. If using Solr, go to step 9 and also refer to :doc:`Solr plugin section <../how-to-guides/ConfigureKyloForGlobalSearch>`.

    8.1. Modify Elasticsearch rest client configuration (if required) in ``/opt/kylo/kylo-services/conf/elasticsearch-rest.properties``

    8.2. Verify ``search-esr`` profile in existing list of profiles in ``/opt/kylo/kylo-services/conf/application.properties``

    .. code-block:: shell

      spring.profiles.include=<other-profiles-as-required>,search-esr

    ..

    8.3. If using Elasticsearch 5, perform the steps as laid out in :doc:`this document <../how-to-guides/ConfigureKyloForGlobalSearch>` under Rest Client section.

..

9. If using Solr as the search engine, go through steps 9.1 to 9.5. Also refer to :doc:`Solr plugin section <../how-to-guides/ConfigureKyloForGlobalSearch>`

    9.1. Create the collection in Solr

    .. code-block:: shell

        bin/solr create -c kylo-datasources -s 1 -rf 1

    ..

    9.2. Navigate to Solr's |SolrAdminLink|

    9.3. Select the ``kylo-datasources`` collection from the drop down in the left nav area

    9.4. Click *Schema* on bottom left of nav area

    9.5. Click *Add Field* on top of right nav pane

        - name: *kylo_collection*

        - type: *string*

        - default value: *kylo-datasources*

        - index: *no*

        - store: *yes*


..

10. Start NiFi:

 .. code-block:: shell

   service nifi start

 ..


11. Migrate Hive schema indexing to Kylo. The indexing of Hive schemas is now handled internally by Kylo instead of using a special feed.

   11.1. Remove the Register Index processor from the ``standard_ingest`` and ``data_transformation`` reusable templates

   11.2. Delete the Index Schema Service feed


.. |SolrAdminLink| raw:: html

   <a href="http://localhost:8983/solr" target="_blank">Admin UI</a>

.. |KyloModuleLink| raw:: html

   <a href="https://github.com/Teradata/kylo/tree/master/samples/plugins/example-module" target="_blank">Custom Kylo Module</a>

.. |SparkJobserverLink| raw:: html

   <a href="https://github.com/spark-jobserver/spark-jobserver" target="_blank">Spark Jobserver</a>
