Authentication
==============

Overview
~~~~~~~~

Kylo uses a pluggable authentication scheme based on `JAAS 
<http://docs.oracle.com/javase/7/docs/technotes/guides/security/jaas/JAASRefGuide.html>`__. 
JAAS allows multiple `LoginModules 
<http://docs.oracle.com/javase/7/docs/technotes/guides/security/jaas/JAASRefGuide.html#LoginModule>`__
to be configured to collaborate in an authentication attempt.

Pre-Configured Pluggable Authentication Modules
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo comes with some pre-configured authentication plugins that may be
activated by adding the approperiate Spring profiles to the UI and server
configuration property files.  By default, whenever any of these profiles
are added to the configuration it is equivalent to adding their associated
LoginModules to the overall JAAS configuration using the "required" control flag.

+------------------+----------------+-----------------+
| Login Method     | Spring Profile | Description     |
+==================+================+=================+
| Kylo User        | auth-kylo      | Authenticates   |
|                  |                | users           |
|                  |                | against the     |
|                  |                | Kylo            |
|                  |                | user/group      |
|                  |                | store (Kylo     |
|                  |                | services        |
|                  |                | only)           |
+------------------+----------------+-----------------+
| LDAP             | auth-ldap      | Authenticates   |
|                  |                | users stored    |
|                  |                | in LDAP         |
+------------------+----------------+-----------------+
| Active Directory | auth-ad        | Authenticates   |
|                  |                | users stored    |
|                  |                | in Active       |
|                  |                | Directory       |
+------------------+----------------+-----------------+
| Users file       | auth-file      | Authenticates   |
|                  |                | users in a      |
|                  |                | file            |
|                  |                | users.properies |
|                  |                | (typically      |
|                  |                | used in         |
|                  |                | development     |
|                  |                | only)           |
+------------------+----------------+-----------------+
| Simple           | auth-simple    | Allows only     |
|                  |                | one admin       |
|                  |                | user defined    |
|                  |                | in the          |
|                  |                | configuration   |
|                  |                | properties      |
|                  |                | (development    |
|                  |                | only)           |
+------------------+----------------+-----------------+

Default Authentication Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When Kylo is newly installed it will be pre-configured with have a few default users
and groups defined; with varying permissions assiged to each group.  The default groups are:

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

Note that the `auth-file` profile should generally not be used in a production
environment because it currently stores user passwords in the clear.  It is primarily
used only in development and testing.

JAAS Configuration
~~~~~~~~~~~~~~~~~~

Currently, there are two applications for which LoginModules may be
===================================================================
Kylo supports a pluggable authentication architecture that allows
customers to integrate their existing infrastructure when authenticating
a user.  The pluggability is built around `JAAS 
<http://docs.oracle.com/javase/7/docs/technotes/guides/security/jaas/JAASRefGuide.html>`__; 
which delegtes authentication to one or more configured `LoginModules 
<http://docs.oracle.com/javase/7/docs/technotes/guides/security/jaas/JAASRefGuide.html#LoginModule>`__
that all collaborate in an authentication attempt.  Kylo
supplies LoginModule implementations for the most common authentication
scenarios, though customers will be able to provide their own modules to
replace or augment the modules provided by Kylo.

In addition to performing authentication, LoginModules may, upon successfull login, associate with
the logged-in user a set of principals (user ID and groups/roles) which can be used
to make authorization checks.  For instance, a LoginModule that authenticates
a user's credentials using LDAP may also load any groups defined in the LDAP store
for that user, and these groups can have permissions granted to them in Kylo. 

Built-In Pluggable Authentication Profiles
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kylo comes with some pre-built authentications configuration that may be
activated by adding the approperiate Spring profiles to the UI and server
configuration `application.properties` files.  By default, whenever any of these profiles
are added to the configuration it is equivalent to adding their associated
LoginModules to the overall JAAS configuration using the "required" control flag.

Note that more than one profile may be activated at one time.  If multiple profiles are used
then authentication in Kylo will only occur if all of the login requirements
of each of the profiles are satisfied.  

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
When this profile is active a LoginModule will be added to the configuration 
which validates whether authenticating user is present in the Kylo user store.
Note that this profile is typically used in conjunction with 
other profiles (such as auth-ldap) as this configuration does 
not perform any password validation.

