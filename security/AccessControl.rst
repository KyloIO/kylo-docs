
==============
Access Control
==============

Overview
--------

A goal is to support authentication and authorization seamlessly
between the Kylo applications and the Hadoop cluster.

Authorization
-------------

Authorization within Kylo uses access control lists (ACL) to control what users can do and see. 
A permission in Kylo is the granting to a user or group the right to perform some action, such as see the description of a template, 
create and edit a category, enable/disable a feed, etc.  
These actions are organized into a hierarchies and permission to perform an action may be granted at any level in that hierarchy.

Authorization in Kylo is divided into two layers: service-level (Kylo-wide) permissions and (when enabled) entity-level permissions.
Access to these functions can often be controlled at both the service-level and entity-level.

Users and Groups can be updated using the Users and Groups pages under the Admin section in Kylo.

.. note:: If groups are enabled only by an external authentication source (such as LDAP) via a plugin module then user groups may not be visible in the Users page.

Logging
~~~~~~~

Kylo can be configured to log every access control check made by each user.  This is turned off by default.    The log message format can be specified with various standard fields that will substitued in the message based on the context
during the access control check.  The valid fields are: 

+----------+---------------------------------------------------------------------------------------+
| Field    | Description                                                                           |
+==========+=======================================================================================+
| `PERM`   | The permission being checked                                                          |
+----------+---------------------------------------------------------------------------------------+
| `ENTITY` | The entity against which the permission is being checked                              |
+----------+---------------------------------------------------------------------------------------+
| `RESULT` | The result of the permission check (ex: "success" or "failure" with an error message) |
+----------+---------------------------------------------------------------------------------------+
| `USER`   | The user for which the permission is being checked                                    |
+----------+---------------------------------------------------------------------------------------+
| `GROUPS` | The groups of the user                                                                |
+----------+---------------------------------------------------------------------------------------+

To enable access check logging you can configure the properties in the table below for the kylo-services properties file:

+-----------------------------------+----------+--------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| Properties                        | Required | Default                                                                                    | Description                                                                                                          |
+===================================+==========+============================================================================================+======================================================================================================================+
| security.log.access               | No       | ``false``                                                                                  | Activates logging of every access control check                                                                      |
+-----------------------------------+----------+--------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| security.log.access.level         | No       | ``DEBUG``                                                                                  | The log level used to log the access control check                                                                   |
+-----------------------------------+----------+--------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| security.log.access.format        | No       | ``Permission check entity: {ENTITY}, permission: {PERM}, result: {RESULT} - user: {USER}`` | The format of the log message with embedded fields to be substitued with the access check details                    |
+-----------------------------------+----------+--------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| security.log.access.ignore.users  | No       | ``service``                                                                                | A comma-separated list of users to ignore when logging; can be useful for service accounts which might flood the log |
+-----------------------------------+----------+--------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| security.log.access.ignore.groups | No       |                                                                                            | A comma-separated list of groups to ignore when logging                                                              |
+-----------------------------------+----------+--------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+


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

Service-level access controla what functions are permitted kylo-wide.  Access is controlled
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

The above actions are hierarchical, in that being permitted a lower level action (such as Edit Feeds) implies being granted the higher-level actions (Access Feeds & Access Feed Support).

.. note:: Although permissions to perform the above actions are currently granted to groups, a future Kylo version may switch to a role-based mechanism similar to the entity-level access control (see below.)

Entity-Level Authorization
--------------------------

Entity-level authorization is an additional, optional form of access control that applies to individual entities: templates, feeds, categories, etc.  Entity-level access control is similar to service-level 
in that it involves granting permissions to perform a hierarchical set of actions.  These actions, though, would apply only to an individual entity.  

Entity-level access control is turned off by default.  To activate this feature you must set this property to true in ``kylo-services/conf/application.properties`` and then restart Kylo:

.. code-block:: properties

   security.entity.access.controlled=true

..

.. warning:: Turning on entity-level access control is a one-way operation; you cannot reset the above property back to false to deactivate this feature

Roles
~~~~~

Entity-level access control differs from service-level access control in that permissions are not granted to individual groups, rather they are granted to one or more **roles**.  
A role is a named, pre-configured set of granted permissions that may be applied to a group or individual user for a particular entity instance.
Roles are defined and associated with each kind of entity and may be granted permission to perform any of the actions defined for that entity type.  
The actual members (users or groups) of a role are associated at the entity-level, though, and grant permissions to perform actions on that entity only.

For instance, there might be the roles *Editor*, *Admin*, and *Read-Only* defined that grant varying sets of permissions for feeds.  
Adding a user, or any group that user belongs to, as a member of the *Editors* role of a specific feed will permit that user to make changes to it.  
A particular user might be a member of the *Editor* role for one feed, an *Admin* member of another feed, but only a *Read-Only* member of a third feed.

~~~~~~~~~~~~~
Default Roles
~~~~~~~~~~~~~

Kylo comes with a set of default roles for each kind of entity as described below.

.. note:: As of Kylo verion 0.8.1, entity roles and their granted permissions are fixed.  Future versions of Kylo will allow for creation and management of custom roles and assigned permissions.


==========  ===
 Template Roles               
===============
 Editor     Allows a user to edit and export a template
 Admin      All capabilities defined in the 'Editor' role along with the ability to change the permissions
 Read-Only  Allows a user to view, but not modify, the template
==========  ===

=============  ===
 Category Roles               
==================
 Editor        Allows a user to edit and delete feeds using this category
 Admin         All capabilities defined in the 'Editor' role along with the ability to change the permissions
 Read-Only     Allows a user to view the category
 Feed Creator  Allows a user to create a new feed using this category
=============  ===

==========  ===
 Feed Roles               
