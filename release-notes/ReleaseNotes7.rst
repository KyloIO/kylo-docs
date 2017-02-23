Release 0.7.0 (Feb. 13, 2017)
=============================

Highlights
----------

-  Renamed thinkbig artifacts to kylo

-  Our REST API documentation has been updated and reorganized for
   easier reading. If you have Kylo running you can
   open http://localhost:8400/api-docs/index.html to view the docs.

-  Kylo is now available under the Apache 2 open-source license. Visit
   our new `GitHub <https://github.com/KyloIO>`__ page!

-  Login to Kylo with our new form-based authentication. A logout option
   has been added to the upper-right menu in both the Feed Manager and
   the Operations Manager.

RPM
---

http://bit.ly/2l5p1tK

Upgrade Instructions from v0.6.0
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

6. Migrate the "thinkbig" database schema to "kylo".

   Kylo versions 0.6 and below use the thinkbig schema in MySQL. Starting from version 0.7, Kylo uses the kylo schema. This guide is intended for installations that are already on Kylo 0.6, and want to upgrade to Kylo 0.7. It outlines the procedure for migrating the current thinkbig schema to kylo schema, so that Kylo 0.7 can work.

   **Migration Procedure**

    a.  Uninstall Kylo 0.6 (Refer to deployment guide and release notes for details).
    b.  Install Kylo 0.7 (Refer to deployment guide and release notes for details).
        Do not yet start Kylo services.
    c. Log into MySQL instance used by Kylo, and list the schemas:

.. code-block:: shell

        mysql> show databases

..

    d. Verify that:

       -- thinkbig schema exists
       -- kylo schema does not exist

    e. Navigate to Kylo’s setup directory for MySQL.

.. code-block:: shell

      cd /opt/kylo/setup/sql/mysql

..

    f. Execute the migration script. It takes 3 parameters. For no password, provide the 3rd parameter as ''../migrate-schema-thinkbig-to-kylo-mysql.sh <host> <user> <password>

      - Step 1 of migration: kylo schema is set up.
      - Step 2 of migration: thinkbig schema is migrated to kylo schema.

    g. Start Kylo services. Verify that Kylo starts and runs successfully. At this point, there are two schemas in MySQL: kylo and thinkbig.

      Once Kylo is running normally and migration is verified, the thinkbig schema can be dropped.

    h. Navigate to Kylo’s setup directory for MySQL.

.. code-block:: shell

        cd /opt/kylo/setup/sql/mysql

..

    i. Execute the script to drop thinkbig schema. It takes 3 parameters. For no password, provide the 3rd parameter as ''../drop-schema-thinkbig-mysql.sh <host> <user> <password>

    k. Verify that only kylo schema now exists in MySQL.

.. code-block:: shell

        mysql> show databases

..

       This completes the migration procedure.

7. Update the database:  

.. code-block:: shell

    /opt/kylo/setup/sql/mysql/kylo/0.7.0/update.sh localhost root <password or blank>

..

8. Run:

.. code-block:: shell

    /opt/kylo/setup/nifi/update-nars-jars.sh

..

9. Edit:

.. code-block:: shell

    /opt/nifi/current/conf/bootstrap.conf

..

    Change "java.arg.15=Dthinkbig.nifi.configPath=/opt/nifi/ext-config" **to** "java.arg.15=Dkylo.nifi.configPath=/opt/nifi/ext-config".

10. Run:

.. code-block:: shell

    mv /opt/thinkbig/bkup-config /opt/kylo
    chown -R kylo:kylo bkup-config

..

11.  Run: 

.. code-block:: shell

    mv /opt/thinkbig/encrypt.key /opt/kylo

..

     If prompted for overwrite, answer 'yes'.

12.  Run: 

.. code-block:: shell

    chown kylo:kylo /opt/kylo/encrypt.key

..

13.  Copy the mariadb driver to access MySQL database.

14.  Run:

.. code-block:: shell

      > cp /opt/kylo/kylo-services/lib/mariadb-java-client-*.jar /opt/nifi/mysql 
      > chown nifi:users  /opt/nifi/mysql/mariadb-java-client-*.jar

..

15.  Start NiFi (wait to start):

.. code-block:: shell

     service nifi start

..

16.  In the standard-ingest template, update the"Validate and Split Records" processor and change the ApplicationJAR value to:  

.. code-block:: shell

     /opt/nifi/current/lib/app/kylo-spark-validate-cleanse-jar-with-dependencies.jar

..

17.  In the standard-ingest template update the"Profile Data" processor and change the ApplicationJAR value to: 

.. code-block:: shell

     /opt/nifi/current/lib/app/kylo-spark-job-profiler-jar-with-dependencies.jar

..

18.  For the MySQL controller service (type: DBCPConnectionPool), update the properties to use the mariadb driver:

     - **Database Driver Class Name:** org.mariadb.jdbc.Driver 
     - **Database Driver Location(s):** file:///opt/nifi/mysql/mariadb-java-client-1.5.7.jar

19. For the JMSConnectionFactoryProvider controller service, set the *MQ Client Libraries path* property value to:

.. code-block:: shell

     /opt/kylo/kylo-services/lib

..

20. For the StandardSqoopConnectionService, copy the value of *Source
    Driver* to *Source Driver (Avoid providing value)* then delete
    the *Source Driver* property.

21. Update, with your custom configuration, the configuration files at:

.. code-block:: shell

    /opt/kylo/kylo-ui/conf/, /opt/kylo/kylo-services/conf/

    /opt/kylo/kylo-spark shell/conf/

..

    A backup of the previous version's configuration is available from /opt/kylo/bkup-config/.

22. Modify both of the metadata controller services in NiFi with the new REST endpoint.

   -  The first one should be under the root process group and is used by our processors.  The REST Client URL property should be changed to http://localhost:8400/proxy/v1/metadata.

   -  The second is under the right-hand menu and is used by our reporting task. The REST Client URL property should be changed to http://localhost:8400/proxy/v1/metadata.

23. If using NiFi v0.7 or earlier, modify:

.. code-block:: shell

      /opt/kylo/kylo-services/conf/application.properties

..

    Change spring.profiles.active from **nifi-v1** to **nifi-v0**.

24. Modify permissions to allow existing NiFi flows to use /tmp/kylo directory.

.. Note::

    After re-importing data_ingest.zip in a later step, any new feeds created will use the /tmp/kylo-nifi folder. The below command will allow existing flows to continue using the /tmp/kylo folder.

.. code-block:: shell

      > chmod 777 /tmp/kylo

..

25. Start kylo apps:

.. code-block:: shell

    /opt/kylo/start-kylo-apps.sh

..

26. Re-import the data_ingest.zip template. (New feeds will use the temp location /tmp/kylo-nifi.)

27. (Optional) If unused, the mysql driver in /opt/nifi/mysql can be deleted.

28. Run:

.. code-block:: shell

    > rm /opt/nifi/mysql/mysql-connector-java-*.jar

..
