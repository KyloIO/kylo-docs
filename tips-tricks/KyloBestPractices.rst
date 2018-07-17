
==============
Best Practices
==============

The following document describes patterns and best practices particularly oriented to IT Designers and System Administrators.

Organizational Roles
--------------------

Kylo supports the division of responsibility between IT designers, administrators, operations, and end-users.

Role separation
~~~~~~~~~~~~~~~

A key tenet of Kylo is IT governed self-service. Most activities such as data ingest and preparation are possible by data analysts who may have deep understanding of their data but not appreciate the advanced data processing concepts of Hadoop. It is the
responsibility of the Designer to build models that incorporate best practices and maintain the ability for end-users to easily configure feeds.

Designers are responsible for developing templates for pipelines using Apache NiFi. When configured in Kylo provide the processing model for feeds created by end-users.  System Administrators are
responsible for activities such as install, configuration, connections, security, performance tuning and role-based security.

Designers
~~~~~~~~~~~

Designers should limit the properties exposed to end-users and assume a
user has limited knowledge of the internal working of the pipeline. For
example, it is poor practice to expose Spark parameters, paths to
libraries, memory settings, concurrency settings, etc. However, a user
creating a feed should would know the name of file(s) to load, whether
they want to do a snapshot or merge, and target table names and business
metadata.

Designers use the NiFi expression language and Kylo’s built-in metadata
properties to auto-wire processor components in the NiFi flow to the
wizard UI.

Administrators
~~~~~~~~~~~~~~~~~

NiFi/Hadoop Administrators are typically system administrators who need
to control resource utilization, such as memory and concurrency. These
activities are typically configured directly in NiFi.

The Administrator is also responsible for configuring NiFi Controller
Services, which may contain privileged database and services login
configuration.

The Administrator must review new pipelines to understand how shared
resources are utilized. For example, a flow may use excessive resources
on the edge node or may need to be properly tuned for the size of the
target cluster. Administrators may modify resource behavior such as
concurrency, back-pressure settings, Spark driver memory, and number of
mappers.

The Administrator should also evaluate new flows and understand security
implications or security vulnerabilities introduced as NiFi operates as
a privileged user.

Operations
~~~~~~~~~~

An Operator uses the Operations Manager dashboard to monitor activity in
the system and relies on alerts. The Designer should consider that an
Operations user may need to respond to problems and recover from errors.

Users
~~~~~~~~~~

Users can include data analytics, data scientists, and data stewards who interact with the Kylo application.  Administrator determines what features are available to users based on roles.
Designers determine how users are able to configure feeds based on templates.


Designers
--------------------

Guidance for designers who design new pipeline templates and enable self-service.

NiFi Template Design
~~~~~~~~~~~~~~~~~~~~

The Designer is responsible for developing Apache NiFi templates, which
provide the processing model for feeds in Kylo. Once a template has been
registered with the Kylo framework through the administrative template
UI, Kylo allows end-users to create and configure feeds (based on that
template model) through a user-friendly, guided wizard. The use of templates
embodies the principle of “write-once, use-many”.

The Designer determines which parameters are settable by an end-user in
the wizard UI, how the field is displayed (for example: picklist, SQL
window, numeric field), and any defaults or constraints. The Designer
may also wire parameters to environment-specific properties and any
standard metadata properties provided by the UI wizard used by
end-users.

After a template is registered in Kylo, an end-user will be able to
create new feeds based on that template using the UI-wizard. End-users
may only set parameters exposed by the template designer.

A well-written template may support many feeds. It should incorporate
best practices and consider security, regulatory requirements, and error
handling.

A good reference model is Kylo’s standard ingest template. This can
serve as a model for best practices and can be adapted to an
organization’s individual requirements.

Template re-use
~~~~~~~~~~~~~~~

Templates should be designed for maximum re-use and flexibility. Kylo's standard ingest serves as
an example of this. There are two types of templates Kylo uses this to promote this objective:

