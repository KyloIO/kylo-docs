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



