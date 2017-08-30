=========================
Additional Configuration
=========================
Before starting Kylo you will want to make sure the configuration is correct. Some common cases of when you would want to change the defaults is

    1. Database configuration
    3. Hive thrift connection configuration

Edit the Properties Files
-------------------------
There are 3 main properties files for Kylo

.. code-block:: shell

    $ vi /opt/kylo/kylo-services/conf/application.properties

    $ vi /opt/kylo/kylo-services/conf/spark.properties

    $ vi /opt/kylo/kylo-ui/conf/application.properties

..

For more details on the properties please see :doc:`../how-to-guides/ConfigurationProperties`


Cloudera Configuration
------------------------
The configuration is setup to work out of the box with the Kylo Hortonworks
sandbox. There are a few differences that require configuration changes
for Cloudera.

1. /opt/kylo/kylo-services/conf/application.properties


   a. Update the MySQL password values to "cloudera":

.. code-block:: properties

        spring.datasource.password=cloudera
        metadata.datasource.password=cloudera
        modeshape.datasource.password=cloudera
        nifi.service.mysql.password=cloudera
        hive.metastore.datasource.password=cloudera
..

    b. Update the Hive configuration:

.. code-block:: properties

        hive.datasource.username=hive
        hive.metastore.datasource.url=jdbc:mysql://localhost:3306/metastore
        config.hive.schema=metastore

..

    c. Update the Spark libraries:

.. code-block:: properties

        nifi.executesparkjob.sparkhome=/usr/lib/spark

        config.spark.validateAndSplitRecords.extraJars=/usr/lib/hive-hcatalog/share/hcatalog/hive-hcatalog-core.jar

..

2. Spark configuration

.. code-block:: shell

    cp /etc/hive/conf/hive-site.xml /etc/spark/conf/hive-site.xml

    # Snappy isn't working well for Spark on Cloudera
    echo "spark.io.compression.codec=lz4" >> /etc/spark/conf/spark-defaults.conf
..



