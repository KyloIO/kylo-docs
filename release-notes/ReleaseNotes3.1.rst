Release 0.3.1 (Aug. 17, 2016)
==============================

Highlights
----------

-  Fixes a few issues found in version 0.3.0.

-  Fixes the download link to NiFi for generating an offline tar file.

-  Compatibility with MySQL 5.7.

-  Installs a stored procedure required for deleting feeds.

-  PC-393 Automatically reconnects to the Hive metastore.

-  PC-396 Script to update NiFi plugins and required JARs.

.. note::

    A bug was introduced with installation of NiFi from the setup wizard (Fixed in the 0.4.0-SNAPSHOT). If installing a new copy of PCNG, make the following change:

    Edit /opt/kylo/setup/nifi/install-kylo-components.sh and change "./create-symbolic-links.sh" to "$NIFI_SETUP_DIR/create-symbolic-links.sh"

..
