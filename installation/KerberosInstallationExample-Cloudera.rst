
========================================
Kerberos Installation Example - Cloudera
========================================

+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Important   | This document should only be used for DEV/Sandbox purposes. It is useful to help quickly Kerberize your Cloudera sandbox so that you can test Kerberos features.   |
+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Prerequisite
============

Java
----

All client node should have java installed on it.

.. code-block:: shell

    $ java version "1.7.0_80"
    $ Java(TM) SE Runtime Environment (build 1.7.0_80-b15)
    $ Java HotSpot(TM) 64-Bit Server VM (build 24.80-b11, mixed mode)

    $ echo $JAVA_HOME
    $ /usr/java/jdk1.7.0_80

..

Install Java Cryptography Extensions (JCE)
------------------------------------------

.. code-block:: shell

    sudo wget -nv --no-check-certificate --no-cookies --header "Cookie:
    oraclelicense=accept-securebackup-cookie"
    http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip
    -O
    /usr/java/jdk1.7.0_80/jre/lib/security/UnlimitedJCEPolicyJDK7.zip

    cd /usr/java/jdk1.7.0_80/jre/lib/security

    sudo unzip UnlimitedJCEPolicyJDK7.zip

    sudo cp UnlimitedJCEPolicy/* .

    #sudo rm -r UnlimitedJCEPolicy*

    ls -l

..

Test Java Cryptography Extension
--------------------------------

Create a java Test.java and paste below mentioned code in it.

.. code-block:: shell

    $ vi Test.java

    import javax.crypto.Cipher;
    class Test {
    public static void main(String[] args) {
    try {
      System.out.println("Hello World!");
      int maxKeyLen = Cipher.getMaxAllowedKeyLength("AES");
      System.out.println(maxKeyLen);
    } catch (Exception e){
      System.out.println("Sad world :(");
    }
    }
    }

..

    Compile:

.. code-block:: shell

    $ javac Test.java

..

    Run test, the expected number is: 2147483647

.. code-block:: shell

    $ java Test
    Hello World!
    2147483647

..

Install Kerberos
================

On a cluster, go to the master node for installation of Kerberos utilities.

1. Install a new version of the KDC server:

.. code-block:: shell

    yum install krb5-server krb5-libs krb5-workstation

..

2. Using a text editor, open the KDC server configuration file, located by default here:

.. code-block:: shell

    vi /etc/krb5.conf

..

3. Change the [realms] as below to CLOUDERA . Udapte KDC and Admin Server Information.

.. code-block:: shell

    [logging]
      default = FILE:/var/log/krb5libs.log
      kdc = FILE:/var/log/krb5kdc.log
      admin_server = FILE:/var/log/kadmind.log

    [libdefaults]
      default_realm = CLOUDERA
      dns_lookup_realm = false
      dns_lookup_kdc = false
      ticket_lifetime = 24h
      renew_lifetime = 7d
      forwardable = true

    [realms]
      CLOUDERA = {
      kdc = quickstart.cloudera
      admin_server = quickstart.cloudera
      }

..

4. Update /var/kerberos/krb5kdc/kdc.conf. Change the [realms] as CLOUDERA.

.. code-block:: shell

    [kdcdefaults]
      kdc_ports = 88
      kdc_tcp_ports = 88

    [realms]
      CLOUDERA = {
        #master_key_type = aes256-cts
        acl_file = /var/kerberos/krb5kdc/kadm5.acl
        dict_file = /usr/share/dict/words
        admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
        supported_enctypes = aes256-cts:normal aes128-cts:normal
        des3-hmac-sha1:normal arcfour-hmac:normal des-hmac-sha1:normal
        des-cbc-md5:normal des-cbc-crc:normal
      }

..

5. Update /var/kerberos/krb5kdc/kadm5.acl and replace EXAMPLE.COM with CLOUDERA.

.. code-block:: shell

    */admin@CLOUDERA*

..

6. Create the Kerberos Database. Use the utility kdb5_util to create the Kerberos database. While asking for password , enter password as thinkbig.

.. code-block:: shell

    kdb5_util create -s

