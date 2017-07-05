Release 0.8.2 (TBD)
===================

Highlights
----------
- Redesigned Provenance Event Capturing and new Kylo Streaming User Interface
- Ability to customize the user interface for the feed stepper
- Ability to customize the user interface and customize the rendering of the feed details and the processors and properties (https://github.com/Teradata/kylo/tree/master/samples/plugins/example-ui-get-file-processor-template)

Upgrade Instructions
--------------------
1. Kylo no longer uses the NiFi Reporting Task to capture Provenance Events.  Instead it uses a modified ProvenanceRepository.  In Nifi stop the Kylp Reporting Task and Delete it and its associated Controller Service.
2. Stop NiFi.  Edit the nifi.properties file  (``/opt/nifi/current/conf/nifi.properties``) and change the ``nifi.provenance.repository.implementation`` property as below:

     .. code-block:: shell

        # Provenance Repository Properties
        #nifi.provenance.repository.implementation=org.apache.nifi.provenance.PersistentProvenanceRepository
        nifi.provenance.repository.implementation=com.thinkbiganalytics.nifi.provenance.repo.KyloPersistentProvenanceEventRepositor
     ..

    - KyloPersistentProvenanceEventRepository configuration properties:  The Provenance Repository uses properies found in the ``/opt/nifi/ext-config/config.properties`` file.
    *Note* this location is configurable via the System Property ``kylo.nifi.configPath`` passed into NiFi when it launches.
     Below are the defaults which are automatically set if the file/properties are not found

      .. code-block:: shell

             ###
            jms.activemq.broker.url=tcp://localhost:61616

            ## Back up location to write the Feed stats data if NiFi goes down
            kylo.provenance.cache.location=/opt/nifi/feed-event-statistics.gz

            ## The maximum number of starting flow files per feed during the given run interval to send to ops manager
            kylo.provenance.max.starting.events=5

            ## The number of starting flow files allowed to be sent through until the throttle mechanism in engaged.
            # if the feed starting processor gets more than this number of events during a rolling window based upon the kylo.provenance.event.throttle.threshold.time.millis timefame events will be throttled back to 1 per second until its slowed down
            kylo.provenance.event.count.throttle.threshold=15

            ## Throttle timefame used to check the rolling window to determine if rapid fire is occurring
            kylo.provenance.event.throttle.threshold.time.millis=1000

            ## run interval to gather stats and send to ops manager
            kylo.provenance.run.interval.millis=3000
      ..


3. Copy the application.properties file from the 0.8.1 install.  If you have customized the application.properties file you will want to copy the 0.8.1 version and add the new properties that were added for this release.

     3.1 Find the /bkup-config/TIMESTAMP/kylo-services/application.properties file

        - Kylo will backup the application.properties file to the following location, */opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties*, replacing the "YYYY_MM_DD_HH_MM_millis" with a valid time:

     3.2 Copy the backup file over to the /opt/kylo/kylo-services/conf folder

        .. code-block:: shell

          ### move the application.properties shipped with the .rpm to a backup file
          mv /opt/kylo/kylo-services/application.properties application.properties.0_8_2_template
          ### copy the backup properties  (Replace the YYYY_MM_DD_HH_MM_millis  with the valid timestamp)
          cp /opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties /opt/kylo/kylo-services/conf

        ..

     3.3 Add in the new properties to the /opt/kylo/kylo-services/application.properties file

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