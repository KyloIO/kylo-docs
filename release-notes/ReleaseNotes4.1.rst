Release 0.4.1 (Oct. 20, 2016)
=============================

Highlights
----------

-  Resolved approximately 65 issues

-  Ranger and Sentry integration (ability to assign groups to feed
   tables)

-  NEW Sqoop import processor for efficient database ingest (tested with
   Sqoop version 1.4.6, Databases-Teradata,Oracle, and MySQL)

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
may fail on initial run. There are 2 workarounds you can do to resolve
this: 

1. Go to the "Feed Details" screen for the feed and disable and then
   enable the feed; or,

2. During creation of the feed on the last "Schedule" step you can
   uncheck the "Enable Feed Immediately".  This will save the feed in a
   "disabled state".  Once the feed has been created on the Success
   screen click "View Details"  then  enable the feed.
