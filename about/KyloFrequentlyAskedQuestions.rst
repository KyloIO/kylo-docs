FAQ
==========================

About Kylo
-----------------

What is Kylo?
~~~~~~~~~~~~~
Kylo is a feature-rich data lake platform built on Apache Hadoop and Spark.  Kylo provides a turn-key, business-friendly, data lake solution enabling self-service data ingest, data
preparation, and data discovery.

Kylo's web application layer offers features oriented to business users, including data analysts, data stewards, data scientists, and IT operations personnel.
Kylo integrates best practices around metadata capture, security, and data quality. Furthermore, Kylo provides a flexible data processing framework
(leveraging Apache NiFi) for building batch or streaming pipeline templates, and for enabling self-service features without compromising governance requirements.

What are Kylo's origins?
~~~~~~~~~~~~~~~~~~~~~~~~

Kylo was developed by |Think_Big_Link| (a Teradata company) and it is in use at a dozen major corporations globally.  Think Big provides big data and
analytics consulting to the world's largest organizations, working across every industry in performing 150 successful big data projects over the last seven years.  Think Big has been a
major beneficiary of the open-source Hadoop ecosystem and elected to open-source Kylo in order to contribute back to the community and improve value.

What does Kylo mean?
~~~~~~~~~~~~~~~~~~~~~

Kylo is a play on the Greek word meaning "flow".


What software license is Kylo provided under?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

|Think_Big_Link| (a Teradata company) has released Kylo under the Apache 2.0 license.

Who uses Kylo?
~~~~~~~~~~~~~~~~~~
Kylo is being used in beta and production at a dozen major multi-national companies worldwide across industries such as manufacturing, banking/financial, retail, and insurance. Teradata is working
with legal departments of these companies to release names in upcoming press releases.



What skills are required for a Kylo-based Data Lake implementation?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Many organizations have found implementing big data solutions on the Hadoop stack to be a complex endeavor.  Big data technologies are heavily oriented to software engineering and system
administrators, and even organizations with deep engineering capabilities struggle to staff teams with big data implementation experience.  This leads to multi-year implementation efforts that
unfortunately can lead to data swamps and fail to produce business value. Furthermore, the business-user is often overlooked in features available for in-house data lake solutions.

Kylo attempts to change all this by providing out-of-the-box features and patterns critical to an enterprise-class data lake.  Kylo provides an IT framework for delivering
powerful pipelines as templates and enabling user self-service to create feeds from these data processing patterns.  Kylo provides essential Operations capabilities around monitoring feeds,
troubleshooting, and measuring service levels.  Designed for extensibility, software engineers will find Kylo's APIs and plug-in architecture flexible and easy to use.



Enterprise Support
-------------------

Is enterprise support available for Kylo?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes, |Think_Big_Link| (a Teradata company) offers support subscription at the standard and enterprise level. Please visit the |Think_Big_Analytics_Link|
website for more information.

Are professional services and consulting available for Kylo?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|Think_Big_Link| (a Teradata company) provides global consulting services with expertise in implementing Kylo-based solutions. It is certainly possible to install and
learn Kylo using internal resources. Think Big's Data Lake Foundation provides a quick start to installing and delivering on your first set of data lake use cases.  Think Big's service
includes hands-on training to ensure that your business is prepared to assume operations.

Is enterprise training available for Kylo?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Yes, |Think_Big_Link| (a Teradata company) offers |Academy_Link| training on Kylo, Hadoop, and Spark.


Are commercial managed services available for Kylo?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Yes, |Think_Big_Link| (a Teradata company) can provide managed operations for your Hadoop cluster, including Kylo, whether it is hosted on-premise or in the cloud. The
managed services team is trained specifically on Kylo and they have operations experience with major Hadoop distributions.


Architecture
------------

What is the deployment architecture? 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo is a modern web application installed on a Linux “edge node” of a Spark & Hadoop
cluster. Kylo contains a number of special purposed routines for data lake operations leveraging Spark
and Apache Hive.

Kylo utilizes Apache NiFi as its scheduler and orchestration engine, providing an integrated framework for designing new types of pipelines with 200 processors (data connectors and transforms). Kylo
has an integrated metadata server currently compatible with databases such as MySQL and Postgres.

Kylo can integrate with Apache Ranger or Sentry and CDH Navigator or Ambari for cluster monitoring.

Kylo can optionally be deployed in the cloud.

