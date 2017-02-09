
===========================
Enable Ranger Authorization
===========================

Pre-requisite
=============

Java
====

All client node should have java installed on it.

.. code-block:: shell

    $ java -version
      $ java version "1.8.0\_92"
    $ OpenJDK Runtime Environment (rhel-2.6.4.0.el6\_7-x86\_64 u95-b00)
      $ OpenJDK 64-Bit Server VM (build 24.95-b01, mixed mode)

    $ echo $JAVA\_HOME
    $ /opt/java/jdk1.8.0\_92/

..

Kylo
====

This documentation assumes that you have Kylo installed and running on a
cluster.

Optional: Delete/Disable HDFS/HIVE Global Policy.
=================================================

If you are using HDP sandbox then remove all HDFS/HIVE global policy.

Disable the HDFS Policy.

|image1|

Disable the HIVE policy.

|image2|

Create NiFi Super User Policy in Hive
=====================================

1. Login to Ranger UI.

2. Select Hive Repository.

3. Click on Add Policy.

4. Create policy as shown in image below.

    Policy Name : ranger\_superuser\_policy
    Select user : nifi
    Permission : All

|image3|


Create hive user policy in HDFS repository.
===========================================

1. Login to Ranger UI

2. Select HDFS Repository.

3. Click on Add Policy.

4. Create policy as shown in the image below.

.. code-block:: shell

    Policy Name : hive\_user\_policy\_kylo
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
