
==============
Access Control
==============

Overview
--------

A goal is to support authentication and authorization seamlessly
between the Kylo applications and the Hadoop cluster.

Authorization
-------------

Authorization within Kylo will use access control lists (ACL) to control
what actions users may perform and what data they may see.  The actions
that a user or group may perform, whether to invoke a function or access
data, are organized into a hierarchy, and privileges may be granted at
any level.

Users and Groups can be updated using the Users and Groups pages under the Admin section in Kylo.

.. note:: If groups are enabled for an authentication plugin module, then user groups will be provided by the external provider and may not be updatable from the Users page.

Default Users and Groups
~~~~~~~~~~~~~~~~~~~~~~~~

When Kylo is newly installed, it will be pre-configured with  a few default users
and groups defined; with varying permissions assigned to each group.  The default groups are:

   * Administrators
   * Operations
   * Designers
   * Analysts
   * Users

The default users and their assigned groups are:

   * Data Lake Administrator - Administrators, Users
   * Analyst - Analysts, Users
   * Designer - Designers, Users
   * Operator - Operations, Users

The initial installation will also
have the `auth-kylo` and `auth-file` included in the active profiles configured in
the conf/application.properties file of both the UI and Services.  With these profiles
active the authentication process will use both the built-in Kylo user store and a username/password
file to authenticate requests.  In this configuration, all activated login modules
will have to successfully authenticate a request before access will be granted.

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
