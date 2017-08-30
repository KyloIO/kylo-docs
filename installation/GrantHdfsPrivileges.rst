============================
Grant HDFS Privileges
============================
Kylo and NiFi requires access to HDFS and Hive. NiFi needs to write to both Hive and HDFS. There are three approaches for granting the
required access to Kylo and NiFi

1. Grant the "kylo" and "nifi" service users super user privileges to access resources on the cluster
2. Control access through Ranger or Sentry
3. Manage the HDFS permissions yourself

Option 1:  Grant super user privileges
----------------------------------------
This is useful in a sandbox environment where you do not need security enabled. This allows Kylo and NiFi the ability to create/edit HDFS and Hive objects.

.. toctree::
    :maxdepth: 1

    GrantHdfsPrivilegesSuperuser

Option 2:  Control access through Ranger or Sentry
---------------------------------------------------
Instructions coming soon !!

Option 3:  Manage the HDFS permissions yourself
------------------------------------------------
This option is rarely used and we do not have documentation at this time