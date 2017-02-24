
========================
NiFi HTTPS Configuration
========================

Follow the directions provided at https://wiki.thinkbiganalytics.com/x/twHK to
setup certificates and properties in NiFi.

The port should match the port found in the
/opt/nifi/current/conf/nifi.properties (nifi.web.https.port)

.. code-block:: properties

    nifi.rest.port=9443
    nifi.rest.https=true
    nifi.rest.useConnectionPooling=false
    nifi.rest.truststorePath=/opt/nifi/data/ssl/localhost/truststore.jks

..

The truststore password below needs to match that found in the
nifi.properties file (nifi.security.truststorePasswd):

.. code-block:: properties

    nifi.rest.truststorePassword=Zl1mAbMm0v4UkGV8VYjTi2ZP8NdwUL9CW7nsjGo47Fs
    nifi.rest.truststoreType=JKS
    nifi.rest.keystorePath=/opt/nifi/data/ssl/CN=kylo_OU=NIFI.p12

..

Value found in the .password file

.. code-block:: properties

    /opt/nifi/data/ssl/CN=kylo_OU=NIFI.password
    nifi.rest.keystorePassword=ydPkkba
    nifi.rest.keystoreType=PKCS12

..

Question: Is this a new section?

.. code-block:: properties

    elasticsearch.host=localhost
    elasticsearch.port=9300
    elasticsearch.clustername=demo-cluster
    kerberos.hive.kerberosEnabled=false
    kerberos.hive.hadoopConfigurationResources=/etc/hadoop/conf/core-site.xml,/etc/hadoop/conf/hdfs-site.xml
    kerberos.hive.kerberosPrincipal=hive/sandbox.hortonworks.com
    kerberos.hive.keytabLocation=/etc/security/keytabs/hive-thinkbig.headless.keytab

..

Used to map Nifi Controller Service connections to the User Interface

The naming convention for the property is
nifi.service.NIFI_CONTROLLER_SERVICE_NAME.NIFI_PROPERTY_NAME

Anything prefixed with nifi.service will be used by the UI. Replace
Spaces with underscores and make it lowercase.

.. code-block:: properties

    nifi.service.mysql.database_user=root
    nifi.service.mysql.password=hadoop
    nifi.service.hive_thrift_service.database_connection_url=jdbc:hive2://localhost:10000/default
    nifi.service.hive_thrift_service.kerberos_principal=nifi
    nifi.service.hive_thrift_service.kerberos_keytab=/etc/security/keytabs/nifi.headless.keytab
    nifi.service.hive_thrift_service.hadoop_configuration_resources=/etc/hadoop/conf/core-site.xml,/etc/hadoop/conf/hdfs-site.xml
    nifi.service.kylo_metadata_service.rest_client_url=http://localhost:8400/proxy/v1/metadata
    nifi.service.kylo_metadata_service.rest_client_password=thinkbig
    jms.activemq.broker.url=tcp://localhost:61616
    jms.client.id=thinkbig.feedmgr

..

NiFi Property Override with Static Defaults
===========================================

Static property override supports three use cases:

    1. Store properties in the file starting with the prefix defined in the "PropertyExpressionResolver class" default = config.

    2. Store properties in the file starting with "nifi.<PROCESSORTYPE>.<PROPERTY_KEY> where PROCESSORTYPE and PROPERTY_KEY are all lowercase and the spaces are substituted with underscore.

    3. Global property replacement. properties starting with "nifi.all_processors.<PROPERTY_KEY> will globally replace the value when the template is instantiated.

Below are Ambari configuration options for Hive Metastore and Spark location:

.. code-block:: properties

    config.hive.schema=hive
    config.metadata.url=http://localhost:8400/proxy/v1/metadata

..

Spark Configuration
===================

.. code-block:: properties

    nifi.executesparkjob.sparkhome=/usr/hdp/current/spark-client
    nifi.executesparkjob.sparkmaster=local
    nifi.executesparkjob.driver_memory=1024m
    nifi.executesparkjob.number_of_executors=1
    nifi.executesparkjob.executor_cores=1

..

Specify to override the default HDFS locations for feed tables and multi-tenancy.

Root HDFS locations for new raw files:

.. code-block:: properties

    config.hdfs.ingest.root=/etl

..

Root HDFS location for Hive ingest processing tables (raw,valid,invalid):

.. code-block:: properties

    config.hive.ingest.root=/model.db

..

Root HDFS location for Hive profile table:

.. code-block:: properties

    config.hive.profile.root=/model.db

..

Root HDFS location for Hive master table:

.. code-block:: properties

    config.hive.master.root=/app/warehouse

..

Prefix to prepend to category system name for this environment (blank if none). Use for multi-tenancy:

.. code-block:: properties

    config.category.system.prefix=

..

Set the JMS server hostname for the Kylo hosted JMS server:

.. code-block:: properties

    config.elasticsearch.jms.url=tcp://localhost:61616

..

Example of replacing global properties:

.. code-block:: properties

    nifi.all_processors.kerberos_principal=nifi
    nifi.all_processors.kerberos_keytab=/etc/security/keytabs/nifi.headless.keytab
    nifi.all_processors.hadoop_configuration_resources=/etc/hadoop/conf/core-site.xml,/etc/hadoop/conf/hdfs-site.xml

..

Cloudera Config
===============

.. code-block:: properties

    config.hive.schema=metastore
    nifi.executesparkjob.sparkhome=/usr/lib/spark

..

How often should SLAs be checked:

.. code-block:: properties

    sla.cron.default=0 0/5 * 1/1 * ? *

..

Additional Hive UDFs for partition functions. Separate multiple functions with commas.

.. code-block:: properties

    kylo.metadata.udfs=

..
