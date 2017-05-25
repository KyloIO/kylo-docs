Release 0.8.1-DEV
=================

Highlights
----------
- 140+ issues resolved

- You can now assign users and groups access to feeds, categories, and templates giving you fine grain control of what users can see and do.  Refer to the :doc:`../security/AccessControl` for more information.

- Kylo can now be clustered for high availability.  Refer to  :doc:`../installation/KyloClusterConfiguration` for more information.

- You now mix and match the order of standardizers and validators giving you more control over the processing of your data.

- The wrangler has been improved with a faster transformation grid and now shows column level profile statistics as you transform your data.

Upgrade Instructions from v0.7.1
--------------------------------
- If upgrading directly from v0.7.1, run the database update to enable Liquibase.

.. code-block:: shell

    /opt/kylo/setup/sql/mysql/kylo/0.8.0/update.sh <db-hostname> <db-user> <db-password>
..

Upgrade Instructions from v0.8.0
--------------------------------

Build or download the RPM <<Link coming soon>>

1. Uninstall Kylo:

 .. code-block:: shell

   /opt/kylo/remove-kylo.sh

 ..

3. Install the new RPM:

 .. code-block:: shell

     rpm –ivh <RPM_FILE>

 ..

4. Copy the application.properties file from the 0.8.0.1 install.  If you have customized the application.properties file you will want to copy the 0.8.0.1 version and add the new properties that were added for this release.

     4.1 Find the /bkup-config/TIMESTAMP/kylo-services/application.properties file

        - Kylo will backup the application.properties file to the following location, */opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties*, replacing the "YYYY_MM_DD_HH_MM_millis" with a valid time:

     4.2 Copy the backup file over to the /opt/kylo/kylo-services/conf folder

        .. code-block:: shell

          ### move the application.properties shipped with the .rpm to a backup file
          mv /opt/kylo/kylo-services/application.properties application.properties.0_8_1_template
          ### copy the backup properties  (Replace the YYYY_MM_DD_HH_MM_millis  with the valid timestamp)
          cp /opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties /opt/kylo/kylo-services/conf

        ..

     4.3  Two new properties were added.  Add in the 2 new properties to the /opt/kylo/kylo-services/conf/application.properties file

        .. code-block:: properties

         # Entity-level access control. To enable, uncomment below line and set value as true
         #security.entity.access.controlled=false

         ## optional.  If added you can control the timeout when you delete a feed
         kylo.feed.mgr.cleanup.timeout=60000

        ..

         Refer to the :doc:`../security/AccessControl` document for more information about entity level access control.  To enable entity access control ensure the property above is set to true.

     4.4 Ensure the property ``security.jwt.key`` in both kylo-services and kylo-ui application.properties file match.  They property below needs to match in both of these files:

         - */opt/kylo/kylo-ui/conf/application.properties*
         - */opt/kylo/kylo-services/conf/application.properties*.

       .. code-block:: properties

         security.jwt.key=

       ..

5. Backup the Kylo database.  Run the following code against your kylp database to export the 'kylo' schema to a file.  Replace the  PASSWORD with the correct login to your kylo database.

  .. code-block:: shell

     mysqldump -u root -pPASSWORD --databases kylo >kylo-0_8_0_1_backup.sql

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

