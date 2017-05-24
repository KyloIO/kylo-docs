
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
any level in that hierarchy.

Authorization in Kylo is divided into two layers: service-level (fuctional) permissions and entity-level permissions.
A permission in Kylo is granting to a user or group right to perform some action, such as see the description of a template, 
create and edit a category, enable/disable a feed, etc.  Access to these functions can often be controlled at both 
the service-level and entity-level.

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

Service-level access control what functions are permitted kylo-wide.  Access is controlled
by granting permissions to groups to perform a set of actions.  A logged in user would
then be authorized to perform any actions permitted to the groups to which the user is a member.

At the service-level, the heirarchical actions available for granting
to groups are organized as follows:

   - **Access Kylo Metadata** - Allows the ability to view and query directly the data in the Kylo metadata store, including extensible types

      - **Administer Kylo Metadata** - Allows the ability to directly manage the data in the Kylo metadata store (edit raw metadata, create/update/delete extensible types, update feed status events)

   - **Access Feed Support** - Allows access to feeds and feed-related functions

      - **Access Feeds** - Allows access to feeds and their metadata

         - **Edit Feeds** - Allows creating, updating, enabling and disabling feeds

         - **Import Feeds** - Allows importing of previously exported feeds (.zip files)

         - **Export Feeds** - Allows exporting feeds definitions (.zip files)

         - **Administer Feeds** - Allows deleting feeds and editing feed metadata

      - **Access Tables** - Allows listing and querying Hive tables

      - **Access Visual Query** - Allows access to visual query data wrangler

      - **Access Categories** - Allows access to categories and their metadata

         - **Edit Categories** - Allows creating, updating and deleting categories

         - **Administer Categories** - Allows updating category metadata

      - **Access Templates** - Allows access to feed templates

         - **Edit Templates** - Allows creating, updating, deleting and sequencing feed templates

         - **Import Templates** - Allows importing of previously exported templates (.xml and .zip files)

         - **Export Templates** - Allows exporting template definitions (.zip files)

         - **Administer Templates** - Allows enabling and disabling feed templates

      - **Access Data Sources** - Allows (a) access to data sources (b) viewing tables and schemas from a data source (c) using a data source in transformation feed

         - **Edit Data Sources** - Allows creating and editing data sources

         - **Administer Data Sources** - Allows getting data source details with sensitive info

      - **Access Service Level Agreements** - Allows access to service level agreements

         - **Edit Service Level Agreements** - Allows creating and editing service level agreements

      - **Access Global Search** - Allows access to search all indexed columns

   - **Access Users and Groups Support** - Allows access to user and group-related functions

      - **Access Users** - Allows the ability to view existing users

         - **Administer Users** - Allows the ability to create, edit and delete users

      - **Access Groups** - Allows the ability to view existing groups

         - **Administer Groups** - Allows the ability to create, edit and delete groups

      - **Access Operational Information** - Allows access to operational information like active feeds, execution history, job and feed stats, health status, etc.

         - **Administer Operations** - Allows administration of operations, such as creating/updating alerts, restart/stop/abandon/fail jobs, start/pause scheduler, etc.

      - **Access Encryption Services** - Allows the ability to encrypt and decrypt values

The above actions hierarchical in that being permitted a lower level action (such as Edit Feeds) implies being granted the higher-level actions (Access Feeds & Access Feed Support).

.. note:: Although permissions to perform the above actions are currently granted to groups, a future Kylo version may switch to a role-based mechanism similar to the entity-level access control (see below.)

Entity-Level Authorization
--------------------------

Entity-level authorization is an additional, optional form of access control that applies to individual entities: templates, feeds, categories, etc.  Entity-level access control is similar to service-level 
in that it involves granting permissions to perform a hierarchical set of actions.  These actions, though, would apply only to an individual entity.  

This level of access control differs from the service-level access control 
in that permissions are not granted to individual groups, rather they are granted to one or more roles defined for a given type of entity, and users and groups are added as members of these roles in relation to 
an entity instance.  For instance, and "Editor" role is defined for feeds that is granted the rights to view and modify a feed details, to enable and disable the feeds, and export a feeds to a file.  A user who is
added as a member of the Editor role of a particular feed would be able to perform all of those action on that feed.

The actions that may be permitted for a particular type of entity are defined below.

Template
~~~~~~~~

   - **Access Template** - Allows the ability to view the template and see basic summary information about it
   
      - **Edit Template** - Allows editing the full details about the template
      
      - **Delete** - Allows deleting the template
      
      - **Export** - Allows exporting the template
      
      - **Create Template** - Allows creating feeds under this template
      
      - **Change Permissions** - Allows editing of the permissions that grant access to the template

Category
~~~~~~~~

Feed
~~~~

Data Source
~~~~~~~~~~~




Why To Levels of Access Control?
--------------------------------


