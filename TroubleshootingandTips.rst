
======================
Troubleshooting & Tips
======================
  

Tuning the ExecuteSparkJob Processor
====================================

Problem
-------

By default, the ExecuteSparkJob processor is configured to run in
*local* or *yarn-client* mode. When a Hadoop cluster is available, it is
recommended that the properties be updated to make full use of the
cluster.

Solution
--------

Your files and jars should be made available to Spark for distributing
across the cluster. Additional configuration may be required for Spark
to run in *yarn-cluster* mode.

1. Add the DataNucleus jars to the “Extra Jars” parameter:

   a. /usr/hdp/current/spark-client/lib/datanucleus-api-jdo-x.x.x.jar

   b. /usr/hdp/current/spark-client/lib/datanucleus-core-x.x.x.jar

   c. /usr/hdp/current/spark-client/lib/datanucleus-rdbms-x.x.x.jar

2. Add the hive-site.xml file to the “Extra Files” parameter:

   a. For Cloudera, this file is at
      /etc/hive/conf.cloudera.hive/hive-site.xml.

   b. For Hortonworks, this file is at
      /usr/hdp/current/spark-client/conf/hive-site.xml.

3. The “Validate and Split Records” processor from standard-ingest
   requires access to the json policy file. Add
   “${table\_field\_policy\_json\_file}” to the “Extra Files”
   property to make this file available.

    |image1|

4. The “Execute Script” processor from the data-transformation reusable
   template requires access to the Scala script.

   a. Change “MainArgs” to:
      ``${transform_script_file:substringAfterLast('/')}``

   b. Add the following to “Extra Files”: ``${transform_script_file}``

Additionally, you can update your Spark configuration with the
following:

1. It is ideal to have 3 executors per node minus 1 used by the manager:

   a. num-executor = 3 \* (number of nodes) - 1

2. Executor cores should be either 4, 5, or 6 depending on the total number
   of available cores. This should be tested. Starting with 6 tends
   to work well:

   a. spark.executor.cores = 6

3. Determine the total memory using the following equation:

   a. total.memory (GB) = yarn.nodemanager.resource.memory-mb \*
      (spark.executor.cores / yarn.nodemanager.resource.cpu-vcores)

4. Use total.memory and split it between spark.executor.memory and
   spark.yarn.executor.memoryOverhead (15-20% of total memory):

   a. spark.yarn.executor.memoryOverhead = total.memory \* (0.15)

   b. spark.executor.memory = total.memory
      - spark.yarn.executor.memoryOverhead

Dealing with non-standard file formats
======================================

Problem
-------

You need to ingest a file with a non-standard format.

Solution
--------

There are two possible solutions:

1. You may write a custom SerDe and register that SerDe in HDFS. Then
   specify the use of the SerDe in the source format field of the
   schema tab during feed creation.

   a. Here’s an example SerDe that reads ADSB files:
      https://github.com/gm310509/ADSBSerDe

   b. The dependencies in the pom.xml file may need to be changed to
      match your Hadoop environment.

2. You can use two feeds: 1) ingest; 2) use the wrangler to
   manipulate the fields into columns:

   a. Create an ingest field, manually define the schema as a single
      field of type string. You can just call that field "data"

   b. Make sure the format specification doesn't conflict with data in
      the file, i.e. tabs or commas which might cause it to get split

   c. Once ingested, create a data transform feed to wrangle the data
      using the transform functions

   d. Here's an example of converting the weird ADSB format into JSON
      then converting into fields:

.. code-block:: js
   :linenos:

    select(regexp_replace(data, "([\\w-.]+)\t([\\w-.]+)", "\"$1\":\"$2\"").as("data"))
    select(regexp_replace(data, "\" *\t\"", "\",\"").as("data"))
    select(concat("{", data, "}").as("data"))
    select(json_tuple(data, "clock", "hexid", "ident", "squawk", "alt", "speed", "airGround", "lat", "lon", "heading"))
    select(c0.as("clock"), c1.as("hexid"), c2.as("ident"), c3.as("squawk"), c4.as("alt"), c5.as("speed"), c6.as("airGround"), c7.as("lat"), c8.as("lon"), c9.as("heading"))

Indexing categories and feeds
=============================

Problem
-------

You need to index specific fields of categories and/or feeds.

Solution
--------

This is a two-step process involving adding the required Maven
dependencies to the Kylo project and updating
the kylo-services configuration.

