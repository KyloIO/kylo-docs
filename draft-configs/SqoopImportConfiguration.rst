
==========================
Sqoop Import Configuration
==========================

DB Connection password and driver (format: nifi.service.<sqoop controller service name in NiFi>.<key>=<value>).

.. note:: Ensure that the driver jar is available in below two locations:

    - sqoop's lib directory (e.g. /usr/hdp/current/sqoop-client/lib/)

    - kylo's lib directory, and owned by 'kylo' user (/opt/kylo/kylo-services/lib)

..

Need explanation:

.. code-block:: properties

    nifi.service.sqoop-mysql-connection.password=hadoop
    nifi.service.sqoop-mysql-connection.database_driver_class_name=com.mysql.jdbc.Driver

..

Base HDFS Landing Directory
===========================

Describe:

.. code-block:: properties

    config.sqoop.hdfs.ingest.root=/sqoopimport

..

Uncommenet the settings below for Gmail to work:

.. code-block:: properties

    sla.mail.protocol=smtp
    sla.mail.host=smtp.google.com
    sla.mail.port=587
    sla.mail.smtpAuth=true
    sla.mail.starttls=true

..

Login Form Authentication
=========================

Describe:

.. code-block:: properties

    security.jwt.algorithm=HS256
    security.jwt.key=<insert-256-bit-secret-key-here>
    security.rememberme.alwaysRemember=false
    security.rememberme.cookieDomain=localhost
    security.rememberme.cookieName=remember-me
    security.rememberme.parameter=remember-me
    security.rememberme.tokenValiditySeconds=1209600
    security.rememberme.useSecureCookie=

..

If a job fails, tell your operations manager to query NiFi for bulletin
information in an attempt to capture more logs about the failure:

.. code-block:: properties

kylo.ops.mgr.query.nifi.bulletins=true

..
