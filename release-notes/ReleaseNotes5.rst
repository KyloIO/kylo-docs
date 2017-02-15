Release 0.5.0 (Dec. 14, 2016)
=============================

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
   on AWS in an HDP 2.5 cluster. Refer to :doc:`HDP25ClusterDeploymentGuide

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
