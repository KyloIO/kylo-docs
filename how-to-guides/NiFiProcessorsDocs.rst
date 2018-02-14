====================
NiFi Processor Guide
====================


ImportSqoop Processor
---------------------

About
~~~~~

The ImportSqoop processor allows loading data from a relational system
into HDFS. This document discusses the setup required to use this
processor.

Starter template
~~~~~~~~~~~~~~~~

A starter template for using the processor is provided at:

.. code-block:: shell

    samples/templates/nifi-1.0/template-starter-sqoop-import.xml

..

Configuration
~~~~~~~~~~~~~

For use with Kylo UI, configure values for the two properties (**nifi.service.<controller service name in NiFi>.password**, **config.sqoop.hdfs.ingest.root**) in the below section in the properties file: **/opt/kylo/kylo-services/conf/application.properties**

.. code-block:: shell

    ### Sqoop import
    # DB Connection password (format: nifi.service.<controller service name in NiFi>.password=<password>
    #nifi.service.sqoop-mysql-connection.password=hadoop
    # Base HDFS landing directory
    #config.sqoop.hdfs.ingest.root=/sqoopimport

..

.. note:: The **DB Connection password** section will have the name of the key derived from the controller service name in NiFi. In the above snippet, the controller service name is called **sqoop-mysql-connection**.

Drivers
~~~~~~~

Sqoop requires the JDBC drivers for the specific database server in order to transfer data. The processor has been tested on MySQL, Oracle, Teradata and SQL Server databases, using Sqoop v1.4.6.

The drivers need to be downloaded, and the .jar files must be copied over to Sqoop’s /lib directory.

As an example, consider that the MySQL driver is downloaded and available in a file named: **mysql-connector-java.jar.**

This would have to be copied over into Sqoop’s /lib directory, which may be in a location similar to: **/usr/hdp/current/sqoop-client/lib.**

The driver class can then be referred to in the property **Source Driver** in **StandardSqoopConnectionService** controller service
configuration. For example: **com.mysql.jdbc.Driver.**

.. tip:: Avoid providing the driver class name in the controller service configuration. Sqoop will try to infer the best connector and driver for the transfer on the basis of the **Source Connection String** property configured for **StandardSqoopConnectionService** controller service.

Passwords
~~~~~~~~~

The processor's connection controller service allows three modes of providing the password:

1. Entered as clear text
2. Entered as encrypted text
3. Encrypted text in a file on HDFS

For modes (2) and (3), which allow encrypted passwords to be used, details are provided below:

Encrypt the password by providing the:

a. Password to encrypt

b. Passphrase

c. Location to write encrypted file to

The following command can be used to generate the
encrypted password:

.. code-block:: shell

      /opt/kylo/bin/encryptSqoopPassword.sh

..

The above utility will output a base64 encoded encrypted password, which can be entered directly in the controller service configuration
via the **SourcePassword** and **Source Password Passphrase** properties (mode 2).

The above utility will also output a file on disk that contains the encrypted password. This can be used with mode 3 as described below:

Say, the file containing encrypted password is named: **/user/home/sec-pwd.enc.**

Put this file in HDFS and secure it by restricting permissions to be only read by **nifi** user.

Provide the file location and passphrase via the **Source Password File** and **Source Password Passphrase** properties in
the **StandardSqoopConnectionService** controller service configuration.

During the processor execution, password will be decrypted for modes 2 and 3, and used for connecting to the source system.

TriggerFeed
-----------

Trigger Feed Overview
~~~~~~~~~~~~~~~~~~~~~

In Kylo, the TriggerFeed Processor allows feeds to be configured
in such a way that a feed depending upon other feeds is automatically
triggered when the dependent feed(s) complete successfully.

Obtaining the Dependent Feed Execution Context
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

|image16|

To get dependent feed execution context data, specify the keys that you
are looking for. This is done through the "Matching Execution Context
Keys" property. The dependent feed execution context will only be
populated the specified matching keys.

For example:

    Feed_A runs and has the following attributes in the flow-file as it
    runs:

.. code-block:: properties

     -property.name = "first name"
     -property.age=23
     -feedts=1478283486860
     -another.property= "test"

..

    Feed_B depends on Feed A and has a Trigger Feed that has "Matching
    Execution Context Keys" set to "property".

    It will then get the ExecutionContext for Feed A populated with 2
    properties:

.. code-block:: shell

    "Feed_A":{property.name:"first name", property.age:23}

..

Trigger Feed JSON Payload
~~~~~~~~~~~~~~~~~~~~~~~~~

The FlowFile content of the Trigger feed includes a JSON string of the
following structure:

.. code-block:: javascript

  {
    "feedName":"string",
    "feedId":"string",
    "dependentFeedNames":[
        "string"
        ],
        "feedJobExecutionContexts":{

        },
        "latestFeedJobExecutionContext":{

        }
   }

..

JSON structure with a field description:

.. code-block:: javascript

  {
     "feedName":"<THE NAME OF THIS FEED>",
     "feedId":"<THE UUID OF THIS FEED>",
     "dependentFeedNames":[<array of the dependent feed names],
     "feedJobExecutionContexts":{<dependent_feed_name>:[
  {
  "jobExecutionId":<Long ops mgr job id>,
              "startTime":<millis>,
              "endTime":<millis>,
              "executionContext":{
  <key,value> matching any of the keys defined as being "exported" in
  this trigger feed
              }
           }
        ]
     },
     "latestFeedJobExecutionContext":{
        <dependent_feed_name>:{  
          "jobExecutionId":<Long ops mgr job id>,
              "startTime":<millis>,
              "endTime":<millis>,
              "executionContext":{
  <key,value> matching any of the keys defined as being "exported" in
  this trigger feed
              }
  }
  }
  }

