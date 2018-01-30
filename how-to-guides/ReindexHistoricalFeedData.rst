============================
Reindex Historical Feed Data
============================

    .. note:: This feature requires NiFi version 1.3 or above. If using Elasticsearch, version 5 or up is required.

A feed definition can be edited to change the columns that are indexed in a search engine.
The change will take effect for future runs of the feed, and the updated list of columns will get indexed going forward.

At time of saving the updated feed definition, Kylo will detect any change in indexing options and prompt for reindexing historical data as per
the updated indexing options. This provides the feed editor an option to:
    - add missing columns for indexing that can be used for search
    - remove sensitive/non-required columns for indexing that should be not be searchable

You can choose to ignore or perform history indexing of feed data by choosing **Yes** or **No** when Kylo prompts for it.

While a feed's history data is being re-indexed, changes to indexing options for the feed will be disabled.
The feed details page provides status of history re-indexing via the **Reindexing In Progress** and **Reindexing Last Status** fields.

To enable this functionality, perform the following steps:

A. Update Kylo Services properties
==================================

1. Enable option in ``/opt/kylo/kylo-services/conf/application.properties`` for Kylo services.

    .. code-block:: shell

        search.history.data.reindexing.enabled=true
    ..


B. (Optional) Update Solr plugin properties
===========================================

1. If using Solr instead of Elasticsearch as the search engine:

    1. Add one property to ``/opt/kylo/kylo-services/conf/solrsearch.properties`` file.

    .. code-block:: shell

        config.http.solr.url=http://${search.host}:${search.port}

    ..

C. Restart Kylo Services
========================

1. Restart Kylo services.

    .. code-block:: shell

        service kylo-services stop
        service kylo-services start
    ..

2. Ensure that Kylo UI and Kylo Spark Shell are running. If not, start them.

    .. code-block:: shell

        service kylo-ui status
        # if stopped, start it
        service kylo-ui start

        service kylo-spark-shell status
        # if stopped, start it
        service kylo-spark-shell start

    ..

D. Update Index Text Service Feed
=================================

1. Once Kylo is up, import the updated Index Text Service feed via these steps:

    1. Feed Manager -> Feeds -> + orange button -> Import from file -> Choose file

    2. Pick the ``index_text_service_v3.feed.zip`` file available at ``/opt/kylo/setup/data/feeds/nifi-1.3/history-reindexing/``

    3. Leave *Change the Category* field blank (It defaults to *System*)

    4. Click *Yes* for these three options (1) *Overwrite Feed* (2) *Replace Feed Template* (3) *Replace Reusable Template*

    5. Click *Import Feed*.

    6. Verify that the feed imports successfully.


E. Import History Reindex Text Service Feed
===========================================

1. Import the History Reindex Text Service feed via these steps:

    1. Feed Manager -> Feeds -> + orange button -> Import from file -> Choose file

    2. Pick the ``history_reindex_text_service_v1.feed.zip`` file available at ``/opt/kylo/setup/data/feeds/nifi-1.3/history-reindexing/``

    3. Leave *Change the Category* field blank (It defaults to *System*)

    4. Click *Yes* for these three options (1) *Overwrite Feed* (2) *Replace Feed Template* (3) *Replace Reusable Template*

    5. Click *Import Feed*.

    6. Verify that the feed imports successfully.

Now, you can choose to reindex a feed's history when updating the columns to index.
The History Reindex Text Service feed runs every 10 minutes (default schedule) and performs the job.