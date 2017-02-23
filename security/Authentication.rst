Authentication
==============

Overview
~~~~~~~~

Kylo supports a pluggable authentication architecture that allows
customers to integrate their existing infrastructure when authenticating
a user.  The pluggability is built around |jaas_link|;
which delegtes authentication to one or more configured |loginmodule_link| that all collaborate in
an authentication attempt.  Kylo
supplies LoginModule implementations for the most common authentication
scenarios, though customers will be able to provide their own modules to
replace or augment the modules provided by Kylo.

In addition to performing authentication, LoginModules may, upon successful login, associate
the logged-in user with a set of principals (user ID and groups/roles) that can be used
to make authorization checks.  For instance, a LoginModule that authenticates
a user's credentials using LDAP may also load any groups defined in the LDAP store
for that user, and these groups can have permissions granted to them in Kylo.

Built-In Pluggable Authentication Profiles
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo comes with some pre-built authentication configurations that may be
activated by adding the appropriate Spring profiles to the UI and server
configuration `application.properties` files.  By default, whenever any of these profiles
are added to the configuration it is equivalent to adding their associated
LoginModules to the overall JAAS configuration using the "required" control flag.

.. note:: More than one profile may be activated at one time.  If multiple profiles are used, authentication in Kylo will only occur if all of the login requirements of each of the profiles are satisfied.

The table below lists all of the profiles currently supported by Kylo out-of-the-box.  When any
of these profiles are activated certain properties are
expected to be present in the `application.properties` files.

+------------------+----------------+------------------------------------+
| Login Method     | Spring Profile | Description                        |
+==================+================+====================================+
| Kylo User        | `auth-kylo`    | Authenticates users against the    |
|                  |                | Kylo user/group store              |
+------------------+----------------+------------------------------------+
| LDAP             | `auth-ldap`    | Authenticates users stored in LDAP |
+------------------+----------------+------------------------------------+
| Active Directory | `auth-ad`      | Authenticates users stored         |
|                  |                | in Active Directory                |
+------------------+----------------+------------------------------------+
| Users file       | `auth-file`    | Authenticates users in a file      |
|                  |                | users.properies (typically used in |
|                  |                | development only)                  |
+------------------+----------------+------------------------------------+
| Simple           | `auth-simple`  | Allows only                        |
|                  |                | one admin                          |
|                  |                | user defined                       |
|                  |                | in the                             |
|                  |                | configuration                      |
|                  |                | properties                         |
|                  |                | (development                       |
|                  |                | only)                              |
+------------------+----------------+------------------------------------+

`auth-kylo`
'''''''''''
When this profile is active, a LoginModule will be added to the configuration
that validates whether the authenticating user is present in the Kylo user store.

.. note:: This profile is typically used in conjunction with other profiles (such as auth-ldap) as this configuration does not perform any password validation.

+-----------------------------------+----------+--------------+------------------------------------------------------------------------------------------------------------------------+
| Properties                        | Required | Example      | Description                                                                                                            |
+===================================+==========+==============+========================================================================================================================+
| security.auth.kylo.login.services | No       | ``required`` | Corresponds to the control flag for LoginModule configurations: `required`, `requisite`, `sufficient`, and `optional`. |
|                                   |          |              | Possible values are `required`, `requisite`, `sufficient`, and `optional`                                              |
+-----------------------------------+----------+--------------+------------------------------------------------------------------------------------------------------------------------+

`auth-file`
'''''''''''
When this profile is active, a LoginModule will be added to the configuration
that authenticates a username/password using user information within specific
files on the file system.  For validating the credentials it looks by default,
unless configured otherwise, for a file called `users.properties` on the classpath containing
a mapping of usernames top passwords in the form:

.. code-block:: properties

   user1=pw1
   user2=pw2

..

If authentication is successful it will then look for a `groups.properties` file on
the classpath to load the groups that have been assigned to the authenticated user.  The
format of this file is:

.. code-block:: properties

   user1=groupA,groupB
   user2=groupA,groupC

..

Note that use of the `groups.properties` file is optional when used in conjuction with other
authentication profiles.  For instance, it would be redundant (but not invalid) to have a groups
file when `auth-file` is used with `auth-kylo`, as the latter profile will load any user
assigned groups from the Kylo store as well as those defined in the group file.  It would likely
be confusing to have to manage groups from two different sources.