What are the individual component/technologies involved in a Kylo deployment? 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Kylo UI. AngularJS browser app with Google Material Design running in a Tomcat container
- Kylo Services. Services, REST APIs, and plug-ins perform the backbone of Kylo.  All features and integrations with other technologies are managed through the services layer.
- Kylo Spark Shell. Manages Spark sessions for data wrangling.
- Kylo Metadata Server. Combination of JBoss ModeShape and MySQL (or Postgres) store all metadata generated by Kylo.
- Apache NiFi. Pipeline orchestration engine and scheduler.
- ActiveMQ.  JMS queue for inter-process communication.
- Apache Spark. Executes Kylo jobs for data profiling, data validation, and data cleansing. Also supports data wrangling and schema detection.
- ElasticSearch. Provides the index for search features in Kylo such as free-form data and metadata
- Apache Hadoop. All Hadoop technologies are available but most notably YARN, HDFS, Hive

Is Kylo compatible with Cloudera, Hortonworks, Map R, EMR, and vanilla Hadoop distributions?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes. Kylo generally relies on standard Hadoop APIs and common Hadoop technologies like HDFS, Hive, and Spark. NiFi operates on the "edge" so isn't bound to any particular
Hadoop distribution. It is therefore compatible with most Hadoop distributions, although we currently only provide install instructions for Cloudera and Hortonworks.

Does Kylo support either Apache NiFi or Hortonworks DataFlow (HDF)? What is the difference?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes, Kylo supports vanilla Apache NiFi or NiFi bundled with Hortonworks DataFlow. HDF bundles Apache NiFi, Storm, and Kafka within a distribution. Apache NiFi within HDF contains the same codebase
as the open-source project.  NiFi is a critical component of the Kylo solution. Kylo is an HDF-certified technology.  Kylo's commercial support subscription bundles 16 cores of Apache NiFi support.

Can Kylo be used in the cloud?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Absolutely. Kylo is used in production on AWS utilizing EC2, S3, SQS, and other AWS features for at least one major Fortune 100 company. Kylo has also been used with Azure.

Does Kylo support high-availability (HA) features?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Yes, Kylo clustering is possible via a load-balancer. In addition, current data processing running under NiFi will not be impacted if Kylo becomes unavailable or during upgrades.

Metadata
--------

What type of metadata does Kylo capture?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo captures extensive business and technical (for example, schema) metadata
defined during the creation of feeds and categories.  Kylo processes lineage
as relationships between feeds, sources, and sinks. Kylo automatically captures all operational
metadata generated by feeds. In addition, Kylo stores job and feed
performance metadata and SLA metrics. We also generate data profile
statistics and samples.

How does Kylo support metadata exchange with 3rd party metadata servers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo's metadata server has REST APIs that could be used for metadata
exchange and documented directly in the application through Swagger.


What is Kylo's metadata server?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A key part of Kylo's metadata architecture relies on the open-source JBoss ModeShape
framework. ModeShape is a JCR compliant store. Modeshape supports dynamic schemas providing the ability to easily extend Kylo's own data
model.

Some core features:

-  Dynamic schemas - provide extensible features for extending schema
   towards custom business metadata in the field

-  Versioning - ability to track changes to metadata over time

-  Text Search - flexible searching metastore

-  Portability - can run on sql and nosql databases

    See: |Modeshape_Link|

How extensible is Kylo metadata model?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Very extensible due our use of ModeShape (see above).

In addition, the Kylo application allows an administrator to define standard business metadata
fields that users will be prompted to enter when creating feeds and categories.


Are there any business-related data captured, or are they all operational metadata?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Business metadata fields can be defined by the user and will appear in the UI during the feed setup process.

What does the REST API look like?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Please access the REST documentation through a running Kylo instance: **http://kylo-host:8400/api-docs/index.html**

Does the Kylo application provide a visual lineage?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Yes, Kylo provides a visual process lineage feature for exploring relationships between feeds and shared sources and sinks.  Job instance level lineage is stored as "steps" visible in the feed job
history.

What type of process metadata do we capture?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo captures job and step level information on the status of the process,
with some information on the number of records loaded, how long it took,
when it was started and finished, and what errors or warnings may have been generated. We
capture operational metadata at each step, which can include record
counts, dependent upon the type of step.

Development Lifecycle
---------------------

What's the pipeline development process using Kylo? 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Pipeline templates developed with Apache NiFi and registered with Kylo can be developed and tested in a sandbox environment, exported from Kylo,
and then imported into Kylo in a UAT and production environment after testing. Once the NiFi template is registered with Kylo, a business
user can configure new feeds through Kylo's step-guided user interface.

Existing Kylo feeds can be exported from one environment into a zip file that contains a combination of the underlying template and metadata. The
package can then be imported to the production NiFi environment by an administrator.

Does deployment of new templates or feeds require restart?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

No restart is required to deploy new pipeline templates or feeds.

