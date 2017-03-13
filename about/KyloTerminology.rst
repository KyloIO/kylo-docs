
================
Terminology
================

There are a lot of new terms with Kylo and NiFi, and trying to learn
them all, including distinctions between Kylo and NiFi usage, can be
overwhelming. The goal of this document is to detail the semantics of
these terms within the context of Kylo and NiFi. This document does not
aim to write a definition for every term you will encounter in Kylo and
Apache NiFi.

Additional Resources:

-  NiFi has documentation on its |terminology_Link| on their website. However, some of the terms will be outlined here in the context of Kylo.

Apache NiFi Terminology
-----------------------

Processor
~~~~~~~~~

Refer to the NiFi |terminology_Link| document for NiFi-specific terminology.

-  A processor has properties that are configured. The values for these
   properties can be hard-coded, or they can be made dynamic by using
   the NiFi expression language, which will allow you to access the
   attributes of a FlowFile as they go through the processor. They can
   also be set or overridden through Kylo.

FlowFile
~~~~~~~~

Immutable NiFi object that encapsulates the data that moves through a
NiFi flow. It consists of the data (content) and some additional
properties (attributes)

-  NiFi wraps data in FlowFiles. FlowFiles can contain a piece of data,
   an entire dataset, and batches of data,. depending upon which
   processors are used, and their configurations. A NiFi flow can have
   multiple FlowFiles running through it at one time, and the FlowFiles
   can move from processor to processor independently of one another. It
   is important to note that FlowFiles only conceptually “contain” the
   data. For scalability reasons, FlowFiles actually have a pointer to
   the data in the NiFi Content Repository.

Connection
~~~~~~~~~~

A connection between two processors, between input/output ports, or
between both

-  FlowFiles move from processor to processor through connections. A
   connection houses a queue. If a processor on the receiving end of a
   connection is stopped or disabled, the FlowFiles will sit in that
   queue/connection until the receiving processor is able to receive
   FlowFiles again.

Relationship
~~~~~~~~~~~~

Closely tied to NiFi connections, see definition in NiFi terminology
document

-  When a processor is done with a FlowFile, it will route it to one or
   more relationships. These relationships can either be set to
   auto-terminate (this would mark the end of the journey for FlowFiles
   that get routed to auto-terminating relationships), or they can be
   attached to NiFi connections. The most common example is the success
   and failure relationships. Processors, when finished with a FlowFile,
   determine which relationship(s) to route the FlowFile to. This can
   create diverging paths in a flow, and can be used to represent
   conditional business logic. For example: a flow can be designed so
   that when processor A routes to the success relationship it goes to
   processor B, and when processor A routes to the failure relationship
   it routes to processor C.

Flow/Dataflow
~~~~~~~~~~~~~

A logically grouped sequence of connected processors and NiFi components

-  You could also think of a flow as a program or a pipeline.

Controller Service
~~~~~~~~~~~~~~~~~~

Refer to the NiFi |terminology_Link| document for NiFi-specific terminology.

-  An example is the Hive Thrift Service of type ThriftConnectionPool,
   which is a controller service that lets the ExecuteHQL and
   ExecuteHQLStatement processor types connect to a HiveServer2
   instance.

NAR files
~~~~~~~~~

Similar to an uber JAR, a NiFi archive which may contain custom NiFi
processors, controllers and all library dependencies

-  NAR files are bundles of code that you use to extend NiFi. If you
   write a custom processor or other custom extension for NiFi, you must
   package it up in a NAR file and deploy it to NiFi.

Template
~~~~~~~~

Refer to the NiFi |terminology_Link| document for NiFi-specific terminology.

-  A template is a flow that has been saved for reuse. You can use a
   template to model a common pattern, and then create useful flows out
   of that by configuring the processors to your specific use case. They
   can be exported and imported as XML. The term “template” becomes
   overloaded with the introduction of Kylo, so it is important when
   thinking and talking about Kylo to specify which kind of “template”
   you are referring to.

 

Kylo Terminology
----------------

Registered Template 
~~~~~~~~~~~~~~~~~~~

The blueprint from which Kylo feeds are created.

-  In Kylo, a template typically refers to a registered template. A
   registered template is a NiFi template that has been registered
   through Kylo. When trying to register a NiFi template, there are
   multiple courses of action. The first option is to upload a NiFi
   template that has been previously exported from NiFi as XML. This
   option does not actually add the NiFi template to the list of
   registered templates in Kylo. Instead, this will upload the NiFi
   template to the running instance of NiFi, which is futile if you
   already have that template available in the running instance of NiFi.
   The second option is to register a NiFi template directly through
   NiFi. This will allow you to choose from the NiFi templates that are
   available in the running instance of NiFi and register it. This does
   add it to the list of registered templates. The third option is to
   upload a template that has been exported from Kylo as a zip.
   Registered templates can be exported from one running instance of
   Kylo and registered in other instances of Kylo by uploading the
   archive file (zip). An archive of a registered template will also
   have the NiFi template in it. It is easiest to think of Kylo
   templates (a.k.a., registered templates) as being a layer on top of
   NiFi templates.

Category
~~~~~~~~

A container for grouping feeds

-  Each feed must belong to a category. A feed cannot belong to multiple
   categories, but a category can contain multiple feeds. A category is
   used as metadata in Kylo, and also manifests itself as a process
   group in the running instance of NiFi

Input Processor or Source
~~~~~~~~~~~~~~~~~~~~~~~~~

The processor in a feed’s underlying flow that is at the beginning of
the flow and generates FlowFiles rather than transforming incoming ones

-  There are processors that do not take incoming connections, and
   instead generate FlowFiles from external sources. An example is the
   GetFile processor, which runs at a configured interval to check a
   specified directory for data. While these processors don’t
   necessarily “kick off” a flow, as a flow is always running (unless
   the components are stopped or disabled), these processors are the
   origin for a flow and are considered the source or input processors
   of a feed.

Feed 
~~~~~

Typically will represent the key movement of data between a source (flat
file) and sink (e.g. Hive)

-  An instantiation of a Kylo template

-  Feeds are created from templates. The idea is that NiFi templates are
   created to be reusable and generic. Then, the NiFi templates are
   registered in Kylo, and the technical configurations of the NiFi
   template are hidden and default values are set so that it is prepared
   for the end user. Then, the end user, equipped with their domain
   knowledge, creates feeds from the Kylo templates.

Job 
~~~

A single run of a feed

-  When an input processor generates a FlowFile, a new job for that feed
   starts. The job follows the FlowFile through its feed’s underlying
   flow, capturing metadata along the way. Jobs can be of two types,
   FEED or CHECK. By default, all jobs are of type FEED. They can be set
   to type CHECK by configuring one of the processors to set the
   tb.jobType attribute to CHECK.

Step
~~~~

A stage in a job

-  Steps are specific to jobs in Kylo, and correlate directly to the
   processors that the FlowFile goes through for that job. Flows can
   have conditional logic and multiple relationships, so each FlowFile
   that goes through a flow may not follow the same path every time. A
   job follows a FlowFile, and has a step for each processor that the
   FlowFile goes through.

Service 
~~~~~~~~

A service that Kylo has been configured to monitor

-  Services in Kylo are not NiFi controller services. They are simply
   services, such as HDFS and Kafka, that Kylo will monitor using either
   Ambari’s API or Cloudera’s REST client.

.. |terminology_Link| raw:: html

    <a href="https://nifi.apache.org/docs/nifi-docs/html/user-guide.html#terminology" target="_blank">terminology</a>
