
==========================
TAR File Installation
==========================

Introduction
============

At this time an RPM file is the only artifact built in Kylo. An RPM
installation is meant to be an opioninated way of installing an
application and reduces the number of steps required during
installation. However, some clients have strict requirements as to where
they need install Kylo and what user to run Kylo under. These
instructions will guide you on an alternative way to install Kylo if
required.

Determine Service Account and Kylo Install Location
---------------------------------------------------

Let’s assume, for this example, that Kylo will run under an account name
"kylo\_user", and it will be installed in /opt/apps/.

Step 1: Install the RPM and copy the /opt/kylo folder to a temporary location.
----------------------------------------------------------------------------------

.. code-block:: shell

    cp -R /opt/kylo /opt/tb-test

..

Step 2: Copy init.d scripts to the same temporary location.
-----------------------------------------------------------

.. code-block:: shell

    cp /etc/init.d/kylo-services /opt/tb-test
    cp /etc/init.d/kylo-spark-shell /opt/tb-test
    cp /etc/init.d/kylo-ui /opt/tb-test

..

Your temp location should look like this:

.. code-block:: shell

    [root@sandbox tb-test]# ls -l /opt/tb-test
    drwxr-xr-x 8 root root 4096 2016-10-27 20:13 kylo
    -rwxr-xr-x 1 root root 1561 2016-10-27 20:20 kylo-services
    -rwxr-xr-x 1 root root 1281 2016-10-27 20:21 kylo-spark-shell
    -rwxr-xr-x 1 root root 1447 2016-10-27 20:21 kylo-ui

..

Step 3 (Optional): Tar up the folder and copy it to the edge node if you aren’t already on it.
----------------------------------------------------------------------------------------------

Step 4: Install the files.
--------------------------

1. Copy the kylo folder to /opt/apps

2. Copy the 3 init.d scripts to /etc/init.d

Step 5: Create Log Folders
--------------------------

.. code-block:: shell

    [root@sandbox tb-test]# mkdir /var/log/kylo-services
    [root@sandbox tb-test]# chown kylo\_user:kylo\_user
    /var/log/kylo-services
    [root@sandbox tb-test]# mkdir /var/log/kylo-ui
    [root@sandbox tb-test]# chown kylo\_user:kylo\_user
    /var/log/kylo-ui
    [root@sandbox tb-test]# mkdir /var/log/kylo-spark-shell
    [root@sandbox tb-test]# chown kylo\_user:kylo\_user
    /var/log/kylo-spark-shell/

..

Step 6: Modify the user in the init.d scripts.
----------------------------------------------

Set this line to be the correct user:

.. code-block:: shell

    RUN\_AS\_USER=kylo\_user

..

Also change any reference of /opt/kylo to /opt/apps/kylo.

Step 7: Modify the bin scripts for the 3 kylo apps.
---------------------------------------------------

Modify the following files and change /opt/kylo references to
/opt/kylo/apps:

.. code-block:: shell

    /opt/apps/kylo/kylo-ui/bin/run-kylo-ui.sh
    /opt/apps/kylo/kylo-services/bin/run-kylo-services.sh
    /opt/apps/kylo/kylo-spark-shell/bin/run-kylo-spark-shell.sh

..

Step 8: Start up Kylo and test.
-------------------------------
