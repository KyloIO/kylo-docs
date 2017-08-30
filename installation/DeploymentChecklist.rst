
====================
Prepare Checklist
====================

This checklist will help you prepare for an enterprise deployment and is valuable if you require approvals ahead of time. Please refer to the :doc:`../installation/Dependencies` guide
for more details in each section

- Pre-installation
    - [ ] Determine data throughput requirements based on expected feeds
    - [ ] Will I use an existing Elasticsearch/SOLR instance?
    - [ ] Will I use an existing ActiveMQ instance?
    - [ ] Review library dependencies to ensure HDFS/Hive/Spark is current enough
    - [ ] Obtain approvals for Linux service users (If not, you must install using TAR method)
    - [ ] Obtain approvals for network ports
    - [ ] Determine if I want to leverage liquibase to automatically install database scripts and upgrades for Kylo
    - [ ] Request or generate SSL certificates if required

- Hardware/OS Provisioning
    - [ ] Provision Edge Nodes
    - [ ] Install supported operating system

- General Configuration Preparation
    - [ ] Hive Hostname/IP Address:
    - [ ] Ambari/Cloudera Manager IP Hostname/IP Address (if used):
    - [ ] Ambari/Cloudera Manager "kylo" user username/password (if used):
    - [ ] Kylo Edge Hostname/IP Address:
    - [ ] NiFi Edge Hostname/IP Address:
    - [ ] MySQL Kylo Hostname/IP Address:
    - [ ] Kylo MySQL Installation User username/password (Create Schema Required):
    - [ ] Kylo MySQL application username/password (For the kylo-services application and Hive metadata access):
    - [ ] MySQL Hive Hostname/IP Address:
    - [ ] Hive MySQL application username/password:
    - [ ] HDFS root folder location (if different than default:

- Kerberos Configuration Preparation
    - [ ] KDC Hostname/IP Address (if used):
    - [ ] Kerberos Principal for "kylo":
    - [ ] Kerberos Principal for "nifi":
    - [ ] Kerberos Principal for "hive" on the Hive Server2 Host: