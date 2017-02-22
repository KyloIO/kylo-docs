
==========================
NiFi & Kylo Reporting Task
==========================

Introduction
------------

Kylo communicates with NiFi via a NiFi reporting task.  As flow files run through NiFi, each processor creates provenance events that track metadata and status information of a running flow.
A NiFi reporting task is used to query for these provenance events and send them to Kylo to display job and step executions in Kylo's operations manager.

Processing Provenance Events
----------------------------

The Kylo reporting task relies on Kylo to provide feed information, which it uses to augment the provenance event giving the NiFi event feed context.  It does this through a cache called the "NiFi Flow Cache", which is maintained by the Kylo Feed manager and kept in sync with the NiFi reporting task.
As feeds are created and updated, this cache is updated and synchronized back to the NiFi reporting task upon processing provenance events.  The cache is exposed through a REST API, which is used by the reporting task.

|image5|

The NiFi Flow Cache REST API
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

|image6|

The above REST endpoints allow you to manage the cache.  Kylo and the reporting task will automatically keep the cache in sync.  If needed you can use these REST endpoints to manage, view, and reset the cache.

.. note:: If for some reason the reporting task is reporting Kylo as "not available", you can try to reset the cache to fix the problem using the "reset-cache" endpoint.

Reporting Task Creation
-----------------------
When Kylo starts up, it will attempt to auto create the controller service and reporting task in NiFi that is needed to communicate with Kylo.  If this process doesn't work, or if you want more control, you can manually create it following the steps below.

Manual Setup
~~~~~~~~~~~~

1. To setup the reporting task, click the menu icon on the top right and
   click the "Controller Settings" link.

    |image0|

2. From there we need to setup a **Controller Service** before adding
   the Reporting task.  The Controller Service is used to allow NiFi to
   talk to Kylo REST endpoints that gather feed information needed for
   processing NiFi events.  Setup a new **Metadata Provider Selection
   Service** and set the properties to communicate with your Kylo
   instance.

    |image1|

    |image2|   

3. Next add the reporting task.

    |image3|

    A rundown of the various properties can be found by hovering over
    the **?** icon or at the bottom of this page: ** Kylo Provenance
    Event Reporting Task Properties.**  

4. Set the schedule on the reporting task.

    It is recommended to set the schedule between 5 and 15 seconds.  On
    this interval the system will run and query for all events that
    haven’t been processed. 

    |image4|

     

Reporting Task Properties
-------------------------

+------------------------------------+---------------------+----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Name**                           | **Default Value**   | **Allowable Values**       | **Description**                                                                                                                                                                                                                                                                                                                  |
+------------------------------------+---------------------+----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Metadata Service                   |                     | Controller Service API:    | Kylo metadata service                                                                                                                                                                                                                                                                                                            |
|                                    |                     | MetadataProviderService    |                                                                                                                                                                                                                                                                                                                                  |
|                                    |                     | Implementation:            |                                                                                                                                                                                                                                                                                                                                  |
+------------------------------------+---------------------+----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Max batch feed events per second   | 10                  |                            | The maximum number of events/second for a given feed allowed to go through to Kylo. This is used to safeguard Kylo against a feed that starts acting like a stream                                                                                                                                                               |
|                                    |                     |                            | Supports Expression Language: true                                                                                                                                                                                                                                                                                               |
+------------------------------------+---------------------+----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| JMS event group size               | 50                  |                            | The size of grouped events sent over to Kylo. This should be less than the Processing Batch Size                                                                                                                                                                                                                                 |
|                                    |                     |                            | Supports Expression Language: true                                                                                                                                                                                                                                                                                               |
+------------------------------------+---------------------+----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Rebuild cache on restart           | false               |                            | Should the cache of the flows be rebuilt every time the Reporting task is restarted? By default, the system will keep the cache up to date; however, setting this to true will force the cache to be rebuilt upon restarting the reporting task.                                                                                 |
|                                    |                     |                            | Supports Expression Language: true                                                                                                                                                                                                                                                                                               |
+------------------------------------+---------------------+----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Last event id not found value      | KYLO                | KYLO                       | If there is no minimum value to start the range query from (i.e. if this reporting task has never run before in NiFi) what should be the initial value?"                                                                                                                                                                         |
|                                    |                     |                            |                                                                                                                                                                                                                                                                                                                                  |
|                                    |                     | ZERO                       | KYLO: It will attempt to query Kylo for the last saved id and use that as the latest id                                                                                                                                                                                                                                          |
|                                    |                     |                            |                                                                                                                                                                                                                                                                                                                                  |
|                                    |                     | MAX_EVENT_ID               | ZERO: this will get all events starting at 0 to the latest event id.                                                                                                                                                                                                                                                             |
|                                    |                     |                            |                                                                                                                                                                                                                                                                                                                                  |
|                                    |                     |                            | MAX_EVENT_ID: this is set it to the max provenance event. This is the default setting                                                                                                                                                                                                                                            |
+------------------------------------+---------------------+----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Initial event id value             | LAST_EVENT_ID       | LAST_EVENT_ID              | Upon starting the Reporting task what value should be used as the minimum value in the range of provenance events this task should query?                                                                                                                                                                                        |
|                                    |                     |                            |                                                                                                                                                                                                                                                                                                                                  |
|                                    |                     | KYLO                       | LAST_EVENT_ID: will use the last event successfully processed from this task. This is the default setting.                                                                                                                                                                                                                       |
|                                    |                     |                            |                                                                                                                                                                                                                                                                                                                                  |
|                                    |                     | MAX_EVENT_ID               | KYLO: It will attempt to query Kylo for the last saved id and use that as the latest id                                                                                                                                                                                                                                          |
|                                    |                     |                            |                                                                                                                                                                                                                                                                                                                                  |
|                                    |                     |                            | MAX_EVENT_ID will start processing every event > the Max event id in provenance. This value is evaluated each time this reporting task is stopped and restarted. You can use this to reset provenance events being sent to Kylo. This is not the ideal behavior so you may lose provenance reporting. Use this with caution.     |
+------------------------------------+---------------------+----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Processing batch size              | 500                 |                            | The maximum number of events to process in a given interval. If there are more events than this number to process in a given run of this reporting task it will partition the list and process the events in batches of this size to increase throughput to Kylo.                                                                |
|                                    |                     |                            | Supports Expression Language: true                                                                                                                                                                                                                                                                                               |
+------------------------------------+---------------------+----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. |image0| image:: ../media/provenance-reporting/1-controller-settings.png
   :width: 2.36458in
   :height: 3.12500in
.. |image1| image:: ../media/provenance-reporting/2-nifi-settings.png
   :width: 6.50000in
   :height: 2.83819in
.. |image2| image:: ../media/provenance-reporting/2a-properties-required.png
   :width: 6.50000in
   :height: 2.83819in
.. |image3| image:: ../media/provenance-reporting/3-reporting-tasks.png
   :width: 6.50000in
   :height: 4.46250in
.. |image4| image:: ../media/provenance-reporting/4-settings.png
   :width: 6.19792in
   :height: 2.93750in
.. |image5| image:: ../media/provenance-reporting/KyloProvenanceReportingTask.png
   :width: 1759px
   :height: 1280px
.. |image6| image:: ../media/provenance-reporting/nifi-flow-cache-rest-api.png
   :width: 989px
   :height: 372px
