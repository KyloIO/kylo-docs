
===============================
Developer Getting Started Guide
===============================

This guide should help you get your local development environment up and
running quickly. Development in an IDE is usually done in conjunction
with a Kylo sandbox in order to have a cluster with which to communicate.

Dependencies
------------

To run the Kylo project locally the following tools must be installed:

-  Maven 3

-  RPM (for install)

-  Java 1.8 (or greater)

-  Kylo 0.9+ Sandbox

-  Virtual Box or other virtual machine manager

The assumption is that you are installing on a Mac or Linux box. You can
do most activities below on a Windows box, except to perform a Maven
build with the RPM install. At some point, we could add a Maven profile
to allow you to build but skip the final RPM step.

Install Maven 3
---------------

This project requires Maven to execute a build. Use this link to
download to the Maven installation file:

.. note:: For instructions on installing Apache Maven see the `Installing Apache Maven <https://maven.apache.org/install.html>`__ docs at the Apache Maven project site.

Optional - Add Java 8 to Bash Profile
-------------------------------------

To build from the command line, you need to add Java 8 and Maven to your
$PATH variable.

Edit ~/.bashrc and add the following:

.. code-block:: shell

    export MVN_HOME=/Users/<HomeFolderName>/tools/apache-maven-3.3.3
    export MAVEN_OPTS="-Xms256m -Xmx512m"
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home
    export PATH=$JAVA_HOME/bin:$MVN_HOME/bin:$PATH

..

To test, run the following:

.. code-block:: shell

    $ mvn -v
    $ java -version

..

Install Virtual Box
-------------------

Use this link to download and install the DMG file to install Virtual
Box:


    `*https://www.virtualbox.org/wiki/Downloads* <https://www.virtualbox.org/wiki/Downloads>`__


Install the RPM Tool on your Mac
--------------------------------

The RPM library is required for building the RPM file as part of the
Maven build. This can be done using Home Brew or Mac Ports.

.. code-block:: shell

    $ brew install rpm

Clone Project from Github
-------------------------

Clone the Kylo project to your host. You can do this in your IDE or from
the command line.

1. From the command line,run the "git clone" command.

   a. cd to the directory you want to install the project to.

   b. Type "git clone `*https://github.com/kyloio/kylo.git"* <https://github.com/kyloio/kylo.git>`__.

2. Import from your IDE using the
   "`*https://github.com/kyloio/kylo.git* <https://github.com/kyloio/kylo.git>`__"
   URL.

Import the Project into your IDE
--------------------------------

Import the project into your favorite IDE as a Maven project.

.. note:: Configure the project to use Java 8.

Perform a Maven Build
---------------------

Perform a Maven build to download all of the artifacts and verify that
everything is setup correctly.

.. code-block:: shell

    $ mvn clean install

..

.. note:: If you receive an OutOfMemoryError try increasing the Java heap space:
    ``$ export MAVEN_OPTS="-Xms2g -Xmx4g"``

.. tip:: For faster Maven builds you can run in offline mode and skip unit testing:
    ``$ mvn clean install -o -DskipTests``
..

Install and Configure the Kylo Sandbox
--------------------------------------

1. `Download and install Kylo sandbox <https://kylo.io/quickstart.html>`__. Make sure 10GB RAM is assigned to the VM. The sandbox comes bundled with Kylo apps, NiFi, ActiveMQ, Elasticsearch and MySQL.

2. Start the VM from VirtualBox.

3. Go to http://localhost:8400. Congratulations! Kylo is up and running. Login with credentials dladmin/thinkbig.


Running in the IDE
------------------

You can run kylo-ui and kylo-services in the IDE. If you plan to
run the apps in the IDE, you should shut down the services in your
sandbox so you aren’t running two instances at the same time.

.. code-block:: shell

    $ service kylo-services stop
    $ service kylo-ui stop
    $ service kylo-services status
    $ service kylo-ui status

The applications are configured using Spring Boot.

IntelliJ Configuration
----------------------

1. Install the Spring Boot plugin.