Can new feeds be created in automated fashion instead of manually through the UI?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes, via Kylo's REST API. See the section on Swagger documentation (above).

Does Kylo leverage automated testing?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Kylo is a large project which can make QA testing challenging. We built a Docker based automated testing infrastructure to
test Kylo deployment with as many different integration points as possible. This runs multiple times per day in addition to our large number of unit tests

Tool Comparisons
----------------

Is Kylo similar to any commercial products?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo has similar capabilities to Podium and Zaloni Bedrock. Kylo is an open-source option. One differentiator is Kylo's extensibility. Kylo provides a plug-in architecture with a variety of
extensions available to developers, and the use of NiFi templates provides incredible flexibility for batch and streaming use cases.

Is Kylo's operations dashboard similar to Cloudera Manager and Apache Ambari?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo's dashboard is feed-health centric. Health of a feed is determined by job completion status, service level agreement violations, and rules that measure data quality.
Kylo provides the ability to monitor feed performance and troubleshoot issues with feed job failures.

Kylo monitors services in the cluster and external dependencies to provide a holistic view of services your data lake depends on.  Kylo provides a simple plugin for adding
enterprise services to monitor.  Kylo includes plugins for pulling service status from Ambari and Cloudera Navigator. This is useful for correlating service issues with feed health problems.

Is Kylo's metadata server similar to Cloudera Navigator, Apache Atlas?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In some ways. Kylo is not trying to compete with these and could certainly
imagine integration with these tools. Kylo includes its own extensible
metadata server. Navigator is a governance tool that comes as part of the
Cloudera Enterprise license. Among other features, it provides data
lineage of your Hive SQL queries. We think this is useful but only
provides part of the picture. Kylo's metadata framework is really the foundation of
an entire data lake solution. It captures both business
and operational metadata. It tracks lineage at the feed-level. Kylo provides IT Operations with a useful dashboard, providing the ability to
track/enforce Service Level Agreements, and performance metrics.  Kylo's REST APIs can be used to do metadata exchange with tools like Atlas and Navigator.

How does Kylo compare to traditional ETL tools like Talend, Informatica, Data Stage?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo uses Apache NiFi to orchestrate pipelines.  NiFi can connect to many different sources and perform lightweight transformations on the edge using 180+ built-in processors.  Generally workload
is delegated to the cluster where the bulk of processing power is available.  Kylo's NiFi processor extensions can effectively invoke Spark, Sqoop, Hive, and even invoke traditional ETL
tools (for example: wrap 3rd party ETL jobs).

Many ETL (extract-transform-load) tools are focused on SQL transformations using their own proprietary technology. Data warehouse style transformations tend to be focused on issues such as loading
normalized relational schemas such as a star or snowflake.  Hadoop data patterns tend to follow ELT (extract and load raw data, then transform). In Hadoop, source data is often stored in raw form, or  flat denormalized
structures. Powerful transformation techniques are available via Hadoop technologies, including Kylo's leveraging of Spark.  We don’t often see the need for expensive and complicated ETL technologies for
Hadoop.

Kylo provides a user interface for an end-user to configure new data feeds including schema, security, validation, and cleansing. Kylo provides the ability to wrangle and prepare
visual data transformations using Spark as an engine.

What is Kylo's value-add over plain Apache NiFi?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NiFi acts as Kylo's pipeline orchestration engine, but NiFi itself does not provide all of the tooling required for a data lake solution. Some of Kylo's distinct benefits over vanilla NiFi and Hadoop:

-  Write-once, use many times. NiFi is a powerful IT tool for designing
   pipelines, but most data lake feeds utilize just a small number of
   unique flows or “patterns". Kylo allows IT the flexibility to
   design and register a NiFi template as a data processing model for feeds. This enables
   non-technical business users to configure dozens, or even hundreds of
   new feeds through Kylo's simple, guided stepper-UI. In other words, our
   UI allows users to setup feeds without having to code them in
   NiFi. As long as the basic ingestion pattern is the same, there is no
   need for new coding. Business users will be able to bring in new data
   sources, perform standard transformations, and publish to target
   systems.

-  Operations Dashboard UI can be used for monitoring data feeds.
   It provides centralized health monitoring of feeds and related infrastructure
   services, Service Level Agreements, data quality metrics reporting,
   and alerts.

-  Web modules offer key data lake features such as metadata search,
   data discovery, data wrangling, data browse, and event-based feed
   execution (to chain together flows).

-  Rich metadata model with integrated governance and best practices.

-  Kylo adds a set of data lake specific NiFi extensions around Data Profile,
   Data Cleanse, Data Validate, Merge/Dedupe, High-water. In addition, general Spark and Hive
   processors not yet available with vanilla NiFi.

