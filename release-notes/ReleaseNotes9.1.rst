Release 0.9.1 (FILL ME IN, 2018)
===============================

Highlights
----------
- Various issues fixed - |JIRA_Issues_Link|
- :ref:`NiFi 1.6.0 support <nifi_support>`
- :ref:`Spark  Shell default is now managed mode <spark_shell_managed_mode>`
- :ref:`Manually start a feed, irrespective of its schedule <start_now>`
- Remote Process Group support
- Wrangler enhancements and improved user interface
- Ingest data from Hadoop to Teradata via TDCH
- New advanced batch and streaming templates


Download Links
--------------
- Visit the :doc:`Downloads <../about/Downloads>` page for links.


Upgrade Instructions from v0.9.0
----------------------------------

1. Backup any Kylo plugins

  When Kylo is uninstalled it will backup configuration files, but not the `/plugin` jar files.
  If you have any custom plugins in either `kylo-services/plugin`  or `kylo-ui/plugin` then you will want to manually back them up to a different location.

2. Uninstall Kylo:

 .. code-block:: shell

   /opt/kylo/remove-kylo.sh

 ..

3. Install the new RPM:

 .. code-block:: shell

     rpm –ivh <RPM_FILE>

 ..

4. Restore previous application.properties files. If you have customized the the application.properties, copy the backup from the 0.9.0 install.

     4.1 Find the /bkup-config/TIMESTAMP/kylo-services/application.properties file

        - Kylo will backup the application.properties file to the following location, */opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties*, replacing the "YYYY_MM_DD_HH_MM_millis" with a valid time:

     4.2 Copy the backup file over to the /opt/kylo/kylo-services/conf folder

        .. code-block:: shell

          ### move the application.properties shipped with the .rpm to a backup file
          mv /opt/kylo/kylo-services/conf/application.properties /opt/kylo/kylo-services/conf/application.properties.0_9_0_template
          ### copy the backup properties  (Replace the YYYY_MM_DD_HH_MM_millis  with the valid timestamp)
          cp /opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties /opt/kylo/kylo-services/conf

        ..

     4.3 If you copied the backup version of application.properties in step 4.2 you will need to make a couple of other changes based on the 0.9.1 version of the properties file

        .. code-block:: shell

          vi /opt/kylo/kylo-services/conf/application.properties

          # Add the auth-spark profile
          spring.profiles.include=native,nifi-v1.2,auth-kylo,auth-file,search-esr,jms-activemq,auth-spark

          # Add the new property
          kylo.feed.mgr.hive.target.syncColumnDescriptions=true

          # Add the new property to support the updated templates
          config.nifi.kylo.applicationJarDirectory=/opt/nifi/current/lib/app

        ..

     4.4 Copy the /bkup-config/TIMESTAMP/kylo-ui/application.properties file to `/opt/kylo/kylo-ui/conf`

     4.5 Ensure the property ``security.jwt.key`` in both kylo-services and kylo-ui application.properties file match.  They property below needs to match in both of these files:

        - */opt/kylo/kylo-ui/conf/application.properties*
        - */opt/kylo/kylo-services/conf/application.properties*

          .. code-block:: properties

            security.jwt.key=

          ..


5.  **NOTE:** Kylo no longer ships with the default **dladmin** user. You will need to re-add this user only if you're using the default authentication configuration:

   - Uncomment the following line in :code:`/opt/kylo/kylo-services/conf/application.properties` and :code:`/opt/kylo/kylo-ui/conf/application.properties` :

    .. code-block:: properties

        security.auth.file.users=file:///opt/kylo/users.properties
        security.auth.file.groups=file:///opt/kylo/groups.properties

    ..

   - Create a file called :code:`users.properties` file that is owned by kylo and replace **dladmin** with a new username and **thinkbig** with a new password:

    .. code-block:: shell

        echo "dladmin=thinkbig" > /opt/kylo/users.properties
        chown kylo:users /opt/kylo/users.properties
        chmod 600 /opt/kylo/users.properties

    ..

   - Create a file called :code:`groups.properties` file that is owned by kylo and set the default groups:

    .. code-block:: shell

        vi /opt/kylo/groups.properties


    .. code-block:: properties

        dladmin=admin,user
        analyst=analyst,user
        designer=designer,user
        operator=operations,user

    .. code-block:: shell

        chown kylo:users /opt/kylo/groups.properties
        chmod 600 /opt/kylo/groups.properties

