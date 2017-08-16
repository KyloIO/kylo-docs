
=======================
Service Monitor Plugins
=======================

Introduction
============

Kylo supports pluggable Service Monitor implementations. There are a number of them available out-of-the-box, for example:

    - |LinkCloudera|
    - |LinkAmbari|
    - |LinkNifi|
    - |LinkKyloCluster|

|LinkAPI| is available to implement additional Service Monitors

Monitor Services via Cloudera Manager
=====================================

Installation
------------

After you have installed Kylo, copy ``/opt/kylo/setup/plugins/kylo-service-monitor-cloudera-service-<version>.jar`` to Kylo plugins directory
``/opt/kylo/kylo-services/plugin`` and make sure plugin jar belongs to user Kylo runs with:

  .. code-block:: shell

    cp /opt/kylo/setup/plugins/kylo-service-monitor-cloudera-service-<version>.jar /opt/kylo/kylo-services/plugin
    chown kylo:kylo /opt/kylo/kylo-services/plugin/kylo-service-monitor-cloudera-service-<version>.jar

  ..

Configuration
-------------

Create service configuration file ``/opt/kylo/kylo-services/conf/cloudera.properties`` which belongs to user Kylo runs with and contains
following properties. Do substitute values with what your Cloudera Manager is configured with:

  .. code-block:: properties

    clouderaRestClientConfig.username=cloudera
    clouderaRestClientConfig.password=cloudera
    clouderaRestClientConfig.serverUrl=127.0.0.1
    clouderaRestClientConfig.port=7180
    cloudera.services.status=HDFS/[DATANODE,NAMENODE,SECONDARYNAMENODE],HIVE/[HIVEMETASTORE,HIVESERVER2],YARN,SQOOP

  ..

Restart Kylo
------------

  .. code-block:: shell

    service kylo-services restart

  ..


Monitor Services via Ambari
===========================

Installation
------------

After you have installed Kylo, copy ``/opt/kylo/setup/plugins/kylo-service-monitor-ambari-<version>.jar`` to Kylo plugins directory
``/opt/kylo/kylo-services/plugin`` and make sure plugin jar belongs to user Kylo runs with:

  .. code-block:: shell

    cp /opt/kylo/setup/plugins/kylo-service-monitor-ambari-<version>.jar /opt/kylo/kylo-services/plugin
    chown kylo:kylo /opt/kylo/kylo-services/plugin/kylo-service-monitor-ambari-<version>.jar

  ..

Configuration
-------------

Create service configuration file ``/opt/kylo/kylo-services/conf/ambari.properties`` which belongs to user Kylo runs with and contains
following properties. Do substitute values with what your Ambari is configured with:

  .. code-block:: properties

    ambariRestClientConfig.host=127.0.0.1
    ambariRestClientConfig.port=8080
    ambariRestClientConfig.username=admin
    ambariRestClientConfig.password=admin
    ambari.services.status=HDFS/[DATANODE,NAMENODE,SECONDARYNAMENODE],HIVE/[HIVEMETASTORE,HIVESERVER2],YARN,SQOOP

  ..

Restart Kylo
------------

  .. code-block:: shell

    service kylo-services restart

  ..




.. |LinkAPI| raw:: html

   <a href="https://github.com/Teradata/kylo/tree/master/core/service-monitor/service-monitor-api/src/main/java/com/thinkbiganalytics/servicemonitor/check" target="_blank">Public Service Monitor API</a>

.. |LinkCloudera| raw:: html

   <a href="https://github.com/Teradata/kylo/tree/master/plugins/service-monitor-cloudera/service-monitor-cloudera-service" target="_blank">Services via Cloudera Manager</a>

.. |LinkAmbari| raw:: html

   <a href="https://github.com/Teradata/kylo/tree/master/plugins/service-monitor-ambari" target="_blank">Services via Ambari</a>

.. |LinkKyloCluster| raw:: html

   <a href="https://github.com/Teradata/kylo/tree/master/plugins/service-monitor-kylo-cluster" target="_blank">Kylo Cluster</a>

.. |LinkNifi| raw:: html

   <a href="https://github.com/Teradata/kylo/tree/master/plugins/service-monitor-nifi" target="_blank">Nifi</a>

