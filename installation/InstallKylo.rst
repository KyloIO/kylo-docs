==============
Install Kylo
==============
Choose one of the installation methods below to install Kylo.

RPM Install
-----------

Download the latest RPM (:doc:`../about/Downloads`) , and place it on the host Linux machine that you want to install Kylo services on.

.. note:: To use wget instead, right-click the download link and copy the url.

.. code-block:: shell

    $ rpm -ivh kylo-<version>.rpm

..


DEB Install
-----------

Download the latest DEB file (:doc:`../about/Downloads`) , and place it on the host Linux machine that you want to install Kylo services on.

.. note:: To use wget instead, right-click the download link and copy the url.

.. code-block:: shell

    $ dpkg -i kylo-<version>.deb

..

TAR File Install
-----------------
The TAR file method is useful when you need more control over where you can install Kylo and you need the flexibility to run Kylo as a different service user. In this example we will
assume you want to install Kylo in the /apps folder, run it as the "ad_kylo" user and "users" group

1. Download the latest TAR (:doc:`../about/Downloads`) , and place it on the host Linux machine that you want to install Kylo services on.

2. Untar the file
    .. code-block:: shell

        $ sudo mkdir /apps/kylo
        $ sudo tar -xvf /tmp/kylo-<version>-dependencies.tar.gz -C /apps/kylo

    ..

3. Run the post-install script

    .. code-block:: shell

        $ sudo /apps/kylo/setup/install/post-install.sh /apps/kylo ad_kylo users

    ..

4. Update kylo-services application.properties file

    .. code-block:: shell

        $ sudo vi /apps/kylo/kylo-services/conf/application.properties

        modeshape.index.dir=/apps/kylo/modeshape/modeshape-local-index

    ..

TAR File Upgrade
-----------------
If you are performing an upgrade please see the TAR file upgrade page for instructions

:doc:`../installation/TarFileUpgrade`