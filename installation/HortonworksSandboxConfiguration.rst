
=================================
Hortonworks Sandbox Configuration
=================================

Introduction
============

This guide will help you install the Hortonworks sandbox for development
and RPM testing.

Install and Configure the Hortonworks Sandbox
=============================================

Download the latest HDP sandbox and import it into Virtual Box. We want
to change the CPU and and RAM settings:

-  CPU - 4

-  RAM - 10GB

|Hortonworks Sandbox_Link|

Add Virtual Box Shared Folder
=============================

Adding a shared folder to Virtual Box will allow you to access the Kylo project folder outside of the VM so you can copy
project artifacts to the sandbox for testing.

.. note:: This should be done before starting the VM to that you can auto mount the folder.

.. code-block:: shell

    VBox GUI > Settings > Shared Folders > Add

..

.. code-block:: properties

    Folder Path = <pathToProjectFolder>
    Folder Name = kylo

..

Choose Auto-mount so that it remembers next time you start the VM.

Open VM Ports
=============

The following ports needs to be forwarded to the VM:

.. code-block:: shell

    (On Virtual Box > Settings > Network > Port Forwarding

..

This table shows the ports to add.

+-------------------------+-------------+--------------+------------------------------------------------------------------------------------------------------+
| Application Name        | Host Port   | Guest Port   | Comment                                                                                              |
+-------------------------+-------------+--------------+------------------------------------------------------------------------------------------------------+
| Kylo UI                 | 8401        | 8400         | Use 8401 on the HostIP side so that you can run it in your IDE under 8400 and still test in the VM   |
+-------------------------+-------------+--------------+------------------------------------------------------------------------------------------------------+
| Kylo Spark Shell        | 8450        | 8450         |                                                                                                      |
+-------------------------+-------------+--------------+------------------------------------------------------------------------------------------------------+
| NiFi                    | 8079        | 8079         |                                                                                                      |
+-------------------------+-------------+--------------+------------------------------------------------------------------------------------------------------+
| ActiveMQ Admin          | 8161        | 8161         |                                                                                                      |
+-------------------------+-------------+--------------+------------------------------------------------------------------------------------------------------+
| ActiveMQ JMS            | 61616       | 61616        |                                                                                                      |
+-------------------------+-------------+--------------+------------------------------------------------------------------------------------------------------+
| MySQL                   | 3306        | 3306         |                                                                                                      |
+-------------------------+-------------+--------------+------------------------------------------------------------------------------------------------------+

.. note:: The current HDP 2.5 sandbox for VirtualBox now uses Docker container, which means configuring port-forwarding in the VirtualBox UI is not enough anymore. You should do some extra steps described in: |port-forwarding-link|

Startup the Sandbox
===================

1.  Start the sandbox.

2.  SSH into the sandbox.

.. code-block:: shell

    $ ssh root@localhost -p 2222 (password is "hadoop")   

..


.. note:: You will be prompted to change your password.


3.  Add the Ambari admin password.

.. code-block:: shell

    $ ambari-admin-password-reset   

..

After setting the password the Ambari server will be started.

.. |Hortonworks Sandbox_Link| raw:: html

    <a href="http://hortonworks.com/products/sandbox/" target="_blank">Hortonworks Sandbox</a>

.. |port-forwarding-link| raw:: html

   <a href="https://community.hortonworks.com/articles/65914/how-to-add-ports-to-the-hdp-25-virtualbox-sandbox.html" target="_blank">How to add ports to the HDP 2.5 VirtualBox Sandbox</a>
