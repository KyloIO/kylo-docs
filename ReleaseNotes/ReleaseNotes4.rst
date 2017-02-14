Release 0.4.0 (OCT. 4, 2016)
============================

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
   *SpringContextLoaderService* and the *Kylo Cleanup Service* in
   NiFi, then re-import the template in the Feed Manager.

-  When deleting a Data Transformation feed, a few Hive tables are not
   deleted as part of the cleanup flow and must be deleted manually.

Running in the IDE
------------------

-  If you are running things via your IDE (Eclipse or IntelliJ) you will
   need to run the following command under the
   **core/operational-metadata/operational-metadata-jpa** module

-  mvn generate-sources     

    This is because it is now using JPA along with
    QueryDSL(\ http://www.querydsl.com/) which generates helper Query
    classes for the JPA entities.  Once this runs you will notice it
    generates a series of Java classes prefixed with "Q" (i.e.
    QNifiJobExecution) in the
    **core/operational-metadata/operational-metadata-jpa/target/generated-sources/java/**

    Optionally you could just run a mvn install on this module which
    will also trigger the generate-sources.

-  Additionally if you havent done so you need to ensure the latest
   nifi-provenance-repo.nar file is in the /opt/nifi/data/lib folder.
