Authentication
==============

Overview
~~~~~~~~

Kylo supports a pluggable authentication architecture that allows
customers to integrate their existing infrastructure when authenticating
a user.  The pluggability is built around |jaas_link|, which delegates authentication
to one or more configured |loginmodule_link| that all collaborate in an authentication attempt. 

Kylo supplies LoginModule implementations for the most common authentication
scenarios, though customers will be able to provide their own modules to
replace or augment the modules provided by Kylo.

In addition to performing authentication, LoginModules may, upon successful login, associate
the logged-in user with a set of principals (user ID and groups/roles) that can be used
to make authorization checks.  For instance, a LoginModule that authenticates
a user's credentials using LDAP may also load any groups defined in the LDAP store
for that user, and these groups can have permissions granted to them in Kylo.

Logging
~~~~~~~

Kylo can be configured to log every authentication request and logout by every user.  This is turned off by default.    The log message format can be specified with various standard fields that will substitued in the message based on the context
during the access control check.  The valid fields are: 

+----------+-------------------------------------------------------------------------------------------------------+
| Field    | Description                                                                                           |
+==========+=======================================================================================================+
| `RESULT` | The result of the authentication or logout attempt (ex: "success" or "failure" with an error message) |
+----------+-------------------------------------------------------------------------------------------------------+
| `USER`   | The user being authenticated / logged out                                                             |
+----------+-------------------------------------------------------------------------------------------------------+
| `GROUPS` | The groups of the user                                                                                |
+----------+-------------------------------------------------------------------------------------------------------+

To enable authentication logging you can configure the properties in the table below in the kylo-ui and/or kylo-services properties file.

.. note:: If kylo-ui is configured with the profile **auth-kylo** then it will deletage all authentication to kylo-services.  In this case you may only want to configure authentication logging on the kylo-services side.

+---------------------------------+----------+----------------------------------------------------+----------------------------------------------------------------------------------------------------------------+
| Properties                      | Required | Default                                            | Description                                                                                                    |
+=================================+==========+====================================================+================================================================================================================+
| security.log.auth               | No       | ``false``                                          | Activates logging of every access control check                                                                |
+---------------------------------+----------+----------------------------------------------------+----------------------------------------------------------------------------------------------------------------+
| security.log.auth.level         | No       | ``DEBUG``                                          | The log level used to log the attempt                                                                          |
+---------------------------------+----------+----------------------------------------------------+----------------------------------------------------------------------------------------------------------------+
| security.log.auth.login.format  | No       | ``Authentication attempt: {RESULT}, user: {USER}`` | The format of the login attempt message with embedded fields to be substitued with the authentication details  |
+---------------------------------+----------+----------------------------------------------------+----------------------------------------------------------------------------------------------------------------+
| security.log.auth.logout.format | No       | ``Logout attempt: {RESULT}, user: {USER}``         | The format of the logout attempt message with embedded fields to be substitued with the authentication details |
+---------------------------------+----------+----------------------------------------------------+----------------------------------------------------------------------------------------------------------------+

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

+--------------------+--------------------+-----------------------------------------------------+
| Login Method       | Spring Profile     | Description                                         |
+====================+====================+=====================================================+
| Kylo User          | `auth-kylo`        | Authenticates users against the                     |
|                    |                    | Kylo user/group store                               |
+--------------------+--------------------+-----------------------------------------------------+
| LDAP               | `auth-ldap`        | Authenticates users stored in LDAP                  |
+--------------------+--------------------+-----------------------------------------------------+
| Active Directory   | `auth-ad`          | Authenticates users stored                          |
|                    |                    | in Active Directory                                 |
+--------------------+--------------------+-----------------------------------------------------+
| Users file         | `auth-file`        | Authenticates users in a file                       |
|                    |                    | users.properies (typically used in                  |
|                    |                    | development only)                                   |
+--------------------+--------------------+-----------------------------------------------------+
| Simple             | `auth-simple`      | Allows only one admin user defined in the           |
|                    |                    | configuration properties (development only)         |
+--------------------+--------------------+-----------------------------------------------------+
| Cached credentials | `auth-cache`       | Short-cicuit, temporary authentication after        |
|                    |                    | previous user authentication by other means         |
+--------------------+--------------------+-----------------------------------------------------+
| Kylo User Groups   | `auth-kylo-groups` | Limits user groups of other profiles to only those  |
|                    |                    | which also exist in Kylo. This is useful when       |
|                    |                    | user is part of many groups in other profiles which |
|                    |                    | may cause JTW token size overflow.                  |
+--------------------+--------------------+-----------------------------------------------------+

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

