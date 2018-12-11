==============
Encryption Key
==============

Kylo uses a encryption key file (`/opt/kylo/encrypt.key`) to both encrypt credentials stored in its metadata store,
and to allow properties in Kylo's configuration files to be encrypted.  This same key is shared with NiFi (`/opt/nifi/ext-config/encrypt.key`) so that it can supply that key to the Spark jobs that
it launches; allowing those jobs can decrypt the credentials needed to access their data sources.

The Kylo key file is usually generated automatically during installation.  This same key is automatically configured for NiFi during installation when using the :doc:`../installation/SetupWizardDeploymentGuide`.  
There are also manual configuration steps to provide this key to NiFi as described in :doc:`../installation/ManualDeploymentGuide`.

===================================
Encrypting Configuration Properties
===================================

By default, a new Kylo installation does not have any of its
configuration properties encrypted. Once you have started Kylo for the
first time, the easiest way to derive encrypted versions of property
values is to post values to the Kylo services/encrypt endpoint to have
it generate an encrypted form for you. You could then paste the
encrypted value back into your properties file and mark it as encrypted
by prepending the values with {cipher}. For instance, if you wanted to
encrypt the Hive datasource password specified in
application.properties (assuming the password is “mypassword”), you can
get its encrypted form using the curl command like this:

.. code-block:: shell

    $ curl -u dladmin:thinkbig -H "Content-Type: text/plain; charset=UTF-8" localhost:8400/proxy/v1/feedmgr/util/encrypt –d mypassword
    29fcf1534a84700c68f5c79520ecf8911379c8b5ef4427a696d845cc809b4af0

..

You then copy that value and replace the clear text password
string in the properties file with the encrypted value:

.. code-block:: shell

    hive.datasource.password={cipher}29fcf1534a84700c68f5c79520ecf8911379c8b5ef4427a696d845cc809b4af0

..

The benefit of this approach is that you will be getting a value that is
guaranteed to work with the encryption settings of the server where that
configuration value is being used. Once you have replaced all properties
you wish to have encrypted in the properties files, you can restart the Kylo
services to use them.

Encrypting Configuration Property Values with Spring CLI
--------------------------------------------------------

1. Install the Spring CLI client Mac example. In this example we will use Home Brew to install it on a Mac:

- Install JCE: http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html

- Install Homebrew: http://brew.sh/

- Install Spring Boot CLI:

.. code-block:: shell

    $ brew tap pivotal/tap
    $ brew install springboot
    $ spring install org.springframework.cloud:spring-cloud-cli:1.0.0.BUILD-SNAPSHOT

..


2. Install the Spring CLI client Linux example:

.. code-block:: shell

    $ wget http://repo.spring.io/release/org/springframework/boot/spring-boot-cli/1.5.3.RELEASE/spring-boot-cli-1.5.3.RELEASE-bin.tar.gz
    $ sudo mkdir /apps/spring-boot
    $ sudo tar -xvf /tmp/spring-boot-cli-1.5.3.RELEASE-bin.tar.gz -C /apps/spring-boot/

    $ sudo vi  /etc/profile
    export SPRING_HOME=/apps/spring-boot/spring-1.5.3.RELEASE
    export JAVA_HOME=/usr/lib/jvm/jre-1.8.0
    export PATH=$SPRING_HOME/bin:$JAVA_HOME/bin:$PATH


    $ source /etc/profile

    $ sudo chown -R centos:centos /apps/spring-boot/
    $ spring install org.springframework.cloud:spring-cloud-cli:1.3.1.RELEASE

..


3. Copy the /apps/kylo/encrypt.key file to the computer with the Spring CLI client (if different)
4. Encrypt the values. Note: Make sure to use single quotes around the password. If not special characters like $ will cause issues:

.. code-block:: shell

    $ spring encrypt 'Pretend$Password' --key ./encrypt.key
    dda0202d65ac03d250b1bc77afcf1097954wee08fc118b0f804a66xx286f61ae

..

5. Decrypt values

.. code-block:: shell

    $ spring decrypt dda0202d65ac03d250b1bc77afcf1097954wee08fc118b0f804a66xx286f61ae --key encrypt.key

..