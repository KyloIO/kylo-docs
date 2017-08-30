===============
Adjust Memory
===============

Optimizing Performance
======================

You can adjust the memory setting for each services using the below
environment variables:

.. code-block:: shell

    /opt/kylo/kylo-ui/bin/run-kylo-ui.sh
    export KYLO_UI_OPTS= -Xmx4g

    /opt/kylo/kylo-services/bin/run-kylo-services.sh
    export KYLO_SERVICES_OPTS= -Xmx4g

..