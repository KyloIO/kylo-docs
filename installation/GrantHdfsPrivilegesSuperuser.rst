===============================
Grant Superuser HDFS Privileges
===============================

NiFi Node
----------
Add nifi user to the HDFS supergroup or the group defined in hdfs-site.xml, for example:

   **Hortonworks (HDP)**

.. code-block:: shell

        $ usermod -a -G hdfs nifi

..

    **Cloudera (CDH)**

.. code-block:: shell

        $ groupadd supergroup
        # Add nifi and hdfs to that group:
        $ usermod -a -G supergroup nifi
        $ usermod -a -G supergroup hdfs

..

.. note:: If you want to perform actions as a root user in a development environment, run the below command.

.. code-block:: shell

        $ usermod -a -G supergroup root

..

Kylo Node
---------
Add kylo user to the HDFS supergroup or the group defined in hdfs-site.xml, for example:

   **Hortonworks (HDP)**

.. code-block:: shell

        $ usermod -a -G hdfs kylo

..

    **Cloudera (CDH)**

.. code-block:: shell

        $ groupadd supergroup
        # Add kylo and hdfs to that group:
        $ usermod -a -G supergroup kylo
        $ usermod -a -G supergroup hdfs

..

.. note:: If you want to perform actions as a root user in a development environment run the below command.

.. code-block:: shell

        $ usermod -a -G supergroup root

..

Clusters
---------

In addition to adding the nifi and kylo users to the supergroup on the edge node you also need to add the users/groups to the **NameNodes** and **Data Nodes** on a cluster.

   **Hortonworks (HDP)**

.. code-block:: shell

        $ useradd kylo

        $ useradd nifi

        $ usermod -G hdfs nifi

        $ usermod -G hdfs kylo

    **Cloudera (CDH)**

.. code-block:: shell

        $ groupadd supergroup
        # Add nifi and hdfs to that group:
        $ usermod -a -G supergroup kylo
        $ usermod -a -G supergroup nifi
        $ usermod -a -G supergroup hdfs