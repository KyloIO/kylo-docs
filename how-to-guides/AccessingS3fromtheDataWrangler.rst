
===================================
Accessing S3 from the Data Wrangler
===================================

Problem
=======

You would like to access S3 or another Hadoop-compatible filesystem from
the data wrangler.

Solution
========

The Spark configuration needs to be updated with the path to the JARs
for the filesystem.

To access S3 on HDP, the following must be added to the spark-env.sh
file:

.. code-block:: shell

    export SPARK_DIST_CLASSPATH=$(hadoop classpath)

..

Additional information is available from the Apache Spark project:

    https://spark.apache.org/docs/latest/hadoop-provided.html
