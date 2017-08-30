
==================================
TAR File Upgrade
==================================


Below are instructions on how to upgrade using a TAR file when using a non standard installation location.

Step 1: Backup and Delete the Kylo folder
------------------------------------------------------------------------------

.. code-block:: shell

    $ sudo kylo-service stop
    $ sudo cp -R /apps/kylo/ /apps/kylo-<version>-bk
    $ sudo rm -rf /apps/kylo
    $ sudo chkconfig --del kylo-ui
    $ sudo chkconfig --del kylo-spark-shell
    $ sudo chkconfig --del kylo-services
    $ sudo rm -rf /etc/init.d/kylo-ui
    $ sudo rm -rf /etc/init.d/kylo-services
    $ sudo rm -rf /etc/init.d/kylo-spark-shell
    $ sudo rm -rf /var/log/kylo-*


..

Step 2: Stop NiFi
------------------------------------------------------------------------------

Step 3: Untar the new file
------------------------------------------------------------------------------

.. code-block:: shell

    $ sudo mkdir /apps/kylo
    $ sudo tar -xvf /tmp/kylo-0.8.2-dependencies.tar.gz -C /apps/kylo

..

Step 4: Run the post install script
------------------------------------------------------------------------------

.. code-block:: shell

    $ sudo /apps/kylo/setup/install/post-install.sh /apps/kylo ad_kylo users

..

Step 5: Update the NiFi JARS and NARS
------------------------------------------------------------------------------

.. code-block:: shell

    $ sudo rm -rf /apps/nifi/data/lib/*.nar
    $ sudo rm -rf /apps/nifi/data/lib/app/*.jar

    $ sudo /apps/kylo/setup/nifi/update-nars-jars.sh /apps/nifi /apps/kylo/setup ad_nifi users

..


Step 6: Start NiFi
------------------------------------------------------------------------------


Step 7: Copy custom configuration files to the new installation
------------------------------------------------------------------------------

For example:

.. code-block:: shell

    $ sudo cp /apps/kylo-<version>-bk/kylo-services/bin/run-kylo-spark-shell.sh /apps/kylo/kylo-services/bin
    $ sudo cp /apps/kylo-<version>-bk/kylo-services/conf/spark.properties /apps/kylo/kylo-services/conf
    $ sudo cp /apps/kylo-<version>-bk/kylo-services/conf/application.properties /apps/kylo/kylo-services/conf
    $ sudo cp /apps/kylo-<version>-bk/kylo-ui/conf/application.properties /apps/kylo/kylo-ui/conf
    $ sudo cp /apps/kylo-<version>-bk/encrypt.key /apps/kylo/
    $ sudo cp /apps/kylo-<version>-bk/kylo-services/lib/postgresql-42.0.0.jar /apps/kylo/kylo-services/lib/

    $ sudo cp /apps/kylo-<version>-bk/kylo-services/conf/ambari.properties /apps/kylo/kylo-services/conf/
    $ sudo cp /apps/kylo/setup/plugins/kylo-service-monitor-ambari-<version>.jar /apps/kylo/kylo-services/plugin/
    $ sudo chown ad_kylo:ad_kylo /apps/kylo/kylo-services/plugin/kylo-service-monitor-ambari-<version>.1.jar

..

Step 8: Start Kylo
------------------------------------------------------------------------------

.. code-block:: shell

    $ sudo kylo-service start

..
