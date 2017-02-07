
======================
Troubleshooting & Tips
======================
  

Setting ExecuteSparkJob to YARN cluster mode
============================================

Problem
-------

By default, all the ExecuteSparkJobs are set to local or yarn-client
mode. To be more efficient, it is recommended to use yarn cluster mode

Solution
--------

Follow the steps in the Configuration Guide found here: \ `Yarn Cluster
Mode
Configuration <https://wiki.thinkbiganalytics.com/display/RD/Yarn+Cluster+Mode+Configuration>`__

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Spark job failing on sandbox with large files* <https://wiki.thinkbiganalytics.com/display/RD/Spark+job+failing+on+sandbox+with+large+files>`__
  - `*NiFi hangs executing Spark task step* <https://wiki.thinkbiganalytics.com/display/RD/NiFi+hangs+executing+Spark+task+step>`__


Tuning ExecuteSparkJob Processor
================================

Problem
-------

The default settings for the ExecuteSparkJob processor is to allow it to
run on a local VM. These parameters need to be updated to work on a
cluster environment.

Solution
--------

These steps have been taken from various blogs. With any type of tuning
work, modifications are required for each job to ensure they work
properly. These steps were tested on 3 node HDP 2.3.4 cluster running on
a TD Appliance 

**Gather information**

1. Get the following values from yarn-site.xml (can be found through
   Ambari as well)

   a. yarn.nodemanager.resources.cpu-vcores

   b. yarn.nodemanager.resource.memory-mb

2. Get the number of nodes in the cluster

   a. number of nodes

**Calculation**

1. Ideally to have 3 executors per node minus 1 used by the manager

   a. **num-executor** = 3 \* (number of nodes) - 1

2. Executor cores should be either 4, 5, 6 depending on the total number
   of available cores. This should be tested. Starting with 6 tends to
   work well

   a. spark.executor.cores = 6

3. Determine the total memory using the following equation

   a. total.memory (GB) = yarn.nodemanager.resource.memory-mb \*
      (spark.executor.cores / yarn.nodemanager.resource.cpu-vcores)

4. Use total.memory and split it between spark.executor.memory and
   spark.yarn.executor.memoryOverhead (15-20% of total memory)

   a. spark.yarn.executor.memoryOverhead = total.memory \* (0.15)

   b. spark.executor.memory = total.memory
      - spark.yarn.executor.memoryOverhead

For reference, these are the values we used for the 3 node cluster:

**Input**

.. code-block:: shell

    yarn.nodemanager.resources.cpu-vcores =  32
    yarn.nodemanager.resource.memory-mb = 196608 
    Nodes = 3

..

**Calculation **

.. code-block:: shell

    num-executors = 8
    spark.executor.cores = 6
    spark.executor.memory = 31 GB
    spark.yarn.executor.memoryOverhead = 6 GB

..

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Spark job failing on sandbox with large file* <https://wiki.thinkbiganalytics.com/display/RD/Spark+job+failing+on+sandbox+with+large+file>`__
  - `*NiFi hangs executing Spark task step* <https://wiki.thinkbiganalytics.com/display/RD/NiFi+hangs+executing+Spark+task+step>`__

Dealing with a non-standard file formats
========================================

Problem
-------

You need to ingest a file with a non-standard format.

Solution
--------

There are two possible solutions:

1. You may write a custom SERDE and register that SERDE in HDFS. Then
   specify the use of the SERDE in the schema tab source format field

   a. I have created a SerDe (actually it is just a De because it only
      reads the file format). You can find it here:
      https://github.com/gm310509/ADSBSerDe

   b. I have created it in NetBeans 8.0, but it should be importable and
      compilable in any IDE.

   c. The Pom has the dependencies for the version of Hive/HDFS used in
      my bootcamp - if that changes, you may need to add a new set of
      dependencies to the project.

   d. Good Luck with it and keep your fingers crossed (it helped me get
      it working). Enjoy!

2. You can split into two feeds 1) ingest 2) use the wrangler to
   manipulate the fields into columns:

   a. Create an ingest field, manually define the schema as a single
      field of type string. You can just call that field "data"

   b. Make sure the format specification doesn't conflict with data in
      the file, i.e. tabs or commas which might cause it to get split

   c. Once ingested, create a data transform feed to wrangle the data
      using the transform functions

   d. Here's an example of converting the weird ADSB format (used in
      bootcamp) into JSON then converting into fields:

