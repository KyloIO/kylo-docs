Release 0.8.2.2 (September 12, 2017)
====================================

.. note:: A later version of 0.8.2.x exists.  Please visit :doc:`ReleaseNotes8.2.5` for the latest version

Highlights
----------
- Optimize feed creation in NiFi and improve NiFi usability when there is a large number of feeds
- Ability to skip NiFi auto alignment when saving feeds
- Fix bug in operations manager that didn't correctly fail jobs
- Support for 'failure connection' detection in feeds that contain sub process groups
- For a complete list of issues resolved visit: :doc:`ReleaseNotes8.2.2.issues`


Download Links
--------------

 - RPM : `<http://bit.ly/2fhpVSq>`__

 - Debian : `<http://bit.ly/2eUBtKA>`__

 - TAR : `<http://bit.ly/2x0g7FD>`__

Upgrade Instructions from v0.8.2
--------------------------------

Build or `download the rpm <http://bit.ly/2fhpVSq>`__

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

     3.3 Optional: If you want to skip the auto alignment after saving feeds then add in the new properties to the /opt/kylo/kylo-services/application.properties file

         .. code-block:: shell

                ## skip auto alignment after you create a feed.
                ##You can always manually align your flows in NiFi via a Kylo Rest Endpoint
                nifi.auto.align=false
         ..

     3.4 Ensure the property ``security.jwt.key`` in both kylo-services and kylo-ui application.properties file match.  They property below needs to match in both of these files:

         - */opt/kylo/kylo-ui/conf/application.properties*
         - */opt/kylo/kylo-services/conf/application.properties*.

       .. code-block:: properties

         security.jwt.key=

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



