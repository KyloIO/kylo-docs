Kylo Kerberos SPNEGO
====================

Configuration
-------------

auth-krb-spnego
~~~~~~~~~~~~~~~

Kerberos SPNEGO is activated in Kylo by adding the profile
``auth-krb-spnego`` to the list of active profiles in the UI and services
properties files.

Currently, if SPNEGO is activated, then either the ``auth-kylo`` or ``auth-ad`` profile must be
used as well.  This is because requests reaching Kylo when SPNEGO is used will already be authenticated
but the groups associated with the requesting user must still be associated during Kylo authentication.
Both the configurations activated by ``auth-kylo`` and ``auth-ad`` are SPNEGO-aware and allow serice
accounts properties to be set for use in looking up the groups of user from the Kylo user store or
Active Directory.

Once SPNEGO is configured in `kylo-services` the services' REST API will begin to accept 
SPNEGO ``Authorization: Negotiate`` headers for authentication.  The REST API will continue to accept 
HTTP BASIC authentication requests as well.

When ``auth-krb-spnego`` is activated, the following properties are required to configure Kerberos SPNEGO:

+-------------------------------------+--------------------------------------------------------------------+----------------------------------+
| **Property**                        | **Description**                                                    | **Example**                      |
+=====================================+====================================================================+==================================+
| security.auth.krb.service-principal | Names the service principal used to access Kylo                    | HTTP/kylo.domain.com@EXAMPLE.COM |
+-------------------------------------+--------------------------------------------------------------------+----------------------------------+
| security.auth.krb.keytab            | Specifies path to the keytab file containing the service principal | /opt/kylo/kylo.keytab            |
+-------------------------------------+--------------------------------------------------------------------+----------------------------------+

auth-kylo
~~~~~~~~~

If the ``auth-kylo`` profile is activated with SPNEGO then the `kylo-ui/conf/appplication.properties` file must contain the credential properties specified 
in the table below to allow access to the Kylo user store via the kylo-services' REST API using BASIC auth.  The authentication configuration 
for `kylo-services` can be anything that accepts the credentials specified in these properties.  

+-----------------------------------+---------------------------------------------------------------------------------------------------------------------------+
| **Property**                      | **Description**                                                                                                           |
+===================================+===========================================================================================================================+
| security.auth.kylo.login.username | Specifies a Kylo username with the rights to retrieve all of the Kylo groups of which the authenticating user is a member |
+-----------------------------------+---------------------------------------------------------------------------------------------------------------------------+
| security.auth.kylo.login.password | Specifies the password of the above username retrieving the authenticating user’s groups                                  |
+-----------------------------------+---------------------------------------------------------------------------------------------------------------------------+

auth-ad
~~~~~~~

If the ``auth-ad`` profile is activated with SPNEGO then the properties in the table below must be set in `kylo-ui/conf/appplication.properties` and `kylo-services/conf/appplication.properties`
(if the profile is used in `kylo-services`).  

+-----------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
| **Property**                            | **Description**                                                                                                       |
+=========================================+=======================================================================================================================+
| security.auth.ad.user.enableGroups      | This should be set to ``true`` as group loading would be the only purpose of activating `auth-ad` with SPNEGO         |
+-----------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
| security.auth.ad.server.serviceUser     | Specifies a username in AD with the rights to retrieve all of the groups of which the authenticating user is a member |
+-----------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
| security.auth.ad.server.servicePassword | Specifies the password of the above AD username retrieving the authenticating user’s groups                           |
+-----------------------------------------+-----------------------------------------------------------------------------------------------------------------------+

Kerberos Configuration
~~~~~~~~~~~~~~~~~~~~~~

In addition to having a principal for every user present in your
Kerberos KDC, you will also need to have a service principal of the form
``HTTP/<Kylo host domain name>/@<YOUR REALM>`` registered. This
service principal should be exported into a keytab file and placed on
file system of the host running Kylo (typically `/opt/kylo/kylo.keytab`).
These values would then be used in the Kylo configuration properties as specified
above.

Verifying Access
----------------

Once Kylo is configured for Kerberos SPNEGO, you can use ``curl`` to verify
access. See the ``curl`` `—negotiate` option documentation (https://curl.haxx.se/docs/manual.html) to see the library
requirements to support SPNEGO. Use the `-V` option to verify whether
these requirements are met.

In these examples we will be accessing Kylo using URLs in the form:
``http://localhost:8420/``. Therefore, curl will
be requesting tickets from Kerberos for access to the service principle:
``HTTP/localhost.localdomain@YOUR_REALM``.

If you use a different URL, say
``http://host.example.com:8400/``, then the requested service principal will
look like: ``HTTP/host.example.com@YOUR_REALM``. In either case these
service principals must be present in your KDC, exported into the keytab
file, and the service principal name added to Kylo’s configuration
property ``security.auth.krb.service-principal``.

First, log into Kerberos with your username (“myname” here) using kinit. The
@YOUR_REALM part is optional if your KDC configuration has a default
realm:

.. code-block:: shell

    $ kinit myname@YOUR_REALM

Attempt to access the feeds API of kylo-services directly:

.. code-block:: shell

    $ curl -v --negotiate -u : http://localhost:8420/api/v1/metadata/feed/

Attempt to access the same feeds API through the kylo-ui proxy:

.. code-block:: shell

    $ curl -v --negotiate -u : http://localhost:8400/proxy/v1/metadata/feed/

Attempt to access the feeds HTML page on the kylo-ui:

.. code-block:: shell

    $ curl -v --negotiate -u : http://localhost:8400/feed-mgr/index.html

Using the `-v` option causes ``curl`` to output the headers and status info
exchanged with Kylo during the processing of the request before writing
out the response. If Kerberos SPNEGO authentication was
successful for each curl command, the output should include lines such
as these:

.. code-block:: shell

    > GET /proxy/v1/metadata/feed/ HTTP/1.1

    < HTTP/1.1 401 Unauthorized

    < WWW-Authenticate: Negotiate

    > GET /proxy/v1/metadata/feed/ HTTP/1.1
    > Authorization: Negotiate YII...

    < HTTP/1.1 200 OK

..

This shows ``curl``:
    1. Attempt to get the feed resource
    #. Receive an unauthorized response (401) and a challenge to negotiate authentication
    #. Retry the request, but this time supplying the Kerberos ticket in an authorization header
    #. Finally receiving a successful response (200)

Test Environment
----------------

The following links provide useful information on setting up your own
KDC in a test environment:

-  `Appendices of the Spring Kerberos Reference
   Documentation <http://docs.spring.io/spring-security-kerberos/docs/1.0.1.RELEASE/reference/htmlsingle/#setup-kerberos-environments>`__

-  `MIT Kerberos Admin
   Guide <http://web.mit.edu/kerberos/krb5-current/doc/admin/index.html>`__