.. code-block:: shell

    select(regexp\_replace(data, "([\\\\w-.]+)\\t([\\\\w-.]+)",
    "\\"$1\\":\\"$2\\"").as("data"))

    select(regexp\_replace(data, "\\" \*\\t\\"", "\\",\\"").as("data"))

    select(concat("{", data, "}").as("data"))

    select(json\_tuple(data, "clock", "hexid", "ident", "squawk", "alt",
    "speed", "airGround", "lat", "lon", "heading"))

    select(c0.as("clock"), c1.as("hexid"), c2.as("ident"),
    c3.as("squawk"), c4.as("alt"), c5.as("speed"), c6.as("airGround"),
    c7.as("lat"), c8.as("lon"), c9.as("heading"))

..

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

Indexing categories and feeds
=============================

Problem
-------

You need to index specific fields of categories and/or feeds.

Solution
--------

This is a two-step process involving adding the required Maven
dependencies to the data-lake-accelerator project and updating
the thinkbig-services configuration.

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
   the /opt/thinkbig/thinkbig-services/conf/metadata-repository.json file.
   Each index must specify a node type (tba:category or tba:feed) and a
   comma-separated list of columns to be indexed. User-defined
   properties must be URL-encoded and prefixed with usr:. As an example,
   add the following properties to the metadata-repository.jsonfile:

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

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

Merge Table fails when storing as Parquet using HDP
===================================================

Problem
-------

There is a bug with Hortonworks where a query against a Parquet backed
table fails while using single or double quotes in the value names. For
example: 

.. code-block:: shell

      hive> select \* from users\_valid where
      processing\_dttm='1481571457830';
      OK
      SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
      SLF4J: Defaulting to no-operation (NOP) logger implementation
      SLF4J:
      See \ http://www.slf4j.org/codes.html#StaticLoggerBinder for
      further details.
      Failed with
      exception \ `java.io <http://java.io/>`__.IOException:java.lang.IllegalArgumentException:
      Column [processing\_dttm] was not found in schema!

..

In versions of Kylo prior to 0.5.0 the Merge Table processor will fail.
In 0.5.0 a hive configuration flag was set to work around the HDP bug. 

Solution
--------

You will need to upgrade to Kylo 0.5.0 or greater for the Merge Table
processor to work. In addition you might need to set some hive
properties for queries to work in hive

Forum threads that explain how to set the correct property

1. https://community.hortonworks.com/questions/47897/illegalargumentexception-when-select-with-where-cl.html

2. https://community.hortonworks.com/questions/40445/querying-a-partition-table.html

3. On the hive command line you can set the following property to allow
   quotes: "set hive.optimize.ppd = false;"

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

NiFi becomes non-responsive
===========================

Problem
-------

NiFi appears to be up but UI is no longer functioning.  NiFi may be
running low on memory.   There may be PID files in the /opt/nifi/current
directory.

Solution
--------

Increase memory to NiFi:

Adding memory to NiFi may help.  In one case we also needed to create
swap space (not recommended by NiFi for performance reasons):

1. edit /opt/nifi/current/conf/boostrap.conf

2. Set the following line, e.g.  java.arg.3=-Xmx3g

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

Automated Flow and Template Importing
=====================================

Problem
-------

Flows and templates should be automatically imported into the staging or
production environment as part of a continuous integration process.

Solution
--------

The Kylo REST API can be used to automate the importing of flows and
templates.

Templates can be imported either as an XML or a ZIP file. Set
the overwrite parameter to true to indicate that existing templates
should be replaced otherwise an error will be returned. Set
the createReusableFlow parameter to true if the template is an XML file
that should be imported as a reusable template.
The importConnectingReusableFlow parameter indicates how to handle a ZIP
file that contains both a template and its reusable flow.
The NOT\_SET value will cause an error to be returned if the template
requires a reusable flow. The YES value will cause the reusable flow to
be imported along with the template. The NO value will cause the
reusable flow to be ignored and the template to be imported as normal.

.. code-block:: shell

  curl -F file=@<path-to-template-xml-or-zip> -F overwrite=false -F createReusableFlow=false -F importConnectingReusableFlow=NOT\_SET -u <kylo-user>:<kylo-password> http://<kylo-host>:8400/proxy/v1/feedmgr/admin/import-template

..

Flows can be imported as a ZIP file containing the feed metadata and
NiFi template. Set the overwrite parameter to true to indicate that an
existing feed and corresponding template should be replaced otherwise an
error will be returned. The importConnectingReusableFlow parameter
functions the same as the corresponding parameter for importing a
template.

.. code-block:: shell

      curl -F file=@<path-to-feed-zip> -F overwrite=false -F importConnectingReusableFlow=NOT\_SET -u <kylo-user>:<kylo-password> http://<kylo-host>:8400/proxy/v1/feedmgr/admin/import-feed

..

Spark job failing on sandbox with large file
============================================

Problem
-------

If running on a sandbox (or small cluster) the spark executor may get
killed due to OOM when processing large files in the standard ingest
flow. The flow will route to failed flow but there will be no error
message.  Look for Exit Code 137 in /var/log/nifi/nifi-app.log.  This
indicates OOM issue.

