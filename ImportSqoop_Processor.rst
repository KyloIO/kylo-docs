
======================
ImportSqoop Processor
======================

About
=====

The ImportSqoop processor allows loading data from a relational system
into HDFS. This document discusses the setup required to use this
processor.

Starter template
================

A starter template for using the processor is provided at:

.. code-block:: shell

    samples/templates/nifi-1.0/template-starter-sqoop-import.xml

..

Configuration
=============

For use with Kylo UI, configure values for the two properties (**nifi.service.<controller service name in NiFi>.password**, **config.sqoop.hdfs.ingest.root**) in the below section in the properties file: **/opt/kylo/kylo-services/conf/application.properties**

.. code-block:: shell

    ### Sqoop import
    # DB Connection password (format: nifi.service.<controller service name in NiFi>.password=<password>
    #nifi.service.sqoop-mysql-connection.password=hadoop
    # Base HDFS landing directory
    #config.sqoop.hdfs.ingest.root=/sqoopimport

..

Please note that the **DB Connection password** section will have the name of the key derived from the controller service name in NiFi. In the above snippet, the controller service name is called **sqoop-mysql-connection**.

Drivers
=======

Sqoop requires the JDBC drivers for the specific database server in order to transfer data. The processor has been tested on MySQL, Oracle, Teradata and SQL Server databases, using Sqoop v1.4.6.

The drivers need to be downloaded, and the .jar files must be copied over to Sqoop’s /lib directory.

As an example, consider that the MySQL driver is downloaded and available in a file named: \ **mysql-connector-java.jar.**

This would have to be copied over into Sqoop’s /lib directory, which may be in a location similar to: \ **/usr/hdp/current/sqoop-client/lib.**

The driver class can then be referred to in the property **Source Driver** in **StandardSqoopConnectionService** controller service
configuration. For example: **com.mysql.jdbc.Driver.**

**Tip**: Avoid providing the driver class name in the controller service configuration.
Sqoop will try to infer the best connector and driver for the transfer on the basis of the **Source Connection String** property configured for **StandardSqoopConnectionService** controller service.

Passwords
=========

The processor's connection controller service allows three modes of providing the password:

1. Entered as clear text
2. Entered as encrypted text
3. Encrypted text in a file on HDFS

For modes (2) and (3), which allow encrypted passwords to be used, details are provided below:

Encrypt the password by providing the:

a. Password to encrypt

b. Passphrase

c. Location to write encrypted file to

The following command can be used to generate the
encrypted password:

.. code-block:: shell

      /opt/kylo/bin/encryptSqoopPassword.sh

..

The above utility will output a base64 encoded encrypted password which can be entered directly in the controller service configuration
via the **SourcePassword** and **Source Password Passphrase** properties (mode 2).

The above utility will also output a file on disk that contains the encrypted password. This can be used with mode 3 as described below:

Say, the file containing encrypted password is named: **/user/home/sec-pwd.enc.**

Put this file in HDFS and secure it by restricting permissions to be only read by **nifi** user.

Provide the file location and passphrase via the **Source Password File** and **Source Password Passphrase** properties in
the **StandardSqoopConnectionService** controller service configuration.

During the processor execution, password will be decrypted for modes 2 and 3, and used for connecting to the source system.
