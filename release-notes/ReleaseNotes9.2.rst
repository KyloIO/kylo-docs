Release 0.9.2 (TBD, 2018)
=========================

Highlights
----------
- Various issues fixed - |JIRA_Issues_Link|
- :ref:`Secret store with HashiCorp Vault <vault>`

Download Links
--------------
- Visit the :doc:`Downloads <../about/Downloads>` page for links.


Upgrade Instructions from v0.9.1
--------------------------------

1. Backup any Kylo plugins

  When Kylo is uninstalled it will backup configuration files, but not the `/plugin` jar files.
  If you have any custom plugins in either `kylo-services/plugin`  or `kylo-ui/plugin` then you will want to manually back them up to a different location.

2. Uninstall Kylo:

 .. code-block:: shell

   /opt/kylo/remove-kylo.sh

 ..

3. Install the new RPM:

 .. code-block:: shell

     rpm –ivh <RPM_FILE>

 ..

4. Restore previous application.properties files. If you have customized the the application.properties, copy the backup from the 0.9.1 install.


     4.1 Find the /bkup-config/TIMESTAMP/kylo-services/application.properties file

        - Kylo will backup the application.properties file to the following location, */opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties*, replacing the "YYYY_MM_DD_HH_MM_millis" with a valid time:

     4.2 Copy the backup file over to the /opt/kylo/kylo-services/conf folder

        .. code-block:: shell

          ### move the application.properties shipped with the .rpm to a backup file
          mv /opt/kylo/kylo-services/conf/application.properties /opt/kylo/kylo-services/conf/application.properties.0_9_2_template
          ### copy the backup properties  (Replace the YYYY_MM_DD_HH_MM_millis  with the valid timestamp)
          cp /opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties /opt/kylo/kylo-services/conf

        ..

     4.3 If you copied the backup version of application.properties in step 4.2 you will need to make a couple of other changes based on the 0.9.2 version of the properties file

        .. code-block:: shell

          vi /opt/kylo/kylo-services/conf/application.properties

          # Add new Vault properties, where missing values will be updated automatically when Vault is installed in following steps
          vault.root=secret/kylo
          vault.scheme=https
          vault.host=localhost
          vault.port=8200
          vault.token=
          vault.keyStoreName=kylo-vault-keystore.jks
          vault.keyStorePassword=
          vault.keyStoreDirectory=
          vault.keyStoreType=jks
          vault.trustStoreName=kylo-vault-truststore.jks
          vault.trustStorePassword=
          vault.trustStoreDirectory=
          vault.trustStoreType=jks

        ..

     4.4 Repeat previous copy step for other relevant backup files to the /opt/kylo/kylo-services/conf folder. Some examples of files:

        - spark.properties
        - ambari.properties
        - elasticsearch-rest.properties
        - log4j.properties
        - sla.email.properties

        **NOTE:**  Be careful not to overwrite configuration files used exclusively by Kylo


     4.5 Copy the /bkup-config/TIMESTAMP/kylo-ui/application.properties file to `/opt/kylo/kylo-ui/conf`

     4.6 Ensure the property ``security.jwt.key`` in both kylo-services and kylo-ui application.properties file match.  They property below needs to match in both of these files:

        - */opt/kylo/kylo-ui/conf/application.properties*
        - */opt/kylo/kylo-services/conf/application.properties*

          .. code-block:: properties

            security.jwt.key=

          ..

    4.7 (If using Elasticsearch for search) Create/Update Kylo Indexes

        Execute a script to create/update kylo indexes. If these already exist, Elasticsearch will report an ``index_already_exists_exception``. It is safe to ignore this and continue.
        Change the host and port if necessary.

            .. code-block:: shell

                /opt/kylo/bin/create-kylo-indexes-es.sh localhost 9200 1 1

            ..


5. Update the NiFi nars.

   Stop NiFi

   .. code-block:: shell

      service nifi stop

   ..

   Run the following shell script to copy over the new NiFi nars/jars to get new changes to NiFi processors and services.

   .. code-block:: shell

      /opt/kylo/setup/nifi/update-nars-jars.sh <NIFI_HOME> <KYLO_SETUP_FOLDER> <NIFI_LINUX_USER> <NIFI_LINUX_GROUP>

      Example:  /opt/kylo/setup/nifi/update-nars-jars.sh /opt/nifi /opt/kylo/setup nifi users

   ..

   Start NiFi

   .. code-block:: shell

      service nifi start

   ..


6. Install and start HashiCorp Vault

   Kylo uses Vault to securely store user credentials. Kylo script installs Vault as a service, similar to other Kylo services.
   The script to install Vault takes following form: ``install-vault.sh <kylo-home> <kylo-user> <kylo-group> <vault-version> <vault-home> <vault-user> <vault-group>``

 .. code-block:: shell

   useradd -r -m -s /bin/bash vault
   /opt/kylo/setup/vault/install-vault.sh /opt/kylo kylo users 0.9.0 /opt/vault vault vault
   service vault start
 ..

 Vault installation also creates Kylo configuration which allows Kylo to connect to Vault over SSL.
 SSL configuration is stored in ``/opt/kylo/ssl`` and following properties are updated in ``kylo-services/conf/application.properties``:

 - ``vault.keyStoreDirectory``
 - ``vault.keyStorePassword``
 - ``vault.trustStoreDirectory``
 - ``vault.trustStorePassword``

 For further details about Vault refer to :doc:`Kylo Vault Documentation <../security/Vault>`


7. Start Kylo

 .. code-block:: shell

   kylo-service start

 ..


Highlight Details
-----------------

.. _vault:

  - Secret store with HashiCorp Vault

      - Kylo now uses HashiCorp Vault to securely store user credentials. Make sure to review Vault documentation

         - :doc:`Kylo Vault Documentation <../security/Vault>`
         - |HashiCorp_Vault_Link|

.. |JIRA_Issues_Link| raw:: html

   <a href="https://kylo-io.atlassian.net/issues/?jql=project%20%3D%20KYLO%20AND%20status%20%3D%20Done%20AND%20fixVersion%20%3D%200.9.2%20ORDER%20BY%20summary%20ASC%2C%20lastViewed%20DESC" target="_blank">Jira Issues</a>

.. |HashiCorp_Vault_Link| raw:: html

   <a href='https://www.vaultproject.io/' target="_blank">HashiCorp Vault Documentation</a>