Solution
--------

On a single-node sandbox it is better to run Spark in local than
yarn-client and simply give Spark enough memory to perform its task.  
This eliminates all the YARN scheduler complications.

1. In the standard-ingest flow, stop and alter the ExecuteSparkJob
   processors:   

2. use local instead of yarn-client

3. increase memory to the executor  e.g. 1024m

4. Start the processors

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Spark job failing on sandbox with large file* <https://wiki.thinkbiganalytics.com/display/RD/Spark+job+failing+on+sandbox+with+large+file>`__
  - `*NiFi hangs executing Spark task step* <https://wiki.thinkbiganalytics.com/display/RD/NiFi+hangs+executing+Spark+task+step>`__

NiFi hangs executing Spark task step
====================================

Problem
-------

Apache NiFi flow appears to be stuck inside the Spark task such as
"Validate and Split Records" step.  This symptom can be verified by
viewing the YARN jobs. The SPARK job appears to be running and there is
a HIVE job queued to run but never launched:

.. code-block:: shell

  http://localhost:8088/cluster

..

So what is happening?   Spark is executing a Hive job to insert data
into a Hive table but the Hive job never gets YARN resources.  This is a
configuration problem that led to a deadlock. Spark will never complete
because the HIVE job will never get launched. The HIVE job is blocked by
the Spark job. Fun!

Solution
--------

First you will need to clean up the stuck job then re-configure the YARN
scheduler.

To clean up the stuck job, from the command-line as root:

1. Obtain the PID of the spark job:   ps -ef \  grep Spark \  grep
   Validator

2. kill <pid>

Configure YARN to handle additional concurrent jobs:

1. Increase the maximum percent with the following parameter:  
   yarn.scheduler.capacity.maximum-am-resource-percent=0.8

2. See: \ https://hadoop.apache.org/docs/r0.23.11/hadoop-yarn/hadoop-yarn-site/CapacityScheduler.html

3. Restart cluster or all affected services

4. Restart Apache NiFi to re-initialized Thrift connection pool: 
   service nifi restart

Note: In Ambari, find this under Yarn \  Configs (advanced) \  Scheduler

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Spark job failing on sandbox with large file* <https://wiki.thinkbiganalytics.com/display/RD/Spark+job+failing+on+sandbox+with+large+file>`__
  - `*NiFi hangs executing Spark task step* <https://wiki.thinkbiganalytics.com/display/RD/NiFi+hangs+executing+Spark+task+step>`__

Spark SQL fails on empty ORC table, HDP 2.4.2, HDP 2.5
======================================================

Problem
-------

Your spark job fails when running in HDP 2.4.2 while interacting with an
empty ORC table. A likely error that you will see is. 

.. code-block:: shell

    "ExecuteSparkJob[id=1fb1b9a0-e7b5-4d85-87d2-90d7103557f6]
    java.util.NoSuchElementException: next on empty iterator "

..

This is due to a change Hortonworks added to change how it loads the
schema for the table. 

Solution
--------

To fix the issue you can modify the following property

1. On the edge node
   edit /usr/hdp/current/spark-client/conf/spark-defaults.conf

2. Add this line to the file "spark.sql.hive.convertMetastoreOrc false"

Related articles
----------------

  - `*https://community.hortonworks.com/questions/44637/spark-sql-fails-on-empty-orc-table-hdp-242.html* <https://community.hortonworks.com/questions/44637/spark-sql-fails-on-empty-orc-table-hdp-242.html>`__
  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

High Performance NiFi setup
===========================

Problem
-------

NiFi team published an article on how to extract the most performance
from Apache NiFi

Solution
--------

1. `See:
   https://community.hortonworks.com/articles/7882/hdfnifi-best-practices-for-setting-up-a-high-perfo.html <https://community.hortonworks.com/articles/7882/hdfnifi-best-practices-for-setting-up-a-high-perfo.html>`__

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

RPM install fails with 'cpio: read' error
=========================================

Problem
-------

Kylo rpm install fails, giving a 'cpio: read' error.

Solution
--------

This problem occurs if the rpm file is corrupt / not downloaded
properly.

1. If the Kylo rpm was downloaded from Think Big artifactory, ensure
   that the download was completed successfully.

2. For example, if downloading version 0.4.0, check that the file size
   on disk is 473690416 bytes. 

3. Once verified, attempt installing again.

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

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

    $ cp /etc/hive/conf/hive-site.xml /usr/lib/spark/conf/

..

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

Compression codec not found for PutHDFS folder
==============================================

Problem
-------

The PutHDFS processor throws an exception like:

.. code-block:: shell

    *java.lang.IllegalArgumentException: Compression codec
    com.hadoop.compression.lzo.LzoCodec not found.*