- Feed Template. Kylo generates a clone of this template as a unique running instance per feed. This means for every feed, there is a copy of the pipeline as defined by the template. Kylo uses the template to make the clone and injects any metadata configured in the feed (e.g. data source selections, schema configuration, etc). The feed template should be composed of the set of initial datasource connectors, an UpdateAttribute processor where Kylo can inject common metadata configured by the wizard, and an output port connected to a re-usable flow (below).  The feed-based template should include minimal logic.  The bulk of logic should be contained in the re-usable flow.

- Reusable-flow Template. This template is used to create a single running instance of the flow that can supports multiple connected feeds through a NiFi input port.  The core logic for your pipelines should be centralized into re-usable flows. This allows one to update the pipeline for many feeds in just one place.

Again, both types of templates are exemplified in Kylo's standard ingest template included with Kylo. More about reusable flows is discussed below.

Reusable Flows
~~~~~~~~~~~~~~

When possible, consider using re-usable flows for the majority of pipeline
workflow and logic.  A reusable flow is a
special template that creates just a single instance of a flow shared
by other feed flows through a NiFi process port.  A single
instance simplifies administration and future updates. All feeds
utilizing a reusable flow will inherit changes automatically.

A re-usable flow will require at least two templates: 1) The feed flow
instance template, and 2) the re-usable flow template.

The feed flow instance will be generated each time a feed is created and
will have the feed-specific configuration defined by the end-user. The
feed-instance defines an output to the re-usable flow. The re-usable
flow template will have an input from the feed-instance flow.

When a Designer registers the re-usable template and the feed instance
template, the Designer is prompted to wire together the input and
output. Kylo will take care of auto-wiring these each time a new feed is
created.

Please see Kylo's standard ingest templates for an example of this in action.

Streaming Templates
~~~~~~~~~~~~~~~~~~~

Kylo can support batch and streaming feeds.   In a batch feed, each dataset is
processed and tracked as a job from start to finish. The entire job fails if the
dataset is not processed successfully.

Streaming feeds typically involve continuous data processing of very frequent,
discrete packets of data. Data can be flowing through different portions of the
pipeline. Tracking each record in a streaming feed as a job would add significant
overhead and could be meaningless.  Imagine consuming millions of JMS messages and
viewing each records journey through the pipeline as a job. This would be impractical.
Instead, Kylo treats a streaming feed as a constant running job, gathering aggregate
statistics such as success and failure rates, throughput, etc.

A template can be registered as a streaming template by checking the ‘Streaming template”
checkbox on the last step of the template registration wizard.

Error Handling
~~~~~~~~~~~~~~

Error handling is essential to building robust flows.

NiFi processors have the ability to route to success or failure paths.
This allows the Designer to setup standard error handling. The Designer
should ensure that data is never lost and that errors allow an Operator
to recover.

Kylo is configured to look for any activity along standard failure paths
and trigger alerts in Ops Mgr.

A best practice is to handle errors in consistent ways through a
reusable “error flow”. Potentially, a custom NiFi processor could be
developed to make this convenient for Designers.

Some processors automatically support retries, providing a penalty to
incoming flowfiles. An example of this case is when a resource is
temporarily unavailable. Rather than failing, the flowfile will be
penalized (delayed) and re-attempted at a later point.

Preserve Edge Resources
~~~~~~~~~~~~~~~~~~~~~~~

The edge node is a limited resource, particularly compared to the Hadoop
cluster. The cluster will have a magnitude greater IO and processing
capacity than the edge, so if possible avoid moving data through Apache
NiFi. Strive to move data directly from source to Hadoop and performing
any data processing in the cluster.

There may be good arguments to perform data processing through the edge
node, in this case a single edge node may be insufficient and require a
small NiFi cluster along the edge.


.. note:: The advantage of external Hive tables is the ability to simply mount an HDFS file (external partition). This means data can be moved to HDFS, and then surfaced in a table through a simple DDL (ADD PARTITION).



Generalize Templates
~~~~~~~~~~~~~~~~~~~~

