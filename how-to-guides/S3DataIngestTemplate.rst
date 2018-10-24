===========================
S3 Standard Ingest Template
===========================

.. contents:: Table of Contents

Problem
=======

You would like to ingest data from a S3 data source into Hive tables backed by S3 external folders without the data files traveling through the NiFi edge nodes. 

Introduction
============

The Data Ingest S3 template is a variation of the standard Data Ingest template within Kylo.  The standard template utilizes HDFS backed hive tables, accepts inputs from local files, and is designed to run on a Cloudera or Hortonworks sandbox.  By contrast, the Data Ingest S3 template utilizes S3 backed hive tables, accepts inputs from an S3 bucket and is designed for use on an AWS stack utilizing EC2 and EMR.  You can also use it with hadoop distributions other than EMR.  For simplicity’s sake, this document shows starting in section 2 how to use the HDP cluster that comes on our AWS Kylo Sandbox.  The S3 ingest template has improved performance in that data on s3 is not brought into the Nifi node.  In order to accommodate these changes, the ExecuteHQLStatement processor has been updated and a new processor, CreateElasticsearchBackedHiveTable, has been created.

1. S3 Data Ingest Template Overview
===================================
The template has two parts. The first is a non-reusable part that is created for each feed. This is responsible for getting the input location of the data in S3 as well as setting properties that will be used by the reusable portion of the template. The second is the reusable template. The reusable template creates the hive tables. It also merges, validates, profiles, and indexes the data.

The template is very similar to the HDFS standard ingestion template. The differences are outlined in the following sections.

1.1 Template processors pull defaults from application.properties
-----------------------------------------------------------------
Creating feeds from the S3 template is simplified by adding default values into Kylo's /opt/kylo/kylo-services/conf/application.properties.   

**config.s3ingest.s3.protocol**
  The protocol to use for your system. e.g. The hortonworks sandbox typically uses "s3a", EMR using an EMRFS may use "s3"
**config.s3ingest.es.jar_url**
  The location of the elasticsearch-hadoop jar.  Use an S3 location accessible to the cluster.
**config.s3ingest.apach-commons.jar_url**
  The location of the commons-httpclient-3.1.jar.  Use an S3 location accessible to the cluster.
**config.s3ingest.hiveBucket**
  This property is the name output bucket where the data ends up. Hive will generate the folder structure within it.  Note: This bucket must have something in it. Hive cannot create folders within an empty S3 bucket.
**config.s3ingest.es.nodes**
  A comma separated list of Elasticsearch nodes that will be connected to.
**config.s3ingest.hive.metastore_warehouse_location**
  The location for the hive metastore warehouse found in hive-site.xml

For Example settings see below.

1.2 Non-reusable portion of template
------------------------------------
1.2.1 List S3
~~~~~~~~~~~~~

Rather than fetching the data and bringing it into the Nifi node the first few properties get the location of the input data and pass the data location to subsequent processors.

**Bucket**
  This is the S3 bucket where the input data is located.  Note: The data files should be in a folder at the root level of the bucket.
**Region**
  The region of the input S3 bucket.
**Prefix**
  The "path" or "sub directory" within the bucket that will receive input files. Be sure the value ends with a trailing slash.

1.2.2 Initialize Feed Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Just like in the Standard ingestion template, this processor sets the attributes that will be used by the reusable portion of the template. There are several parameters that have been added to accommodate changes made to the template for S3 integration:

**InputFolderName:=<the path portion of the filename>**
  The input folder name will be used by the create feed partition processor in the reusable flow.
**s3ingest.apache-commons.jar_url:=${config.s3ingest.apache-commons.jar_url}**
  The location of the commons-httpclient.jar.  Use an S3 location accessible to the cluster.
**s3ingest.es.jar_url:=${config.s3ingest.es.jar_url}**
  The location of the elasticsearch-hadoop.jar.  Use an S3 location accessible to the cluster.
**s3ingest.hiveBucket:=${config.3ingest.hiveBucket}**
  This property is the name output bucket where the data ends up. Hive will generate the folder structures within it.  Note: Hive cannot create folders into a fresh bucket that has not had objects written to it before. Prime the pump on new S3 buckets by uploading and deleting a file.
**s3ingest.es.nodes:=${config.s3ingest.es.nodes}**
  The comma separated list of node names for your elasticsearch nodes. 
**s3ingest.s3.protocol:=${config.s3ingest.s3.protocol}**
  The protocol your cluster will use to access the S3 bucket. (e.g. 's3a')
**s3ingest.hive.metastore_warehouse_location:=${config.s3ingest.hive.metastore_warehouse_location}**
  The location for the hive metastore warehouse found in hive-site.xml