+-----------------------------------+----------+--------------+------------------------------------------------------------------------------------------------------------------------+
| Properties                        | Required | Example      | Description                                                                                                            |
+===================================+==========+==============+========================================================================================================================+
| security.auth.kylo.login.services | No       | ``required`` | Corresponds to the control flag for LoginModule configurations: `required`, `requisite`, `sufficient`, and `optional`. |
|                                   |          |              | Possible values are `required`, `requisite`, `sufficient`, and `optional`                                              |
+-----------------------------------+----------+--------------+------------------------------------------------------------------------------------------------------------------------+

`auth-file`
'''''''''''
When this profile is active a LoginModule will be added to the configuration
which authenticates a username/password using user information within specific
files on the file system.  For validating the credentials it looks by default,
unless configured otherwise, for a file called `users.properties` on the classpath containing
a mapping of usernames top passwords in the form:

::

   user1=pw1
   user2=pw2
   ...
   
If authentication is successfull then it will also look for a file `groups.properties` on
the classpath to load the groups that have been assigned to the authenticated user.  The
format of this file is:

::

   user1=groupA,groupB
   user2=groupA,groupC
   ...
   
Note that use of the `groups.properties` file is optional when used in conjuction with other
authentication profiles.  For instance, it would be redundant (but not illegal) to have a groups
file when `auth-file` is used along with `auth-kylo`, as the latter profile will load any user 
assigned groups on successful login and it could be confusing to manage groups in two different
sources.

Note also that the `auth-file` profile should generally not be used in a production
environment because it currently stores user passwords in the clear.  It is primarily
used only in development and testing.

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

+-------------------------------------------------+----------+----------------------------------------------+-----------------+
| Property                                        | Required | Example                                      | Description     |
+=================================================+==========+==============================================+=================+
| security.auth.ldap.server.uri                   | Yes      | ``ldap://localhost:52389/dc=example,dc=com`` | The URI to the  |
|                                                 |          |                                              | LDAP server and |
|                                                 |          |                                              | root context    |
+-------------------------------------------------+----------+----------------------------------------------+-----------------+
| security.auth.ldap.authenticator.userDnPatterns | Yes      | ``uid={0},ou=people``                        | The DN filter   |
|                                                 |          |                                              | patterns, minus |
|                                                 |          |                                              | the root        |
|                                                 |          |                                              | context         |
|                                                 |          |                                              | portion, that   |
|                                                 |          |                                              | identifies the  |
|                                                 |          |                                              | entry for the   |
|                                                 |          |                                              | user. The       |
|                                                 |          |                                              | username is     |
|                                                 |          |                                              | substitued for  |
|                                                 |          |                                              | the ``{0}``     |
|                                                 |          |                                              | tag. If more    |
|                                                 |          |                                              | than one        |
|                                                 |          |                                              | pattern is      |
|                                                 |          |                                              | supplied they   |
|                                                 |          |                                              | should be       |
|                                                 |          |                                              | separated by "  |
+-------------------------------------------------+----------+----------------------------------------------+-----------------+
| security.auth.ldap.user.enableGroups            | No       | ``true``                                     | Activates user  |
|                                                 |          |                                              | group loading;  |
|                                                 |          |                                              | default:        |
|                                                 |          |                                              | ``false``       |
+-------------------------------------------------+----------+----------------------------------------------+-----------------+
| security.auth.ldap.user.groupsBase              | No       | ``ou=groups``                                | The filter      |
|                                                 |          |                                              | pattern that    |
|                                                 |          |                                              | identifies      |
|                                                 |          |                                              | group entries   |
+-------------------------------------------------+----------+----------------------------------------------+-----------------+
| security.auth.ldap.user.groupNameAttr           | No       | ``ou``                                       | The attribute   |
|                                                 |          |                                              | of the group    |
|                                                 |          |                                              | entry           |
|                                                 |          |                                              | containing the  |
|                                                 |          |                                              | group name      |
+-------------------------------------------------+----------+----------------------------------------------+-----------------+
| security.auth.ldap.server.authDn                | No       | ``uid=admin,ou=people,dc=example,dc=com``    | The LDAP        |
|                                                 |          |                                              | account with    |
|                                                 |          |                                              | the privileges  |
|                                                 |          |                                              | necessary to    |
|                                                 |          |                                              | access user or  |
|                                                 |          |                                              | group entries;  |
|                                                 |          |                                              | usually only    |
|                                                 |          |                                              | needed (if at   |
|                                                 |          |                                              | all) when group |
|                                                 |          |                                              | loading is      |
|                                                 |          |                                              | activated       |
+-------------------------------------------------+----------+----------------------------------------------+-----------------+
| security.auth.ldap.server.password              | No       |                                              | The password    |
|                                                 |          |                                              | for the account |
|                                                 |          |                                              | with the        |
|                                                 |          |                                              | privileges      |
|                                                 |          |                                              | necessary to    |
|                                                 |          |                                              | access user or  |
|                                                 |          |                                              | group entries   |
+-------------------------------------------------+----------+----------------------------------------------+-----------------+

`auth-ad`
'''''''''
This profile configures a LoginModule that authenticates the username and
password against an Active Directory server.