Templates allow the Designer to promote the “write-once,use-many”
principle. That is, once a template is registered with Kylo, any feeds
created will utilize the model provided. The Designer should consider
parameterizing flows to support some derivative data use cases, while
always striving to maintain ease of use for end-users, who have to
create feeds and ensure their testability.

An example of this type of flexibility is a flow that allows the
end-user to select from a set of sources (for example: kafka,
filesystem, database) and write to different targets (for example: HDFS,
Amazon S3). A single template could feasibly provide this capability.
There is no need to write nxn templates for each possible case.

It may be necessary to write “exotic templates” that will only be used
once by a single feed. This is also fine. The Designer should still
consider other best practices, such as portability. See chaining feeds
below for a possible alternative to this.

Chaining Feeds
~~~~~~~~~~~~~~

Instead of creating long special-purposed pipelines, consider breaking
the pipeline into a series of feeds. Each feed then represents a
significant movement of data between source and sink (for example:
ingest feed, transform feed A, transform feed B, export feed).

Kylo provides the ability to chain feeds together via *preconditions.
Preconditions* define a rule for the “event” that will trigger a feed.
Preconditions allow triggering based on the completion of one or more
predecessor jobs.  The ability to define *preconditions* can be enabled
by a Designer and configured by a Data Analyst during the feed creation
process.  This allows for sophisticated chaining of feeds without
resorting to the need to build specially-purpose pipelines.

One-Time Setup and Deletion
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Designer should incorporate any one-time setup, and any processing
flow required for deletion of a feed. One time setup is referred to as
*registration* within a feed. The metadata server can route a flow
through a one-time registration process to setup Hive tables and HDFS
paths.

A proper deletion routine should delete all the Hadoop artifacts created
by a feed. Delete allows a user to test a feed and easily delete it if
needed.  The cleanup-up flow is described below.

Clean-up
~~~~~~~~
When creating a template, ensure you have the appropriate clean-up activity associated. If
using the standard ingest, you can also use the standard clean-up to remove HDFS, Hive tables
and the feed itself. This is triggered when the delete feed option is clicked on the Kylo UI.

Clean up flows should be configured to start with a TriggerCleanup trigger processor and
the attribute variables set to specify that feed. When you register the template in Kylo,
be sure to set the attributes for the Trigger Cleanup processor to take the metadata systemNames
of the feed.

For each client, think about what a clean-up best practice will be when you design the template
as this may be different per client.

Clean-ups could also be triggered through a JMS message using the publish and consumeJMS processors. In t
this way you could start a clean-up activity on the completion of a feed for instance


Lineage Tracking
~~~~~~~~~~~~~~~~

Kylo automatically maintains lineage at the “feed-level”
and by any sources and sinks identified by the template designer when
registering the template.

Kylo relies on the designer specifying the roles of processors as sources or sinks
when registering the flow. The default or stereotype role of processors can be
defined by a system administrator conf/datasource-definitions.json.

Idempotence
~~~~~~~~~~~

Pipelines and template steps should be idempotent, such that if work is
replayed it will produce the same result without a harmful side effect
such as duplicates.

Environment Portability
~~~~~~~~~~~~~~~~~~~~~~~

NiFi Templates and associated Kylo configuration can be exported from
one environment and imported into another environment. The Designer
should ensure that Apache NiFi templates are designed to be portable
across development, test and production environments .

Environment-specific settings such as library paths or URLs should be
specified in the environment-specific settings file in Kylo. See
documentation. Environment-specific variables can be set through an
environment specific properties file. Kylo provides an expression syntax
for a Designer to utilize these properties when registering the
template.  An Administrator typically maintains the environment-specific
settings.

Application properties override template attribute settings and can be very useful
for setting environment specific settings and also to set specific controller related
settings. Application properties can be set encrypted and should be when setting sensitive information.

Note: You should NOT add your processor attributes to application properties unless they
are ENVIRONMENT specific. It is an anti-pattern to try to bring all attributes out into
“configuration property files”.


Data Confidence
~~~~~~~~~~~~~~~

