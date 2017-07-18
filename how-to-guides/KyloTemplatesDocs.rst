======================
Kylo Templates Guide
======================

Templates facilitate the creation of data flows. They can be:

- normal (1 template for the whole flow)

- reusable (1 reusable template and 1 flow template)

.. important::
   More on `reusable flows here <../tips-tricks/KyloBestPractices.html#use-reusable-flows>`_


Setup templates
======================

Import Kylo template
---------------------

1. Import template from file

2. Select file

3. Select overwrite + replace the reusable template option

4. Register the template

.. note::
   The following sections apply only if you didn't import yet a template in Kylo, or are lacking a Kylo template archive.

Import reusable template
-------------------------

1. Import template from file.

.. warning::
   You can't import the reusable template from NiFi environment, as it has input/output ports which need to be connected.

2. Select file and select overwrite + replace the reusable template option

3. Register the template

Import flow template
-------------------------

1. Import template from NiFi environment (as we want to customize it)

2. Enable/Customize the available fields (steps 2 - 4)

3. Under `Connection Options` (step 5) - connect the output ports from the flow template to the input ports from reusable template

4. Customize the `Feed Lineage Datasources`

5. Register the template

Update template
===================

1. Remember the template name <template_name> from NiFi

2. Create a new flow from the template <template_name>

3. Modify your flow for <template_name>

4. Delete <template_name> in NiFi template registry

5. Save flow with name <template_name>

6. In Kylo (if exists), from the Template menu, go through the edit wizard (click on the template name), so that it's reinitialized properly

Available templates
=======================

Kylo provides some ready to be used templates in the `Kylo repository <https://github.com/Teradata/kylo/tree/master/samples/templates>`_

Data Ingest
-------------------

Data Ingest template is used to import data from with various formats (CSV, JSON, AVRO, Parquet, ORC) into Hive tables.

S3
*******************
:doc:`../how-to-guides/S3DataIngestTemplate`

JSON
*******************

There is a limitation with the JSON file format:

1. Ensure 'skip header' is turned OFF. This will allow all of the JSON data in file to be processed. Otherwise the first record will be skipped.

2. Ensure that this jar file is provided to the Validator step via the 'Extra JARs' parameter (HDP location shown for reference): /usr/hdp/current/hive-webhcat/share/hcatalog/hive-hcatalog-core.jar. Otherwise, an exception will be thrown: "java.lang.ClassNotFoundException Class org.apache.hive.hcatalog.data.JsonSerDe not found"

3. The JSON data in the file should be on one row per line. 

Example:
.. code-block::

    {"id":"978-0641723445","cat":["book","hardcover"],"name":"The Lightning Thief","author":"Rick Riordan","series_t":"Percy Jackson and the Olympians","sequence_i":1,"genre_s":"fantasy","inStock":true,"price":12.50,"pages_i":384} {"id":"978-1423103349","cat":["book","paperback"],"name":"The Sea of Monsters","author":"Rick Riordan","series_t":"Percy Jackson and the Olympians","sequence_i":2,"genre_s":"fantasy","inStock":true,"price":6.49,"pages_i":304}

..

Data Transformation
--------------------

Data Transformation is used to transform/wrangle data with various operations from Spark ML.

Several tables can be taken from a data source and be joined, denormalized or transformed together, to result a new data table.

Accesing S3 and other distributed filesystems
***********************************************

:doc:`../how-to-guides/AccessingS3fromtheDataWrangler`
