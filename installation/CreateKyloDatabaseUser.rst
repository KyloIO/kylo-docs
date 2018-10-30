=============================
Create Kylo Database and User
=============================
If you prefer to run Kylo as a non-privileged user and want to create the database schema yourself please do the following.

.. Note:: These commands need to be ran as a database administrator

Create the kylo database user
-------------------------------

Postgres

.. code-block:: shell

    $ sudo -u postgres psql

    > CREATE USER kylo WITH PASSWORD 'abc123';

..

Grant Kylo user access to DB
----------------------------

Postgres

.. code-block:: shell

    $ sudo -u postgres psql -d kylo

    > grant usage on schema public to kylo;
    > GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA PUBLIC TO kylo;
    > GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA PUBLIC TO kylo;
    > grant execute on all functions in schema public to kylo;
    > alter default privileges in schema public grant execute on functions to kylo;

..


