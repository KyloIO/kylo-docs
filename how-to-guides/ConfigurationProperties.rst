========================
Configuration Properties
========================

Overview
========

This guide provides details on how to configure Kylo Templates and Feeds with properties from different sources.
The sources can be the following:

    1. Configuration from application.properties
    2. Configuration from Feed Metadata
    3. Configuration from Nifi environment variables

There are two property resolution options:

    1. Design-time resolution
    2. Runtime resolution


1. Configuration Sources
------------------------

1.1 Configuration from application.properties
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When creating Kylo feeds and templates one can refer to configuration properties which appear in
``/opt/kylo/kylo-services/conf/application.properties`` file. Property names must begin with word ``config.`` and they
should be referenced by following notation in Kylo UI ``${config.<property-name>}``

Here is an example of how we use this in ``application.properties``

.. code-block:: properties

    config.hive.schema=hive
    config.props.max-file-size=3 MB

..

Here is how you would refer to ``config.props.max-file-size`` in Kylo template:

|image1|


Setting NiFi Processor Properties
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There is a special property naming convention available for Nifi Processors and Services in ``application.properties`` too.

For Processor properties four notations are available:

    1. ``nifi.<processor_type>.<property_key>``
    2. ``nifi.all_processors.<property_key>``
    3. ``nifi.<processor_type>[<processor_name>].<property_key>``  (Available in Kylo 0.8.1)
    4. ``$nifi{nifi.property}`` will inject the NiFi property expression into the value. (Available in Kylo 0.8.1)


where ``<processor_type>``, ``<property_key>``, ``<processor_name>`` should be all lowercase with spaces replaced by underscores.  The ``<processor_name>`` is the display name of the processor set in NiFi.
Starting in Kylo 0.8.1 you can inject a property that has NiFi Expression Language as the value.  Since Spring and NiFi EL use the same notation (``${property}``) Kylo will detect any
nifi expression in the property value if it start with ``$nifi{property}``

 - Setting properties matching the NiFi Processor Type.  Here is an example of how to set 'Spark Home' and 'Driver Memory' properties on all 'Execute Spark Job' Processors:

    .. code-block:: properties

        nifi.executesparkjob.sparkhome=/usr/hdp/current/spark-client
        nifi.executesparkjob.driver_memory=1024m

    ..

 - Setting properties for a named NiFi Processor (starting in Kylo 0.8.1). Here is an example setting the property for just the ExecuteSparkJob processor named "Validate and Split Records":

    .. code-block:: properties

        nifi.executesparkjob[validate_and_split_records].number_of_executors=3
        nifi.executesparkjob[validate_and_split_records].driver_memory=1024m

    ..

 - Setting a property with NiFi expression language as a value (starting in Kylo 0.8.1).  Here is an example of injecting a value which refers to a NiFi expression

    .. code-block:: properties

       nifi.updateattributes[my_processor].my_property=/path/to/$nifi{my.nifi.expression.property}

    ..

    The "my property" on the UpdateAttribute processor named "My Processor" will get resolved to ``/path/to/${my.nifi.expression.property}`` in NiFi.


 - Setting all properties matching the property key.  Here is an example of how to set Kerberos configuration for all processors which support it:

    .. code-block:: properties

        nifi.all_processors.kerberos_principal=nifi
        nifi.all_processors.kerberos_keytab=/etc/security/keytabs/nifi.headless.keytab

    ..

Setting Controller Service Properties
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
For Services use following notation: ``nifi.service.<service_name>.<property_name>``.
Anything prefixed with ``nifi.service`` will be used by the UI. Replace spaces in Service and Property names with underscores
and make it lowercase. Here is an example of how to set 'Database User' and 'Password' properties for MySql Service:

.. code-block:: properties

    nifi.service.mysql.database_user=root
    nifi.service.mysql.password=hadoop

..


1.2 Configuration from Feed Metadata
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When creating Kylo feeds and templates you can also refer to Feed Metadata, i.e. set property values based on known
information about the feed itself. These properties start with word 'metadata', e.g. ``${metadata.<property-name>}``

Here is how you would refer to Category name and Feed name in Kylo template:

|image2|



1.3 Configuration from Nifi environment variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO - Help us complete this section



2. Property Resolution Options
------------------------------

2.1 Design-time Resolution
~~~~~~~~~~~~~~~~~~~~~~~~~~

These properties will be resolved at design-time during Feed creation from Template. They use the following notation ``${property-name}``.
If you had ``property-name=value`` in application.properties and ``${property-name}`` in Template then static ``value`` would be placed
into Processor field in Nifi on Feed creation.

You can also provide nested properties or properties which refer to other properties ``${property-name2.${property-name1}}``
If you had ``property-name1=value1`` and ``property-name2.value1=value2`` in application.properties and
``${property-name1.${property-name2}}`` in Template then static ``value2`` would be placed into Processor field in Nifi on Feed creation.

.. note:: This type of resolution is great for properties which do not support Nifi's Expression Language.


2.2 Runtime or Partial Resolution
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you don't want to resolve properties at design time and would rather take advantage of property resolution at runtime by Nifi's
Expression Language then you can still refer to properties in Kylo Feeds and Template, just escape them with a dollar sign ``$`` like so:
``$${config.${metadata.feedName}.input-dir}``. Notice the double dollar sign at the start. This property will be resolved at
design-time to ``${config.<feed-name>.input-dir}`` and will be substituted at runtime with a value from ``application.properties`` file.
So if you had a feed called ``users`` and ``config.users.input-dir=/var/dropzone/users`` in ``application.properties`` then at
runtime the feed would take its data from ``/var/dropzone/users`` directory.


|image3|

.. note:: This type of resolution is great for creating separate configurations for multiple feeds created from the same template



.. |image1| image:: ../media/kylo-config/properties/config-property.png
    :width: 4.87500in
    :height: 1.91667in
.. |image2| image:: ../media/kylo-config/properties/metadata-property.png
    :width: 4.87500in
    :height: 1.91667in
.. |image3| image:: ../media/kylo-config/properties/runtime-property.png
    :width: 4.87500in
    :height: 1.91667in
