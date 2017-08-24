
==========================================================
Setup Wizard Configuration Guide for Cloudera
==========================================================

The configuration is setup to work out of the box with the Hortonworks
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


Templates / System feeds
========================

1. index_schema_service
    - Update "Set parameters" processor, set:
        - hive.schema = {config.hive.schema}