2. Create the kylo-services application run configuration.

   a. Open the Run configurations.

   b. Create a new Spring Boot run configuration.

   c. Give it a name like "KyloServerApplication".

   d. Set "use classpath of module" property to "kylo-service-app"
      module.

   e. Set the "Main Class" property to
      "com.thinkbiganalytics.server.KyloServerApplication".

   f. Add "dev" to list of Active Profiles.

   g. Add a file named "application-dev.properties" to kylo-service-app at kylo/services/service-app/src/main/resources location. Populate properties to override from the standard "application.properties". Some key properties are:

    .. code-block:: shell

        security.entity.access.controlled=<value>
        spring.datasource.username=<value>
        spring.datasource.password=<value>

        hive.datasource.username=<value>
        hive.metastore.datasource.username=<value>
        hive.metastore.datasource.password=<value>

        modeshape.datasource.username=${spring.datasource.username}
        modeshape.datasource.password=${spring.datasource.password}

        nifi.service.kylo_mysql.database_user=<value>
        nifi.service.kylo_mysql.password=<value>

        nifi.service.kylo_metadata_service.rest_client_password=<value>

        modeshape.index.dir=<value>

   h. The Kylo Spark Shell currently does not run from an IDE. When you run the server you will encounter error stating: "Unable to determine Spark version."

   i. If you won't be uploading sample files or using Data Transformation or Visual Query, then you can ignore that error and continue development.

   j. If you want to have spark shell started you need to manually run it in your sandbox by running command:

    .. code-block:: shell

        $ /opt/kylo/kylo-services/bin/run-kylo-spark-shell.sh

   k. `Enable port forwarding for port 8450 <https://www.virtualbox.org/manual/ch06.html>`__ in VirtualBox.

   l. Add the following lines to spark.properties in your IDE:

     .. code-block:: shell

         spark.shell.server.host=localhost
         spark.shell.server.port=8450

3. Create the kylo-ui application run configuration.

   a. Open the Run configurations.

   b. Create a new Spring Boot run configuration.

   c. Give it a name like "KyloDataLakeUiApplication".

   d. Set "use classpath of module" property to "kylo-ui-app"
      module.

   e. Set the "Main Class" property to
      "com.thinkbiganalytics.KyloUiApplication".
   
   f. Add "native,auth-kylo,dev" to list of Active Profiles.

   g. Add a file named "application-dev.properties" to kylo-ui at kylo/ui/ui-app/src/main/resources location. Add following properties:

    .. code-block:: shell

        security.auth.file.users=file:///opt/kylo/users.properties
        security.auth.file.groups=file:///opt/kylo/groups.properties

4. Create users.properties in /opt/kylo and add following content:
   
    .. code-block:: shell

        dladmin=thinkbig
        analyst=analyst
        designer=designer
        operator=operator

5. Create empty file groups.properties under /opt/kylo. Add permissions to both files created above: chmod 777

6. Go to Maven Projects view in IntelliJ and under Profiles check nifi.version.override and prod.

7. Run both applications.

Eclipse Configuration
---------------------

1. Open Eclipse.

2. Import the Kylo project.

   a. File - Import

   b. Choose "maven" and "Existing Maven Projects" then choose next

   c. Choose the Kylo root folder. You should see all
      Maven modules checked

   d. Click finish

   e. Import takes a bit - if you get an error about scala plugin, just click
      finish to ignore it.

3. Find and open the
   "com.thinkbiganalytics.server.KyloServerApplication" class.

4. Right click and choose to debug as a Java application.

5. Repeat for "com.thinkbiganalytics.KyloUiApplication".

    OPTIONAL: Install the spring tools suite and run as a spring boot
    option

.. note:: Consult the Spring Boot documentation for  `Running Your Application <http://docs.spring.io/spring-boot/docs/current/reference/html/using-boot-running-your-application.html>`__ for additional ways to run with spring boot.

Web Development
---------------

Most of the Kylo UI depends on |AngularJsLink| and |AngularJsMaterialLink| but a few parts have been upgraded to |Angular2Link| and |CovalentLink|. New plugins should be written in Typescript and use Angular 2 for future compatibility.

Start your web development environment:

1. Install the development packages and local NPM:

.. code-block:: shell

    $ cd kylo/ui/ui-app
    $ mvn clean package

2. Start Kylo and the development server:

.. code-block:: shell

    $ service kylo-services start
    $ service kylo-ui start
    $ ./npm start

3. A new browser window will open showing the Kylo UI. Any changes you make will automatically refresh the page with the new changes.


Angular Material Notes
----------------------

There are a few notes worth mentioning about using AngularJS Material:

1. Do not use ``layout-row`` and ``layout-wrap`` with percents. It `has been broken on Safari for a while now <https://github.com/angular/material/issues/10516>`__ with current plan to be fixed only in Angular 4.x.

2. Do not refer to Angular model in plain HTML ``style`` element, it is broken on IE. Instead use Angular ``ng-style`` element which works on all browsers like so ``ng-style="{'fill':controller.fillColor}"``

3. Do not use ``flex`` element where you don't have to. Browsers will usually flex elements correctly. This is to minimise the occurrence of ``flex`` being required by Safari while breaking layout on IE.



.. |AngularJsLink| raw:: html

    <a href="https://code.angularjs.org/1.6.2/docs/guide" target="_blank">AngularJS</a>

.. |AngularJsMaterialLink| raw:: html

    <a href="https://material.angularjs.org/1.1.3/" target="_blank">AngularJS Material</a>

.. |Angular2Link| raw:: html

    <a href="https://angular.io/docs" target="_blank">Angular 2</a>

.. |CovalentLink| raw:: html

    <a href="https://teradata.github.io/covalent/" target="_blank">Covalent</a>
