============================
Prepare Offline Setup Folder
============================
The OPTIONAL offline setup TAR file can be useful in two scenarios:

    1. You are installing ActiveMQ, Elasticsearch, Java or NiFi on nodes with no external network access.

    2. You plan on installing ActiveMQ, Elasticsearch, Java or NiFi on separate nodes than Kylo and want to take advantage of the setup files you will want to generate an

The offline setup TAR file will include the binaries required to install the services mentioned above.

Generate the Setup TAR file
---------------------------

1. Install the Kylo RPM on a node that has internet access.

.. code-block:: shell

    $ rpm -ivh kylo-<version>.rpm
..

2. Run the script, which will download all application binaries and put them in their respective directory in the setup folder.

.. code-block:: shell

    $ /opt/kylo/setup/generate-offline-install.sh
..

.. note:: If installing the Debian packages make sure to change the Elasticsearch download from RPM to DEB


3. Copy the ``/opt/kylo/setup/kylo-install.tar`` file to the node you install the RPM on. This can be copied to a temp directory. It doesn’t have to be put in the ``/opt/kylo/setup`` folder.

4. Run the command to tar up the setup folder.

.. code-block:: shell

    tar -xvf kylo-install.tar
..

5. Note the directory name where you untar’d the files. You will need to reference the setup location when running installation setup wizard in offline mode or manually running shell scripts.
   Refer to :doc:`InstallAdditionalKyloComponents` for installing in offline mode.