1. Plugins are available for indexing with ElasticSearch or Lucene
   (including Solr). One of these must be added as a dependency to
   the metadata/metadata-modeshape/pom.xml file.

   a. For ElasticSearch:

.. code-block:: shell

      <dependency>
          <groupId>org.modeshape</groupId>
          <artifactId>modeshape-elasticsearch-index-provider</artifactId>
          <version>${modeshape.version}</version>
      </dependency>

..

    a. For Lucene (including Solr):

.. code-block:: shell

      <dependency>
          <groupId>org.modeshape</groupId>
          <artifactId>modeshape-lucene-index-provider</artifactId>
          <version>${modeshape.version}</version>
      </dependency>

..

2. Indexes are defined in
   the /opt/kylo/kylo-services/conf/metadata-repository.json file.
   Each index must specify a node type (tba:category or tba:feed)
   and a comma-separated list of columns to be indexed. User-defined
   properties must be URL-encoded and prefixed with ``usr:``. As an
   example, add the following properties to
   the metadata-repository.json file:

.. code-block:: shell

      {
          "indexes": {
              "category": {
                  "columns": "jcr:title(STRING), jcr:description(STRING)",
                  "kind": "text",
                  "nodeType": "tba:category",
                  "provider": "local"
              },

              "feed": {
                  "columns": "jcr:title(STRING), jcr:description(STRING), tba:tags(STRING)",
                  "kind": "text",
                  "nodeType": "tba:feed",
                  "provider": "local"
              }
          },
          "indexProviders": {
              "local": {
                  "classname": "org.modeshape.jcr.index.elasticsearch.EsIndexProvider",
                  "host": "localhost",
                  "port": 9200
              }
          }
      }

..

Merge Table fails when storing as Parquet using HDP
===================================================

Problem
-------

There is a bug with Hortonworks where a query against a Parquet backed
table fails while using single or double quotes in the value names. For
example: 

.. code-block:: none

    hive> select * from users_valid where processing_dttm='1481571457830';
    OK
    SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
    SLF4J: Defaulting to no-operation (NOP) logger implementation
    SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
    Failed with exception java.io.IOException:java.lang.IllegalArgumentException: Column [processing_dttm] was not found in schema!

Solution
--------

You need to set some Hive properties for queries to work in Hive. These
forum threads explain how to set the correct property:

1. https://community.hortonworks.com/questions/47897/illegalargumentexception-when-select-with-where-cl.html

2. https://community.hortonworks.com/questions/40445/querying-a-partition-table.html

3. On the Hive command line you can set the following property to allow
   quotes:

.. code-block:: none

   set hive.optimize.ppd = false;

NiFi becomes non-responsive
===========================

Problem
-------

NiFi appears to be up but the UI is no longer functioning. NiFi may be
running low on memory.  There may be PID files in the /opt/nifi/current
directory.

Solution
--------

Increase memory to NiFi by editing
/opt/nifi/current/conf/boostrap.conf and setting the following line:

.. code-block:: shell

   java.arg.3=-Xmx3g

Additionally, it may also be necessary to create swap space but this is
not recommended by NiFi for performance reasons.

Automated Feed and Template Importing
=====================================

Problem
-------

Feeds and templates should be automatically imported into the staging or
production environment as part of a continuous integration process.

Solution
--------

The Kylo REST API can be used to automate the importing of feeds and
templates.

Templates can be imported either as an XML or a ZIP file. Set
the `overwrite` parameter to `true` to indicate that existing templates
should be replaced otherwise an error will be returned. Set
the `createReusableFlow` parameter to true if the template is an XML file
that should be imported as a reusable template.
The `importConnectingReusableFlow` parameter indicates how to handle a ZIP
file that contains both a template and its reusable flow.
The `NOT_SET` value will cause an error to be returned if the template
requires a reusable flow. The `YES` value will cause the reusable flow to
be imported along with the template. The `NO` value will cause the
reusable flow to be ignored and the template to be imported as normal.

.. code-block:: shell

  curl -F file=@<path-to-template-xml-or-zip> -F overwrite=false -F createReusableFlow=false -F importConnectingReusableFlow=NOT_SET -u <kylo-user>:<kylo-password> http://<kylo-host>:8400/proxy/v1/feedmgr/admin/import-template

..

Feeds can be imported as a ZIP file containing the feed metadata and
NiFi template. Set the `overwrite` parameter to `true` to indicate that an
existing feed and corresponding template should be replaced otherwise an
error will be returned. The `importConnectingReusableFlow` parameter
functions the same as the corresponding parameter for importing a
template.

