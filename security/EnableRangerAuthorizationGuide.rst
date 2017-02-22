
===========================
Enable Ranger Authorization
===========================

Prerequisite
============

Java
====

Java must be installed on all client nodes.

.. code-block:: shell

    $ java -version
      $ java version "1.8.0_92"
    $ OpenJDK Runtime Environment (rhel-2.6.4.0.el6_7-x86_64 u95-b00)
      $ OpenJDK 64-Bit Server VM (build 24.95-b01, mixed mode)

    $ echo $JAVA_HOME
    $ /opt/java/jdk1.8.0_92/

..

Kylo
====

This documentation assumes that you have Kylo installed and running on a
cluster.

Optional: Delete/Disable HDFS/HIVE Global Policy
================================================

If you are using HDP sandbox, remove all HDFS/HIVE global policy.

Disable the HDFS Policy.

|image1|

Disable the HIVE policy.

|image2|

Create a NiFi Super User Policy in Hive
=======================================

1. Login to Ranger UI.

2. Select Hive Repository.

3. Click on Add Policy.

4. Create a policy as shown in image below.

    Policy Name : ranger_superuser_policy
    Select user : nifi
    Permission : All

|image3|


Create a Hive User Policy in the HDFS Repository
================================================

1. Login to Ranger UI.

2. Select HDFS Repository.

3. Click on Add Policy.

4. Create a policy as shown in the image below.

.. code-block:: shell

    Policy Name : hive_user_policy_kylo
    Resource Path : /model.db/
                                        /app/warehouse/
                                        /etl/

..

|image4|

Ranger authorization is configured successfully. Now create a feed from the
Kylo UI and create feed for testing.


.. |image1| image:: ../media/ranger-enable-auth/R1.png
   :width: 6.50000in
   :height: 1.24861in
.. |image2| image:: ../media/ranger-enable-auth/R2.png
   :width: 6.50000in
   :height: 1.96250in
.. |image3| image:: ../media/ranger-enable-auth/R3.png
   :width: 6.50000in
   :height: 3.28403in
.. |image4| image:: ../media/ranger-enable-auth/R4.png
   :width: 6.50000in
   :height: 3.08194in
