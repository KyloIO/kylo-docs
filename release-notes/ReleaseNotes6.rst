Release 0.6.0 (Jan. 19, 2017)
=============================

Highlights
----------

-  90+ issues resolved

-  NiFi clustering support. Ability to cluster NiFi with Kylo.

-  Streaming enhancements. New streaming UI plots and higher throughput
   performance between Kylo and NiFi. Ability to specify a feed as a
   streaming type to optimize display.

-  Improved schema manipulation. Ability for feeds and target Hive
   tables to diverge (e.g. drop fields, rename fields, and change data
   types for fields the exist in raw files regardless of raw type)

-  Alert persistence.  Ability for alert panel to store alerts (and
   clear) including and APIs for plugging in custom alert responder and
   incorporate SLA alerts

-  Configurable data profiling.  Profiled columns can be toggled to
   avoid excessive Spark processing

-  Tags in search. Ability to search tags in global search

-  Legacy NiFi version cleanup.  Deletes retired version of NiFi feed
   flows

-  Avro format option for database fetch.  GetTableData processor has
   been updated to allow writing rows in Avro format and to allow
   setting a custom column delimiter when the output type is a delimited
   text file

-  Feed file upload.  Ability to upload a file directly to a feed and
   have it trigger immediately (for feeds using filesystem)

-  Tutorials. New admin tutorial videos

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

RPM
---

`thinkbig-datalake-accelerator-0.6.0-1.noarch.rpm <http://52.203.91.75:8080/artifactory/simple/libs-release-local/com/thinkbiganalytics/datalake/thinkbig-datalake-accelerator/0.6.0/thinkbig-datalake-accelerator-0.6.0-1.noarch.rpm>`__

(RPM file size: 786393081 bytes)

Upgrade Instructions from v0.5.0
--------------------------------

Build or download the rpm:

1. Shut down nifi - "service nifi stop"

2. Run /opt/thinkbig/remove-thinkbig-datalake-accelerator.sh to
   uninstall the RPM

3. Install the new RPM "rpm –ivh <RPM\_FILE>"

4. Run /opt/thinkbig/setup/nifi/update-nars-jars.sh

5. Update /opt/nifi/current/conf/nifi.properties file and change it to
   use the default PersistentProvenanceRepository:
   nifi.provenance.repository.implementation=org.apache.nifi.provenance.PersistentProvenanceRepository

6. Execute the database upgrade script: 
   /opt/thinkbig/setup/sql/mysql/thinkbig/0.6.0/update.sh localhost root
   <password or blank>

7. Create the "/opt/nifi/activemq" folder and copy the jars:

.. code-block:: shell

    $ mkdir /opt/nifi/activemq 
    $ cp /opt/thinkbig/setup/nifi/activemq/*.jar
    /opt/nifi/activemq 
    $ chown -R nifi /opt/nifi/activemq/

..

8. Add a service account for thinkbig application to nifi group (This
   will allow Kylo to upload files to the dropzone location defined in
   NiFi). This step will differ per operating system. Note also that these may differ depending
   on how the service accounts where created.

.. code-block:: shell

      $ sudo usermod -a -G nifi thinkbig

..

.. Note::

    All dropzone locations must allow the Kylo service account to write.

..

9. Start NiFi: (wait to start)

.. code-block:: shell

    service nifi start

..

.. note::

    If errors occur, try removing the transient provenance data:   
    rm -fR /PATH/TO/NIFI/provenance\_repository/.

..

10. Update, using your custom configuration, the configuration files at:

.. code-block:: shell

    /opt/thinkbig/thinkbig-ui/conf/
    /opt/thinkbig/thinkbig-services/conf/
    /opt/thinkbig/thinkbig-spark-shell/conf/

    A backup of the previous version's configuration is available from /opt/thinkbig/bkup-config/.

11. If using NiFi v0.7 or earlier, modify
   /opt/thinkbig/thinkbig-services/conf/application.properties by
   changing spring.profiles.active from nifi-v1 to nifi-v0.

12. Start thinkbig apps - /opt/thinkbig/start-thinkbig-apps.sh

13. Update the re-usable standard-ingest template,
   index\_schema\_service, and the index\_text\_service 

   a. The standard-ingest template can be updated through the templates
      page. (/opt/thinkbig/setup/data/templates/nifi-1.0/) The upgrade
      will:

      i.   Add "json field policy file" path as one of the parameters to
           Profiler processor to support selective column profiling. See
           "Configurable data profiling" in highlights

      ii.  Add feed field specification to support UI ability to modify
           feeds. See "Improved schema manipulation" in highlights above

      iii. Adds shared library path to activemq libraries required going
           forward

   b. The index\_schema\_service and index\_text\_service templates are
      feed templates and should be updated through the feeds page.
      (/opt/thinkbig/setup/data/feeds/nifi-1.0/.

      i.   Go to the feeds page

      ii.  Click the Plus icon

      iii. Click on the "import from file" link

      iv.  Choose one of the Elasticsearch templates and check the overwrite box

14. A ReportingTask is now used for communication between NiFi and
   Operations Manager.  In order to see Jobs and Steps in Ops Manager
   you will need to configure this following these instructions:

:doc:`../how-to-guides/NiFiKyloProvenanceReportingTask`
