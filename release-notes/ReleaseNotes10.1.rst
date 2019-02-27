Release 0.10.1 (March 1, 2019)
==============================

Highlights
----------
- Various :doc:`issues <ReleaseNotes10.1.issues>` fixed.

Download Links
--------------
- Visit the :doc:`Downloads <../about/Downloads>` page for links.


Upgrade Instructions from v0.10.0
---------------------------------

1. Please see `Upgrade Instructions from v0.9.1 <ReleaseNotes10.0.html#upgrade-instructions-from-v0-9-1>`_ if upgrading from an earlier version of Kylo.

2. Backup any Kylo plugins

  When Kylo is uninstalled it will backup configuration files, but not the `/plugin` jar files.
  If you have any custom plugins in either `kylo-services/plugin`  or `kylo-ui/plugin` then you will want to manually back them up to a different location.


3. Stop and uninstall Kylo

    3.1 Stop Kylo

        .. code-block:: shell

          /opt/kylo/stop-kylo-apps.sh

        ..

    3.2 Uninstall Kylo

        .. code-block:: shell

          /opt/kylo/remove-kylo.sh

        ..


4. Install the new RPM:

 .. code-block:: shell

     rpm –ivh <RPM_FILE>

 ..

5. Restore previous application.properties files. If you have customized the the application.properties, copy the backup from the 0.10.0 install.

     5.1 Find the /bkup-config/TIMESTAMP/kylo-services/application.properties file

        - Kylo will backup the application.properties file to the following location, */opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties*, replacing the "YYYY_MM_DD_HH_MM_millis" with a valid time:

     5.2 Copy the backup file over to the /opt/kylo/kylo-services/conf folder

        .. code-block:: shell

          ### move the application.properties shipped with the .rpm to a backup file
          mv /opt/kylo/kylo-services/conf/application.properties /opt/kylo/kylo-services/conf/application.properties.0_10_0_template
          ### copy the backup properties  (Replace the YYYY_MM_DD_HH_MM_millis  with the valid timestamp)
          cp /opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties /opt/kylo/kylo-services/conf

        ..

     5.3 Copy the /bkup-config/TIMESTAMP/kylo-ui/application.properties file to `/opt/kylo/kylo-ui/conf`

        .. code-block:: shell

          ### move the application.properties shipped with the .rpm to a backup file
          mv /opt/kylo/kylo-ui/conf/application.properties /opt/kylo/kylo-ui/conf/application.properties.0_10_0_template
          ### copy the backup properties  (Replace the YYYY_MM_DD_HH_MM_millis  with the valid timestamp)
          cp /opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-ui/application.properties /opt/kylo/kylo-ui/conf

        ..

     5.4 Ensure the property ``security.jwt.key`` in both kylo-services and kylo-ui application.properties file match.  The property below needs to match in both of these files:

        - */opt/kylo/kylo-ui/conf/application.properties*
        - */opt/kylo/kylo-services/conf/application.properties*

          .. code-block:: properties

            security.jwt.key=

          ..

6. Update the NiFi nars.

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

7. Start Kylo

 .. code-block:: shell

   /opt/kylo/start-kylo-apps.sh

 ..



.. |Think_Big_Analytics_Contact_Link| raw:: html

   <a href="https://www.thinkbiganalytics.com/contact/" target="_blank">Think Big Analytics</a>

.. |JIRA_Issues_Link| raw:: html