1.2.3 DropInvalidFlowFile
~~~~~~~~~~~~~~~~~~~~~~~~~
When ListS3 scans a bucket, the first time it sees an object that represents the folder you specified in the Prefix it creates a flow file.  Since this flow file is not a data file it will not process correctly in the flow and should be removed.

1.2.4 Initialize Cleanup Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The clean up flow needs to know the name of the Hive bucket in order to clean it so the s3ingest.hiveBucket property has been added to this processor.

1.3 Reusable portion of Template
--------------------------------

1.3.1 Register Tables
~~~~~~~~~~~~~~~~~~~~~

This processor creates S3 backed hive tables for storing valid, invalid, feed, profile, and master data.
Feed Root Path, Profile Root Path, and Master Root Path define the location of their respective tables.  Each of these properties will use the protocol you specified in s3ingest.protocol (s3, s3n, or s3a).  The protocol must be supported by you cluster distribution.

1.3.2 Route if Data to Create ES Table
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This processor routes the flow to the CreateElastisearchBackedHiveTable processor if the metadata.table.fieldIndexString property has been set. Otherwise, the CreateElastisearchBackedHiveTable processor is skipped.
 
1.3.3 CreateElasticsearchBackedHiveTable
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This processor creates an elasticsearch backed hive table for indexing data that will be searchable from with in the Kylo UI. A description of this processor and it's properties can be found here: CreateElasticsearchBackedHiveTable
Create Feed Partition
In the statement for this processor the protocol for the s3 location may need to be updatad to use a protocol supported by the distribution being used.

1.3.4 Set Feed Defaults
~~~~~~~~~~~~~~~~~~~~~~~

The following property has been modified:

**filename**
  The filename property will later be used by Failed Flow processor when the flowfile is placed into the temp location.  Since filename coming from the ListS3 processor in the feed flow includes path information, it is stripped of that here.

1.3.5 Create Feed Partition
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ALTER TABLE statement has been modified to include the InputFolderName


1.3.6 ExecuteHQLStatement
~~~~~~~~~~~~~~~~~~~~~~~~~

We have updated the ExecuteHQLStatement processor to run Hive statements they just need to be separated by a semi-colon (";").  This allows us to add the elasticsearch-hadoop jar using the config.s3ingest.es.jar_url property. This particular processor inserts the data to be indexed into the elasticsearch backed hive table. It executes the following statements:

:: 

  ADD JAR ${config.s3ingest.es.jar_url};
  ADD JAR ${config.s3ingest.apache-commons.jar_url};
  INSERT INTO TABLE ${category}.${feed}_index SELECT ${metadata.table.fieldIndexString},processing_dttm FROM ${category}.${feed}_valid

1.3.5 Merge Table
~~~~~~~~~~~~~~~~~

The Merge Table processor will merge the incoming data with the master table, based on the merge strategy you choose. 

1.3.4.1 Sync Merge Strategy
+++++++++++++++++++++++++++

If you encounter an error similar to:: 

  2017-06-21 20:50:42,430 ERROR [Timer-Driven Process Thread-4] c.t.ingest.TableMergeSyncSupport Failed to execute alter table `category_name`.`feed_name_1498078145646` RENAME TO `catgeory_name`.`feed_name` with error
  java.sql.SQLException: Error while processing statement: FAILED: Execution Error, return code 1 from org.apache.hadoop.hive.ql.exec.DDLTask. Unable to alter table. Alter Table operation for <category_name>.<feed_name>_1498078145646 failed to move data due to: 'Renaming s3a://${hiveS3Bucket}/${hive.root.master}/<category_name>/<feed_name>_1498078145646 to s3a://hiveS3Bucket/${hive.metastore.warehouse.dir}/${category_name}.db/<feed_name> failed' See hive log file for details.

Note that hive.root.master is a feed property and that hive.metastore.warehouse.dir is a property from your hive-site.xml.  In versions of Hive prior to 2.2.0 the HDFS location of a managed table, with a LOCATION clause, will be moved and that Hive derives the new location using the hive.metastore.warehouse.dir and the schema_name with a .db suffix.  
Be sure that you have set the properties ``mapred.input.dir.recursive=true`` and ``hive.mapred.supports.subdirectories=true`` in your hive-site.xml.

1.3.6 DeleteS3Object
~~~~~~~~~~~~~~~~~~~~
This processor replaces the RemoveHDFSFolder processor in standard ingest.  It is analgous in that it takes the attributes from earlier in the flow and uses them to calculate the objects in the S3bucket that need to be removed and performs the delete operation.

2. Sandbox Walk-Through
=======================