In addition to NiFi templates for feeds, a Designer can and should
create templates for performing Data Quality (DQ) verification of those
feeds. Data Quality verification logic can vary but often can be
designed to be generalized into a few common patterns.

Examples of a DQ template might evaluate the profile statistics from the
latest run and use those statistics such as ratio of valid-to-invalid
records. Another check could compare aggregates in the source table
against Hadoop to verify that totals match at certain intervals (for
example: nightly revenue roll-ups match).

A special field identifies the template as a DQ check related to a feed
and used for Data Confidence KPI, alerts, and feed health by the Ops
manager. See Manual.

Data Ingestion
~~~~~~~~~~~~~~~

**Archival**: It is best practice to preserve original raw content and
consider regulatory compliance. Also, consider security and encryption
at rest since raw data may contain sensitive information.  After a
retention period is passed, information may be deleted. ILM feeds can be
created to do this type of house-keeping. Retention policies can
optionally be defined by a feed or business metadata at the
category-level.

Make sure to secure intermediate tables and HDFS locations used for data
processing. These tables may contain views of raw, sensitive data.
Intermediate tables may require different security requirements than the
managed table.  Additionally, the data may need to go on an encryption
zone on HDFS. Administrators and Operators may need visibility for
troubleshooting, but typical end-users should not see intermediate data.

Avoid “transformations” to raw.  Best practice is to ingest the raw
source (although consider protecting sensitive data) and avoid
transformation of the data.

Cleanup Intermediate Data
~~~~~~~~~~~~~~~~~~~~~~~~~

The intermediate data generated by feed processing should be
periodically deleted. It may be useful to have a brief retention period
(for example: 72 hours) for troubleshooting. A single cleanup feed can
be created to do this cleanup.

Data Cleansing and Standardization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo includes a number of useful cleansing and standardization functions
that can be configured by an end-user in the feed creation wizard UI.

Avoid using the cleansing and standardization capabilities to do complex
“transformation” data. It should be primarily used for manipulating data
into conventional or canonical formats (for example: simple datatype
conversion such as dates, stripping special characters) or data
protection (for example: masking credit cards, PII, etc.)

Kylo provides an extensible Java API for developing custom cleansing and
standardization routines.

Validation
~~~~~~~~~~

Hive is extremely tolerant of inconsistencies between source data and
the HCatalog schema. Using Hive without additional validation will allow
data quality issues to go unnoticed and extremely difficult to detect.

Kylo automatically provides schema validation, ensuring that source data
conforms to target schema.  For example, if a field contains alpha
characters and is destined for a numeric column, Kylo will flag the
record as invalid.

Additionally users can define field-level validation to protect against
data quality issues.

Kylo provides an extensible Java API for developing custom validation
routines.

Data Profiling
~~~~~~~~~~~~~~

Kylo’s Data profiling routine generates statistics for each field in an
incoming dataset.

Beyond being useful to Data Scientists, profiling is useful for
validating data quality (See Data Quality checking).


RDBMS Data
~~~~~~~~~~

Joins in Hadoop are inefficient. Consider de-normalizing data during
ingest.  One strategy is to ingest data via views.

File Ingest
~~~~~~~~~~~~

One common problem with files is ensuring they are fully written from a
source before they are picked up for processing. A strategy for this is
to set the process writing the file to either change permissions on the
file after the write is complete, or append a suffix such as DONE.


Character Conversion and Hive
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Hive works with UTF-8. Character conversion may be required for any
records that should be queried from Hive.  NiFi provides a character
conversion processor that can be used for this. Kylo can detect source
encoding using Tikka.


Development Patterns
-----------------------

Best practices and guidance oriented to the development process, release, and testing.

Development Process
~~~~~~~~~~~~~~~~~~~

NiFi templates should be developed and tested in a personal development
environment. Do not develop NiFi templates in the production NiFi
instance used by Kylo.

It is recommended to do initial testing in NiFi. Once the flow has been
tested and debugged within NiFi, then register the template with Kylo in
the development environment, where one can test feed creation.

