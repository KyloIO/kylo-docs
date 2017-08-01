==============================
Configure Kylo & Global Search
==============================

Kylo supports Global search via a plugin-based design. Two plugins are provided out of the box:

1) Elasticsearch (default)

2) Solr

Elasticsearch
=============

Steps to configure Kylo with Elasticsearch engine are below:

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

    Update cluster properties in ``/opt/kylo/kylo-services/conf/elasticsearch.properties`` if different from the defaults provided below.

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

5. Steps to import updated Index Text Service feed

    1. Feed Manager -> Feeds -> + orange button -> Import from file -> Choose file

    2. Pick the ``index_text_service_elasticsearch.feed.zip`` file available at ``/opt/kylo/setup/data/feeds/nifi-1.0``

    3. Leave *Change the Category* field blank (It defaults to *System*)

    4. Click *Yes* for these two options (1) *Overwrite Feed* (2) *Replace Feed Template*

    5. (optional) Click *Yes* for option (3) *Disable Feed upon import* only if you wish to keep the indexing feed disabled upon import (You can explicitly enable it later if required)

    6. Click *Import Feed*.

    7. Verify that the feed imports successfully.


Solr
====

Kylo is designed  to work with Solr (SolrCloud mode) and tested with v6.5.1. This configuration assumes that you already have a running Solr instance. You can also get it from the `official download page <http://lucene.apache.org/solr/downloads.html>`_.

Steps to configure Kylo with Solr are below:

1. Include ``search-solr`` profile in existing list of profiles in ``/opt/kylo/kylo-services/conf/application.properties``


    .. code-block:: shell

      spring.profiles.include=native,nifi-v1,auth-kylo,auth-file,search-solr

    ..

2. Ensure that the plugin is available in ``/opt/kylo/kylo-services/plugin``. The plugin comes out-of-the-box at another location ``/opt/kylo/setup/plugins``. It should have ownership as ``kylo:users`` and permissions ``755``.


    .. code-block:: shell

        kylo-search-solr-0.8.2.jar
    ..

    .. note:: There should be only one search plugin in the /opt/kylo/kylo-services/plugin directory. If there is another search plugin (for example, kylo-search-elasticsearch-0.8.2.jar), move it to /opt/kylo/setup/plugins/ for later use.


    Reference commands to get the plugin, and change ownership and permissions:

    .. code-block:: shell

        mv /opt/kylo/kylo-services/plugin/kylo-search-elasticsearch-0.8.2.jar /opt/kylo/setup/plugins/
        cp /opt/kylo/setup/plugins/kylo-search-solr-0.8.2.jar /opt/kylo/kylo-services/plugin/
        cd /opt/kylo/kylo-services/plugin/
        chown kylo:users kylo-search-solr-0.8.2.jar
        chmod 755 kylo-search-solr-0.8.2.jar
    ..

3. Create a folder on the box where Kylo is running to store indexes for Kylo metadata. Ensure that Kylo can write to this folder.

    Reference commands to create this folder and give full permissions:

    .. code-block:: shell

        mkdir /tmp/kylosolr
        chmod 777 /tmp/kylosolr

    ..

4. Provide solr properties

    Update cluster properties in ``/opt/kylo/kylo-services/conf/solrsearch.properties`` if different from the defaults provided below. The ``search.indexStorageDirectory`` should match with the folder location created in previous step.

    .. code-block:: shell

        search.host=localhost
        search.port=8983
        search.indexStorageDirectory=/tmp/kylosolr

    ..

5. Create collections in Solr that Kylo will use.

    Reference commands:

    .. code-block:: shell

        bin/solr create -c kylo-datasources -s 1 -rf 1
        bin/solr create -c kylo-data -s 1 -rf 1

    ..


6. Configure Kylo collections created in previous step via Admin UI

    Reference steps:

    **Navigate to Admin UI**
        - http://localhost:8983/solr

    **Configure collection for datasources**

        1. Select ``kylo-datasources`` collection from the drop down on left nav area

    	2. Click *Schema* on bottom left of nav area

    	3. Click *Add Field* on top of right nav pane

    	        - name: *kylo_collection*

    	        - type: *string*

                - default value: *kylo-datasources*

                - index: *no*

                - store: *yes*

    **Configure collection for data**

        1. Select ``kylo-data`` collection from the drop down on left nav area

        2. Click *Schema* on bottom left of nav area

        3. Click *Add Field* on top of right nav pane

                - name: *kylo_collection*

                - type: *string*

                - default value: *kylo-data*

                - index: *no*

                - store: *yes*


7. Restart Kylo Services

    .. code-block:: shell

        service kylo-services restart

    ..

8. Steps to import updated Index Text Service feed

    1. Feed Manager -> Feeds -> + orange button -> Import from file -> Choose file

    2. Pick the ``index_text_service_solr.feed.zip`` file available at ``/opt/kylo/setup/data/feeds/nifi-1.0``

    3. Leave *Change the Category* field blank (It defaults to *System*)

    4. Click *Yes* for these two options (1) *Overwrite Feed* (2) *Replace Feed Template*

    5. (optional) Click *Yes* for option (3) *Disable Feed upon import* only if you wish to keep the indexing feed disabled upon import (You can explicitly enable it later if required)

    6. Click *Import Feed*.

    7. Verify that the feed imports successfully.


9. Ensure that the box running Kylo can connect to the box running Solr (if they are on separate machines). If required, open up these ports:

    - 8983
    - 9983
