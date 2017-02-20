
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
file to authenticate requests.  In this configuration, the login modules activated
by these profiles would both have to successfully athenticate a request before access
would be granted.

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
