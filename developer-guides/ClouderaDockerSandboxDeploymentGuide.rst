
========================================
Cloudera Docker Sandbox Deployment Guide
========================================


About
=====

In some cases, you may want to deploy a Cloudera sandbox in AWS for a
team to perform a simple proof-of-concept, or to avoid system resource usage
on the local computer. Cloudera offers a Docker image, similar
to the Cloudera sandbox, that you download and install to your
computer.

.. warning:: Once you create the docker container called "cloudera" do not remove the container unless you intend to delete all of your work and start cleanly. There are instructions below on how to start and stop an existing container to retain your data.

..


Prerequisites
=============

You need access to an AWS instance and permission to create an EC2 instance.

Installation
============

Step 1: Create an EC2 instance
------------------------------

For this document, we will configure a CoreOS AMI which is optimized for running Docker images.

1. Choose an AMI for the region in which you will configure the EC2 instance.

.. note:: For detailed procedures for |configuring_the_EC2_Link| instance, visit Running CoreOS Container Linux on EC2 on the CoreOS website.

2. Create the EC2 instance. You might want to add more disk space than the default 8GB.

3. Configure the EC2 security group.

4. After starting up the instance, Login to the EC2 instance:

.. code-block:: shell

    $ ssh -i <private_key> core@<IP_ADDRESS>

Step 2: Create Script to Start Docker Container
-----------------------------------------------

Create a shell script to startup the Docker container. This makes it
easier to create a new container if you decided to delete it at some
point and start clean.

1. Create Cloudera docker script:

.. code-block:: shell

    $ vi startCloudera.sh

..

2. Add the following:

.. code-block:: properties

    #!/bin/bash
    docker run --name cloudera =
      --hostname=quickstart.cloudera \
      --privileged=true -t -d \
      -p 8888:8888 \
      -p 7180:7180 \
      -p 80:80 \
      -p 7187:7187 \
      -p 8079:8079 \
      -p 8400:8400 \
      -p 8161:8161 \
      cloudera/quickstart:5.7.0-0-beta /usr/bin/docker-quickstart

..

3. Change permissions:

.. code-block:: shell

    $ chmod 755 startCloudera.sh

4. Start the Container:

.. code-block:: shell

    $ /startCloudera.sh

..

    It will have to first download the Docker image, which is about 4GB,
    so give it some time.

Step 3: Login to the Cloudera Container and Start Cloudera Manager
------------------------------------------------------------------

1. Login to the Docker container:

.. code-block:: shell

    $ docker exec -it cloudera bash

2. Start Cloudera Manager:

.. code-block:: shell

    $ /home/cloudera/cloudera-manager --express

3. Login to Cloudera Manager:

.. code-block:: shell

    <EC2_HOST>:7180 (username/password is cloudera/cloudera)

..

4. Start all services in Cloudera Manager.

Step 4: Install Kylo in the Docker Container
--------------------------------------------

1. Follow the Setup Wizard guide

:doc:`../installation/SetupWizardDeploymentGuide`
   

2. Login to Kylo at <EC2_HOST>:8400, and NiFi at <EC2_HOST>:8079.

Shutting down the container when not in use
===========================================

EC2 instance can get expensive to run. If you don’t plan to use the
sandbox for a period of time, we recommend shutting down the EC2
instance. Here are instructions on how to safely shut down the Cloudera
sandbox and CoreOS host.

1. Login to Cloudera Manager and tell it to stop all services.

2. On the CoreOS host, type "docker stop cloudera".

3. Shutdown the EC2 Instance.

Starting up an Existing EC2 instance and Cloudera Docker Container
==================================================================

1. Start the EC2 instance.

2. Login to the CoreOS host.

3. Type "docker start cloudera" to start the container.

4. SSH into the docker container.

.. code-block:: shell

    $ docker exec -it cloudera bash

5. Start Cloudera Manager.

.. code-block:: shell

    $ /home/cloudera/cloudera-manager --express

6. Login to Cloudera Manager and start all services.

.. |configuring_the_EC2_Link| raw:: html

    <a href="https://coreos.com/os/docs/latest/booting-on-ec2.html" target="_blank">configuring_the_EC2</a>
