
===============================
Developer Getting Started Guide
===============================

This guide should help you get your local development environment up and
running quickly. Development in an IDE is usually done in conjunction
with a Hortonworks sandbox in order to have a cluster with which to communicate.

Dependencies
------------

To run the Kylo project locally the following tools must be installed:

-  Maven 3

-  RPM (for install)

-  Java 1.8 [Either OracleJDK or OpenJDK] (or greater)

-  Hadoop 2.3+ Sandbox

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

Install and Configure the Hortonworks Sandbox
---------------------------------------------

Follow the guide below to install and configure the Hortonworks sandbox:

    :doc:`../developer-guides/HortonworksSandboxConfiguration`


Install the Kylo Applications
-----------------------------

To install the Kylo apps, NiFi, ActiveMQ, and Elasticsearch in the
VM you can use the deployment wizard instructions found here:

    :doc:`../installation/SetupWizardDeploymentGuide`

Instead of downloading the RPM file copy the RPM file from your project folder after running a Maven build.

.. code-block:: shell

    $ cd /opt
    $ cp /media/sf_kylo/install/target/rpm/kylo/RPMS/noarch/kylo-<version>.noarch.rpm.
    $ rpm -ivh kylo-<version>.rpm

..

Follow the rest of the deployment wizard steps to install the rest of
the tools in the VM.


.. important!:: You only need to install Elasticsearch, NiFi, and ActiveMQ once. During development you will frequently uninstall the Kylo RPM and re-install it for testing.


You now have a distribution of the stack running in your Hortonworks
sandbox.

Running in the IDE
------------------

You can run kylo-ui and thinkbig-services in the IDE. If you plan to
run the apps in the IDE, you should shut down the services in your
sandbox so you aren’t running two instances at the same time.

.. code-block:: shell

    $ service kylo-services stop
    $ service kylo-ui stop

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

3. Create the kylo-ui application run configuration.

   a. Open the Run configurations.

   b. Create a new Spring Boot run configuration.

   c. Give it a name like "KyloDataLakeUiApplication".

   d. Set "use classpath of module" property to "kylo-ui-app"
      module.

   e. Set the "Main Class" property to
      "com.thinkbiganalytics.KyloUiApplication".

4. Run both applications.

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

NPM should be used to configure and start your web development environment:

1. Install NPM in your development environment:

    * apt-get install npm (Debian / Ubuntu)
    * brew install npm (Mac)

2. Install the development packages:

.. code-block:: shell

    $ cd kylo/ui/ui-app
    $ npm install

3. Start Kylo and the development server:

.. code-block:: shell

    $ service kylo-services start
    $ service kylo-ui start
    $ npm run start

4. A new browser window will open showing the Kylo UI. Any changes you make will automatically refresh the page with the new changes.

Optionally, you can configure IntelliJ to build Typescript files instead of using NPM:

1. Install the JavaScript Support plugin.

2. Open Preferences and navigate to Languages & Frameworks > TypeScript.

3. Edit the TypeScript version and navigate to the node_modules/typescript/lib/ directory.

4. Check the box to Enable TypeScript Compiler then click OK.

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
