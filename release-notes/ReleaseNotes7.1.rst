Release 0.7.1 (Mar 13, 2017)
============================

Highlights
----------


 - 64 issues resolved
 - UI performance.  Modules combined in a single page application and many other optimizations.
 - Lineage auto-alignment.  Correctly aligns feeds, sources, and destinations.
 - Wrangle and machine learning.  Added over 50 machine learning functions to the data wrangler. The data wrangler now supports over 600 functions!
 - Test framework. Initial groundwork for automated integration testing.
 - Notable issues resolved:
    - Multiple Spark validation and profiler issues resolved
    - Login issues when using https
    - Race condition on startup of Kylo and Modeshape service
 - For a complete list of resolved issues see here: :doc:`ReleaseNotes7.1.resolvedIssues`

RPM
---

|rpm_link|

Upgrade Instructions from v0.7.0
--------------------------------

Build or download the RPM: |rpm_link|

1. Uninstall the RPM, run:

.. code-block:: shell

    /opt/kylo/remove-kylo.sh

..

2. Install the new RPM:

.. code-block:: shell

     rpm –ivh <RPM_FILE>

..

3. Update the Database:

.. code-block:: shell

    /opt/kylo/setup/sql/mysql/kylo/0.7.1/update.sh localhost root <password or blank>

..

4. Start kylo apps:

.. code-block:: shell

    /opt/kylo/start-kylo-apps.sh

..


.. |rpm_link| raw:: html

   <a href="http://bit.ly/2mlqhZr" target="_blank">http://bit.ly/2mlqhZr</a>

