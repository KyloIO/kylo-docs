V0.3.2 RELEASE (SEPT. 19, 2016)
===============================

Highlights
----------

-  Fixes a few issues found in version 0.3.1.

-  Removed thinkbig, nifi, and activemq user creation from RPM install
   and installation scripts. Creating those users are now a manual
   process to support clients who use their own user management tools.

-  Kerberos support for the UI features (data wrangling, hive tables,
   feed profiling page). Data wrangling uses the thinkbig user keytab
   and the rest uses the hive user keytab.

-  Fixed bug introduced in 0.3.1 where the nifi symbolic link creation
   is broken during a new installation.

-  Added support for installation Elasticsearch on SUSE.

.. note::

    The activemq download URL was changed. To manually update the installation script edit: /opt/thinkbig/setup/activemq/install-activemq.sh and change the URL on line 25 to be https://archive.apache.org/dist/activemq/5.13.3/apache-activemq-5.13.3-bin.tar.gz

..
