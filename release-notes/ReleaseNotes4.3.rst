Release 0.4.3 (Nov. 18, 2016)
=============================

Highlights
----------

-  67 issues resolved

-  Hive user impersonation. Ability to restrict Hive table access
   throughout Kylo based on permissions of logged-in user

-  Visual data lineage.   Visualization of relationship between feeds,
   data sources, and sinks. Refer to :do:`FeedLineage`

-  Auto-layout NiFi feeds. Beautified display of Kylo-generated feeds in
   NiFi.

-  Sqoop export. Sqoop export and other Sqoop improvements from last
   release.

-  Hive table formats.  Final Hive table format extended to: RCFILE,
   CSV, AVRO (in addition to ORC, PARQUET).

-  Hive change tracking.  Batch timestamp (processing\_dttm partition
   value) carried into final table for change tracking.

-  Delete, disable, reorder templates. Ability to disable and/or remove
   templates  as well as change their order in Kylo.

-  Spark yarn-cluster support. ExecuteSparkJob processor now supports
   yarn-cluster mode (thanks Prav!).

-  Kylo logo replaces Teradata Thinkbig logo (note: this is not our
   final approved logo).

Known Issues
------------

Hive impersonation is not supported with CDH if using Sentry.

Wrangler does not yet support user impersonation.

Potential Impacts
-----------------

-  Existing wrangler feed tables will need to ALTER TABLE to add a
   processing\_dttm field to table in order to work.

-  Processing\_dttm field is now java epoch time instead of formatted
   date to be timezone independent. Older feeds will now have partition
   keys in two different formats.

-  All non-feed tables will now be created as managed table\ **s**