+------------------------------------+----------+-------------------------+-----------------+
| Property                           | Required | Example Value           | Description     |
+====================================+==========+=========================+=================+
| security.auth.ad.server.uri        | Yes      | ``ldap://example.com/`` | The URI to the  |
|                                    |          |                         | AD server       |
|                                    |          |                         |                 |
+------------------------------------+----------+-------------------------+-----------------+
| security.auth.ad.server.domain     | Yes      | ``test.example.com``    | The AD domain   |
|                                    |          |                         | of the users to |
|                                    |          |                         | authenticate    |
+------------------------------------+----------+-------------------------+-----------------+
| security.auth.ad.user.enableGroups | No       | ``true``                | Activates user  |
|                                    |          |                         | group loading;  |
|                                    |          |                         | default:        |
|                                    |          |                         | ``false``       |
+------------------------------------+----------+-------------------------+-----------------+

`auth-simple`
'''''''''''''
This profile configures a LoginModule that authenticates a single user as an administrator using 
username and password properties specified in `application.properties`.  The specified user will be
the only one able to login to Kylo.  Obviously, this profile should only be used in development.

+--------------------------------+----------+---------------+-----------------------------------+
| Property                       | Required | Example Value | Description                       |
+================================+==========+===============+===================================+
| authenticationService.username | Yes      | ``dlamin``    | The username of the administrator |
+--------------------------------+----------+---------------+-----------------------------------+
| authenticationService.password | Yes      | ``thinkbig``  | The password of the administrator |
+--------------------------------+----------+---------------+-----------------------------------+

User Group Handling
~~~~~~~~~~~~~~~~~~~

Kylo access control is governed by permissions assigned to user groups,
so upon successful authentication any groups to which the user belongs
must be loaded and associated with the current authenticated request
being processed. JAAS LogionModules have two responsibilities: 

   #. To authenticate a login attempt
   #. To optionally associate principals (user and group identifiers) with the securiity conext of the request
   
A number of authentication profiles described above support loading of user groups at login time.
For `auth-kylo` this is done automatically; for others (`auth-ldap`, 'auth-file`, etc.) this must be configured.
If more than one group-loading profiles are configured then the result is additive.  For example, if your configuraton
activates the profiles `auth-kylo` and `auth-LDAP`, and the LDAP properties enable groups, then any groups associated
with the user in both LDAP and the Kylo user store will be combined and associated with the user's security
context.

JAAS Application Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Currently, there are two applications (from a JAAS standpoint) for which LoginModules may be
>>>>>>> Added Authentication section and updated auth docs
configured for authentication: the Kylo UI and Services REST API. Kylo
provides an API that allows plugins to easily integrate custom login
modules into the authentication process.

Creating a Custom Authentication Plugin
'''''''''''''''''''''''''''''''''''''''

The first step is to create Kylo plugin containing a
`LoginModule <http://docs.oracle.com/javase/7/docs/technotes/guides/security/jaas/JAASLMDevGuide.html>`__
that performs whatever authentication is required and then adds any
username/group principals upon successful authentication. This module
will be added to whatever other LoginModules that may be associated
with the target application (Kylo UI and/or Services.)

The service-auth framework provides an API to make it easy to integrate
a new LoginModule into the authentication of the Kylo UI or services
REST API. The easiest way to integrate your custom LoginModule is to
create a Spring configuration class, which will be bundled into your
plugin jar along with your custom LoginModule, that uses the framework-provided
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

As with any Kylo plugin, to deploy this configuration you would create a
jar file containing the above configuration class, your custom login
module class, and a ``plugin/plugin-context.xml`` file to bootstrap
your plugin configuration. Dropping this jar into the plugin directories of
the UI and Services would allow your custom LoginModule to participate in their
login process.



