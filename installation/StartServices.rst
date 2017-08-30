===============
Start Services
===============

Start Kylo and NiFi
-------------------

.. code-block:: shell

    $ kylo-service start
    $ service nifi start

At this point all services should be running. Verify by running:

.. code-block:: shell

    $ kylo-service status
    $ service nifi status
    $ service elasticsearch status
    $ service activemq status
..

Test Services
----------------------

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


