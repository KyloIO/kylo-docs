Release 0.8.3 (Aug, 2017)
=========================

Highlights
----------

- Pluggable JMS implementation with out-of-the-box support for ActiveMQ and Amazon SQS. Refer to :doc:`../how-to-guides/JmsProviders` for details
- Pluggable REST client for :doc:`Elasticsearch <../how-to-guides/ConfigureKyloForGlobalSearch>`. This is now used by default in lieu of transport client.
- Cloudera Services Monitor as Kylo plugin. Refer to :doc:`../how-to-guides/ServiceMonitorPlugins` for details
- Define business domain types to columns and auto apply them to fields.
- Ability to assign a business domain type to a field (separate from the actual data types. (i.e. detect and mark fields that are of credit card’s and auto apply the masking standardizer)
- Columns can now be tagged.
- Ability to modify column descriptions and see them in the data wrangler
- Alerts improvement. User Interface enhancements and additional alerts capabilities.  The Alerts page has been improved and the alerts on the dashboard are now in sync with the alerts page and adhere to entity access controls
- Ability to query/filter Service Level Assessments against the Service Level Agreements
- IE & Safari browser support
- :doc:`Elasticsearch 5 <../how-to-guides/ConfigureKyloForGlobalSearch>` support
- New angular UI module plugin support.  Ability to create entirely new user interface modules and plug them into the UI navigation. Refer to |KyloModuleLink|

Download Links
--------------

 - RPM :

 - Debian :

 - TAR :

Upgrade Instructions from v0.8.2
--------------------------------

1. Uninstall Kylo:

 .. code-block:: shell

   /opt/kylo/remove-kylo.sh

 ..

2. Install the new RPM:

 .. code-block:: shell

     rpm –ivh <RPM_FILE>

 ..

3. Update the NiFi nars.  Run the following shell script to copy over the new NiFi nars/jars to get new changes to NiFi processors and services.

   .. code-block:: shell

      /opt/kylo/setup/nifi/update-nars-jars.sh <NIFI_HOME> <KYLO_SETUP_FOLDER> <NIFI_LINUX_USER> <NIFI_LINUX_GROUP>

      Example:  /opt/kylo/setup/nifi/update-nars-jars.sh /opt/nifi /opt/kylo/setup nifi users
   ..

4. Backup the Kylo database.  Run the following code against your kylo database to export the 'kylo' schema to a file.  Replace the  PASSWORD with the correct login to your kylo database.

  .. code-block:: shell

     mysqldump -u root -pPASSWORD --databases kylo >kylo-0_8_2_backup.sql

  ..

5. Database updates.  Kylo uses liquibase to perform database updates.  Two modes are supported.

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

6. Update NiFi to use default ActiveMQ JMS provider. Kylo now supports two JMS providers out-of-the-box: ActiveMQ and Amazon SQS. A particular provider is selected by active Spring profile in ``/opt/nifi/ext-config/config.properties``.

   6.1. Edit ``/opt/nifi/ext-config/config.properties``

   6.2. Add following line to enable ActiveMQ ``spring.profiles.active=jms-activemq``

   Please follow this :doc:`../how-to-guides/JmsProviders` on how to switch active JMS Provider.

..

7. Modify Elasticsearch rest client configuration (if required) in ``/opt/kylo/kylo-services/conf/elasticsearch-rest.properties``

    7.1 Verify ``search-esr`` profile in existing list of profiles in ``/opt/kylo/kylo-services/conf/application.properties``

    .. code-block:: shell

      spring.profiles.include=<other-profiles-as-required>,search-esr

    ..

    7.2 If using Elasticsearch 5, perform the steps as laid out in :doc:`this document <../how-to-guides/ConfigureKyloForGlobalSearch>` under Rest Client section.

8. Migrate Hive schema indexing to Kylo. The indexing of Hive schemas is now handled internally by Kylo instead of using a special feed.

   8.1. Remove the Register Index processor from the ``standard_ingest`` and ``data_transformation`` reusable templates

   8.2. Delete the Index Schema Service feed

   8.3. The following steps must be completed for Solr:

        8.3.1. Create the collection in Solr

              .. code-block:: shell

                 bin/solr create -c kylo-datasources -s 1 -rf 1

        8.3.2. Navigate to Solr's |SolrAdminLink|

        8.3.3. Select the ``kylo-datasources`` collection from the drop down in the left nav area

    	8.3.2. Click *Schema* on bottom left of nav area

    	8.3.3. Click *Add Field* on top of right nav pane

    	        - name: *kylo_collection*

    	        - type: *string*

                - default value: *kylo-datasources*

                - index: *no*

                - store: *yes*

.. |SolrAdminLink| raw:: html

   <a href="http://localhost:8983/solr" target="_blank">Admin UI</a>

.. |KyloModuleLink| raw:: html

   <a href="https://github.com/Teradata/kylo/tree/master/samples/plugins/example-module" target="_blank">Custom Kylo Module</a>