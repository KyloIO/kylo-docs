==============================
Azure Standard Ingest Template
==============================

.. contents:: Table of Contents

Problem
=======

You need to modify Kylo's standard ingest template for Hive tables backed by the Azure Blob (WASB) store.

Intro
=====

This guide provides the basics for modifying Kylo's existing standard ingest template for use with the Azure Blob (WASB) store. For details on how to modify an existing template, please see the
video tutorials on http://kylo.io.

Configuration
=============

The resulting Data Ingest template will be a slightly modified version of the standard Data Ingest template included with Kylo.

.. note::

  * HD Insight clusters with Azure Blob Storage as a default storage has all the necessary properties set so default resource file, i.e. /etc/hadoop/conf/core-site.xml, can be used.

..

=============================-

To access Azure Blob Storage from HDFS, create an Hadoop Configuration XML file which, at minimum, will contain following properties:

+-----------------------------------------------------------+----------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Property                                                  | Value                                                                | Note                                                                             |
+===========================================================+======================================================================+==================================================================================+
| fs.azure.account.key.<your-account>.blob.core.windows.net | access key to your Azure Blob Storage's account (MSDN documentation) | See  Hadoop Azure documentation for more options for how to specific access keys |
+-----------------------------------------------------------+----------------------------------------------------------------------+----------------------------------------------------------------------------------+
| fs.defaultFS                                              | wasb://@.blob.core.windows.net                                       |                                                                                  |
+-----------------------------------------------------------+----------------------------------------------------------------------+----------------------------------------------------------------------------------+
| fs.wasb.impl                                              | org.apache.hadoop.fs.azure.NativeAzureFileSystem                     |                                                                                  |
+-----------------------------------------------------------+----------------------------------------------------------------------+----------------------------------------------------------------------------------+

Modify HDFS processor in template
=================================

Load the existing reusable Data Ingest template into NiFi, locate the HDFS processor and modify the following properties and reimport the template into Kylo:

+--------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------+
| Property                       | Note                                                                                                                                    |
+================================+=========================================================================================================================================+
| Hadoop Configuration Resources | Comma separated paths to XML configuration files. See  Hadoop Azure documentation for more options for how to specific access keys      |
+--------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------+
| Directory                      | absolute / relative path, within default FS, for writing / reading files                                                                |
+--------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------+
| Additional Classpath Resources | path to directory containing additional JARs needed by WASB (usually hadoop-azure-2.7.3.jar,azure-storage-2.0.0.jar                     |
+--------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------+

Known Limitations
-----------------

Default FS
----------

Because HDFS processors are using value of fs.defaultFS property in connection with processor's Directory property to figure out where to write/read files, this functionality can be limiting in terms when you need to copy/move files between various distributed file systems (DFS), using HDFS processors, within a single NiFi flow.

To overcome this limitation you can create minimal Hadoop configuration resource for the other FS and specify it in the list of files in Hadoop Configuration Resources property of HDFS processor. This will change the default FS for this single processor and thus allows to use a different DFS.

Single container
----------------

With previous limitation, Default FS, is a closely related a limitation on a single container - fs.defaultFS property contains also the container name. Way to overcome this limitation is the same as for default FS, i.e. create a copy of minimal Hadoop Configuration Resource file and change the fs.defaultFS property.
Troubleshooting
Server failed to authenticate the request. Make sure the value of Authorization header is formed correctly including the signature.

1. check that access keys are valid and you set them correctly in XML file (including the blob.core.windows.net after the storage account name)
2. if you run the NiFi on virtual machine make sure your OS time is synchronised (e.g. using NTP)

