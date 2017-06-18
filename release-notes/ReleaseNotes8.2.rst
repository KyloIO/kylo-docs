Release 0.8.2 (TBD)
===================

Highlights
----------
- Redesigned Provenance Event Capturing and new Kylo Streaming User Interface

Provenance Event Changes
------------------------
 1. Provenance Event Repository changes

    - Kylo no longer uses the NiFi Reporting Task to capture Provenance Events.  Instead it uses a modified ProvenanceRepository.
    Edit the nifi.properties file  (``/opt/nifi/current/conf/nifi.properties``) and change the ``nifi.provenance.repository.implementation`` property as below:

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


