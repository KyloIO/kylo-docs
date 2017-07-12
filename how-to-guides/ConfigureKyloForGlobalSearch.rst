==============================
Configure Kylo & Global Search
==============================

Elasticsearch
=============

Kylo supports Global search via a plugin-based design. Steps to configure Kylo with Elasticsearch engine are below:

1. Include ``search-es`` profile in existing list of profiles in ``/opt/kylo/kylo-services/conf/application.properties``


    .. code-block:: shell

      spring.profiles.include=native,nifi-v1,auth-kylo,auth-file,search-es

    ..

2. Ensure that the plugin is available in ``/opt/kylo/kylo-services/plugin``. This comes out-of-the-box at this location by default. It should have ownership as ``kylo:users`` and permissions ``755``.


    .. code-block:: shell

        kylo-search-elasticsearch-0.8.2.jar
    ..

.. note:: There should be only one search plugin in the above plugin directory. If there is another search plugin (for example, kylo-search-solr-0.8.2.jar), move it to /opt/kylo/setup/plugins/ for later use.

Reference commands to get the plugin, and change ownership and permissions:

    .. code-block:: shell

        cp <location-where-you-saved-the-default-plugin-jar-named kylo-search-elasticsearch-0.8.2.jar> /opt/kylo/kylo-services/plugin/
        cd /opt/kylo/kylo-services/plugin/
        chown kylo:users kylo-search-elasticsearch-0.8.2.jar
        chmod 755 kylo-search-elasticsearch-0.8.2.jar
    ..


3. Provide elasticsearch properties

    1. Update cluster properties in ``/opt/kylo/kylo-services/conf/elasticsearch.properties`` if different from the defaults provided below.

    .. code-block:: shell

        search.host=localhost
        search.clusterName=demo-cluster
        search.restPort=9200
        search.transportPort=9300

    ..


4. Restart Kylo Services

    .. code-block:: shell

        service kylo-services restart

    ..

5. Steps to import updated Index Schema Service feed

    1. Feed Manager -> Feeds -> + orange button -> Import from file -> Choose file

    2. Pick the ``index_schema_service_elasticsearch.feed.zip`` file available at ``/opt/kylo/setup/data/feeds/nifi-1.0``

    3. Leave *Change the Category* field blank (It defaults to *System*)

    4. Click *Yes* for these two options (1) *Overwrite Feed* (2) *Replace Feed Template*

    5. (optional) Click *Yes* for option (3) *Disable Feed upon import* only if you wish to keep the indexing feed disabled upon import (You can explicitly enable it later if required)

    6. Click *Import Feed*.

    7. Verify that the feed imports successfully.

    8. If your Hive metastore is in a schema named something other than ``hive``, edit the feed and set ``hive.schema`` to the schema name (if not already properly set). This configuration value may be available with the key ``config.hive.schema`` in ``/opt/kylo/kylo-services/conf/application.properties``.


6. Steps to import updated Index Text Service feed

    1. Feed Manager -> Feeds -> + orange button -> Import from file -> Choose file

    2. Pick the ``index_text_service_elasticsearch.feed.zip`` file available at ``/opt/kylo/setup/data/feeds/nifi-1.0``

    3. Leave *Change the Category* field blank (It defaults to *System*)

    4. Click *Yes* for these two options (1) *Overwrite Feed* (2) *Replace Feed Template*

    5. (optional) Click *Yes* for option (3) *Disable Feed upon import* only if you wish to keep the indexing feed disabled upon import (You can explicitly enable it later if required)

    6. Click *Import Feed*.

    7. Verify that the feed imports successfully.