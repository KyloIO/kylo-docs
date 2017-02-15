Release 0.6.1 (Jan. 26, 2017)
=============================

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

Upon upgrading the ExecuteSparkJob processors will be marked as invalid
saying: “Max wait time is invalid property”.  You will need to stop
these processors and delete the "Max wait time" property.

Upgrade Instructions from v0.6.0
--------------------------------

Build or download the RPM:

1.  Shut down NiFi:

.. code-block:: shell

    "service nifi stop"

..

2.  To uninstall the RPM, run:

.. code-block:: shell

    /opt/kylo/remove-kylo.sh

..

3.  Install the new RPM:

.. code-block:: shell

    "rpm –ivh <RPM\_FILE>"

..

4.  Run:

.. code-block:: shell

    /opt/kylo/setup/nifi/update-nars-jars.sh

..

5.  Start NiFi: (wait to start)

.. code-block:: shell

    "service nifi start"

..

6.  Update, using your custom configuration, the configuration files at:

.. code-block:: shell

    /opt/kylo/kylo-ui/conf/
    /opt/kylo/kylo-services/conf/
    /opt/kylo/kylo-spark-shell/conf/ 

..

    A backup of the previous version's configuration is available from /opt/kylo/bkup-config/.

7.  If using NiFi v0.7 or earlier, modify
    /opt/kylo/kylo-services/conf/application.properties by
    changing spring.profiles.active from nifi-v1 to nifi-v0.

8.  Start kylo apps: -

.. code-block:: shell

    /opt/kylo/start-kylo-apps.sh

..

9.  Update the ExecuteSparkJob processors (Validate and Profile
    processors) fixing the error: “Max wait time is invalid property” by
    removing that property.

10. Ensure the reporting task is configured A ReportingTask is now used
    for communication between NiFi and Operations Manager.  In order to
    see Jobs and Steps in Ops Manager you will need to configure this
    following these instructions, refer to :doc:`NiFi
    KyloProvenanceReportingTask`
