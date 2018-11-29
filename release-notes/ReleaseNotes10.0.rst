Release 0.10.0 (TBD, 2018)
==========================

Highlights
----------
- Various issues fixed - |JIRA_Issues_Link|

Download Links
--------------
- Visit the :doc:`Downloads <../about/Downloads>` page for links.


Upgrade Instructions from v0.9.1
--------------------------------

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

4. Restore previous application.properties files. If you have customized the the application.properties, copy the backup from the 0.9.1 install.


     4.1 Find the /bkup-config/TIMESTAMP/kylo-services/application.properties file

        - Kylo will backup the application.properties file to the following location, */opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties*, replacing the "YYYY_MM_DD_HH_MM_millis" with a valid time:

     4.2 Copy the backup file over to the /opt/kylo/kylo-services/conf folder

        .. code-block:: shell

          ### move the application.properties shipped with the .rpm to a backup file
          mv /opt/kylo/kylo-services/conf/application.properties /opt/kylo/kylo-services/conf/application.properties.0_10_0_template
          ### copy the backup properties  (Replace the YYYY_MM_DD_HH_MM_millis  with the valid timestamp)
          cp /opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties /opt/kylo/kylo-services/conf

        ..

     4.3 If you copied the backup version of application.properties in step 4.2 you will need to make a couple of other changes based on the 0.10.0 version of the properties file

        .. code-block:: shell

          vi /opt/kylo/kylo-services/conf/application.properties

        ..

     4.4 Repeat previous copy step for other relevant backup files to the /opt/kylo/kylo-services/conf folder. Some examples of files:

        - spark.properties
        - ambari.properties
        - elasticsearch-rest.properties
        - log4j.properties
        - sla.email.properties

        **NOTE:**  Be careful not to overwrite configuration files used exclusively by Kylo


     4.5 Copy the /bkup-config/TIMESTAMP/kylo-ui/application.properties file to `/opt/kylo/kylo-ui/conf`

     4.6 Ensure the property ``security.jwt.key`` in both kylo-services and kylo-ui application.properties file match.  They property below needs to match in both of these files:

        - */opt/kylo/kylo-ui/conf/application.properties*
        - */opt/kylo/kylo-services/conf/application.properties*

          .. code-block:: properties

            security.jwt.key=

          ..

    4.7 (If using Elasticsearch for search) Create/Update Kylo Indexes

        Execute a script to create/update kylo indexes. If these already exist, Elasticsearch will report an ``index_already_exists_exception``. It is safe to ignore this and continue.
        Change the host and port if necessary.

            .. code-block:: shell

                /opt/kylo/bin/create-kylo-indexes-es.sh localhost 9200 1 1

            ..


5. Update the NiFi nars.

   Stop NiFi

   .. code-block:: shell

      service nifi stop

   ..

   Run the following shell script to copy over the new NiFi nars/jars to get new changes to NiFi processors and services.

   .. code-block:: shell

      /opt/kylo/setup/nifi/update-nars-jars.sh <NIFI_HOME> <KYLO_SETUP_FOLDER> <NIFI_LINUX_USER> <NIFI_LINUX_GROUP>

      Example:  /opt/kylo/setup/nifi/update-nars-jars.sh /opt/nifi /opt/kylo/setup nifi users

   ..
   
   Setup the shared Kylo encryption key:
   
      1. Copy Kylo's encryption key file (ex: ``/opt/kylo/encrypt.key``) to the NiFi extention config directory ``/opt/nifi/ext-config``
      
      2. Change the ownership of that file to the "nifi" user and ensure only nifi can read it

   .. code-block:: shell

      chown nifi /opt/nifi/ext-config/encrypt.key
      chmod 400 /opt/nifi/ext-config/encrypt.key

   ..
   
      3. Edit the ``/opt/nifi/current/bin/nifi-env.sh`` file and add the ENCRYPT_KEY variable with the key value

   .. code-block:: shell

      export ENCRYPT_KEY="$(< /opt/nifi/ext-config/encrypt.key)"
      
   ..

   Start NiFi

   .. code-block:: shell

      service nifi start

   ..


6. :ref:`Install XML support <install-xml-support>` if not using Hortonworks.

7. Start Kylo to begin the upgrade

 .. code-block:: shell

   kylo-service start

 ..
 .. note:: NiFi must be started and available during the Kylo upgrade process.

8. The Hive data source is no longer accessible to all users by default. To grant permissions to Hive go to the Catalog page and click the pencil icon to the left of the Hive data source. This page will provide options for granting access to Hive or granting permissions to edit the data source details.

Highlight Details
-----------------

.. |JIRA_Issues_Link| raw:: html

   <a href="https://kylo-io.atlassian.net/issues/?jql=project%20%3D%20KYLO%20AND%20status%20%3D%20Done%20AND%20fixVersion%20%3D%200.10.0%20ORDER%20BY%20summary%20ASC%2C%20lastViewed%20DESC" target="_blank">Jira Issues</a>