..

Solution
--------

Edit the /etc/hadoop/conf/core-site.xml file and remove the failing
codec from the io.compression.codecs property.

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

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
   TriggerCleanup. This processor will be run automatically when a feed
   is deleted.

3. Connect additional processors such as RemoveHDFSFolder or
   DropFeedTables as needed.

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

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

  export SPARK\_DIST\_CLASSPATH=$(hadoop classpath)

..

Additional information is available from the Apache Spark project:

.. code-block:: shell

  https://spark.apache.org/docs/latest/hadoop-provided.html

..

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

Hive performance tuning
=======================

Problem
-------

You are experiencing Hive performance issues

Solution
--------

Douglas Moore wrote an excellent tuning
guide:  HiveCodingandPerformanceTuning.pdf

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

Dealing with XML files
======================

Problem
-------

You need to ingest an XML file and parse into Hive columns

Solution
--------

1. You can split into two feeds 1) ingest 2) use the wrangler to
   manipulate the fields into columns:

   a. Create an ingest field, manually define the schema as a single
      field of type string.  You can just call that field "data"

   b. Make sure the format specification doesn't conflict with data in
      the file, i.e. tabs or commas which might cause it to get split

   c. Once ingested, create a data transform feed to wrangle the data
      using the transform functions

   d. Here's an example of converting the XML to columns using wrangler
      functions:

 

XML Explode
-----------

.. code-block:: shell

  1      select(regexp\_replace(contents, "(?s).\*<TicketDetails>\\\\s\*<TicketDetail>\\\\s\*", "").as("xml"))
  2      select(regexp\_replace(xml, "(?s)</TicketDetails>.\*", "").as("xml"))
  3      select(split(xml, "<TicketDetail>\\\\s\*").as("TicketDetails"))
  4      select(explode(TicketDetails).as("TicketDetail"))
  5      select(concat("<TicketDetail>", TicketDetail).as("TicketDetail"))
  6      xpath\_int(TicketDetail, "//Qty").as("Qty")
  7      xpath\_int(TicketDetail, "//Price").as("Price")
  8      xpath\_int(TicketDetail, "//Amount").as("Amount")
  9      xpath\_int(TicketDetail, "//NetAmount").as("NetAmount")
  10     xpath\_string(TicketDetail, "//TransDateTime").as("TransDateTime")
  11     drop("TicketDetail")

..

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

Dealing with fixed width files
==============================

Problem
-------

You need to load a fixed-width text file.

Solution
--------

This is possible to configure with the schema tab of the ingest feed
creation, you can set the SERDE and properties:

1. Create an ingest feed

2. When at the schema tab look for the field (near bottom) specifying
   the source format

3. Manually build the schema since we can't detect width

4. Place text as follows in the field substituting regex based on the
   actual columns:

.. code-block:: shell

    ROW FORMAT SERDE 'org.apache.hadoop.hive.contrib.serde2.RegexSerDe'

    WITH SERDEPROPERTIES ("input.regex" =
    "(.{10})(.{20})(.{20})(.{20})(.{5}).\*")

..

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__

Dealing with custom SERDE or CSV files with quotes and escape characters
========================================================================

Problem
-------

You need to load a CSV file with surrounding quotes and don't want those
quotes removed.

Solution
--------

This is possible to configure within the schema tab of the ingest feed
creation, you can set the SERDE and properties:

1. Create an ingest feed

2. When at the schema tab look for the field (near bottom) specifying
   the source format

3. See \ https://cwiki.apache.org/confluence/display/Hive/CSV+Serde  for
   configuring CSV options

4. Place text as follows in the field:

.. code-block:: shell

      ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'

      WITH SERDEPROPERTIES (

         "separatorChar" = ",",

         "quoteChar"     = "\\\\"",

         "escapeChar"="\\\\\\\\");

       )

..

      Notice the double escape required!

Related articles
----------------

  - `*Setting ExecuteSparkJob to YARN cluster mode* <https://wiki.thinkbiganalytics.com/display/RD/Setting+ExecuteSparkJob+to+YARN+cluster+mode>`__
  - `*Tuning ExecuteSparkJob Processor* <https://wiki.thinkbiganalytics.com/display/RD/Tuning+ExecuteSparkJob+Processor>`__
  - `*Dealing with a non-standard file formats* <https://wiki.thinkbiganalytics.com/display/RD/Dealing+with+a+non-standard+file+formats>`__
  - `*Indexing categories and feeds* <https://wiki.thinkbiganalytics.com/display/RD/Indexing+categories+and+feeds>`__
  - `*Merge Table fails when storing as Parquet using HDP* <https://wiki.thinkbiganalytics.com/display/RD/Merge+Table+fails+when+storing+as+Parquet+using+HDP>`__
