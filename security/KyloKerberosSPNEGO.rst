Kylo Kerberos SPNEGO
====================

Configuration
-------------

Kylo
~~~~

Kerberos SPNEGO is activated in Kylo by adding the profile
``auth-krb-spnego`` to the list of active profiles in the UI and services
properties files.

Currently, if SPNEGO is activated, then the ``auth-kylo`` profile must be
used as well, and all Kerberos-authenticated users must be present in the Kylo user store.
Once activated, the following properties are required to configure Kerberos SPNEGO:

+--------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------+
| **Property**                         | **Description**                                                                                                                                                | **Example**                      |
+======================================+=====================================================================================================================+==========================================+=================+================+
| security.auth.krb.service-principal  | Names the service principal used to access Kylo                                                                                                                | HTTP/kylo.domain.com@EXAMPLE.COM |
+--------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------+
| security.auth.krb.keytab             | Specifies path to the keytab file containing the service principal                                                                                             | /opt/kylo/kylo.keytab            |
+--------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------+
| security.auth.kylo.login.username    | `(kylo-ui/application.properties only)`  Specifies a username with the rights to retrieve all of the Kylo groups of which the authenticating user is a member  |                                  |
+--------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------+
| security.auth.kylo.login.password    | `(kylo-ui/application.properties only)`  Specifies the password of the above username retrieving the authenticating user’s groups - should be encrypted        |                                  |
+--------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------+

.. note:: Other authentication profile(s) must be activated in the `kylo-services/application.properties`, such as
``auth-simple``, to allow the user/password specified in the ``security.auth.kylo.login.*`` properties above to be authenticated.

Kerberos
~~~~~~~~

In addition to having a principal for every user present in your
Kerberos KDC, you will also need to have a service principal of the form
HTTP/<Kylo host domain name>/@<YOUR REALM> registered. This
service principal should be exported into a keytab file and placed on
file system of the host running Kylo (typically /opt/kylo/kylo.keytab).
These values would then be used in the Kylo configuration as specified
above.

Verifying Access
~~~~~~~~~~~~~~~~

Once Kylo is configured for Kerberos SPNEGO you can use ``curl`` to verify
access. See the ``curl`` `—negotiate` option documentation to see the library
requirements to support SPNEGO, and use the `-V` option to verify whether
these requirements are met.

In these examples we will be accessing Kylo using URLs in the form:
``http://localhost:8420/``. Therefore, curl will
be requesting tickets from Kerberos for access to the service principle:
``HTTP/localhost.localdomain@YOUR_REALM``. If you use a different URL, say
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
    #. ``curl`` retrying the request again but this time supplying the Kerberos ticket in an authorization header
    #. Finally receiving a successful response (200).

Test Environment
----------------

The following links provide useful information on setting up your own
KDC in a test environment:

-  `Appendices of the Spring Kerberos Reference
   Documentation <http://docs.spring.io/spring-security-kerberos/docs/1.0.1.RELEASE/reference/htmlsingle/#setup-kerberos-environments>`__

-  `MIT Kerberos Admin
   Guide <http://web.mit.edu/kerberos/krb5-current/doc/admin/index.html>`__
