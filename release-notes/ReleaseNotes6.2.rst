Release 0.6.2 (Feb. 7, 2017)
============================

Highlights
----------

-  Support for triggering multiple dependent feeds

-  Added a flag to allow operations manager to query and display NiFi
   bulletins on feed failure to help show any logs NiFi generated during
   that execution back in operations manager

-  Fixed NiFi provenance reporting to support manual emptying of flow
   files which will now fail the job in ops manager

-  The Audit Log table in Kylo will now track feed updates

Upgrade Instructions from v0.6.0
--------------------------------

Build or download the RPM.

1. Shut down NiFi:

.. code-block:: shell

     service nifi stop

..

2. To uninstall the RPM, run:

.. code-block:: shell

    /opt/kylo/remove-kylo-datalake-accelerator.sh

..

3. Install the new RPM:

.. code-block:: shell

     rpm –ivh <RPM\_FILE>

..

4. Run:

.. code-block:: shell

    /opt/kylo/setup/nifi/update-nars-jars.sh

..

5. Start NiFi: (wait to start)

.. code-block:: shell

     service nifi start

..

6. Update, using your custom configuration, the configuration files at:

.. code-block:: shell

    /opt/kylo/kylo-ui/conf/
    /opt/kylo/kylo-services/conf/
    /opt/kylo/kylo-spark-shell/conf/

..

    A backup of the previous version's configuration is available from /opt/kylo/bkup-config/.

7. If using NiFi v0.7 or earlier, modify
   /opt/kylo/kylo-services/conf/application.properties by
   changing spring.profiles.active from nifi-v1 to nifi-v0.

8. Start kylo apps:

.. code-block:: shell

    /opt/kylo/start-kylo-apps.sh

..

9. Ensure the reporting task is configured A ReportingTask is now used
   for communication between NiFi and Operations Manager.  In order to
   see Jobs and Steps in Ops Manager you will need to configure this
   following these instructions: Refer to:

:doc:`../how-to-guides/NiFiKyloProvenanceReportingTask`

Whats coming in 0.7.0?
----------------------

The next release will be oriented to public open-source release and
select issues identified by the field for client projects.

The approximate release date is February 13, 2017.