..

7. Start the KDC. Start the KDC server and the KDC admin server.

.. code-block:: shell

    /etc/rc.d/init.d/krb5kdc start
    /etc/rc.d/init.d/kadmin start

..

+-------------+-----------------------------------------------------------------------------------------------------------------------+
| **NOTE:**   | When installing and managing your own MIT KDC, it is very important to set up the KDC server to auto start on boot.   |
+-------------+-----------------------------------------------------------------------------------------------------------------------+

.. code-block:: shell

    chkconfig krb5kdc on
    chkconfig kadmin on

..

8. Create a KDC admin by creating an admin principal. While asking for password , enter password as thinkbig.

.. code-block:: shell

    kadmin.local -q "addprinc admin/admin"

..

9. Confirm that this admin principal has permissions in the KDC ACL. Using a text editor, open the KDC ACL file:

.. code-block:: shell

    vi /var/kerberos/krb5kdc/kadm5.acl

..

10. Ensure that the KDC ACL file includes an entry so to allow the admin principal to administer the KDC for your specific realm. The file should have an entry:

.. code-block:: shell

    */CLOUDERA*

..

11. After editing and saving the kadm5.acl file, you must restart the kadmin process.

.. code-block:: shell

    /etc/rc.d/init.d/kadmin restart

..

12. Create a user in the linux by typing below. We will use this user to test whether the Kerberos authentication is working or not. We will first run the command hadoop fs ls / but switching to this user. And we will run the same command again when we enable Kerberos.

.. code-block:: shell

    adduser testUser
    su testUser
    hadoop fs ls /

..

Install Kerberos on Cloudera Cluster
====================================

1. Login to Cloudera Manager and Select Security option from Administration tab.

    |image1|

2. Click on Enable Kerberos.

    |image2|

3. Select each item and click on continue.

    |image3|

4. The Kerberos Wizard needs to know the details of what the script configured. Fill in the entries as follows and click continue.

.. code-block:: shell

    KDC Server Host: quickstart.cloudera
    Kerberos Security Realm: CLOUDERA
    Kerberos Encryption Types: aes256-cts-hmac-sha1-96

..

    |image4|

5. Select checkbox Manage krb5.conf through cloudera manager.

    |image5|

6. Enter username and password for of KDC admin user.

.. code-block:: shell

    Username : admin/admin@CLOUDERA
    Password : thinkbig

..

    The next screen provides good news. It lets you know that the wizard was able to successfully authenticate.

    |image6|

7. Select "I’m ready to restart the cluster now" and click on continue.

    |image7|

8. Make sure all services started properly. Kerberos is successfully installed on cluster.

KeyTab Generation
=================

1. Create a keytab file for Nifi user.

.. code-block:: shell

    kadmin.local
    addprinc -randkey nifi@CLOUDERA
    xst -norandkey -k /etc/security/nifi.headless.keytab nifi@CLOUDERA
    exit

    chown nifi:hadoop /etc/security/keytabs/nifi.headless.keytab
    chmod 440 /etc/security/keytabs/nifi.headless.keytab

    [Optional] You can initialize your keytab file using below command.

    kinit -kt /etc/security/keytabs/nifi.headless.keytab nifi

..


.. |image1| image:: ../media/kerberos-install/CK111.png
   :width: 5.91892in
   :height: 1.58407in
.. |image2| image:: ../media/kerberos-install/CK2.png
   :width: 5.94884in
   :height: 1.49293in
.. |image3| image:: ../media/kerberos-install/CK3.png
   :width: 5.84438in
   :height: 2.93343in
.. |image4| image:: ../media/kerberos-install/CK4.png
   :width: 5.93220in
   :height: 3.05483in
.. |image5| image:: ../media/kerberos-install/CK5.png
   :width: 5.99531in
   :height: 3.11679in
.. |image6| image:: ../media/kerberos-install/CK6.png
   :width: 5.87381in
   :height: 2.87415in
.. |image7| image:: ../media/kerberos-install/CK8.png
   :width: 5.86554in
   :height: 2.62320in
