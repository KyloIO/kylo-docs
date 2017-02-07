FAQ
==========================

General Questions
-----------------

What is Kylo?
~~~~~~~~~~~~~
Kylo is a full-featured Data Lake platform built on Apache Hadoop and Spark.  Kylo provides a turn-key, business-friendly Data Lake solution enabling data ingest, data
preparation, and data discovery.

Kylo provides a web application layer with features oriented to business users such as: Data Analysts, Data Stewards, Data Scientists, and IT Operations. Kylo
integrates best practices around metadata capture, security, and data confidence. Furthermore Kylo provides a flexible data processing framework
(leveraging Apache NiFi) that allows Information Technology to build batch or streaming pipelines, then enable user service-service without compromising governance.

What are Kylo's origins?
~~~~~~~~~~~~~~~~~~~~~~~~

Kylo was developed by `Think Big <https://www.thinkbiganalytics.com>`_ (a Teradata company) and is already in use at a dozen major corporations globally.  Think Big provides big data and
analytics consulting to the world's largest organizations across every industry with over 7 years and 150 successful big data projects related to the Hadoop ecosystem.  Think Big has been a
major beneficiary of the open-source Hadoop ecosystem and elected to open-source Kylo in order to contribute back to the community and advance enterprise-class Data Lakes.

What software license is Kylo provided under?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Think Big <https://www.thinkbiganalytics.com>`_ (a Teradata company) has released Kylo under the Apache 2.0 license.

Is enterprise support available for Kylo?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes, `Think Big (a Teradata company) <https://www.thinkbiganalytics.com>`_ offers support subscription at the standard and enterprise level. Please visit the Think Big Analytics
`website <https://www.thinkbiganalytics.com>`_ for more information.

Is professional services and consulting available for Kylo?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Absolutely.   `Think Big (a Teradata company) <https://www.thinkbiganalytics.com>`_ provides global consulting services with expertise implementing Kylo-based solutions. Where it is possible to
implement Kylo using internal resources, the Data Lake Foundation offering provides a quick start to installing and delivering on your first set of data lake use cases.  Think Big's service
includes hands-on training that ensures your business is prepared to assume operations.

Are commercial managed services available for Kylo?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Yes, `Think Big (a Teradata company) <https://www.thinkbiganalytics.com>`_ can provide operations for your Hadoop cluster including Kylo whether it is hosted on-premise or in the cloud. The managed
services team are trained specifically on Kylo.

How is Kylo differentiated against similar commercial products?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo has similar capabilities to Podium and Zaloni Bedrock. Kylo is an open-source option. One differentiator is Kylo's extensibility. Kylo provides plug-in architecture with a variety of extension points available to developers and use of NiFi templates provides incredible flexibility for batch and streaming use cases.

What skills are required for a Kylo-based Data Lake implementation?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As many organization have learned, implementing big data solutions on the Hadoop stack is a complex endeavor.  Big data technologies are heavily oriented to software engineering and system
administrators. Organizations with deep engineering capabilities still struggle to staff teams with big data implementation experience.  This leads to multi-year implementation efforts that
unfortunately can lead to data swamps and fail to produce business value.   Furthermore, the business-user is often overlooked in features available for in-house data lake solutions.

Kylo attempts to change all this by providing out-of-the-box features and patterns critical to enterprise-class Data Lake.  Kylo provides a framework for IT data architects (designers) to build
powerful pipelines as templates and enable user self-service to create feeds from these data processing patterns.  Kylo provides essential Operations capabilities around monitoring feeds,
troubleshooting, and measuring service levels.  Designed for extensibility,  Software engineers will find Kylo's APIs and plug-in architecture flexible and easy to use.

What does Kylo mean?
~~~~~~~~~~~~~~~~~~~~

Kylo is a play on the greek word meaning "flow".

Is Kylo compatible with Cloudera, Hortonworks, Map R, EMR, and vanilla Hadoop distributions?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes. Kylo generally relies on standard Hadoop APIs and common Hadoop technologies like HDFS, Hive, and Spark. NiFi operates on the "edge" so isn't bound to any particular
Hadoop distribution It is therefore compatible with most Hadoop distributions although we only provide install instructions for Cloudera and Hortonworks.

Who is using Kylo?
~~~~~~~~~~~~~~~~~~
Kylo is being used in beta and production at a dozen major multi-national companies worldwide across industries such as manufacturing, banking/financial, retail, and insurance. Teradata is working
with legal departments of these companies to release names in upcoming press releases.

Can Kylo be used in the cloud?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Absolutely. Kylo is used in production on AWS for at least one major Fortune 100 company. Kylo has also been used with Azure.