Note that use of the `groups.properties` file is optional when used in conjunction with other
authentication profiles.  For instance, it would be redundant (but not invalid) to have a groups
file when `auth-file` is used with `auth-kylo`, as the latter profile will load any user
assigned groups from the Kylo store as well as those defined in the group file.  It would likely
be confusing to have to manage groups from two different sources.

.. note:: The `auth-file` profile should generally not be used in a production environment unless the passwords are encrypted (see below.)  The default is to expect the user passwords to be **unencrypted**.

+--------------------------------------------+----------+-----------------------+--------------------------------------------------------------------------------------------------------------------+
| Properties                                 | Required | Example               | Description                                                                                                        |
+============================================+==========+=======================+====================================================================================================================+
| security.auth.file.users                   | No       | ``users.properties``  | The value is either a name of a resource found on the classpath or, if prepended by `file:///`, a direct file path |
+--------------------------------------------+----------+-----------------------+--------------------------------------------------------------------------------------------------------------------+
| security.auth.file.groups                  | No       | ``groups.properties`` | The same as security.auth.file.users but for the groups file                                                       |
+--------------------------------------------+----------+-----------------------+--------------------------------------------------------------------------------------------------------------------+
| security.auth.file.password.hash.enabled   | No       | ``false``             | Indicates whether the passwords in ``users.properties`` are hashed                                                 |
+--------------------------------------------+----------+-----------------------+--------------------------------------------------------------------------------------------------------------------+
| security.auth.file.password.hash.algorithm | No       | ``SHA-256``           | Specifies the java.security.MessageDigest algorithm used to hash the passwords                                     |
+--------------------------------------------+----------+-----------------------+--------------------------------------------------------------------------------------------------------------------+
| security.auth.file.password.hash.encoding  | No       | ``hex``               | Specifies the byte encoding used for the hashed passwords (``hex``, ``base64``, ``rfc2617``)                       |
+--------------------------------------------+----------+-----------------------+--------------------------------------------------------------------------------------------------------------------+

If `auth-file` is configured to use hashed passwords, then password values can be generated on the command line of most *nix systems, assuming the default digest and encoding settings, using:

::

   $ echo -n "mypassword" | shasum -a 256 | cut -d' ' -f1 


If `auth-file` is active and no users file property is specified in the configuration then these implicit username/password properties will be assumed:

.. code-block:: properties

   dladmin=thinkbig
   analyst=analyst
   designer=designer
   operator=operator
..

