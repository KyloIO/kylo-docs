=========================
Additional Configuration
=========================
Before starting Kylo you will want to make sure the configuration is correct. Some common cases of when you would want to change the defaults is

    1. Database configuration
    2. Hive thrift connection configuration
    3. Set all required passwords

Note: Kylo no longer includes default passwords

Edit the Properties Files
-------------------------
There are 3 main properties files for Kylo

.. code-block:: shell

    $ vi /opt/kylo/kylo-services/conf/application.properties

    $ vi /opt/kylo/kylo-services/conf/spark.properties

    $ vi /opt/kylo/kylo-ui/conf/application.properties

..

For more details on the properties please see :doc:`../how-to-guides/ConfigurationProperties`

Kylo HDP Demo Sandbox Example
-----------------------------
Here is an example of the properties that need to be changed to work on the Kylo HDP demo sandbox

.. code-block:: properties

    spring.datasource.username=root
    spring.datasource.password=hadoop

    hive.datasource.username=kylo
    hive.metastore.datasource.username=root
    hive.metastore.datasource.password=hadoop

    nifi.service.mysql.database_user=root
    nifi.service.mysql.password=hadoop
    nifi.service.kylo_mysql.database_user=root
    nifi.service.kylo_mysql.password=hadoop
    nifi.service.kylo_metadata_service.rest_client_password=thinkbig

    modeshape.datasource.username=${spring.datasource.username}
    modeshape.datasource.password=${spring.datasource.password}
    metadata.datasource.username=${spring.datasource.username}
    metadata.datasource.password=${spring.datasource.password}

..

Here is an example bash script to automatically make the above changes

.. code-block:: shell

    #!/bin/bash

    KYLO_HOME=/opt/kylo

    sed -i  "s|spring.datasource.username=|spring.datasource.username=root|" $KYLO_HOME/kylo-services/conf/application.properties

    sed -i  "s|spring.datasource.password=|spring.datasource.password=hadoop|" $KYLO_HOME/kylo-services/conf/application.properties

    sed -i  "s|hive.datasource.username=|hive.datasource.username=kylo|" $KYLO_HOME/kylo-services/conf/application.properties

    sed -i  "s|hive.metastore.datasource.username=|hive.metastore.datasource.username=root|" $KYLO_HOME/kylo-services/conf/application.properties

    sed -i  "s|hive.metastore.datasource.password=|hive.metastore.datasource.password=hadoop|" $KYLO_HOME/kylo-services/conf/application.properties

    sed -i  "s|nifi.service.mysql.database_user=|nifi.service.mysql.database_user=root|" $KYLO_HOME/kylo-services/conf/application.properties

    sed -i "s|nifi.service.mysql.password=|nifi.service.mysql.password=hadoop|" $KYLO_HOME/kylo-services/conf/application.properties

    sed -i "s|nifi.service.kylo_mysql.database_user=|nifi.service.kylo_mysql.database_user=root|" $KYLO_HOME/kylo-services/conf/application.properties

    sed -i "s|nifi.service.kylo_mysql.password=|nifi.service.kylo_mysql.password=hadoop|" $KYLO_HOME/kylo-services/conf/application.properties

    sed -i "s|nifi.service.kylo_metadata_service.rest_client_password=|nifi.service.kylo_metadata_service.rest_client_password=thinkbig|" $KYLO_HOME/kylo-services/conf/application.properties

    sed -i "s|#modeshape.datasource.username=\${spring.datasource.username}|modeshape.datasource.username=\${spring.datasource.username}|" /opt/kylo/kylo-services/conf/application.properties

    sed -i "s|#modeshape.datasource.password=\${spring.datasource.password}|modeshape.datasource.password=\${spring.datasource.password}|" /opt/kylo/kylo-services/conf/application.properties

    sed -i "s|#metadata.datasource.username=\${spring.datasource.username}|metadata.datasource.username=\${spring.datasource.username}|" /opt/kylo/kylo-services/conf/application.properties

    sed -i "s|#metadata.datasource.password=\${spring.datasource.password}|metadata.datasource.password=\${spring.datasource.password}|" /opt/kylo/kylo-services/conf/application.properties

..


Kylo Cloudera Demo Sandbox Example
------------------------
The configuration is setup to work out of the box with the Kylo Hortonworks
sandbox. There are a few differences that require configuration changes
for Cloudera.


1. /opt/kylo/kylo-services/conf/application.properties


.. code-block:: properties

    spring.datasource.username=root
    spring.datasource.password=cloudera

    hive.datasource.username=hive
    hive.metastore.datasource.username=root
    hive.metastore.datasource.password=cloudera
    hive.metastore.datasource.url=jdbc:mysql://localhost:3306/metastore
    config.hive.schema=metastore

    nifi.service.mysql.database_user=root
    nifi.service.mysql.password=cloudera
    nifi.service.kylo_mysql.database_user=root
    nifi.service.kylo_mysql.password=hadoop
    nifi.service.kylo_metadata_service.rest_client_password=thinkbig
    nifi.executesparkjob.sparkhome=/usr/lib/spark
    config.spark.validateAndSplitRecords.extraJars=/usr/lib/hive-hcatalog/share/hcatalog/hive-hcatalog-core.jar

    modeshape.datasource.username=${spring.datasource.username}
    modeshape.datasource.password=${spring.datasource.password}
    metadata.datasource.username=${spring.datasource.username}
    metadata.datasource.password=${spring.datasource.password}

..



2. Spark configuration

.. code-block:: shell

    cp /etc/hive/conf/hive-site.xml /etc/spark/conf/hive-site.xml

    # Snappy isn't working well for Spark on Cloudera
    echo "spark.io.compression.codec=lz4" >> /etc/spark/conf/spark-defaults.conf
..



