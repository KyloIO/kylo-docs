Clustering Kylo
===============

Kylo Custering is available starting in v0.8.1

Kylo uses jgroups, http://jgroups.org/index.html, for cluster configuration.  This is chosen because Kylo's metadata engine, Modeshape(http://modeshape.jboss.org/) uses jgroups internally for its cluster management.

Two jgroups configuration files are needed to be setup (One for ModeShape and one for Kylo)


ModeShape Configuration
~~~~~~~~~~~~~~~~~~~~~~~
1. Update the metadata-repository.json file and add the "clustering" section

   .. code-block:: json

    "clustering": {
        "clusterName":"kylo-modeshape-cluster",
        "configuration":"modeshape-jgroups-config.xml",
        "locking":"db"
    },

   ..

   Make sure the name of the jgroups-config.xml file is in the `/kylo-services/conf` folder.  Refer sample files for setting up a jgroups configuration at `/opt/kylo/setup/config/kylo-cluster`.
   Note if working in Amazon you need to refer to the "s3" jgroups configuration as it needs to use an S3Ping to have the nodes communicate with each other.

Kylo Configuration
~~~~~~~~~~~~~~~~~~

We also have another jgroups configuration setup for Kylo nodes.  We cannot use the ModeShape cluster configuration since that is internal to ModeShape.

1. Create a similar jgroup-config.xml file and add it to the `/kylo-services/conf` file.  Refer sample files for setting up a jgroups configuration at `/opt/kylo/setup/config/kylo-cluster`.
Ensure the ports are different between this xml file and the ModeShape xml file

2. Add a property to the kylo-services/conf/application.properties to reference this file

 .. code-block:: properties

  kylo.cluster.jgroupsConfigFile=kylo-cluster-jgroups-config.xml

 ..

3. Startup Kylo

  When starting up you should see 2 cluster configurations in the logs.  One for the modeshape cluster and one for the kylo cluster

  .. code-block:: text

        -------------------------------------------------------------------
        GMS: address=Kylo - MUSSR186054-918-31345, cluster=kylo-modeshape-cluster, physical address=127.0.0.1:7800
        -------------------------------------------------------------------
  ..

  .. code-block:: text

        -------------------------------------------------------------------
        GMS: address=Kylo - MUSSR186054-918-31345, cluster=internal-kylo-cluster, physical address=127.0.0.1:7900
        -------------------------------------------------------------------
        2017-05-04 06:17:06 INFO  pool-5-thread-1:JGroupsClusterService:120 - Cluster membership changed: There are now 1 members in the cluster. [Kylo - MUSSR186054-918-31345]
        2017-05-04 06:17:06 INFO  pool-5-thread-1:JGroupsClusterService:155 - *** Channel connected Kylo - MUSSR186054-918-31345,[Kylo - MUSSR186054-918-31345]
        2017-05-04 06:17:06 INFO  pool-5-thread-1:NifiFlowCacheClusterManager:205 - on connected 1 members exist.  [Kylo - MUSSR186054-918-31345]
  ..

Quartz Scheduler Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
When running in clustered mode you need to configure the Quartz SLA scheduler to be backed by the database and run it in clustered mode.
Do the following:

1. Download and extract the Quartz distribution to a machine. http://d2zwv9pap9ylyd.cloudfront.net/quartz-2.2.3-distribution.tar.gz  You just need this to get the database scripts.

2. Run the Quartz database scripts for your database found in the `docs/dbTables`

3. Create a `quartz.properties` file and put it in the `/opt/kylo/kylo-services/conf` folder.  Refer to a sample file `/opt/kylo/setup/kylo-cluster/quartz-cluster-example.properties`

   a. Do not specify datasource connection information in this file.  The system will use the default `spring.datasource` property information found in the `application.properties` for the database connection


Service Monitoring
~~~~~~~~~~~~~~~~~~
You can monitor the health of the kylo cluster by adding the `kylo-service-monitor-kylo-cluster.jar` to the `/opt/kylo/kylo-services/plugins` folder.

1. Copy the file in the `/opt/kylo/setup/plugins/kylo-service-monitor-kylo-cluster-VERSION.jar` to the /opt/kylo/kylo-services/plugins` folder

2. Add a new property to the application.properties to indicate the expected number of nodes you are running in your cluster.  Below is an example expecting 2 nodes in the cluster

 .. code-block:: properties

  kylo.cluster.nodeCount=2

 ..

3. Now a new Service Monitor will appear in the Kylo Dashboard and show you cluster health status


Troubleshooting
~~~~~~~~~~~~~~~

 If you are having issues identifying if the clustering is working you can modify the log4j.properties and have it show cluster events.  This is especially useful for modeshape.
Note: by doing this logs will be very verbose, so its recommended this is only done for initial setup/debugging

  .. code-block:: properties

    log4j.logger.org.modeshape.jcr.clustering.ClusteringService=DEBUG
    log4j.logger.org.jgroups=DEBUG

  ..