===============
 Editor     Allows a user to edit, enable/disable, delete, export, and access job operations of the feed
 Admin      All capabilities defined in the 'Editor' role along with the ability to change the permissions
 Read-Only  Allows a user to view the feed and access job operations
==========  ===

==========  ===
 Data Source Roles
===============
 Editor     Allows a user to edit and delete the datasource
 Admin      All capabilities defined in the 'Editor' role along with the ability to change the permissions
 Read-Only  Allows a user to view the datasource
==========  ===

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Category-Wide Feed Role Memberships
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo supports adding users and groups to feed roles at the category level that apply to all feeds under that category.
This is useful when you wish to organize your feed access control around feeds grouped by category and apply all feed
access control changes in one place.  Assigning feed role memberships at the category level does not prevent adding 
additional memberships on each individual feed however.  The members of the roles of a particular feed are the union
of all memberships assigned at the individual feed level and at the level of the category containing that feed.

In Kylo feed role memberships are managed by editing them in the category details page just below where the category
role memberships are managed.

Why Two Levels of Access Control?
---------------------------------

Kylo support two levels acces control because not all installations require the fine-grained control of entity-level authorization.
Service-level authorization is generally easier to manage if your security requirements are not very selective or stringent.  If 
you only need the ability to restrict some Kylo actions to certain select groups of users then service-level might be sufficient.

If your installation deals with sensitive information, and you need to be very selective of what data certain users and groups can see and 
manipulate, then you should use entity-level authorization to provide tight controls over that data.

Having two security schemes can pose management challenges as there is a bit of an overlap between the service-level and entity-level
permissions, and both levels of access control must be satisfied for a user's action to be successful.  If you choose to use entity-level
control then it may be helpful to loosen up the service-level access a bit more where the entity and service permissions are redundant.  To help
determine what permissions are needed to perform common Kylo activities, the next section describes both kinds of access requirements
depending upon what actions are attempted in Kylo.

Roles and Permissions Required for Common Activities
----------------------------------------------------

To help understand and manage permissions required by users when using Kylo, the following tables show:

   #. Common actions in Kylo
   #. The default entity-level roles that permit those actions
   #. Additional service-level permissions reqired to perform those actions

Template Actions
~~~~~~~~~~~~~~~~

  ========================================================================  ======================================== =================================
   Action                                                                   Roles Permitted                          Service-level Permissions
  ========================================================================  ======================================== =================================
    View template and its summary                                           Editor, Admin, Read-Only                 Access Templates
    Edit template and its details                                           Editor, Admin                            Edit Templates
    Delete template                                                         Editor, Admin                            Edit Templates
    Export template                                                         Editor, Admin                            Export Templates
    Grant permissions on template to users/groups                           Admin                                    Edit Templates
    Import template (new)                                                   N/A                                      Import Templates
    Import template (existing)                                              Editor, Admin                            Import Templates, Edit Templates
    Enable template                                                         N/A                                      Admin Templates
    Disable template                                                        N/A                                      Admin Templates
  ========================================================================  ======================================== =================================


Category Actions
~~~~~~~~~~~~~~~~

  ========================================================================  ======================================== =================================
   Action                                                                   Roles Permitted                          Service-level Permissions
  ========================================================================  ======================================== =================================
    View category and its summary                                           Editor, Admin, Feed Creator, Read-Only   Access Categories
    Edit category summary                                                   Editor, Admin                            Edit Categories
    View category and its details                                           Editor, Admin, Feed Creator              Access Categories
    Edit category details                                                   Editor, Admin                            Edit Categories
    Edit set user fields                                                    Editor, Admin                            Admin Categories
    Delete category                                                         Editor, Admin                            Edit Categories
    Create feeds under category                                             Feed Creator                             Edit Categories
    Grant permissions on category to users/groups                           Admin                                    Edit Categories
  ========================================================================  ======================================== =================================

Feed Actions
~~~~~~~~~~~~

  ========================================================================  ======================================== =================================
   Action                                                                   Roles Permitted                          Service-level Permissions
  ========================================================================  ======================================== =================================
    View feed and its details                                               Editor, Admin, Read-Only                 Access Feeds
    Edit feed summary                                                       Editor, Admin                            Edit Feeds
    Edit feed details                                                       Editor, Admin                            Edit Feeds
    Edit feed user fields                                                   Editor, Admin                            Admin Feeds
    Delete feed                                                             Editor, Admin                            Admin Feeds
    Enable feed                                                             Editor, Admin                            Edit Feeds
    Disable feed                                                            Editor, Admin                            Edit Feeds
    Export feed                                                             Editor, Admin                            Export Feeds
    Import feed (new)                                                       N/A                                      Import Feeds
    Import feed (existing)                                                  Editor, Admin                            Import Feeds
    View operational history of feed                                        Editor, Admin, Read-Only                 Access Feeds
    Grant permissions on feed to users/groups                               Admin                                    Edit Feeds
  ========================================================================  ======================================== =================================

Data Source Actions
~~~~~~~~~~~~~~~~~~~

  ========================================================================  ======================================== =================================
   Action                                                                   Roles Permitted                          Service-level Permissions
  ========================================================================  ======================================== =================================
    View data source summary and use in data transformations                Editor, Admin, Read-Only                 Access Data Sources
    Edit data source summary                                                Editor, Admin                            Edit Data Sources
    View data source and its details                                        Editor, Admin                            Access Data Sources
    View data source details, including sensitive information               Editor, Admin                            Admin Data Sources
    Edit data source details                                                Editor, Admin                            Edit Data Sources
    Delete data source                                                      Editor, Admin                            Edit Data Sources
    Grant permissions on data source to users/groups                        Admin                                    Edit Data Sources
  ========================================================================  ======================================== =================================


