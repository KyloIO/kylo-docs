===========================
Configuration Inspector App
===========================


Overview
========


Configuration Inspector App is a standalone application, separate from Kylo UI and Services and its purpose is to check whether Kylo UI and Kylo Services are configured correctly or not.
It comes with a number of Configuration Inspections out-of-the-box and is designed to be easily extensible.

Here is a screenshot of how it may look like:


|image0|


Pre-requisites
==============

- Java 8 installed. Kylo installs Java 8 into ``/opt/java`` directory. We will assume this directory for our examples.
- ``kylo`` user privileges because this application will access Kylo UI and Services ``application.properties`` and their ``lib`` directories


Run Application
===============

Inspector App is distributed with Kylo and can be found in ``<KYLO_INSTALL_PATH>/lib/install-inspector`` directory. We will assume default ``/opt/kylo/lib/install-inspector`` directory for this example.
Since this application requires Java 8 and needs to be ran as ``kylo`` user here is how you would run it:

.. code-block:: shell

    sudo su kylo
    /opt/java/current/bin/java -jar /opt/kylo/lib/install-inspector/kylo-install-inspector-app-<version>.war --inspections.path=/opt/kylo/lib/install-inspector/lib

..

Now that the application is running, open your browser and find it at ``http://localhost:8099``.


Custom Logging
==============

Currently application logs to console. If you prefer to change that provide path to you custom ``logback.xml`` like so:

.. code-block:: shell

    sudo su kylo
    /opt/java/current/bin/java -jar /opt/kylo/lib/install-inspector/kylo-install-inspector-app-<version>.war  --inspections.path=/opt/kylo/lib/install-inspector/lib --logging.config=<absolute-path-to-custom-logback.xml>

..


Download Report
===============

Click the circular "Download Report" button closer to the right top corner just above the Inspections list to download and share the inspection report produced by Inspector App.


Add Custom Configuration Inspections
====================================

- Extend ``Inspection`` or ``AbstractInspection`` class found in ``kylo-install-inspector-api`` module. At minimum you will need to implement three methods where the one which does the work looks like this: ``public InspectionStatus inspect(Configuration configuration)``. Via ``Configuration`` class you get access to Kylo UI and Services properties, e.g. ``Configuration.getServicesProperty(String propertyName)``. You can either directly @Inject Kylo classes into your Inspections or you first create Spring configuration which defines the beans, e.g. see |NifiConnectionInspectionExample| and |NifiConnectionInspectionConfigurationExample| which uses custom Spring configuration to get ``JerseyClient`` which can talk to Nifi.
- Package your custom Inspections into a ``jar``
- Add your jar and its dependencies to Inspector App classpath, i.e. drop them into ``/opt/kylo/lib/install-inspector/lib`` directory.
- Run Inspector App as usual




.. |image0| image:: ../media/config-inspector-app/config-inspector-app.png

.. |NifiConnectionInspectionExample| raw:: html

   <a href="https://github.com/Teradata/kylo/blob/bfcf0a5f2a56b3a45bea7cd3d4e298692bb3c697/install/install-inspector/install-inspector-app/src/main/java/com/thinkbiganalytics/install/inspector/inspection/NifiConnectionInspection.java#L174" target="_blank">NifiConnectionInspection</a>

.. |NifiConnectionInspectionConfigurationExample| raw:: html

   <a href="https://github.com/Teradata/kylo/blob/bfcf0a5f2a56b3a45bea7cd3d4e298692bb3c697/install/install-inspector/install-inspector-app/src/main/java/com/thinkbiganalytics/install/inspector/inspection/NifiConnectionInspectionConfiguration.java" target="_blank">NifiConnectionInspectionConfiguration</a>

.. |IgnoredByInspectorAppExample| raw:: html

   <a href="https://github.com/Teradata/kylo/blob/bfcf0a5f2a56b3a45bea7cd3d4e298692bb3c697/install/install-inspector/install-inspector-app/src/main/java/com/thinkbiganalytics/install/inspector/inspection/NifiConnectionInspectionConfiguration.java#L32" target="_blank">@IgnoredByInspectorApp</a>

