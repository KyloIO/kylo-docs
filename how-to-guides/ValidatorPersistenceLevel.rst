===================================
Setting Validator Persistence Level
===================================

The Validator allows specifying the RDD persistence level via command line argument.

To use this feature in the standard ingest flow, perform these steps:

1. In NiFi, navigate to 'reusable_templates -> standard_ingest'.

2. Stop 'Validate And Split Records' processor.

3. Open configuration for 'Validate And Split Records' processor. Add two arguments at the end for the *MainArgs* property.

.. code-block:: shell

    <existing_args>,--storageLevel,<your_value>

    <your_value> can be any valid Spark persistence level (e.g. MEMORY_ONLY, MEMORY_ONLY_SER)

..


4. Start 'Validate And Split Records' processor.

.. note:: If not specified, the default persistence level used is MEMORY_AND_DISK.