.. note:: The `auth-file` profile should generally not be used in a production environment because it currently stores user passwords in the clear.  It is primarily used only in development and testing.

+---------------------------------+----------+-----------------------+--------------------------------------------------------------------------------------------------------------------+
| Properties                      | Required | Example               | Description                                                                                                        |
+=================================+==========+=======================+====================================================================================================================+
| security.auth.file.users:users  | No       | ``users.properties``  | The value is either a name of a resource found on the classpath or, if prepended by `file:///`, a direct file path |
+---------------------------------+----------+-----------------------+--------------------------------------------------------------------------------------------------------------------+
| security.auth.file.users:groups | No       | ``groups.properties`` | The same as security.auth.file.users but for the groups file                                                       |
+---------------------------------+----------+-----------------------+--------------------------------------------------------------------------------------------------------------------+

`auth-ldap`
'''''''''''
This profile configures a LoginModule that authenticates the username and
password against an LDAP server.

+-------------------------------------------------+----------+----------------------------------------------+----------------------------------------------------+
| Property                                        | Required | Example                                      | Description                                        |
+=================================================+==========+==============================================+====================================================+
| security.auth.ldap.server.uri                   | Yes      | ``ldap://localhost:52389/dc=example,dc=com`` | The URI to the LDAP server and root context        |
+-------------------------------------------------+----------+----------------------------------------------+----------------------------------------------------+
| security.auth.ldap.authenticator.userDnPatterns | Yes      | ``uid={0},ou=people``                        | The DN filter patterns, minus the root             |
|                                                 |          |                                              | context portion, that identifies the entry for the |
|                                                 |          |                                              | user. The username is substitued forthe ``{0}``    |
|                                                 |          |                                              | tag. If more than one pattern is supplied they     |
|                                                 |          |                                              | should be separated by vertical bars               |
+-------------------------------------------------+----------+----------------------------------------------+----------------------------------------------------+
| security.auth.ldap.user.enableGroups            | No       | ``true``                                     | Activates user group loading;  default: ``false``  |
+-------------------------------------------------+----------+----------------------------------------------+----------------------------------------------------+
| security.auth.ldap.user.groupsBase              | No       | ``ou=groups``                                | The filter pattern that identifies group entries   |
+-------------------------------------------------+----------+----------------------------------------------+----------------------------------------------------+
| security.auth.ldap.user.groupNameAttr           | No       | ``ou``                                       | The attribute of the group entry containing the    |
|                                                 |          |                                              | group name                                         |
+-------------------------------------------------+----------+----------------------------------------------+----------------------------------------------------+
| security.auth.ldap.server.authDn                | No       | ``uid=admin,ou=people,dc=example,dc=com``    | The LDAP account with the privileges necessary to  |
|                                                 |          |                                              | access user or group entries; usually only         |
|                                                 |          |                                              | needed (if at all) when group loading is activated |
+-------------------------------------------------+----------+----------------------------------------------+----------------------------------------------------+
| security.auth.ldap.server.password              | No       |                                              | The password for the account with the privileges   |
|                                                 |          |                                              | necessary to access user or group entries          |
+-------------------------------------------------+----------+----------------------------------------------+----------------------------------------------------+

`auth-ad`
'''''''''
This profile configures a LoginModule that authenticates the username and
password against an Active Directory server.

+------------------------------------+----------+-------------------------+--------------------------------------------------+
| Property                           | Required | Example Value           | Description                                      |
+====================================+==========+=========================+==================================================+
| security.auth.ad.server.uri        | Yes      | ``ldap://example.com/`` | The URI to the AD server                         |
+------------------------------------+----------+-------------------------+--------------------------------------------------+
| security.auth.ad.server.domain     | Yes      | ``test.example.com``    | The AD domain of the users to authenticate       |
+------------------------------------+----------+-------------------------+--------------------------------------------------+
| security.auth.ad.user.enableGroups | No       | ``true``                | Activates user group loading; default: ``false`` |
+------------------------------------+----------+-------------------------+--------------------------------------------------+

