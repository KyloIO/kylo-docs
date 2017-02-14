=============
Release Notes
=============

V0.6.2 RELEASE (FEB. 7, 2017)
=============================

Highlights
----------

-  Support for triggering multiple dependent feeds (PC-1186)

-  Added a flag to allow operations manager to query and display NiFi
   bulletins on feed failure to help show any logs NiFi generated during
   that execution back in operations manager

-  Fixed NiFi provenance reporting to support manual emptying of flow
   files which will now fail the job in ops manager

-  The Audit Log table in Kylo will now track feed updates

Upgrade Instructions from v0.6.0
--------------------------------

Build or download the rpm.

1. Shut down nifi - "service nifi stop"

2. Run /opt/kylo/remove-kylo.sh to
   uninstall the RPM

3. Install the new RPM "rpm –ivh <RPM_FILE>"

4. Run /opt/kylo/setup/nifi/update-nars-jars.sh

5. Start NiFi - "service nifi start"  (wait to start)

6. Update the configuration files, with your custom configuration, at:

.. code-block:: shell

   /opt/kylo/kylo-ui/conf/,
   /opt/kylo/kylo-services/conf/, and
   /opt/kylo/kylo-spark-shell/conf/

..

   A backup of the previous version's configuration is available from /opt/kylo/bkup-config/.

7. If using NiFi v0.7 or earlier, modify /opt/kylo/kylo-services/conf/application.properties by
   changing spring.profiles.active from nifi-v1 to nifi-v0.

8. Start the kylo apps:

.. code-block:: shell

    /opt/kylo/start-kylo-apps.sh

..

9. Ensure that the reporting task is configured. A ReportingTask is now used
   for communication between NiFi and the Operations Manager.  In order to
   see Jobs and Steps in the Operations Manager, follow these configuration instructions: :doc: `NiFi
   KyloProvenanceReportingTask`

Whats coming in 0.7.0?
----------------------

The next release will be oriented to public open-source release and
select issues identified by the field for client projects.

The approximate release date is February 13, 2017.

V0.6.1 RELEASE (JAN. 26, 2017)
==============================

Highlights
----------

-  Improved NiFi provenance reporting performance

-  Added timeout option to the NiFi ExecuteSparkJob processor

-  Fixed missing Cloudera dependency

   -  To build for Cloudera, substitute
      "kylo-service-monitor-ambari" with
      "kylo-service-monitor-cloudera-service" in
      services/service-app/pom.xml

Potential Impacts
-----------------

Upon upgrading, the ExecuteSparkJob processors will be marked as invalid and you will get a note saying: “Max wait time is invalid property”.  You will need to stop these processors and delete the "Max wait time" property


Upgrade Instructions from v0.6.0
--------------------------------

Build or download the rpm:

1.  Shut down NiFi using the "service nifi stop" command.

2.  Run /opt/kylo/remove-kylo.sh to
    uninstall the RPM.

3.  Install the new RPM "rpm –ivh <RPM_FILE>"

4.  Run /opt/kylo/setup/nifi/update-nars-jars.sh

5.  Start NiFi - "service nifi start"  (wait to start)

6.  Update, with your custom configuration, these configuration files:

.. code-block:: shell

    /opt/kylo/kylo-ui/conf/
    /opt/kylo/kylo-services/conf/
    /opt/kylo/kylo-spark-shell/conf/

..

    A backup of the previous version's configuration is
    available from /opt/kylo/bkup-config/.

7.  If using NiFi v0.7 or earlier, modify the
    /opt/kylo/kylo-services/conf/application.properties by
    changing spring.profiles.active from nifi-v1 to nifi-v0.

8.  Start kylo apps:

.. code-block:: shell

     /opt/kylo/start-kylo-apps.sh

..

9.  Update the ExecuteSparkJob processors (Validate and Profile
    processors) fixing the error, “Max wait time is invalid property”, by
    removing that property.

10. Ensure that the reporting task is configured as ReportingTask is now used
    for communication between NiFi and Operations Manager.  In order to
    see Jobs and Steps in Ops Manager you will need to configure this
    following these instructions: :doc: `NiFi
    KyloProvenanceReportingTask`

V0.6.0 RELEASE (JAN. 19, 2017)
==============================