..

Example JSON for a Feed:

.. code-block:: javascript

  {
     "feedName":"companies.check_test",
     "feedId":"b4ed909e-8e46-4bb2-965c-7788beabf20d",
     "dependentFeedNames":[
        "companies.company_data"
     ],
     "feedJobExecutionContexts":{
        "companies.company_data":[
           {
              "jobExecutionId":21342,
              "startTime":1478275338000,
              "endTime":1478275500000,
              "executionContext":{
              }
           }
        ]
     },
     "latestFeedJobExecutionContext":{
        "companies.company_data":{
           "jobExecutionId":21342,
           "startTime":1478275338000,
           "endTime":1478275500000,
          "executionContext":{
          }
       }
    }
 }

..

Example Flow
~~~~~~~~~~~~

The screenshot shown here is an example of a flow in which the inspection of the payload triggers dependent feed data.

|image17|

The EvaluateJSONPath processor is used to extract JSON content from the flow file.

Refer to the Data Confidence Invalid Records flow for an example:
|data_confidence_invalid_records_link|

.. |data_confidence_invalid_records_link| raw:: html

   <a href="https://github.com/KyloIO/kylo/blob/master/samples/templates/nifi-1.0/data_confidence_invalid_records.zip" target="_blank">https://github.com/KyloIO/kylo/blob/master/samples/templates/nifi-1.0/data_confidence_invalid_records.zip</a>

.. |image16| image:: ../media/kylo-config/KC16.png
   :width: 5.33825in
   :height: 3.07839in
.. |image17| image:: ../media/kylo-config/KC17.png
   :width: 6.59028in
   :height: 0.76042in
   
High-Water Mark Processors
--------------------------

The high-water mark processors are used to manage one or more water marks for a feed.  High-water marks support incremental batch processing by storing the highest value of an increasing 
field in the source records (such as a timestamp or record number) so that subsequent batches can pick up where the previous one left off.

The water mark processors have two roles:

1. To load the current value of a water mark of a feed as a flow file attribute, and to later commit (or rollback on error) the latest value of that attribute as the new water mark value
2. To bound a section of a flow so that only one flow file at a time is allowed to process data for the latest water mark value

There are two water mark processors: LoadHighWaterMark and ReleaseHighWaterMark.  The section of a NiFi flow where a water mark becomes active is bounded starts when a flow file 
passes through a LoadHighWaterMark processor and ends when it passes through a ReleaseHighWaterMark.  After a flow file passes through a LoadHighWaterMark processor there must 
be a ReleaseHighWaterMark present to release that water mark somewhere along every possible subsequent route in the flow.

LoadHighWaterMark Processor
~~~~~~~~~~~~~~~~~~~~~~~~~~~

This processor is configured, when a flow files is created by it or passes through it, to load the value of a single high-water mark for the feed and to store 
that value in a particular attribute in the flow file.  It also marks that water mark as _active_; preventing other flow files from passing through this processor
until the active water mark is released (committed or rolled back.)

*Properties*

+-------------------------------------+---------------+-------------------------------------------------------------------------+
| Property                            | Default       | Description                                                             |
+=====================================+===============+=========================================================================+
| High-Water Mark                     | highWaterMark | The unique name of the high-water mark as stored in the feed's metadata |
+-------------------------------------+---------------+-------------------------------------------------------------------------+
| High-Water Mark Value Property Name | water.mark    |                                                                         |
+-------------------------------------+---------------+-------------------------------------------------------------------------+
| Active Water Mark Strategy          |               |                                                                         |
+-------------------------------------+---------------+-------------------------------------------------------------------------+
| Max Yield Count Strategy            |               |                                                                         |
+-------------------------------------+---------------+-------------------------------------------------------------------------+
| Max Yield Count                     |               |                                                                         |
+-------------------------------------+---------------+-------------------------------------------------------------------------+
| Initial Value                       |               |                                                                         |
+-------------------------------------+---------------+-------------------------------------------------------------------------+
|                                     |               |                                                                         |
+-------------------------------------+---------------+-------------------------------------------------------------------------+
|                                     |               |                                                                         |
+-------------------------------------+---------------+-------------------------------------------------------------------------+

+---------------+-------------+
| Relationship  | Description |
+===============+=============+
| success       |             |
+---------------+-------------+
| failure       |             |
+---------------+-------------+
| activeFailure |             |
+---------------+-------------+


ReleaseHighWaterMark Processor
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

+-------------------------------------+---------------+-------------------------------------------------------------------------+
| Property                            | Default       | Description                                                             |
+=====================================+===============+=========================================================================+
| High-Water Mark                     | highWaterMark | The unique name of the high-water mark as stored in the feed's metadata |
+-------------------------------------+---------------+-------------------------------------------------------------------------+
| High-Water Mark Value Property Name | water.mark    |                                                                         |
+-------------------------------------+---------------+-------------------------------------------------------------------------+
|                                     |               |                                                                         |
+-------------------------------------+---------------+-------------------------------------------------------------------------+
|                                     |               |                                                                         |
+-------------------------------------+---------------+-------------------------------------------------------------------------+

+--------------+-------------+
| Relationship | Description |
+==============+=============+
| success      |             |
+--------------+-------------+
| failure      |             |
+--------------+-------------+




 
