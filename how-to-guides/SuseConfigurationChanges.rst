
==========================
SUSE Configuration Changes
==========================

Overview
========

The deployment guide currently addresses installation in a Redhat based
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

RPM installation isn’t supported on SUSE. To work around this issue we created a custom init.d service script and wrote up a manual procedure to install Elasticsearch on a single node.

  `*https://www.elastic.co/support/matrix* <https://www.elastic.co/support/matrix>`__

We have created a service script to make it easy to start and stop
Elasticsearch, as well as leverage chkconfig to automatically start
Elasticsearch when booting up the machine. Below are the instructions on
how we installed Elasticsearch on a SUSE box.

1.  Make sure Elasticsearch service user/group exists

2.  mkdir /opt/elasticsearch

3.  cd /opt/elasticsearch

4.  mv /tmp/elasticsearch-2.3.5.tar.gz

5.  tar -xvf elasticsearch-2.3.5.tar.gz

6.  rm elasticsearch-2.3.5.tar.gz

7.  ln -s elasticsearch-2.3.5 current

8.  cp elasticsearch.yml elasticsearch.yml.orig

9.  Modify elasticsearch.yml if you want to change the cluster name. Our
    copy that is installed the wizard scripts is located in
    /opt/kylo/setup/elasticsearch

10. chown -R elasticsearch:elasticsearch /opt/elasticsearch/

11. vi /etc/init.d/elasticsearch - paste in the values from
    /opt/kylo/setup/elasticsearch/init.d/sles/elasticsearch

12. Uncomment and set the java home on line 44 of the init.d file in
    step #10

13. chmod 755 /etc/init.d/elasticsearch

14. chkconfig elasticsearch on

15. service elasticsearch start