.. code-block:: shell

      curl -F file=@<path-to-feed-zip> -F overwrite=false -F importConnectingReusableFlow=NOT_SET -u <kylo-user>:<kylo-password> http://<kylo-host>:8400/proxy/v1/feedmgr/admin/import-feed

..

Spark job failing on sandbox with large file
============================================

Problem
-------

If running on a sandbox (or small cluster) the spark executor may get
killed due to OOM when processing large files in the standard ingest
flow. The flow will route to failed flow but there will be no error
message.  Look for Exit Code 137 in /var/log/nifi/nifi-app.log.  This
indicates an OOM issue.

Solution
--------

On a single-node sandbox it is better to run Spark in *local* mode than
*yarn-client* mode and simply give Spark enough memory to perform its
task. This eliminates all the YARN scheduler complications.

1. In the standard-ingest flow, stop and alter the ExecuteSparkJob
   processors:   

   a. Set the SparkMaster property to *local* instead of *yarn-client*.

   b. Increase the Executor Memory property to at least 1024m.

2. Start the processors.

NiFi hangs executing Spark task step
====================================

Problem
-------

Apache NiFi flow appears to be stuck inside the Spark task such as
"Validate and Split Records" step. This symptom can be verified by
viewing the YARN jobs. The Spark job appears to be running and there is
a Hive job queued to run but never launched: http://localhost:8088/cluster

So what is happening?  Spark is executing a Hive job to insert data into
a Hive table but the Hive job never gets YARN resources. This is a
configuration problem that leads to a deadlock. Spark will never
complete because the Hive job will never get launched. The Hive job is
blocked by the Spark job.

Solution
--------

First you will need to clean up the stuck job then re-configure the YARN
scheduler.

To clean up the stuck job, from the command-line as root:

1. Obtain the PID of the Spark job:

.. code-block:: shell

    ps -ef | grep Spark | grep Validator

2. Kill the Spark job:

.. code-block:: shell

    kill <pid>

Configure YARN to handle additional concurrent jobs:

1. Increase the maximum percent with the following parameter
   (see: https://hadoop.apache.org/docs/r0.23.11/hadoop-yarn/hadoop-yarn-site/CapacityScheduler.html):

.. code-block:: shell

    yarn.scheduler.capacity.maximum-am-resource-percent=0.8

2. Restart the cluster or all affected services.

3. Restart Apache NiFi to re-initialized Thrift connection pool:

.. code-block:: shell

    service nifi restart

Note: In Ambari, find this under Yarn \| Configs (advanced) \|
Scheduler.

Spark SQL fails on empty ORC table
==================================

Problem
-------

Your spark job fails when running in HDP 2.4 or 2.5 while interacting
with an empty ORC table. A likely error that you will see is:

.. code-block:: none

    ExecuteSparkJob[id=1fb1b9a0-e7b5-4d85-87d2-90d7103557f6] java.util.NoSuchElementException: next on empty iterator

..

This is due to a change Hortonworks added that modified how it loads the
schema for the table. 

Solution
--------

To fix the issue you can modify the following property

1. On the edge node
   edit /usr/hdp/current/spark-client/conf/spark-defaults.conf

2. Add this line to the file:

.. code-block:: none

    spark.sql.hive.convertMetastoreOrc false

See: https://community.hortonworks.com/questions/44637/spark-sql-fails-on-empty-orc-table-hdp-242.html

High Performance NiFi setup
===========================

Problem
-------

The NiFi team published an article on how to extract the most
performance from Apache NiFi

Solution
--------

See https://community.hortonworks.com/articles/7882/hdfnifi-best-practices-for-setting-up-a-high-perfo.html

RPM install fails with 'cpio: read' error
=========================================

Problem
-------

Kylo rpm install fails giving a 'cpio: read' error.

Solution
--------

This problem occurs if the rpm file is corrupt or not downloaded
properly. Try re-downloading the Kylo rpm from the Kylo website.

Accessing Hive tables from Spark
================================

Problem
-------

You receive a NoSuchTableException when trying to access a Hive table
from Spark.

Solution
--------

Copy the hive-site.xml file from Hive to Spark.

For Cloudera, run the following command:

.. code-block:: shell

    cp /etc/hive/conf/hive-site.xml /usr/lib/spark/conf/

..

Compression codec not found for PutHDFS folder
==============================================

Problem
-------

The PutHDFS processor throws an exception like:

.. code-block:: none

    java.lang.IllegalArgumentException: Compression codec com.hadoop.compression.lzo.LzoCodec not found.

..

Solution
--------

Edit the /etc/hadoop/conf/core-site.xml file and remove the failing
codec from the io.compression.codecs property.

Creating a cleanup flow
=======================

Problem
-------

When deleting a feed it is sometimes useful to run a separate NiFi flow
that will remove any HDFS folders or Hive tables that were created by
the feed.

Solution
--------

1. You will need to have a controller service of type
   JmsCleanupEventService. This service has a Spring Context Service
   property that should be connected to another service of type
   SpringContextLoaderService.

2. In your NiFi template, create a new input processor of type
   TriggerCleanup. This processor will be run automatically when a
   feed is deleted.

3. Connect additional processors such as RemoveHDFSFolder or
   DropFeedTables as needed.

Accessing S3 from the data wrangler
===================================

Problem
-------

You would like to access S3 or another Hadoop-compatible filesystem from
the data wrangler.

Solution
--------

The Spark configuration needs to be updated with the path to the JARs
for the filesystem.

To access S3 on HDP, the following must be added to the spark-env.sh
file:

.. code-block:: shell

   export SPARK_DIST_CLASSPATH=$(hadoop classpath)

.. 

Additional information is available from the Apache Spark project:
https://spark.apache.org/docs/latest/hadoop-provided.html

Dealing with XML files
======================

Problem
-------

You need to ingest an XML file and parse into Hive columns.

Solution
--------

1. You can use two feeds: 1) ingest; 2) use the wrangler to
   manipulate the fields into columns:

   a. Create an ingest field and manually define the schema as a single
      field of type string.  You can just call that field "data".

   b. Make sure the format specification doesn't conflict with data in
      the file, i.e. tabs or commas which might cause it to get split.

   c. Once ingested, create a data transform feed to wrangle the data
      using the transform functions.

   d. Here's an example of converting XML to columns using wrangler
      functions:

