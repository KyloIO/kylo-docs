
=======================
Cloudera Services Check
=======================

Describe what is shown here:

.. code-block:: properties

    clouderaRestClientConfig.username=cloudera
    clouderaRestClientConfig.password=cloudera
    clouderaRestClientConfig.serverUrl=127.0.0.1
    cloudera.services.status=

..

Explain:

HDFS/[DATANODE,NAMENODE,SECONDARYNAMENODE],HIVE/[HIVEMETASTORE,HIVESERVER2],YARN,SQOOP

Server Port
-----------

Explain:

.. code-block:: properties

    server.port=8420
    server.port=8443

..

Add if SSL is Needed
====================

Explain:

.. code-block:: properties

    #server.ssl.key-store=/Users/sr186054/tools/test-ssl/test/localhost/keystore.jks
    #server.ssl.key-store-password=sxkJ96yw2ZZktkVFtflln2IqjxkXPCD+vh3gAPDhQ18
    #server.ssl.key-store-type=jks
    #server.ssl.trust-store=/Users/sr186054/tools/test-ssl/test/localhost/truststore.jks
    #server.ssl.trust-store-password=S1+cc2FKMzk2td/p6OJE0U6FUM3fV5jnlrYj46CoUSU
    #server.ssl.trust-store-type=JKS

..

General Configuration

Describe this section.

.. note:: Supported configurations include: STANDALONE, BUFFER_NODE_ONLY, BUFFER_NODE, EDGE_NODE.

.. code-block:: properties

    application.mode=STANDALONE

..

Turn on debug mode to display more verbose error messages in the UI.

.. code-block:: properties

    application.debug=true

..

Prevents execution of jobs at startup. Change to true, and provide the name of the job that should be run at startup if we want that behavior

.. code-block:: properties

    spring.batch.job.enabled=false
    spring.batch.job.names=
    spring.jpa.show-sql=true
    spring.jpa.hibernate.ddl-auto=validate

..

.. note:: For Cloudera, metadata.datasource.password=cloudera is required.

.. code-block:: properties

    metadata.datasource.driverClassName=org.mariadb.jdbc.Driver
    metadata.datasource.url=jdbc:mysql://localhost:3306/kylo
    metadata.datasource.username=root
    metadata.datasource.password=hadoop
    metadata.datasource.validationQuery=SELECT 1
    metadata.datasource.testOnBorrow=true

..

.. note:: For Cloudera hive.datasource.username=hive is required.

.. code-block:: properties

    hive.userImpersonation.enabled=false
    hive.datasource.driverClassName=org.apache.hive.jdbc.HiveDriver
    hive.datasource.url=jdbc:hive2://localhost:10000/default
    hive.datasource.username=hive
    hive.datasource.password=hive
    hive.datasource.validationQuery=show tables 'test'

..

.. note:: For Cloudera, hive.metastore.datasource.password=cloudera is required.

          Also the Cloudera url should be /metastore instead of /hive.

.. code-block:: properties

    hive.metastore.datasource.driverClassName=org.mariadb.jdbc.Driver
    hive.metastore.datasource.url=jdbc:mysql://localhost:3306/hive
    hive.metastore.datasource.url=jdbc:mysql://localhost:3306/metastore
    hive.metastore.datasource.username=root
    hive.metastore.datasource.password=hadoop
    hive.metastore.datasource.validationQuery=SELECT 1
    hive.metastore.datasource.testOnBorrow=true
    modeshape.datasource.driverClassName=org.mariadb.jdbc.Driver
    modeshape.datasource.url=jdbc:mysql://localhost:3306/kylo
    modeshape.datasource.username=root
    modeshape.datasource.password=hadoop
    nifi.rest.host=localhost
    nifi.rest.port=8079

..
