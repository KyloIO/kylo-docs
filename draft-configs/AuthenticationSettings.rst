
=======================
Authentication Settings
=======================

Currently available athentication/authorization Spring profiles:

    **auth-kylo** - Users are authenticated if they exist in the Kylo user store and any groups associated with the user are retrieved for access control.

      This profile is usually used in conjunction with other auth profiles (for example: auth-ldap, auth-ad).

    **auth-ldap** - Authenticates users using LDAP, and optionally loads any associated user groups.

    **auth-ad** - Authenticates users using Active Directory and loads any associated user groups.

    **auth-simple** - Uses authenticationService.username and authenticationService.password for authentication (development only)

    **auth-file** - Uses users.properties and roles.properties files for authentication and role assignment (generally for development only)

Auth-file
=========

If this profile is active, then these optional properties may be used:

.. code-block:: properties

    security.auth.file.users=file:///opt/kylo/users.properties
    security.auth.file.groups=file:///opt/kylo/groups.properties

..

Auth-simple
===========

If this profile is active, these authenticationService properties are used:

.. code-block:: properties

    authenticationService.username=dladmin
    authenticationService.password={cipher}52fd39e4e4f7d0f6a91989efbfa870f1a543550401e6ab0b17f3059c1ada9b5f
    authenticationService.password=thinkbig

..

Auth-ldap
=========

If this profile is active, then these properties should uncommented and updated appropriately:

.. code-block:: properties

    security.auth.ldap.server.uri=ldap://localhost:52389/dc=example,dc=com
    security.auth.ldap.server.authDn=uid=dladmin,ou=people,dc=example,dc=com
    security.auth.ldap.server.password=thinkbig

..

.. note:: User DN patterns are separated by '|'

.. code-block:: properties

    security.auth.ldap.authenticator.userDnPatterns=uid={0},ou=people
    security.auth.ldap.user.enableGroups=true
    security.auth.ldap.user.groupNameAttr=ou
    security.auth.ldap.user.groupsBase=ou=groups

..

Auth-ad
=======

If this profile is active, then these properties should uncommented and updated appropriately:

.. code-block:: properties

    security.auth.ad.server.uri=ldap://example.com/
    security.auth.ad.server.domain=test.example.com
    security.auth.ad.user.enableGroups=true

..

.. note:: Group attribute patterns are separated by '|'.

.. code-block:: properties

    security.auth.ad.user.groupAttributes=

..
