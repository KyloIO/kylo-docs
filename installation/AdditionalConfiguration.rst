========================
Additional Configuration
========================
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
Here is an example of the properties that need to be changed in :code:`kylo-services/conf/application.properties` to work on the Kylo HDP demo sandbox:

.. code-block:: properties

    spring.datasource.username=<REPLACE_ME_WITH_USERNAME>
    spring.datasource.password=<REPLACE_ME_WITH_PASSWORD>

    hive.datasource.username=<REPLACE_ME_WITH_USERNAME>
    hive.metastore.datasource.username=<REPLACE_ME_WITH_USERNAME>
    hive.metastore.datasource.password=<REPLACE_ME_WITH_PASSWORD>

    nifi.service.mysql.database_user=<REPLACE_ME_WITH_USERNAME>
    nifi.service.mysql.password=<REPLACE_ME_WITH_PASSWORD>
    nifi.service.kylo_mysql.database_user=<REPLACE_ME_WITH_USERNAME>
    nifi.service.kylo_mysql.password=<REPLACE_ME_WITH_PASSWORD>

    #Note: The value for this property is the password for the dladmin user.
    nifi.service.kylo_metadata_service.rest_client_password=<REPLACE_ME_WITH_PASSWORD>

    modeshape.datasource.username=${spring.datasource.username}
    modeshape.datasource.password=${spring.datasource.password}
    metadata.datasource.username=${spring.datasource.username}
    metadata.datasource.password=${spring.datasource.password}

..


Kylo Cloudera Demo Sandbox Example
----------------------------------
The configuration is setup to work out of the box with the Kylo Hortonworks sandbox. There are a few differences that require configuration changes for Cloudera.


1. /opt/kylo/kylo-services/conf/application.properties


.. code-block:: properties

    spring.datasource.username=<REPLACE_ME_WITH_USERNAME>
    spring.datasource.password=<REPLACE_ME_WITH_PASSWORD>

    hive.datasource.username=<REPLACE_ME_WITH_PASSWORD>
    hive.metastore.datasource.username=REPLACE_ME_WITH_USERNAME
    hive.metastore.datasource.password=<REPLACE_ME_WITH_PASSWORD>
    hive.metastore.datasource.url=jdbc:mysql://localhost:3306/metastore
    config.hive.schema=metastore

    nifi.service.mysql.database_user=REPLACE_ME_WITH_USERNAME
    nifi.service.mysql.password=<REPLACE_ME_WITH_PASSWORD>
    nifi.service.kylo_mysql.database_user=REPLACE_ME_WITH_USERNAME
    nifi.service.kylo_mysql.password=<REPLACE_ME_WITH_PASSWORD>
    nifi.service.kylo_metadata_service.rest_client_password=<REPLACE_ME_WITH_PASSWORD>
    nifi.executesparkjob.sparkhome=/usr/lib/spark
    config.spark.validateAndSplitRecords.extraJars=/usr/lib/hive-hcatalog/share/hcatalog/hive-hcatalog-core.jar

    modeshape.datasource.username=${spring.datasource.username}
    modeshape.datasource.password=${spring.datasource.password}
    metadata.datasource.username=${spring.datasource.username}
    metadata.datasource.password=${spring.datasource.password}

..



2. Spark configuration

.. code-block:: shell

    # Allow Spark to access Hive
    cp -n /etc/hive/conf/hive-site.xml /etc/spark/conf/hive-site.xml

    # Snappy isn't working well for Spark on Cloudera
    echo "spark.io.compression.codec=lz4" >> /etc/spark/conf/spark-defaults.conf

    # If using Spark 2, enable support in Kylo
    echo "config.spark.version=2" >> /opt/kylo/kylo-services/conf/application.properties
..