6. To enable reindexing of a feed's historical data:

    1. Verify option in ``/opt/kylo/kylo-services/conf/application.properties`` for Kylo services. This is **true** by default.

        .. code-block:: shell

            search.history.data.reindexing.enabled=true
        ..


    2. If using Solr instead of Elasticsearch as the search engine, add one property to ``/opt/kylo/kylo-services/conf/solrsearch.properties`` file.

        .. code-block:: shell

            config.http.solr.url=http://${search.host}:${search.port}

        ..

7. Update the NiFi nars.

   Stop NiFi

   .. code-block:: shell

      service nifi stop

   ..

   Run the following shell script to copy over the new NiFi nars/jars to get new changes to NiFi processors and services.

   .. code-block:: shell

      /opt/kylo/setup/nifi/update-nars-jars.sh <NIFI_HOME> <KYLO_SETUP_FOLDER> <NIFI_LINUX_USER> <NIFI_LINUX_GROUP>

      Example:  /opt/kylo/setup/nifi/update-nars-jars.sh /opt/nifi /opt/kylo/setup nifi users

   ..

   Start NiFi

   .. code-block:: shell

      service nifi start

   ..


8. Remove kylo-service script. It has been moved

 .. code-block:: shell

   rm /opt/kylo/kylo-service

 ..

9. Start Kylo

 .. code-block:: shell

   kylo-service start

 ..

10. Re-import Data Ingest template (data_ingest.zip).

 - There was a bug fixed to allow HDF support
 - To enable this, re-import the data_ingest.zip file (Templates -> + icon -> Import from a file -> Choose file -> Check yes to 'overwrite' feed template -> Check yes to 'Replace the reusable template' -> Import template)

11. Re-import Data Transformation template (data_transformation.zip).

 - There was a bug fixed to allow HDF support, and allow customizing the profile table location
 - To enable this, re-import the data_transformation.zip file (Templates -> + icon -> Import from a file -> Choose file -> Check yes to 'overwrite' feed template -> Check yes to 'Replace the reusable template' -> Import template)


**NOTE:** You will no longer see the kylo-spark-shell service start. The spark shell is now launched by kylo-services (managed mode)


Highlight Details
-----------------

.. _nifi_support:

  - NiFi 1.6.0 support

      - Kylo now works with NiFi 1.6.0.  If you have NiFi 1.6.0, You should still use the spring profile ``nifi-v1.2`` in the ``kylo-services/conf/application.properties`` file.

.. _spark_shell_managed_mode:

  - Spark Shell Service

      - The spark shell process has been removed and managed mode is now the default mode

.. _start_now:

   - Manually start a feed irrespective of its schedule

       |image0|

.. |Think_Big_Analytics_Contact_Link| raw:: html

   <a href="https://www.thinkbiganalytics.com/contact/" target="_blank">Think Big Analytics</a>

.. |JIRA_Issues_Link| raw:: html

   <a href="https://kylo-io.atlassian.net/issues/?jql=project%20%3D%20KYLO%20AND%20status%20%3D%20Done%20AND%20fixVersion%20%3D%200.9.1%20ORDER%20BY%20summary%20ASC%2C%20lastViewed%20DESC" target="_blank">Jira Issues</a>


.. |image0| image:: ../media/release-notes/release-0.9.1/start-now-button.png
   :width: 1015px
   :height: 339px
   :scale: 15%