2.1 Prerequisites
-----------------

Download the required JARS for Hive to write table data to ElasticSearch.  You can find these in Maven Central at `Maven Central: Elasticsearch Hadoop 5.5.3 Jars <https://mvnrepository.com/artifact/org.elasticsearch/elasticsearch-hadoop/5.5.3>`_ and `Maven Central: Apache Commons HTTP 3.1 Jars <https://mvnrepository.com/artifact/commons-httpclient/commons-httpclient/3.1>`_.  Once you've downloaded thema you should place them in a folder within your hive bucket.  In the end you should have jars available in S3 and the following commands should produce a good result (see `Install the AWS Command Line Interface on Linux <https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html>`_ to install AWS CLI on your edge node) :

.. code-block:: shell

  aws s3 ls s3://hive-bucket/jars/elasticsearch-hadoop-5.5.3.jar
  aws s3 ls s3://hive-bucket/jars/commons-httpclient-3.1.jar

..

2.2  Launch an EC2 instance using the Sandbox AMI
-------------------------------------------------

  The S3 template was developed using the 0.8.1 sandbox but relies on code changes released in the 0.8.2 release.  Go to AWS Market place and find the 0.8.2 or later sandbox for your region and launch the instance (refer to https://kylo.io/quickstart-ami.html for the AMI id of the latest sandbox).  Wait 15 minutes or more for nifi service and kylo services to start.  Now shut down Nifi so we can change cluster configs and will need to refresh the NiFi connections to the cluster. Shut down Kylo and Nifi so we can configure these services in later sections. 

.. code-block:: shell

  service nifi stop
  /opt/kylo/stop-kylo-apps.sh 

..

2.3 Configuring core-site.xml and hive-site.xml
-----------------------------------------------

In the core-site.xml where your data is to be processed make sure that your fs.s3 properties are set.

.. note::
 
  * for s3 use ``fs.s3.awsAccessKeyId`` and ``fs.s3.awsSecretAccessKey``
  * for s3n use ``fs.s3n.awsAccessKeyId`` and ``fs.s3n.awsSecretAccessKey``
  * for s3a use  ``fs.s3a.access.key`` and ``fs.s3a.secret.key``

  Depending on what distribution you are using the supported protocol may be different (s3, s3n) in which case you would need to use the equivalent property for that protocol.

..

.. warning::

  There are times when AWS SDK will consult the 's3' properties for the keys, regardless of the protocol you use.  To work around the problem define s3 properties in addition to your protocol properties.

..

Open Ambari and go to HDFS -> Configs -> Advanced -> Custom core-site section.  Add the fs.s3a access properties.

.. code-block:: properties

  fs.s3.awsAccessKeyId=XXX
  fs.s3.awsSecretAccessKey=YYY
  fs.s3a.access.key=XXX 
  fs.s3a.secret.key=YYY

..

.. warning::

  Your cluster may not have been configured for Spark or Hive to read properties from core-site.xml.  In which case you may need to add the properties to one or more hive-site.xml files.

  For Hive, go to Ambari and do this via the UI at 'Hive -> Configs -> Advanced -> Custom hive-site'

  For Spark, manually edit the hive-site.xml files (which will be overwritten if Ambari restarts spark services, the Ambari section to maintain these properties is not currently working in HDP-2.6.5.0 and this bug has been observed by others https://community.hortonworks.com/questions/164800/spark2-custom-properties-in-hive-sitexml-are-ignor.html )

  The hive-site xml files are: /etc/spark/conf/hive-site.xml, /etc/spark2/conf/hive-site.xml

Beware that if you restart 

..


Go to Hive -> Configs -> Advanced -> Custom hive-site section.  Add the mapred.input.dir.recursive and hive.mapred.supports.subdirectories properties.

.. code-block:: properties

  mapred.input.dir.recursive=true
  hive.mapred.supports.subdirectories=true

..

Stop all services in the cluster.  Start all services. 

2.4 Get Nifi Ready
------------------

.. code-block:: shell

 service nifi start

..

Go into Nifi UI and open up the Process Group Configuration and create a new AWSCredentialsProviderControllerService under the Controller Services tab.  This service will be utilized by the various S3 processors to access the configured S3 buckets.  Add your Access Key and Secret Key to the named parameters.

2.5 Get Kylo Ready
------------------

Edit /opt/kylo/kylo-services/conf/application.properties and edit your settings.  Append your template defaults.   Example settings:

.. code-block:: properties

  config.s3ingest.s3.protocol=s3a
  config.s3ingest.hiveBucket=hive-bucket
  config.s3ingest.es.jar_url=s3a://hive-bucket/jars/elasticsearch-hadoop-5.5.3.jar
  config.s3ingest.apache-commons.jar_url=s3a://hive-bucket/jars/commons-httpclient-3.1.jar
  config.s3ingest.es.nodes=localhost
  config.s3ingest.hive.metastore_warehouse_location=/hive_warehouse

..

Start Kylo

.. code-block:: shell

  /opt/kylo/start-kylo-apps.sh 

..

2.6 Import the Template
---------------------------------------
Go to Admin -> Templates section of Kylo.  Import the 'S3 Data Ingest' bundle from the kylo source repo path: `samples/templates/nifi-1.0/s3_data_ingest.template.zip`, making sure to import the reusable portion as well as overwriting any previous versions of the template.

2.7 Create the Data Ingest Feed
-------------------------------

Create a category called "S3 Feeds" to place your new feed.   Create a feed and provide the following feed inputs:

**Bucket**
  This is the name of your S3 bucket for input data.  e.g. "myInputBucket"
**Region**
  This is the region where your servers operate.   e.g. us-east-1
**s3ingest.hiveBucket**
  This is the name of your S3 bucket for the various hive tables e.g. "myHiveBucket".  It appears twice as it will be initilaized for the feed flow and the cleanup flow. It should be defaulted to the value you set in application.properties.
**prefix**
  This is the folder in the S3 input bucket to search for input files.   The default bucket will look in a folder with the same system name as the feed you are creating: "${metadata.systemFeedName}/"

2.8 Test the Feed 
-----------------

In the S3 bucket you configured for the feed, manually create an input folder with the name you provided for 'prefix' in the feed.  This is where the inputs for the feed should be placed.  Put a data file in this folder and check Kylo to ensure your feed ran successfully!

.. note::  The ListS3 processor in the feed template will, by design, keep state information about which files it has seen in your folder (the 'systemFeedName' folder you created in S3).  Consult Apache NiFi's istS3 processor documentation for more info.  This means that the feed only processes the data of the folder once, and again when the S3 folder contents change.

3. Helpful Tips
===============

3.1 SQL Exceptions from Hive unable to reach Elastic Search
-----------------------------------------------------------

If you used a value other than localhost for `config.s3ingest.es.nodes` then be sure your elastic search server has been configured to listen on that interface or you may see an error like:

|    2018-07-10 17:54:52,150 ERROR [Timer-Driven Process Thread-6] c.t.n.v.i.CreateElasticsearchBackedHiveTable CreateElasticsearchBackedHiveTable[id=609d71e2-015c-1000-dae6-aa4f4b1be180] Unable to execute SQL DDL [ADD JAR s3a://<..snip..>, CREATE EXTERNAL TABLE IF NOT EXISTS <..snip..> for StandardFlowFileRecord[uuid=<..snip..>] due to java.sql.SQLException: Error while processing statement: FAILED: Execution Error, return code 1 from org.apache.hadoop.hive.ql.exec.DDLTask.  org.elasticsearch.hadoop.EsHadoopIllegalArgumentException: Cannot detect ES version - typically this happens if the network/Elasticsearch cluster is not accessible or when targeting a WAN/Cloud instance without the proper setting 'es.nodes.wan.only'; routing to failure

This error comes from Hive attempting to write data to an Elastic Search index. You can modify the interfaces that elastic will respond on by editing your elasticsearch.yml config (e.g. `vim /etc/elasticsearch/elasticsearch.yml`) and change `network.host: 0.0.0.0`, which will instruct elastic to listen on all interfaces (often this is safe to do if you have used AWS VPC rules to restrict network between edge and cluster nodes, otherwise consider carefully the ramifications of opening your server to listen on interfaces other than just localhost).  Be sure to restart elastic after the configs have been modified `service elasticsearch restart`.

Test your connection from your cluster's nodes before running your next feed e.g. `telnet 172.X.X.X 9200`


4. Further Reference
====================

* `Configure Apache Hive to Recursively Search Directories for Files <https://joshuafennessy.com/2015/06/30/configure-apache-hive-to-recursively-search-directories-for-files/>`_
* `Hadoop-AWS module: Integration with Amazon Web Services  <https://hadoop.apache.org/docs/r2.8.0/hadoop-aws/tools/hadoop-aws/index.html#S3A_Authentication_methods>`_
* `LanguageManual DDL: Rename Table <https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-RenameTable>`_
* `Maven Central: Elasticsearch Hadoop Jars <https://mvnrepository.com/artifact/org.elasticsearch/elasticsearch-hadoop>`_
* `Maven Central: Apache Commons HTTP Jars <https://mvnrepository.com/artifact/commons-httpclient/commons-httpclient>`_