-  Pre-built  templates that implement data lake best practices: Data Ingest, ILM, and Data Processing.

Scheduler
---------

How does Kylo manage job priority?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo exposes the ability to control which yarn queue a task executes on. Typically scheduling this is done through the scheduler. There are some
advanced techniques in NiFi that allow further prioritization for shared
resources. 

Can Kylo support complicated ETL scheduling?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo supports cron-based scheduling, but also timer-based, or event-based using JMS and an internal Kylo ruleset. NiFi embeds the Quartz.

What’s the difference between “timer” and “cron” schedule strategies?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Timer is fixed interval, “every 5 minutes or 10 seconds”. Cron can be
configured to do that as well, but can handle more complex cases like
“every tues at 8AM and 4PM”.

Does Kylo support 3rd party schedulers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes, feeds can be triggered via JMS or REST.

Does Kylo support chaining feeds? One data feed consumed by another data feed?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo supports event-based triggering of feeds based on preconditions or rules. One can define rules in the UI that determine when to run a
feed, such as “run when data has been processed by feed a and feed b and
wait up to an hour before running anyway”. We support simple rules up to
very complicated rules requiring use of our API.

Security
----------

Does Kylo support roles?
~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo supports the definition of roles (or groups), and the specific permissions a user with that role can perform, down to the function level.

What authentication methods are available?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo uses Spring Security. Using pluggable login-modules, it can integrate with Active Directory, Kerberos, LDAP,
or most any authentication provider. See :doc:`../developer-guides/KyloDeveloperGuide`.

What security features does Kylo support?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo provides plugins that integrate with Apache Ranger or Apache Sentry, depending on the distribution that you are running. These can be used to configure feed-based security and impersonating users
properly to enforce user permissions.  Kylo fully supports Kerberized clusters and built-in features, such as HDFS encryption.

Is Kylo PCI compliant?
~~~~~~~~~~~~~~~~~~~~~~

Kylo can be configured to use TLSv1.2 for all network communication it uses internally or externally. We are testing running NiFi repositories on encrypted disk with a client. v0.8 will
include some improvements required for full PCI compliance.

Data Ingest
--------------

What is Kylo's standard batch ingest workflow?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo includes a sample pipeline template that implements many best practices around data ingest, mostly utilizing Spark.  Kylo makes it very simple for a business user to configure ingest of new source
files and RDMBS tables into Hive.  Data can be read from a filesystem attached to the edge node, or directly using Kylo's sqoop processor into Hadoop.  Original data is archived into a distinct
location.
Small files are optionally merged and headers stripped, if needed.  Data is cleansed, standardized, and validated based on user-defined policies.  Invalid records are binned into a
separate table for later inspection. Valid records are inserted into a final Hive table with options such as (append, snapshot, merge with dedupe, upsert, etc). Target format can differ from the
raw source, contain custom partitions, and group-based security. Finally each batch of valid data is automatically profiled.

Does Kylo support batch and streaming?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes, either types of pipelines can configured with Kylo.  Kylo tracks performance statistics of streaming-style feeds in activity over units of time.  Kylo tracks performance of batch feeds in jobs and steps.

Which raw formats does Kylo support?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo has a pluggable architecture for adding support for new types.  Currently Kylo supports delimited-text formats (for example: csv, tab, pipe) and all Hadoop formats, such as ORC, Parquet, RCFile, AVRO,
and JSON.


Which target formats for Hive does Kylo support?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo supports text-file, Parquet and ORC (default) with optional block compression, AVRO, text, and RCFile.


How does “incremental” loading strategy of a data feed work?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo supports a simple incremental extract component. We maintain a
high-water mark for each load using a date field in the source record.

Can Kylo ingest from relational databases?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes, Kylo allows a user to select tables from RDBMS sources and easily configure ingest feeds choosing the target table structure, cleansing and validation rules, and target format.  Kylo invokes
Sqoop via NiFi to avoid IO through the edge node.

Kylo's RDBMS ingest support requires configuring a type-specific JDBC driver. It has been tested with data sources such as Teradata, SQL Server, Oracle, Postgres, and MySQL.

.. |Think_Big_Link| raw:: html

    <a href="https://www.thinkbiganalytics.com" target="_blank">Think Big</a>

.. |Academy_Link| raw:: html

    <a href="https://www.thinkbiganalytics.com/apache-nifi-kylo-introduction.html" target="_blank">Academy</a>

.. |Modeshape_Link| raw:: html

    <a href="http://modeshape.jboss.org" target="blank">Modeshape</a>

.. |Think_Big_Analytics_Link| raw:: html

   <a href="https://www.thinkbiganalytics.com" target="_blank">Think Big Analytics</a>
