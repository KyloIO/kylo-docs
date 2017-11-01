Release 0.8.4 (TBD)
===================

Highlights
----------
- Item 1
- Item 2
- Item 3
- Item 4
- Item 5
- Item 6
- Item 7
- Item 8


Download Links
--------------
- Visit the :doc:`Downloads <../about/Downloads>` page for links.


Upgrade Instructions from v0.8.3
--------------------------------
- **Order of execution of instructions to be updated**

1. Stop NiFi:

 .. code-block:: shell

   service nifi stop

 ..

2. Uninstall Kylo:

 .. code-block:: shell

   /opt/kylo/remove-kylo.sh

 ..

3. Install the new RPM:

 .. code-block:: shell

     rpm –ivh <RPM_FILE>

 ..

- If using Elasticsearch 5, update the **Index Text Service** feed. This step should be done once Kylo services are started and Kylo is up and running.

    - [Note: This requires NiFi 1.3 or later] Import the feed ``index_text_service_v2.feed.zip`` file available at ``/opt/kylo/setup/data/feeds/nifi-1.3``. Click 'Yes' for these options during feed import (a) Overwrite Feed (b) Replace Feed Template (c) Replace Reusable Template.

- If using Elasticsearch 2, install an additional plugin to support deletes. If required, change the location to where Elasticsearch is installed.

.. code-block:: shell

     sudo /usr/share/elasticsearch/bin/plugin install delete-by-query
     service elasticsearch restart

..


4. JMS configuration:

It was previously possible to provide ActiveMQ and AmazonSQS configuration in their respective configuration files called ``activemq.properties`` and ``amazon-sqs.properties``.
It is no longer possible and these properties should be moved over to standard Kylo configuration file found in ``<KYLO_HOME>/kylo-services/conf/application.properties``.

