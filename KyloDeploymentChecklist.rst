
====================
Deployment Checklist
====================

This document provides a sample checklist to help prepare for a Kylo
deployment.

Edge Node Resource Requirements
-------------------------------

-  Kylo and Apache NiFi can be installed on a single edge node, however it is recommended they run on separate edge nodes.

-  Minimum production recommendation is 4 cores CPU, 16 GB RAM.

-  Preferred production recommendation is 8 cores CPU, 32 GB RAM.

Dependencies
------------

+----------------------------------------------+
| Redhat/GNU/Linux distributions               |
+----------------------------------------------+
| RPM (for install)                            |
+----------------------------------------------+
| Java 1.8+                                    |
+----------------------------------------------+
| Hadoop 2.4+ cluster                          |
+----------------------------------------------+
| Spark 1.5.2+                                 |
+----------------------------------------------+
| Apache NiFi 1.x+ (or HDF 2.x)                |
+----------------------------------------------+
| Hive  1.2.x+                                 |
+----------------------------------------------+
| MySQL 5.x+                                   |
+----------------------------------------------+

Linux User/Group Creation
-------------------------

There are three Linux users accounts that need to be created before
installing the Kylo stack. If an external user management tool is used,
these user accounts need to be created ahead of time. If not, there are
instructions in the deployment guide on how to create the users and
groups.

-  kylo

-  nifi

-  activemq

Please create the above users and groups with the same names.

Edge Node Ports
---------------

The following ports are required to be open for browser access unless using a web proxy server:

-  Think Big UI – 8400

-  NiFi – 8079

-  ActiveMQ JMS – 61616 (only if on a different edge node than NiFi or
   Kylo)

The following is optional:

-  ActiveMQ Admin – 8161

Cluster Host Names, User Names, and Ports
-----------------------------------------

Collect the following information to speed up configuration of Kylo

-  Hive Hostname/IP Address:

-  Ambari IP Hostname/IP Address (if used):

-  Ambari "kylo" user username/password (if used):

-  KDC Hostname/IP Address (if used):

-  MySQL Metastore Hostname/IP Address:

-  Kylo Edge Hostname/IP Address:

-  NiFi Edge Hostname/IP Address:

-  Kylo MySQL Installation User username/password (Create Schema
   Required):

-  Kylo MySQL application username/password (For the kylo-services
   application and Hive metadata access):

Kerberos Principals (if using Kerberos)
----------------------------------------

Note the following Kerberos principals after the step of creating the
Keytabs

-  Kerberos Principal for "kylo":

-  Kerberos Principal for "nifi":

-  Kerberos Principal for "hive" on the Hive Server2 Host:

