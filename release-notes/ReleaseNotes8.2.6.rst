Release 0.8.2.6 (October 16, 2017)
==================================

Highlights
----------
 - New configuration option added to the `auth-ad` security profile to control user details filtering (addresses Windows 365 issues)
 - Fixed KYLO-1264 ExecuteHQLStatement does not route to failure
 - Fixed KYLO-940 ThriftConnectionPool doesn't reconnect on Hive restart
 - Fixes KYLO-1281 missing Kylo Upgrade Version


Download Links
--------------

Coming soon

Upgrade Instructions from v0.8.2
--------------------------------

1. Uninstall Kylo:

 .. code-block:: shell

   /opt/kylo/remove-kylo.sh

 ..

2. Install the new RPM:

 .. code-block:: shell

     rpm –ivh <RPM_FILE>

 ..

3. Copy the application.properties file from the 0.8.2 install.  If you have customized the application.properties file you will want to copy the 0.8.2 version and add the new properties that were added for this release.

     3.1 Find the /bkup-config/TIMESTAMP/kylo-services/application.properties file

        - Kylo will backup the application.properties file to the following location, */opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties*, replacing the "YYYY_MM_DD_HH_MM_millis" with a valid time:

     3.2 Copy the backup file over to the /opt/kylo/kylo-services/conf folder

        .. code-block:: shell

          ### move the application.properties shipped with the .rpm to a backup file
          mv /opt/kylo/kylo-services/application.properties application.properties.0_8_2_2_template
          ### copy the backup properties  (Replace the YYYY_MM_DD_HH_MM_millis  with the valid timestamp)
          cp /opt/kylo/bkup-config/YYYY_MM_DD_HH_MM_millis/kylo-services/application.properties /opt/kylo/kylo-services/conf

        ..


     3.3 If using the ``auth-ad`` profile and having problems with accessing user info in AD (experienced by some Windows 365 deployments), add the following property to the existing AD properties in both kylo-services and kylo-ui application.properties files:

        .. code-block:: shell

           security.auth.ad.server.searchFilter=(&(objectClass=user)(sAMAccountName={1}))

        ..

4. Update the NiFi nars.  Run the following shell script to copy over the new NiFi nars/jars to get new changes to NiFi processors and services.

   .. code-block:: shell

      /opt/kylo/setup/nifi/update-nars-jars.sh <NIFI_HOME> <KYLO_SETUP_FOLDER> <NIFI_LINUX_USER> <NIFI_LINUX_GROUP>

      Example:  /opt/kylo/setup/nifi/update-nars-jars.sh /opt/nifi /opt/kylo/setup nifi users
   ..

5. Optional: To increase performance in Kylo you can choose to add indexes to the ``metadata-repository.json`` file.  Add the following json snippet to the ``/opt/kylo/kylo-services/conf/metadata-repository.json``

  5.1 make a directory that kylo has read/write acess to:

       .. code-block:: shell

          mkdir -p /opt/kylo/modeshape/modeshape-local-index/

       ..
   5.2. Edit the  ``/opt/kylo/kylo-services/conf/metadata-repository.json`` and add in this snippet of JSON.  Please ensure the "directory" in the json is the same that you created above.

          .. code-block:: javascript

                "indexProviders": {
                    "local": {
                        "classname": "org.modeshape.jcr.index.local.LocalIndexProvider",
                        "directory": "/opt/kylo/modeshape/modeshape-local-index/"
                    }
                    },
                    "indexes": {
                        "feedModificationDate": {
                            "kind": "value",
                            "provider": "local",
                            "nodeType": "tba:feed",
                            "columns": "jcr:lastModified(DATE)"
                        },
                        "feedState": {
                            "kind": "value",
                            "provider": "local",
                            "nodeType": "tba:feedData",
                            "columns": "tba:state(NAME)"
                        },
                        "categoryName": {
                            "kind": "value",
                            "provider": "local",
                            "nodeType": "tba:category",
                            "columns": "tba:systemName(STRING)"
                        },
                        "titleIndex": {
                            "kind": "value",
                            "provider": "local",
                            "nodeType": "mix:title",
                            "columns": "jcr:title(STRING)"
                        },
                        "nodesByName": {
                            "kind": "value",
                            "provider": "local",
                            "synchronous": "true",
                            "nodeType": "nt:base",
                            "columns": "jcr:name(NAME)"
                        },
                        "nodesByDepth": {
                            "kind": "value",
                            "provider": "local",
                            "synchronous": "true",
                            "nodeType": "nt:base",
                            "columns": "mode:depth(LONG)"
                        },
                        "nodesByPath": {
                            "kind": "value",
                            "provider": "local",
                            "synchronous": "true",
                            "nodeType": "nt:base",
                            "columns": "jcr:path(PATH)"
                        },
                        "nodeTypes": {
                            "kind": "nodeType",
                            "provider": "local",
                            "nodeType": "nt:base",
                            "columns": "jcr:primaryType(STRING)"
                        }
                    },

          ..

     *Note*:  After you start you may need to re-index kylo.  You can do this via a REST endpoint after you login to Kylo at the following url:

       http://localhost:8400/proxy/v1/metadata/debug/jcr-index/reindex



