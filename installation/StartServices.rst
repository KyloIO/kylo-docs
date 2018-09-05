==============
Start Services
==============

Start NiFi
----------

.. code-block:: shell

    $ service nifi start

..

At this point all services should be running. Verify by running:

.. code-block:: shell

    $ service nifi status
    $ service elasticsearch status
    $ service activemq status
..

Optionally Inspect Kylo Configuration
-------------------------------------

You can now optionally inspect Kylo configuration for errors with :doc:`Kylo Config Inspector App <../how-to-guides/ConfigurationInspectorApp>`, otherwise you proceed to start Kylo services


Start Kylo Services
-------------------

.. code-block:: shell

    $ kylo-service start
    $ kylo-service status

..


Test Services
-------------

| Feed Manager and Operations UI
| http://127.0.0.1:8400
| username: dladmin
| password: thinkbig
|
| NiFi UI
| http://127.0.0.1:8079/nifi
|
| Elasticsearch REST API
| curl localhost:9200
|
| ActiveMQ Admin
| http://127.0.0.1:8161/admin
|