Does Kylo support either Apache NiFi or Hortonworks DataFlow (HDF)? What is the difference?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes, Kylo support vanilla Apache NiFi or NiFi bundled with Hortonworks DataFlow. HDF bundles Apache NiFi, Storm, and Kafka within a distribution. Apache NiFi within HDF contains the same codebase
as the open-source project.  NiFi is a critical component of the Kylo solution. Kylo is an HDF-certified technology.

What is Kylo's value-add over plain Apache NiFi?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NiFi acts as Kylo's pipeline orchestration engine, but NiFi itself does not provide all the tooling required for a Data Lake solution. Some of Kylo's distinct benefits over vanilla NiFi and Hadoop:

-  Write-once, use many times. NiFi is a powerful IT tool for designing
   pipelines but most Data Lake feeds utilize just a small number of
   unique flows or “patterns". Kylo allows IT the flexibility to
   design then register a NiFi template as a data processing model for feeds. This enables
   non-technical business users to configure dozens, or even hundreds of
   new feeds through Kylo's simple, guided stepper-UI. In other words, our
   UI allows users to setup feeds without having to code them in
   NiFi. As long as the basic ingestion pattern is the same, there is no
   need for new coding. Business users will be able to bring in new data
   sources, perform standard transformations, and publish to target
   systems.

-  Operations Dashboard is a superior UI for monitoring data feeds.
   It provides centralized health monitoring of feeds and related infrastructure
   services, Service Level Agreements, data quality metrics reporting,
   and alerts.

-  Web modules offer key Data Lake features such as metadata search,
   data discovery, data wrangling, data browse, and event-based feed
   execution (to chain together flows).

-  Rich metadata model with integrated governance and best practices

-  Kylo adds a set of Data Lake specific NiFi extensions around Data Profile,
   Data Cleanse, Data Validate, Merge/Dedupe, High-water. In addition, general Spark and Hive
   processors not yet available with vanilla NiFi

-  Pre-built  templates that implement Data Lake best practices: Data Ingest, ILM, and Data Processing

Architecture
------------

What is the deployment architecture? 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo is a modern web application typically installed on a Linux “edge node” of a Spark & Hadoop
cluster. Kylo contains a number of special purposed routines for data lake operations leveraging Spark
and Apache Hive.

Kylo utilizes Apache NiFi for scheduler and orchestration engine providing an integrated framework for designing new types of pipelines with 200 processors (data connectors and transforms). Kylo
has an integrated metadata server currently compatible with databases such as MySQL and Postgres.

Kylo can integrate with Apache Ranger or Sentry and CDH Navigator or Ambari for cluster monitoring.

Kylo can optionally be deployed in the cloud.


Metadata
--------

What type of metadata does Kylo capture?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo captures extensive business and technical (for example, schema) metadata
defined during the creation of feeds and categories.  Process lineage
as relationships between feeds, sources, and sinks. Kylo automatically capture all operational
metadata generated by feeds. In addition, Kylo stores job and feed
performance metadata and SLA metrics. We also generate data profile
statistics and samples. We capture feed versions.

How does Kylo support metadata exchange with 3rd party metadata servers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo's metadata server has REST APIs that could be used to do metadata
exchange fully documented in Swagger.

Often the actual question isn’t whether/how we support metadata
exchange, but how we would map our metadata model to the 3rd party
model.

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

    See: \ `*http://modeshape.jboss.org/* <http://modeshape.jboss.org/>`__

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

Please access the REST documentation through a running Kylo instance  http://kylo-host:8400/api-docs/index.html

Does the Kylo application provide a visual lineage?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Yes, Kylo provides a visual process lineage feature for exploring relationships between feeds and shared sources and sinks.  Job instance level lineage is stored as "steps" visible in the feed job
history.

What type of process metadata do we capture?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We capture job and step level information on the status of the process,
with some information on the number of records loaded, how long it took,
when it was started and finished, and errors or warnings generated. We
capture operational metadata at each step, which can include record
counts, etc. dependent on the type of step.

What type of data or record lineage?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo tracks lineage as relationships between feeds. A feed in Kylo
represents a significant unit movement of data between source(s) and
sink (for example an ingest, transformation pipeline, or export of data)
but it does not imply a particular technology since transformations can
occur in Spark, Hive, Pig, Shell scripts, or even 3rd party tools like
Informatica. We believe the feed lineage has advantages of consistency over bottom-up
approach other common tools provide. Feeds as entities are interesting units as they are
naturally enriched with business data, Service Level Agreements, job history,
and technical metadata about any sources and sinks it uses, as well as
operational metadata about datasets.

