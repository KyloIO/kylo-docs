===================
Change Java Home
===================

By default, the kylo-services and kylo-ui application set the
JAVA_HOME location to /opt/java/current. This can easily be changed by
editing the JAVA_HOME environment variable in the following two files:

.. code-block:: shell

    /opt/kylo/kylo-ui/bin/run-kylo-ui.sh
    /opt/kylo/kylo-services/bin/run-kylo-services.sh

..

In addition, if you run the script to modify the NiFI JAVA_HOME
variable you will need to edit:

.. code-block:: shell

    /opt/nifi/current/bin/nifi.sh

..
