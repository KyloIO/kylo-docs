Release 0.8.2 (TBD)
===================

Highlights
----------
- Redesigned Provenance Event Capturing and new Kylo Streaming User Interface
- Ability to customize the user interface for the feed stepper and NiFi processor templates (https://github.com/Teradata/kylo/tree/master/samples/plugins/example-ui-get-file-processor-template)

Upgrade Instructions
--------------------
1. Remove the NiFi reporting task.  Kylo no longer uses the NiFi reporting task to capture provenance events.  Instead it uses a modified ProvenanceRepository.

   a. In NiFi stop and delete the Kylo Reporting Task and its associated Controller Service.

   b. Stop NiFi

   c. Follow the guide :doc:`../how-to-guides/NiFiKyloProvenance` to setup the KyloProvenanceRepository

2. Copy the application.properties file from the 0.8.1 install.  If you have customized the application.properties file you will want to copy the 0.8.1 version and add the new properties that were added for this release.

     2.1 Find the /bkup-config/TIMESTAMP/kylo-services/application.properties file

        - Kylo will backup the application.properties file to the following location, */opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties*, replacing the "YYYY_MM_DD_HH_MM_millis" with a valid time:

     2.2 Copy the backup file over to the /opt/kylo/kylo-services/conf folder

        .. code-block:: shell

          ### move the application.properties shipped with the .rpm to a backup file
          mv /opt/kylo/kylo-services/application.properties application.properties.0_8_2_template
          ### copy the backup properties  (Replace the YYYY_MM_DD_HH_MM_millis  with the valid timestamp)
          cp /opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties /opt/kylo/kylo-services/conf

        ..

     2.3 Add in the new properties to the /opt/kylo/kylo-services/application.properties file

         - ActiveMQ properties: Redelivery processing properties are now available for configuration.  If Kylo receives provenance events and they have errors are are unable to attach NiFi feed information (i.e. if NiFi goes down and Kylo doesnt have the feed information in its cache) then the JMS message will be returned for redelivery based upon the following parameters.  Refer to the ActiveMQ documentation, http://activemq.apache.org/redelivery-policy.html, for assigning these values:

              .. code-block:: shell

                ## retry for xx times before sending to DLQ (Dead Letter Queue) set -1 for unlimited redeliveries
                jms.maximumRedeliveries=100
                ##The initial redelivery delay in milliseconds.
                jms.initialRedeliveryDelay=1000
                ##retry every xx seconds
                jms.redeliveryDelay=5000
                ##Sets the maximum delivery delay that will be applied if the useExponentialBackOff option is set (use value -1 for no max)
                jms.maximumRedeliveryDelay=600000L
                ##The back-off multiplier.
                jms.backOffMultiplier=5
                ##Should exponential back-off be used, i.e., to exponentially increase the timeout.
                jms.useExponentialBackOff=false

              ..
         - NiFi 1.3 support
            If you are using NiFi 1.2 or 1.3 you need to update the spring profile to point to the correct nifi version.

            Example NiFi 1.2 or 1.3 support

            .. code-block:: shell

              ### Indicate the NiFi version you are using with the correct spring profile.
              ###  - For NiFi 1.0.x or 1.1.x:    nifi-v1
              ###  - For NiFi 1.2.x or 1.3.x:    nifi-v1.2
              spring.profiles.include=native,nifi-v1.2,auth-kylo,auth-file

            ..

            Example NiFi 1.0 or 1.1 support

            .. code-block:: shell

              spring.profiles.include=native,nifi-v1,auth-kylo,auth-file

            ..