Highlights
----------

-  90+ issues resolved

-  NiFi clustering support. Ability to cluster NiFi with Kylo.

-  Streaming enhancements. New streaming UI plots and higher throughput
   performance between Kylo and NiFi. Ability to specify a feed as a
   streaming type to optimize display.

-  Improved schema manipulation. Ability for feeds and target Hive
   tables to diverge (for example: drop fields, rename fields, and change data
   types for fields the exist in raw files regardless of raw type).

-  Alert persistence.  Ability for the alert panel to store alerts (and
   clear), including APIs for plugging in custom alert responder and
   incorporate SLA alerts.

-  Configurable data profiling.  Profiled columns can be toggled to
   avoid excessive Spark processing.

-  Tags in search. Ability to search tags in global search.

-  Legacy NiFi version cleanup.  Deletes retired version of NiFi feed
   flows.

-  Avro format option for database fetch.  The GetTableData processor has
   been updated to allow writing rows in Avro format and to allow
   setting a custom column delimiter when the output type is a delimited
   text file.

-  Feed file upload.  Ability to upload a file directly to a feed and
   have it trigger immediately (for feeds using filesystem).

-  Tutorials. New admin tutorial videos.

Potential Impacts
-----------------

-  JMS topics switch to queues in order to support NiFi clustering.
   Check your ActiveMQ Topics page
   (http://localhost:8161/admin/topics.jsp) to ensure that there are no
   pending messages before shutting down NiFi. The number of enqueued
   and dequeued messages should be the same.

-  Apache NiFi versions 0.6 and 0.7 are no longer supported. Some
   features may continue to function normally but haven't been properly
   tested. These will stop working in future releases. Upgrading to the
   latest version of Apache NiFi is recommended.

-  (for VirtualBox sandbox upgrades) The default password for MySQL has
   changed. If you are using default config files deployed via RPM, 
   modify your MySQL password to match or alter the configuration files.


Upgrade Instructions from v0.5.0
--------------------------------

Build or download the rpm:

1. Shut down nifi - "service nifi stop"

2. Run /opt/kylo/remove-kylo.sh to
   uninstall the RPM

3. Install the new RPM "rpm –ivh <RPM_FILE>"

4. Run /opt/kylo/setup/nifi/update-nars-jars.sh

5. Update /opt/nifi/current/conf/nifi.properties file and change it to
   use the default PersistentProvenanceRepository:
   nifi.provenance.repository.implementation=org.apache.nifi.provenance.PersistentProvenanceRepository

6. Execute the database upgrade script: 

.. code-block:: shell

   /opt/kylo/setup/sql/mysql/kylo/0.6.0/update.sh localhost root
   <password or blank>

..

7. Create the "/opt/nifi/activemq" folder and copy the jars:

.. code-block:: shell

    $ mkdir /opt/nifi/activemq 
    $ cp /opt/kylo/setup/nifi/activemq/*.jar /opt/nifi/activemq 
    $ chown -R nifi /opt/nifi/activemq/

..

8. Add a service account for kylo application to the nifi group (This
   will allow Kylo to upload files to the dropzone location defined in
   NiFi). This step will differ per operating system, and depending upon how the service accounts were created.

.. code-block:: shell

    $ sudo usermod -a -G nifi kylo

..

+-----------+------------------------------------------------------------------+
| **Note:** | All dropzone locations must allow kylo service account to write. |
+-----------+------------------------------------------------------------------+

9. Start NiFi - "service nifi start"  (wait to start).

   Note: If errors occur, try removing the transient provenance data:

.. code-block:: shell

    rm -fR /PATH/TO/NIFI/provenance_repository/

..

10. Update, using your custom configuration, these configuration files:

.. code-block:: shell

     /opt/kylo/kylo-ui/conf/
     /opt/kylo/kylo-services/conf/
     /opt/kylo/kylo-spark-shell/conf/  

..

    A backup of the previous version's configuration is available from /opt/kylo/bkup-config/.

11. If using NiFi v0.7 or earlier, modify /opt/kylo/kylo-services/conf/application.properties by changing spring.profiles.active from nifi-v1 to nifi-v0.

12. Start Kylo apps:

.. code-block:: shell

     /opt/kylo/start-kylo-apps.sh

..

13. Update the re-usable standard-ingest template:

.. code-block:: shell

     index_schema_service, and the index_text_service 

..

   a. The standard-ingest template can be updated through the templates
      page. (/opt/kylo/setup/data/templates/nifi-1.0/) The upgrade
      will:

      i.   Add "json field policy file" path as one of the parameters to
           Profiler processor to support selective column profiling. See
           "Configurable data profiling" in highlights

      ii.  Add feed field specification to support UI ability to modify
           feeds. See "Improved schema manipulation" in highlights above

      iii. Adds shared library path to activemq libraries required going
           forward

   b. The index_schema_service and index_text_service templates are
      feed templates and should be updated through the feeds page.
      (/opt/kylo/setup/data/feeds/nifi-1.0/.

      i.   Go to the feeds page.

      ii.  Click the Plus icon.

      iii. Click on the "import from file" link.

      iv.  Choose one of the Elasticsearch templates and check the overwrite box.

14. A ReportingTask is now used for communication between NiFi and Operations Manager.  In order to see Jobs and Steps in Ops Manager you will need to configure this following these instructions:

:doc:`NiFiConfigurationforaKerberosCluster`

:doc:`NiFiKyloProvenanceReportingTask`

V0.5.0 RELEASE (DEC. 14, 2016)
==============================

Highlights
----------

-  65 issues resolved

-  Audit tracking.  All changes in Kylo are tracked for audit logging.

-  Spark 2.0 support!

-  PySparkExec support. New NiFi processor for executing Spark Python
   scripts

-  Plug-in API for adding raw formats.   Ability to plug-in support for
   new raw file formats and introspect schema

-  New raw formats: Parquet, ORC, Avro, JSON

-  Customize partition functions.  Ability to add custom UDF functions
   to dropdown for deriving partition keys

-  Feed import enhancements. Allow users to change target category on
   feed import

-  Sqoop improvements. Improved compatibility with Kylo UI and behavior

-  JPA conversion. Major conversion away from legacy Spring Batch
   persistence to JPA for Ops Mgr

-  Date/time standardization.  Storage of all dates and times will be
   epoch time to preserve the ability to apply timezones 

-  New installation document showing an example on how to install Kylo
   on AWS in an HDP 2.5 cluster with the following: 

:doc: `HDP25ClusterDeploymentGuide`

-  Ranger enabled

-  Kerberos enabled

-  Minimal admin privileges 

-  NiFi and Kylo on separate edge nodes

Known Issues
------------

Modeshape versioning temporarily disabled for feeds due to rapid storage
growth.   We will have a fix for this issue and re-introduce it in
0.5.1.

Potential Impacts
-----------------

-  JPA conversion requires one-time script (see install instructions)

-  Spark Shell moved into Think Big services /opt directory

-  Date/time modification Timestamp fields converted to Java time for
   portability and timezone consistency.  Any custom reports will need
   to be modified

V0.4.3 RELEASE (NOV. 18, 2016)
==============================

Highlights
----------

-  67 issues resolved

-  Hive user impersonation. Ability to restrict Hive table access
   throughout Kylo based on permissions of logged-in user

-  Visual data lineage.   Visualization of relationship between feeds,
   data sources, and sinks  (`Feed
   Lineage) <https://wiki.thinkbiganalytics.com/display/RD/Feed+Lineage>`__

-  Auto-layout NiFi feeds. Beautified display of Kylo-generated feeds in
   NiFi

-  Sqoop export. Sqoop export and other Sqoop improvements from last
   release

-  Hive table formats.  Final Hive table format extended to: RCFILE,
   CSV, AVRO (in addition to ORC, PARQUET)

-  Hive change tracking.  Batch timestamp (processing_dttm partition
   value) carried into final table for change tracking

-  Delete, disable, reorder templates. Ability to disable and/or remove
   templates  as well as change their order in Kylo

-  Spark yarn-cluster support.   ExecuteSparkJob processor now supports
   yarn-cluster mode ( thanks Prav!)

-  Kylo logo replaces Teradata Thinkbig logo (note: this is not our
   final approved logo)

Known Issues
------------

Hive impersonation is not supported with CDH if using Sentry.

Wrangler does not yet support user impersonation.

Potential Impacts
-----------------

-  Existing Wrangler feed tables will need to ALTER TABLE to add a
   processing_dttm field to table in order to work.

-  The Processing_dttm field is now in Java epoch time, instead of formatted
   date to be timezone independent. Older feeds will now have partition
   keys in two different formats.

-  All non-feed tables will now be created as managed table **s**.


V0.4.2 RELEASE (NOV. 4, 2016)
=============================

Highlights
----------

-  70+ issues resolved

-  NiFi v1.0 and HDF v2.0 support

-  Encrypted properties and passwords in configuration files (`Encrypted
   Property
   Guide <https://github.com/ThinkBigAnalytics/data-lake-accelerator/blob/master/docs/latest/deployment-guide.adoc#encrypting-configuration-property-values>`__)

-  SSL support.  SSL between services  `SSL Configuration
   Guide <https://wiki.thinkbiganalytics.com/display/RD/NiFi+1.0+%28HDF+2.0%29+SSL+Configuration++for+use+with+Kylo+0.4.2>`__

-  Feed-chaining context.   Context can be passed from dependent feeds
   (`Trigger Feed
   Guide <https://wiki.thinkbiganalytics.com/display/RD/TriggerFeed>`__)

-  Lineage tracking.  Schema, feed, and preconditions

-  UI/UX improvements

-  CSVSerde support and improved schema discovery for text files

-  NiFi Template upgrades

-  Procedure for relocating install locations of Kylo and dependencies.
   See `Kylo TAR
   install <https://github.com/ThinkBigAnalytics/data-lake-accelerator/blob/master/docs/latest/deployment/kylo-tar-install.adoc>`__


V0.4.1 RELEASE (OCT. 20, 2016)
==============================

Highlights
----------

-  Resolved approx 65 issues

-  Ranger and Sentry integration (ability to assign groups to feed
   tables)

-  NEW Sqoop import processor for efficient database ingest (tested with
   Sqoop v1.4.6, Databases-Teradata,Oracle, and MySQL)

-  Watermark service provides support for incremental loads

-  Hive merge on Primary Key option

-  Skip header support

-  Configurable root paths for Hive and HDFS folders (multi-tenancy
   phase I)

-  New and simplified standard ingest and re-usable wrangler flows

-  Support for Hive decimal type

-  Support for choosing existing field as partition

-  Documentation updates

-  UI usability improvements (validation, etc)

Known Issues
------------

Creating a feed using standard data ingest with Database as the input
may fail on initial run. There are two workarounds you can do to resolve
this: 

1. Go to the "Feed Details" screen for the feed and disable and then
   enable the feed.

2. During creation of the feed, on the last "Schedule" step, you can
   uncheck the "Enable Feed Immediately".  This will save the feed in a
   "disabled state".  Once the feed has been created, click "View Details" on the Success
   screen then enable the feed.

V0.4.0 RELEASE (OCT. 4, 2016)
=============================

Highlights
----------

-  Support Streaming/Rapid Fire feeds from NiFi

-  Note: Operations Manager User Interfaces for viewing Streaming feeds
   will come in a near future release

-  Security enhancements including integration with LDAP and
   administration of users and groups through the web UI

-  Business metadata fields can be added to categories and feeds

-  Category and feed metadata can be indexed with Elasticsearch, Lucene,
   or Solr for easier searching

-  Fixed bug with kylo init.d service scripts not support the
   startup command

-  Fixed issues preventing preconditions or cleanup feeds from
   triggering

-  Fixed usability issues with the visual query

-  Better error notification and bug fixes when importing templates

-  Service level agreement assessments are now stored in our relational
   metadata store

-  Spark Validator and Profiler Nifi processors can now handle
   additional Spark arguments

-  Redesign of job details page in operations manager to view
   steps/details in vertical layout

-  Allow injection of properties for any processor or controller service
   in the application.properties file. The feed properties will be
   overridden when importing a template. This includes support to auto
   fill all kerberos properties


Known Issues
------------

-  The Data Ingest and Data Transformation templates may fail to import
   on a new install. You will need to manually start the
   *SpringContextLoaderService* and the *Think Big Cleanup Service* in
   NiFi, then re-import the template in the Feed Manager. Please
   see `PC-582 <https://bugs.thinkbiganalytics.com/browse/PC-582>`__ for
   more information.

-  When deleting a Data Transformation feed, a few Hive tables are not
   deleted as part of the cleanup flow and must be deleted manually.

Running in the IDE
------------------

-  If you are running things via your IDE (Eclipse or IntelliJ) you will
   need to run the following command under the
   **core/operational-metadata/operational-metadata-jpa** module

-  mvn generate-sources     

    This is because it is now using JPA along with
    QueryDSL( http://www.querydsl.com/) which generates helper Query
    classes for the JPA entities.  Once this runs you will notice it
    generates a series of Java classes prefixed with "Q" (i.e.
    QNifiJobExecution) in the
    **core/operational-metadata/operational-metadata-jpa/target/generated-sources/java/**

    Optionally you could just run a mvn install on this module which
    will also trigger the generate-sources.

-  Additionally if you havent done so you need to ensure the latest
   nifi-provenance-repo.nar file is in the /opt/nifi/data/lib folder.

V0.3.2 RELEASE (SEPT. 19, 2016)
===============================

Highlights
----------

-  Fixes a few issues found in v0.3.1.

-  Removed kylo, nifi, and activemq user creation from RPM install
   and installation scripts. Creating those users are now a manual
   process to support clients who use their own user management tools.

-  Kerberos support for the UI features (data wrangling, hive tables,
   feed profiling page). Data wranging uses the kylo user keytab and
   the rest uses the hive user keytab.

-  Fixed bug introduced in 0.3.1 where the nifi symbolic link creation
   is broken during a new installation.

-  Added support for installation Elasticsearch on SUSE

Note: The activemq download URL was changed. To manually update the
installation script edit:

/opt/kylo/setup/activemq/install-activemq.sh

and change the URL on line 25 to be

https://archive.apache.org/dist/activemq/5.13.3/apache-activemq-5.13.3-bin.tar.gz

V0.3.1 RELEASE (AUG. 17, 2016)
==============================

Highlights
----------

-  Fixes a few issues found in v0.3.0.

-  Fixes the download link to NiFi for generating an offline tar file.

-  Compatibility with MySQL 5.7.

-  Installs a stored procedure required for deleting feeds.

-  PC-393 Automatically reconnects to the Hive metastore.

-  PC-396 Script to update NiFi plugins and required JARs.

**Note:** A bug was introduced with installation of NiFi from the setup
wizard (Fixed in the 0.4.0-SNAPSHOT). If installing a new copy of PCNG
make the following change

Edit /opt/kylo/setup/nifi/install-kylo-components.sh and change
"./create-symbolic-links.sh" to
"$NIFI_SETUP_DIR/create-symbolic-links.sh"

V0.3.0 RELEASE (AUG. 10, 2016)
==============================

Highlights
----------

-  65 issues resolved by the team

-  **Feed migration**. Import/export feeds across environments

-  **Feed delete**. Delete a feed (including tables and data)

-  **Business metadata**. Ability to add user-defined business metadata
   to categories and feeds

-  **Feed chaining**. Chain feeds using UI-driven precondition rules

-  **SLA support**. Create Service Level Agreements in UI

-  **Alerting**. Alert framework and built-in support for JIRA and email

-  **Profiling UI**. New graphical UI for viewing profile statistics

-  **Wrangler XML support**. Wrangler enhancements including improved
   XML support

-  **Authentication**. Pluggable authentication support

V0.2.0 RELEASE (JUNE 22, 2016)
==============================

Whats New
---------

Release data: June 22, 2016

R&D is pleased to announce the release of v0.2.0 of the framework which
represents the last 3 weeks of sprint development. 

-  Over 60 issues were resolved by the team working in collaboration
   with our International teams using the framework for client projects.

-  Dependency on Java 8

-  Updated metadata server to ModeShape framework which supports many of
   our underlying architectural requirements:

   -  Dynamic schemas - provides extensible features for extending
      schema towards custom business metadata in the field

   -  Versioning - ability to track changes to metadata over time

   -  Text Search - flexible searching metastore

   -  Portability - can run on sql and nosql databases

   -  See: http://modeshape.jboss.org/
