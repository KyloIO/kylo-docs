
============================
Spring Datasource Properties
============================

Other properties are in the services-app/application.properties.

Add extra profiles by setting "spring.profiles.active=<profile-name>"
property on command line. For example:

.. code-block:: properties

    -Dspring.profiles.active=hdp24,gmail,cdh

..

Extra profiles will add to this set of profiles and override properties given in this file:

.. code-block:: properties

    spring.profiles.include=native,nifi-v1,auth-kylo,auth-file

..

Spring Datasource properties for spring batch and the default data source:

.. note:: Cloudera default password for root access to mysql is "cloudera".

.. code-block:: properties

    spring.datasource.url=jdbc:mysql://localhost:3306/kylo
    spring.datasource.username=root
    spring.datasource.password=hadoop
    spring.datasource.maxActive=30
    spring.datasource.validationQuery=SELECT 1
    spring.datasource.testOnBorrow=true
    spring.datasource.driverClassName=org.mariadb.jdbc.Driver
    spring.jpa.database-platform=org.hibernate.dialect.MySQL5InnoDBDialect
    spring.jpa.open-in-view=true

..
