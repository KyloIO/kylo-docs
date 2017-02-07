
=========================================
NiFi Configuration for a Kerberos Cluster
=========================================

Prerequisites
=============

Below are the list of prerequisites to enable Kerberos for the NiFi data
lake platform:

-  A Hadoop cluster must be running.

-  NiFi should be running with latest changes.

-  Kerberos should be enabled.

-  Keytabs should be created and accessible.

Types of Processors to be Configured
====================================

HDFS
----

-  IngestHDFS

-  CreateHDFSFolder

-  PutHDFS

Hive
----

-  TableRegister

-  ExecuteHQLStatement

-  TableMerge

Spark
-----

-  ExecuteSparkJob

Configuration Steps
===================

1. Create a Kerberos keytab file for Nifi user.

    kadmin.local

    addprinc -randkey nifi@sandbox.hortonworks.com

    xst -norandkey -k /etc/security/keytabs/nifi.headless.keytab
    nifi@sandbox.hortonworks.com

    exit

    chown nifi:hadoop /etc/security/keytabs/nifi.headless.keytab

    chmod 440 /etc/security/keytabs/nifi.headless.keytab

    Test that the keytab works. You can initialize your keytab file
    using below command.

    su - nifi

    kinit -kt /etc/security/keytabs/nifi.headless.keytab nifi

    klist

2. Make sure nifi.properties file is available in conf directory of NiFi
   installed location.

|image1|

3. Open nifi.properties file and set location of krb5.conf file to
   property nifi.kerberos.krb5.file.

    vi nifi.properties

    nifi.kerberos.krb5.file=/etc/krb5.conf

4. HDFS Processor Configuration : Log in to NiFi UI and select HDFS
   processor and set properties which is highlighted in red box.

    Hadoop Configuration Resource :
    /etc/hadoop/conf/core-site.xml,/etc/hadoop/conf/hdfs-site.xml

    Kerberos Principal: nifi

    Kerberos Keytab : /etc/security/keytabs/nifi.headless.keytab

    |image2|

5. SPARK Processor Configuration : Log in to NiFi UI and select HDFS
   processor and set properties which is highlighted in red box.

    |image3|

6. Hive Processor Configuration : Log in to NiFi UI and go to toolbar.

    |image4|

7. Go to Controller Service Tab and disable Thrift Controller Services
   if already running which highlighted in red box.

    |image5|

8. Make sure everything has stopped properly like below.

    |image6|

9. Update HiveServer2 hostname and Hive principal name.

.. code-block:: shell

    Database Connection URL:
    'jdbc:hive2://:<HOSTNAME>:10000/default;principal=hive/<HOSTNAME>@HOSTNAME'

    ex.
    'jdbc:hive2://localhost:10000/default;principal=hive/sandbox.hortonworks.com@sandbox.hortonworks.com'

..

    |image7|

10. Update Kerberos user information and Hadoop Configuration. Apply Changes and start controller services.

    You have successfully configured NiFi DataLake Platform with Kerberos.


.. |image1| image:: media/nifi-kerberos/N1.png
   :width: 5.82219in
   :height: 0.67700in
.. |image2| image:: media/nifi-kerberos/N3.png
   :width: 5.93388in
   :height: 3.26871in
.. |image3| image:: media/nifi-kerberos/N4.png
   :width: 5.93770in
   :height: 3.20230in
.. |image4| image:: media/nifi-kerberos/N5.png
   :width: 5.93250in
   :height: 1.18396in
.. |image5| image:: media/nifi-kerberos/N6.png
   :width: 5.88170in
   :height: 1.66837in
.. |image6| image:: media/nifi-kerberos/N7.png
   :width: 5.93631in
   :height: 3.30429in
.. |image7| image:: media/nifi-kerberos/N8.png
   :width: 5.86186in
   :height: 2.45309in