XML Explode
-----------

.. code-block:: js
   :linenos:

    select(regexp_replace(contents, "(?s).*<TicketDetails>\\s*<TicketDetail>\\s*", "").as("xml"))
    select(regexp_replace(xml, "(?s)</TicketDetails>.*", "").as("xml"))
    select(split(xml, "<TicketDetail>\\s*").as("TicketDetails"))
    select(explode(TicketDetails).as("TicketDetail"))
    select(concat("<TicketDetail>", TicketDetail).as("TicketDetail"))
    xpath_int(TicketDetail, "//Qty").as("Qty")
    xpath_int(TicketDetail, "//Price").as("Price")
    xpath_int(TicketDetail, "//Amount").as("Amount")
    xpath_int(TicketDetail, "//NetAmount").as("NetAmount")
    xpath_string(TicketDetail, "//TransDateTime").as("TransDateTime")
    drop("TicketDetail")

Dealing with fixed width files
==============================

Problem
-------

You need to load a fixed-width text file.

Solution
--------

This is possible to configure with the schema tab of the feed creation
wizard. You can set the SerDe and properties:

1. Create an ingest feed.

2. When at the schema tab look for the field (near bottom) specifying
   the source format.

3. Manually build the schema since Kylo won’t detect the width.

4. Place text as follows in the field substituting regex based on the
   actual columns:

.. code-block:: none

    ROW FORMAT SERDE 'org.apache.hadoop.hive.contrib.serde2.RegexSerDe'
    WITH SERDEPROPERTIES ("input.regex" = "(.{10})(.{20})(.{20})(.{20})(.{5}).\*")

..

Dealing with custom SerDe or CSV files with quotes and escape characters
========================================================================

Problem
-------

You need to load a CSV file with surrounding quotes and don't want those
quotes removed.

Solution
--------

This is possible to configure within the schema tab of the ingest feed
creation, you can set the SerDe and properties:

1. Create an ingest feed.

2. When at the schema tab look for the field (near bottom) specify the
   source format.

3. See https://cwiki.apache.org/confluence/display/Hive/CSV+Serde for
   configuring CSV options.

4. Place text as follows in the field:

.. code-block:: none

      ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
      WITH SERDEPROPERTIES (
         "separatorChar" = ",",
         "quoteChar"     = "\\\\"",
         "escapeChar"="\\\\\\\\");
       )

..

Notice the double escape required!

.. |image1| image:: media/kylo-troubleshooting/2_executesparkjob.png
