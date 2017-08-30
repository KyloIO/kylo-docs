================
Import Templates
================
The Kylo installation includes some sample ingestion templates to get you started. You can import them either through the command line or in the UI

Import from the command line
----------------------------
The setup folder includes a script to import the templates locally.

.. code-block:: shell

    $ <KYLO_HOME>/setup/install-templates-locally.sh

Import from the Kylo UI
------------------------

1. Import Index Text Template (For Elasticsearch or SOLR).

   a. Locate the file. You will need the file locally to upload it. You can find it in one of two places:

    If you are using a version of NiFi prior to 1.3:

    .. code-block:: none

        - <kylo_project>/samples/feeds/nifi-1.0/index_text_service_<TYPE>.zip
        - /opt/kylo/setup/data/feeds/nifi-1.0/index_text_service_<TYPE>.zip

    ..


    If you are using NiFi 1.3 or later:

    .. code-block:: none

        - <kylo_project>/samples/feeds/nifi-1.3/index_text_service_v2.zip
        - /opt/kylo/setup/data/feeds/nifi-1.3/index_text_service_v2.zip
    ..

   b. Go to the the Feeds page in Kylo.

   c. Click on the plus icon to add a feed.

   d. Select "Import from a file".

   e. Choose the file from above.

   f. Click "Import Feed".

2. Import the data ingest template.

   a. Locate the data_ingest.zip file. You will need the file locally to upload it. You can find it in one of two places:

    .. code-block:: none

        - <kylo_project>/samples/templates/nifi-1.0/data_ingest.zip
        - /opt/kylo/setup/data/templates/nifi-1.0/data_ingest.zip

    ..

   b. Go to the templates page in the Admin section

   c. Click on the plus icon on the top left

   d. Click on "Import from file" and choose the data_ingest.zip

   e. If this is the first time you are importing the template you do not need to check any of the additional options

   f. Click "Import Template"

3. Import the data transformation template.

   a. Locate the data_transformation.zip file. You will need the file locally to upload it. You can find it in one of two places:

    .. code-block:: none

        - <kylo_project>/samples/templates/nifi-1.0/data_transformation.zip
        - /opt/kylo/setup/data/templates/nifi-1.0/data_transformation.zip

    ..

   b. Go to the templates page in the Admin section

   c. Click on the plus icon on the top left

   d. Click on "Import from file" and choose the data_transformation.zip

   e. If this is the first time you are importing the template you do not need to check any of the additional options

   f. Click "Import Template"

4. Import the data confidence template.

   a. Locate the data_confidence_invalid_records.zip file. You will need the file locally to upload it. You can find it in one of two places:

    .. code-block:: none

        - <kylo_project>/samples/templates/nifi-1.0/data_confidence_invalid_records.zip
        - /opt/kylo/setup/data/templates/nifi-1.0/data_confidence_invalid_records.zip

    ..

   b. Go to the templates page in the Admin section

   c. Click on the plus icon on the top left

   d. Click on "Import from file" and choose the data_confidence_invalid_records.zip

   e. If this is the first time you are importing the template you do not need to check any of the additional options

   f. Click "Import Template"