=============================
Ambari Service Monitor Plugin
=============================


Purpose
---------
The Ambari Service Monitor reports the status of Ambari services in Kylo Operations Manager.

Enable Plugin
-------------
To enable the plugin please do the following

1. Create a new file /opt/kylo/kylo-services/conf/ambari.properties. Ensure the owner of the file is kylo
2. Add the following to the ambari.properties file.

.. code-block:: properties

    ambariRestClientConfig.host=127.0.0.1
    ambariRestClientConfig.port=8080
    ambariRestClientConfig.username=admin
    ambariRestClientConfig.password=admin
    ambari.services.status=HDFS,HIVE,MAPREDUCE2,SQOOP

..

3. Copy the /opt/kylo/setup/plugins/kylo-service-monitor-ambari-<<VERSION>>.jar to /opt/kylo/kylo-services/plugin

.. code-block:: properties

    cp /opt/kylo/setup/plugins/kylo-service-monitor-ambari-<<VERSION>>.jar /opt/kylo/kylo-services/plugin/

..

4. Restart kylo-services