
===========================
Enable Sentry Authorization
===========================

Prerequisite
============

Java
----

Java must be installed on all client nodes.

.. code-block:: shell

    $ java -version
      $ java version "1.8.0_92"
    $ OpenJDK Runtime Environment (rhel-2.6.4.0.el6_7-x86_64 u95-b00)
      $ OpenJDK 64-Bit Server VM (build 24.95-b01, mixed mode)

    $ echo $JAVA_HOME
    $ /opt/java/jdk1.8.0_92/

Cluster Requirements
--------------------

-  This documentation assumes that you have Kylo installed and running on
   a cluster.

-  Kerberos is mandatory. For testing purposes, set
   sentry.hive.testing.mode to true.

-  You must be running Hive Server2.

-  In order to define policy for a role, you should have the user-group
   created on all nodes of a cluster, and you must then map each role to
   user-group.

-  Only Sentry Admin can grant all access (create role, grant, revoke)
   to a user. You can add a normal user to Sentry admin group via
   Cloudera Manager.

Grant Sentry Admin Access to NiFi User
--------------------------------------

1. Create a sentryAdmin group and assign a NiFi user to it.

    groupadd sentryAdmin
    usermod -a -G sentryAdmin nifi

2. Add sentryAdmin group to Sentry Admin List.

   a. Log in to Cloudera Manager.

   b. Select Sentry Service.

   c. Go to Configuration tab.

   d. Select Sentry(Service-Wide) from Scope.

   e. Select Main from Category.

   f. Look for sentry.service.admin.group property.

   g. Add sentryAdmin to list.

   h. Click **Save** and **Restart Service**.

|image1|

Enabling Sentry for Hive
========================

Change Hive Warehouse Ownership
-------------------------------

The Hive warehouse directory (/user/hive/warehouse or any path you
specify as hive.metastore.warehouse.dir in your hive-site.xml) must be
owned by the Hive user and group.

.. code-block:: shell

    $ sudo -u hdfs hdfs dfs -chmod -R 771 /user/hive/warehouse
    $ sudo -u hdfs hdfs dfs -chown -R hive:hive /user/hive/warehouse

If you have a Kerberos-enabled cluster:

.. code-block:: shell

    $ sudo -u hdfs kinit -kt <hdfs.keytab> hdfs
    $ sudo -u hdfs hdfs dfs -chmod -R 771 /user/hive/warehouse
    $ sudo -u hdfs hdfs dfs -chown -R hive:hive /user/hive/warehouse

Disable Impersonation for HiveServer2
-------------------------------------

1. Go to the Hive service.

2. Click the Configuration tab.

3. Select Scope > HiveServer2.

4. Select Category > Main.

5. Uncheck the HiveServer2 Enable Impersonation checkbox.

6. Click **Save Changes** to commit the changes.

Yarn Setting For Hive User
--------------------------

1. Open the Cloudera Manager Admin Console and go to the YARN service.

2. Click the Configuration tab.

3. Select Scope > NodeManager.

4. Select Category > Security.

5. Ensure the Allowed System Users property includes the Hive user. If not, add Hive.

6. Click **Save Changes** to commit the changes.

7. Repeat steps 1-6 for every NodeManager role group for the YARN service that is associated with Hive.

8. Restart the YARN service.

Enabled Sentry
--------------

1. Go to the Hive service.

2. Click the Configuration tab.

3. Select Scope > Hive (Service-Wide).

4. Select Category > Main.

5. Locate the Sentry Service property and select Sentry.

6. Click **Save Changes** to commit the changes.

7. Restart the Hive service.

|image2|

Administrative Privilege
------------------------

Once the sentryAdmin group is part of Sentry Admin list, it will be able
to create policies in Sentry but sentryAdmin will not be allowed to
read/write any tables. To do that, privileges must be granted to the sentryAdmin group.

    CREATE ROLE admin_role
    GRANT ALL ON SERVER server1 TO ROLE admin_role;
    GRANT ROLE admin_role TO GROUP sentryAdmin;

Enabled HDFS ACL
----------------

1. Go to the Cloudera Manager Admin Console and navigate to the HDFS
   service.

2. Click the Configuration tab.

3. Select Scope > HDFS-1 (Service-Wide).

4. Select Category > Security.

5. Locate the Enable Access Control Lists property and select its checkbox to enable HDFS ACLs.

6. Click **Save Changes** to commit the changes.

|image3|

Sentry authorization is configured successfully. Now create a feed from
the Kylo UI and test it.

.. |image1| image:: ../media/sentry-auth/S1.png
   :width: 6.50000in
   :height: 2.35556in
.. |image2| image:: ../media/sentry-auth/S2.png
   :width: 6.50000in
   :height: 2.87500in
.. |image3| image:: ../media/sentry-auth/S3.png
   :width: 6.50000in
   :height: 2.98819in