.. note:: Controller Services that contain service, cluster, and database connection information should be setup by the Developer using their personal login information. In production, an Administrator manages these controller services, and they typically operate as an application account with elevated permissions.

Automated Deployment
~~~~~~~~~~~~~~~~~~~~
Building an automated deployment scripts is the best practice approach to
deploying feeds and templates and this should be delivered along with your
other deployment scripts. Importing of templates and feeds can be carried
out via the REST API of Kylo.

Template Export/Import
~~~~~~~~~~~~~~~~~~~~~~

As stated previously, it is recommended that Apache NiFi template
development occur in a development environment. This is a best practice
from a security and operations perspective. Kylo allows templates and
the registration metadata to be exported to a ZIP file. This file can be
imported into a new environment.

Feed Export/Import
~~~~~~~~~~~~~~~~~~

Although Kylo can be used for self-service feed creation in production,
some organizations prefer to lock this ability down and perform feed
development and testing in a separate environment.

Version Control
~~~~~~~~~~~~~~~~

It is recommended to manage exported templates and feeds through an SCM
tool such as git, subversion, or CVS.

General Deployment Guidelines
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Regardless of whether deploying manually or using automated scripts,
ensure the following:

- Deploy any reusable templates first
- Configure controller services (in NiFi) on the first time a template is imported or if any new controllers are introduced
- Smoke test your pipeline


Users
--------------

Best practices and guidance oriented to end-users (users of the Kylo application).

When to Use Snapshot
~~~~~~~~~~~~~~~~~~~~

Kylo allows users to configure feeds to do incremental updates or
to enable the use of a snapshot (replacing the target with the entire
contents). In the case of RDBMS, where there small source tables, it may
be more efficient to simply overwrite (snapshot) the data each time.
Tables with less than 100k records probably fit the snapshot pattern.

When to Use Timer (vs. Cron)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Timer is a good scheduling technique for lightweight polling behavior.
Be aware, however, that all timers fire concurrently when NiFi starts.
Avoid using for processors that place heavy demand on a source when
triggered. For example: database sources or launching a transformation
workflow. Cron is a more appropriate scheduling option for these
resource-intensive processors.

Wrangling
~~~~~~~~~

The wrangling utility allows for users to do visual drag-drop SQL joins
and apply transform functions to build complex transformations in a
WYSIWG, Excel-like interface. This is a recommended method for
performing transformations on raw data.

Service Level Agreements
~~~~~~~~~~~~~~~~~~~~~~~~~

Service level agreements are created by users to enforce service levels,
typically related to feeds. An SLA may set a threshold tolerance for
data arrival time or feed processing time. An SLA can enforce ratio of
invalid data from a source.

SLAs are useful for alerting and measuring service level performance
over-time.

Administrators
--------------------------

Back-Pressure
~~~~~~~~~~~~~

Administrators (and Designers) should understand NiFi capabilities
regarding back-pressure. Administrators can configure backpressure
limits at the processor level to control how many flow files can be
queued before upstream processors start to throttle activity. This can
assure that a problem with a service doesn’t cause a huge queue or
result in a large number of failed jobs.

Business Metadata
~~~~~~~~~~~~~~~~~

Business metadata is any information that enriches the usefulness of the
data, or is potentially helpful for future processing or error handling.

Kylo allows an Administrator to setup business metadata fields that a
user sees when creating a feed.  These business metadata templates can
be setup either globally or at the category-level.  Once setup, the user
is prompted to fill this information in the Properties step of the
Ingest wizard.

Security
---------

Guidance around security.

Security Vulnerabilities
~~~~~~~~~~~~~~~~~~~~~~~~

Designers and Administrators should be aware of introducing a backdoor
for malicious users, or even for developers.  Although NiFi components
are extremely powerful, be aware of SQL Injection or exposing the
ability for a user to paste script.

Consider issues such a malicious user configuring an ingestion path that
accesses secure files on the file system.

When importing feeds from other environments, the Administrator should
always ensure that the security group is appropriate to the environment.
A security group that may be appropriate in a development environment
might not be inappropriate for production.
