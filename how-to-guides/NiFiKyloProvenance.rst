
======================
NiFi & Kylo Provenance
======================

Introduction
------------
Kylo uses a custom ProvenanceRepository (KyloPersistentProvenanceEventRepository) to send data from NiFi to Kylo.
A custom NiFi nar file https://github.com/Teradata/kylo/tree/master/integrations/nifi/nifi-nar-bundles/nifi-provenance-repo-bundle is used for the ProvenanceRepository.

Setup
-----
1. Edit the nifi.properties file  (``/opt/nifi/current/conf/nifi.properties``) and change the ``nifi.provenance.repository.implementation`` property as below:

     .. code-block:: shell

        # Provenance Repository Properties
        #nifi.provenance.repository.implementation=org.apache.nifi.provenance.PersistentProvenanceRepository
        nifi.provenance.repository.implementation=com.thinkbiganalytics.nifi.provenance.repo.KyloPersistentProvenanceEventRepository
     ..

2. Ensure the correct nars are available in the NiFi classpath.  Depending upon the NiFi version there are 2 different nar files that are used.  If you use the kylo wizard it will copy the nar files and setup the symlinks to point to the correct nar version for your NiFi installation.

   - For NiFi 1.0 or 1.1

      - kylo-nifi-provenance-repo-v1-nar-<version>.nar

   - For NiFi 1.2 or 1.3

      - kylo-nifi-provenance-repo-v1.2-nar-<version>.nar

3. Configure the KyloPersistentProvenanceEventRepository properties:  The Provenance Repository uses properties found in the ``/opt/nifi/ext-config/config.properties`` file.
    *Note:* this location is configurable via the System Property ``kylo.nifi.configPath`` passed into NiFi when it launches.  Below are the defaults which are automatically set if the file/properties are not found.

    *Note:* the config.properties marked with ## *Supports dynamic update* below can be updated without restarting NiFi.  Every 30 seconds a check is made to see if the config.properties file has been updated.

      .. code-block:: shell

             ###
            jms.activemq.broker.url=tcp://localhost:61616

            ## Back up location to write the Feed stats data if NiFi goes down
            ## *Supports dynamic update*
            kylo.provenance.cache.location=/opt/nifi/feed-event-statistics.gz

            ## The maximum number of starting flow files per feed during the given run interval to send to ops manager
            ## *Supports dynamic update*
            kylo.provenance.max.starting.events=5

            ## The number of starting flow files allowed to be sent through until the throttle mechanism in engaged.
            # if the feed starting processor gets more than this number of events during a rolling window based upon the kylo.provenance.event.throttle.threshold.time.millis timefame events will be throttled back to 1 per second until its slowed down
            kylo.provenance.event.count.throttle.threshold=15

            ## Throttle timefame used to check the rolling window to determine if rapid fire is occurring
            kylo.provenance.event.throttle.threshold.time.millis=1000

            ## run interval to gather stats and send to ops manager
            ## *Supports dynamic update*
            kylo.provenance.run.interval.millis=3000

            ## JSON string of the Event Type to Array of Processor classes
            ## These processors produce orphan child flow files that dont send DROP provenance events for the children.
            ## Child flow files produced by events  matching the EventType and processor class will not be processed
            ## *Supports dynamic update*
            kylo.provenance.orphan.child.flowfile.processors={"CLONE":["ConvertCSVToAvro"]}
      ..


Event Processing
----------------
When NiFi runs the processors will send provenance events to JMS Queues.  Kylo listens on these JMS queues and creates Jobs/Steps and Streaming statistics about each feed and job execution.  These are displayed in the Operations Manager.