`auth-ldap`
'''''''''''
This profile configures a LoginModule that authenticates the username and
password against an LDAP server.

+-------------------------------------------------+----------+--------------------------------------------------------+----------------------------------------------------+
| Property                                        | Required | Example                                                | Description                                        |
+=================================================+==========+========================================================+====================================================+
| security.auth.ldap.server.uri                   | Yes      | ``ldap://localhost:52389/ou=people,dc=example,dc=com`` | The URI to the LDAP server and root context        |
+-------------------------------------------------+----------+--------------------------------------------------------+----------------------------------------------------+
| security.auth.ldap.authenticator.userDnPatterns | Yes      | ``uid={0}``                                            | The DN filter patterns, minus the root             |
|                                                 |          |                                                        | context portion, that identifies the entry for the |
|                                                 |          |                                                        | user. The username is substitued forthe ``{0}``    |
|                                                 |          |                                                        | tag. If more than one pattern is supplied they     |
|                                                 |          |                                                        | should be separated by vertical bars               |
+-------------------------------------------------+----------+--------------------------------------------------------+----------------------------------------------------+
| security.auth.ldap.user.enableGroups            | No       | ``true``                                               | Activates user group loading;  default: ``false``  |
+-------------------------------------------------+----------+--------------------------------------------------------+----------------------------------------------------+
| security.auth.ldap.user.groupsBase              | No       | ``ou=groups``                                          | The filter pattern that identifies group entries   |
+-------------------------------------------------+----------+--------------------------------------------------------+----------------------------------------------------+
| security.auth.ldap.user.groupNameAttr           | No       | ``ou``                                                 | The attribute of the group entry containing the    |
|                                                 |          |                                                        | group name                                         |
+-------------------------------------------------+----------+--------------------------------------------------------+----------------------------------------------------+
| security.auth.ldap.server.authDn                | No       | ``uid=admin,ou=people,dc=example,dc=com``              | The LDAP account with the privileges necessary to  |
|                                                 |          |                                                        | access user or group entries; usually only         |
|                                                 |          |                                                        | needed (if at all) when group loading is activated |
+-------------------------------------------------+----------+--------------------------------------------------------+----------------------------------------------------+
| security.auth.ldap.server.password              | No       |                                                        | The password for the account with the privileges   |
|                                                 |          |                                                        | necessary to access user or group entries          |
+-------------------------------------------------+----------+--------------------------------------------------------+----------------------------------------------------+

If connecting to an LDAP server over SSL please make the following changes

1. Change the "security.auth.ldap.server.uri" to use "ldaps" and the correct port
2. You need to install the SSL certificates in the Kylo trust store. If you have not setup a trust store for Kylo please do the following:

   - Create a Java keystore and add the certificates

   - Modify /opt/kylo/kylo-services/bin/run-kylo-services.sh file and append the truststore location and password to the KYLO_SERVICES_OPTS environment variable

      .. code:: shell

         export KYLO_SERVICES_OPTS='-Xmx768m -Djavax.net.ssl.trustStore=/opt/kylo/truststore.jks -Djavax.net.ssl.trustStorePassword=xxxxxx'


   - Modify /opt/kylo/kylo-ui/bin/run-kylo-ui.sh file and append the truststore location and password to the KYLO_UI_OPTS environment variable

      .. code:: shell

         export KYLO_UI_OPTS='-Xmx768m -Djavax.net.ssl.trustStore=/opt/kylo/truststore.jks -Djavax.net.ssl.trustStorePassword=xxxxxx'

3. Restart the kylo-ui and kylo-services application

`auth-ad`
'''''''''
This profile configures a LoginModule that authenticates the username and
password against an Active Directory server.  If the properties ``security.auth.ad.server.serviceUser`` and ``security.auth.ad.server.servicePassword``
are set then those credentials will be used to autheticate with the AD server and only the username will be validated to exist in AD;
loading the user's groups load (when configured) if the user is present.

