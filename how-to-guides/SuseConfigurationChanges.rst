
==========================
SUSE Configuration Changes
==========================

Overview
========

The deployment guide currently addresses installation in a Red Hat Enterprise Linux (RHEL or variant, CentOS, Fedora) based
environment. There are a couple of issues installing Elasticsearch and
ActiveMQ on SUSE. Below are some instructions on how to install these
two on SUSE.

ActiveMQ
========

When installing ActiveMQ you might see the following error.

.. error:: Configuration variable JAVA_HOME or JAVACMD is not defined correctly.

    (JAVA_HOME='', JAVACMD='java')

..

For some reason ActiveMQ isn’t properly using the system Java that is
set. To fix this issue I had to set the JAVA_HOME directly.

1. Edit /etc/default/activemq and set JAVA_HOME at the bottom

2. Restart ActiveMQ (service activemq restart)

Elasticsearch
=============

The setup wizard currently doesnt autodetect that its on a SUSE. Therefore you should skip the Elasticsearch installation step and download/install the DEB distribution manually.