When tracing lineage, we are capable of providing a much more relatable
representation of dependencies (either forwards or backwards through the
chain) than other tools.

Object lineage: ability to perform impact analysis on backward and
forward at object level (table level,attribute level).

Development Lifecycle
---------------------

What's the pipeline development process using Kylo? 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Pipelines developed with Apache NiFi can be developed in one environment
and then imported into UAT and production after testing. Once
the NiFi template is registered with Think Big’s system then a business
analyst can configure new feeds from it through our guided user
interface.

Alternatively an existing Kylo feed can be exported from an environment to a zip file which contains a combination of the underlying template and the metadata. The
package can then be imported in the production NiFi environment by an administrator.

Does Kylo support an approval process to move feeds into production?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo generation using Apache NiFi does NOT require a restart to deploy
new pipelines. By locking down production NiFi access, users could be
restricted from creating new types of pipelines without a formal
approval process.

Can new feeds be created in automated fashion instead of manually through the UI?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes via Kylo's REST API. See Swagger documentation (above).

Tool Comparisons
----------------

Is Kylo's metadata support similar to Cloudera Navigator, Apache Atlas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In some ways. Kylo is not trying to compete with these and could certainly
imagine integration with these tools. However, we also have an extensible
metadata server. Navigator is a governance tool that comes as part the
Cloudera Enterprise license. Among other features, it provides data
lineage of your Hive SQL queries. We think this is useful but only
provides part of the picture. Our framework is really the foundation of
an entire data lake solution. It captures both business
and operational metadata. It tracks lineage at the feed-level. Kylo provides IT Operations with a useful dashboard, ability to
track/enforce Service Level Agreements, and performance metrics.

How does it compare to traditional ETL tools like Talend, Informatica, Data Stage?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Many ETL tools are focused on SQL transformations using their own
technology (often clustered). Hadoop data patterns are more often ELT (extract and load raw data,
then transform). But typically the data warehouse style transformation
is into a relational schema such as a star or snowflake. In Hadoop it is
in another flat denormalized structure. So we don’t feel those expensive
and complicated technologies are really necessary for most ELT
requirements in Hadoop. Kylo provides a user interface for an end-user to
configure new data feeds including schema,security,validation, and
cleansing. Kylo provides the ability to wrangle and prepare
visual data transformations using Spark as an engine.

Potentially Kylo can invoke traditional ETL tools, e.g. wrap 3rd party ETL jobs as "feeds" and so leverage these technologies.

Scheduler
---------

How does Kylo manage job priority?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo exposes the ability to control which yarn queue a task executes on. Typically scheduling this is done through the scheduler. There are some
advanced techniques in NiFi that allow further prioritization for shared
resources. 

Can Kylo support complicated ETL scheduling?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We support the flexibility of cron-based scheduling, but also
timer-based, or event-based using JMS and an internal Kylo ruleset. NiFi embeds the Quartz.

What’s the difference between “timer” and “cron” schedule strategies?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Timer is fixed interval, “every 5 min or 10 seconds”. Cron can be
configured to do that as well but can handle more complex cases like
“every tues at 8AM and 4PM”.

Does Kylo support 3rd party schedulers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes, feeds can be triggered via JMS or REST.

Does Kylo support chaining feeds? One data feed consumed by another data feed?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo supports event-based triggering of feeds based on preconditions or rules. One can define rules in the UI that determine when to run a
feed such as “run when data has been processed by feed a and feed b and
wait up to an hour before running anyway”. We support simple rules up to
very complicated rules requiring use of our API.

Security
--------

Does Kylo have roles, users and privileges management function?
---------------------------------------------------------------

Kylo uses Spring Security. It can integrate with Active Directory, Kerberos, LDAP,
or most any authentication provider.

Kylo supports the definition of roles (or groups) and the specific permissions a user with that role can perform down to the function level.

Detailed Questions
------------------

How does “incremental” loading strategy of a data feed work?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo supports a simple incremental extract component. We maintain a
high-water mark for each load using a date field in the source record.

Can we generate data feeds for relational databases?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes, Kylo inspects the source schema and exposes it through our user
interface for the user to be able to configure feeds.

What kinds of database can be supported in Kylo?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We store metadata and job history in MySQL or Postgres. For sourcing
data, any JDBC supported driver. It has been tested with data sources such as Teradata, SQL Server, Oracle, Postgres, and MySQL.


Does Kylo support creating Hive table automatically after the source data is put into Hadoop?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes. We have a stepper “wizard” that is used to configure feeds and can
define a table schema in Hive. The stepper infers the schema looking at
a sample file or from the database source. It automatically creates the
Hive table on the first run of the feed.