+-----------------------------------------+----------+-----------------------------------------------+------------------------------------------------------------------------------------------------------------------------------+
| Property                                | Required | Example Value                                 | Description                                                                                                                  |
+=========================================+==========+===============================================+==============================================================================================================================+
| security.auth.ad.server.uri             | Yes      | ``ldap://example.com/``                       | The URI to the AD server                                                                                                     |
+-----------------------------------------+----------+-----------------------------------------------+------------------------------------------------------------------------------------------------------------------------------+
| security.auth.ad.server.domain          | Yes      | ``test.example.com``                          | The AD domain of the users to authenticate                                                                                   |
+-----------------------------------------+----------+-----------------------------------------------+------------------------------------------------------------------------------------------------------------------------------+
| security.auth.ad.server.searchFilter    | No       | ``(&(objectClass=user)(sAMAccountName={1}))`` | Specifies the filter to use to find AD entries for the login user; default: ``(&(objectClass=user)(userPrincipalName={0}))`` |
+-----------------------------------------+----------+-----------------------------------------------+------------------------------------------------------------------------------------------------------------------------------+
| security.auth.ad.server.serviceUser     | No       | ``admin``                                     | A service account used to authenticate with AD rather than                                                                   |
|                                         |          |                                               | the user logging in (typically used with auth-spnego)                                                                        |
+-----------------------------------------+----------+-----------------------------------------------+------------------------------------------------------------------------------------------------------------------------------+
| security.auth.ad.server.servicePassword | No       |                                               | A service account password used to authenticate with AD rather than                                                          |
|                                         |          |                                               | that of the user logging in (typically used with auth-spnego)                                                                |
+-----------------------------------------+----------+-----------------------------------------------+------------------------------------------------------------------------------------------------------------------------------+
| security.auth.ad.user.enableGroups      | No       | ``true``                                      | Activates user group loading; default: ``false``                                                                             |
+-----------------------------------------+----------+-----------------------------------------------+------------------------------------------------------------------------------------------------------------------------------+

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

`auth-cache`
''''''''''''
Kylo's REST API is stateless and every request must be authenticated.  In cases where the REST API is 
heavily used and/or the primary means of authetication is expensive, this profile can be used to reduce
the amount of times the primary authentication mechanism is consulted.  This is achieved by inserting
a LoginModule a the head of the login sequence, flagged as `Sufficient <http://docs.oracle.com/javase/7/docs/api/javax/security/auth/login/Configuration.html>`_, 
that reports a login success if the user credential for the current request is present in its cache.  
Another LoginModule, flagged as `Optional <http://docs.oracle.com/javase/7/docs/api/javax/security/auth/login/Configuration.html>`_, 
is inserted at the end of the sequence to add the credential to the cache whenever a successful login is committed.

+--------------------------+----------+------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Property                 | Required | Example Value                            | Description                                                                                                                                                            |
+==========================+==========+==========================================+========================================================================================================================================================================+
| security.auth.cache.spec | No       | ``expireAfterWrite=30s,maximumSize=512`` | The cache `specification <https://google.github.io/guava/releases/19.0/api/docs/com/google/common/cache/CacheBuilderSpec.html>`_ (entry expire time, cache size, etc.) |
+--------------------------+----------+------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

`auth-kylo-groups`
''''''''''''''''''
This profile will limit user groups to only those which also exist in Kylo. It is expected to be used only in combination with other profiles where user store is external to Kylo, e.g. Active Directory.
This profile is useful to prevent JWT token size overflow when user is part of many groups in other stores.
Lets consider following example where a user is part of following groups in Active Directory and following groups exist in Kylo:

+------------------+---------------------------------------------+
| User store       | Groups                                      |
+==================+=============================================+
| Active Directory | Group A, Group B, Group C, Group D, Group E |
+------------------+---------------------------------------------+
| Kylo             | Group B, Group D, Group F                   |
+------------------+---------------------------------------------+

Then having `auth-kylo-groups` profile will limit user groups to: Group B, Group D



User Group Handling
~~~~~~~~~~~~~~~~~~~

Kylo access control is governed by permissions assigned to user groups,
so upon successful authentication any groups to which the user belongs
must be loaded and associated with the current authenticated request
being processed. JAAS LoginModules have two responsibilities:

   #. Authenticate a login attempt
   #. Optionally, associate principals (user and group identifiers) with the security context of the request

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
        @Bean
        public LoginConfiguration myLoginConfiguration(LoginConfigurationBuilder builder) {
            return builder
                    .loginModule(JaasAuthConfig.JAAS_UI)
                        .moduleClass(MyCustomLoginModule.class)
                        .controlFlag("required")
                        .option("customOption", "customValue1")
                        .add()
                    .loginModule(JaasAuthConfig.JAAS_SERVICES)
                        .moduleClass(MyCustomLoginModule.class)
                        .controlFlag("required")
                        .option("customOption", "customValue2")
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
