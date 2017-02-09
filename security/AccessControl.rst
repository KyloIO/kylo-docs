
=============================
Security Configuration
=============================

Overview
========

A goal is to support authentication and authorization seamlessly
between the Kylo applications and the Hadoop cluster.

Authentication
--------------

Kylo supports a pluggable authentication architecture that allows
customers to integrate their existing infrastructure when authenticating
a user.  The pluggability is built around  JAAS LoginModules.  Kylo
supplies LoginModule implementations fort the most common authentication
scenarios, though customers will be able to provide their own modules to
replace or augment the modules provided by Kylo.

JAAS Authentication
~~~~~~~~~~~~~~~~~~~

The JAAS authentication framework provides a means of configuring the
multiple modules that are engaged in an authentication attempt.

Authorization
=============

Authorization within Kylo will use access control lists (ACL) to control
what actions users may perform and what data they may see.  The actions
that a user or group may perform, whether to invoke a function or access
data, are organized into a hierarchy, and privileges may be granted at
any level.

Service-Level Authorization
---------------------------

At the service (functional) level, the actions available to be granted
to a user or group are organized as follows:

   -  Feed Support

         -  Access Feeds

         -  Edit Feeds

         -  Import Feeds

         -  Export Feeds

         -  Administer Feeds

   -  Access Categories

         -  Edit Categories

         -  Administer Categories

         -  Access Templates

         -  Edit Templates

         -  Administer Templates

   -  Access SLAs

         -  Administer SLA's

   -  Access Users/Groups

         -  Access Users

         -  Administer Users

         -  Access Groups

         -  Administer Groups

   -  Wrangle Data

   -  Search

   -  Administer Authorizations