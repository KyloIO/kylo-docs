=====================
Enable Kerberos
=====================
If the cluster Kylo and NiFi will talk to has Kerberos enabled you will need to make a few additional configuration changes before starting Kylo for the first time.

Enable Kerberos for NiFi
------------------------
:doc:`../security/KerberosNiFiConfiguration`

Enable Kerberos for Kylo
------------------------
:doc:`../security/KerberosKyloConfiguration`

Test Client
-----------
If your cluster is Kerberized its a good idea to test the keytabs generated for Kylo and NiFi to make sure they work in the JVM. Kylo
provides a test client to make this easy.

    1. Download the Test Client

    :doc:`../about/Downloads`

    2. Run the test client

    Follow the instructions in the test client to validate connectivity in the JVM

    .. code-block:: shell

        $ java -jar /opt/kylo-kerberos-test-client-VERSION.jar

    ..