`auth-simple`
'''''''''''''
This profile configures a LoginModule that authenticates a single user as an administrator using
username and password properties specified in `application.properties`.  The specified user will be
the only one able to login to Kylo.  Obviously, this profile should only be used in development.

+--------------------------------+----------+---------------+-----------------------------------+
| Property                       | Required | Example Value | Description                       |
+================================+==========+===============+===================================+
| authenticationService.username | Yes      | ``dladmin``   | The username of the administrator |
+--------------------------------+----------+---------------+-----------------------------------+
| authenticationService.password | Yes      | ``thinkbig``  | The password of the administrator |
+--------------------------------+----------+---------------+-----------------------------------+

User Group Handling
~~~~~~~~~~~~~~~~~~~

Kylo access control is governed by permissions assigned to user groups,
so upon successful authentication any groups to which the user belongs
must be loaded and associated with the current authenticated request
being processed. JAAS LoginModules have two responsibilities:

   #. Authenticate a login attempt
   #. Optionally, associate principals (user and group identifiers) with the securiity conext of the request

A number of authentication profiles described above support loading of user groups at login time.
For `auth-kylo` this is done automatically, for others (`auth-ldap`, 'auth-file`, etc.) this must be configured.
If more than one group-loading profile is configured, the result is additive. For example, if your configuration
activates the profiles `auth-kylo` and `auth-LDAP`, and the LDAP properties enable groups, then any groups associated
with the user in both LDAP and the Kylo user store will be combined and associated with the user's security
context.

JAAS Application Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Currently, there are two applications (from a JAAS perspective) for which LoginModules may be
configured for authentication: the Kylo UI and Services REST API. Kylo
provides an API that allows plugins to easily integrate custom login
modules into the authentication process.

Creating a Custom Authentication Plugin
'''''''''''''''''''''''''''''''''''''''

The first step is to create Kylo plugin containing a |loginmodule_dev_link|
that performs whatever authentication is required and then adds any
username/group principals upon successful authentication. This module
will be added to whatever other LoginModules may be associated
with the target application (Kylo UI and/or Services.)

The service-auth framework provides an API to make it easy to integrate
a new LoginModule into the authentication of the Kylo UI or services
REST API. The easiest way to integrate your custom LoginModule is to
create a Spring configuration class, which will be bundled into your
plugin jar along with your custom LoginModule. That then uses the framework-provided
LoginConfigurationBuilder to incorporate your LoginModule into the
authentication sequence. The following is an example of a configuration
class that adds a new module to the authentication sequence of both the
Kylo UI and Services; each with different configuration options:

.. code:: java

    @Configuration
    public class MyCustomAuthConfig {
        @Bean(name = "uiMyLoginConfiguration")
        public LoginConfiguration uiLoginConfiguration(LoginConfigurationBuilder builder) {
            return builder
                    .loginModule(JaasAuthConfig.JAAS_UI)
                        .moduleClass(MyCustomLoginModule.class)
                        .controlFlag("REQUIRED")
                        .option("myCustomOptionKey", "customValue1")
                        .add()
                    .loginModule(JaasAuthConfig.JAAS_SERVICES)
                        .moduleClass(MyCustomLoginModule.class)
                        .controlFlag("REQUIRED")
                        .option("myCustomOption", "customValue2")
                        .option("anotherOption", "anotherValue")
                        .add()
                    .build();
        }
    }

..

As with any Kylo plugin, to deploy this configuration you would create a
jar file containing the above configuration class, your custom login
module class, and a ``plugin/plugin-context.xml`` file to bootstrap
your plugin configuration. Dropping this jar into the plugin directories of
the UI and Services would allow your custom LoginModule to participate in their
login process.


.. |jaas_link| raw:: html

   <a href="http://docs.oracle.com/javase/7/docs/technotes/guides/security/jaas/JAASRefGuide.html" target="_blank">JAAS</a>

.. |loginmodule_link| raw:: html

   <a href="http://docs.oracle.com/javase/7/docs/technotes/guides/security/jaas/JAASRefGuide.html#LoginModule" target="_blank">LoginModules</a>

.. |loginmodule_dev_link| raw:: html

   <a href="http://docs.oracle.com/javase/7/docs/technotes/guides/security/jaas/JAASLMDevGuide.html" target="_blank">LoginModule</a>
