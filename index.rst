.. Kylo Operations Guide documentation master file, created by
   sphinx-quickstart on Wed Jan  4 19:21:44 2017.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

===========================
Welcome to the Kylo Project
===========================

|image1|

Capturing and processing big data isn’t easy.
Products such as Spark, Kafka, Hadoop, and NiFi are
great at processing immense data volumes at scale; however,
they are not easy for business users to access, create, optimize,
and analyze their data.  Kylo overcomes this challenge and
lets businesses easily create, configure
and monitor data pipelines in and through the data lake
so users have constant access to high quality data.
Kylo also enhances data profiling and discovery with
extensible metadata.

The documentation for the site is organized into a few sections:

* :ref:`quickstart`
* :ref:`about`
* :ref:`installation`
* :ref:`security_toc`
* :ref:`how_to_guides`
* :ref:`developer_guides`
* :ref:`user_guides`
* :ref:`tips_tricks`


.. _quickstart:
.. toctree::
    :maxdepth: 1
    :caption: Quickstart

    quickstart/QuickStart

.. _about:
.. toctree::
    :maxdepth: 1
    :caption: About

    about/KyloFeatures
    about/KyloFrequentlyAskedQuestions
    about/KyloTerminology

.. _installation:
.. toctree::
    :maxdepth: 1
    :caption: Installation

    installation/KyloDeploymentChecklist
    installation/KyloDeploymentGuide
    installation/InstallationConfigurationGuide

.. _security_toc:
.. toctree::
    :maxdepth: 1
    :caption: Security

    Access Control <security/AccessControl>
    Ranger <security/EnableRangerAuthorizationGuide>
    Sentry <security/EnableSentryAuthorizationGuide>
    Kerberos <security/KerberosHDP>
    Kerberos SPNEGO <security/KyloKerberosSPNEGO>

.. _how_to_guides:
.. toctree::
    :maxdepth: 1
    :caption: How to guides

    NiFi Cluster <how-to-guides/SetupaNiFiClusterinaKyloSandbox>
    NiFi & SSL <how-to-guides/ConfigureNiFiWithSSL>
    NiFi & HDF Encryption <how-to-guides/ConfigNififorHDFSEncryption>
    NiFi & Kylo Reporting Task <how-to-guides/NiFiKyloProvenanceReportingTask>
    how-to-guides/NiFiProcessorsDocs
    S3 & Data Wrangler <how-to-guides/AccessingS3fromtheDataWrangler>
    Feed Lineage <how-to-guides/FeedLineage>
    how-to-guides/SentryInstallationGuide
    SUSE Configuration <how-to-guides/SuseConfigurationChanges>

.. _developer_guides:
.. toctree::
    :maxdepth: 1
    :caption: Developer guides

    Developer Guide <developer-guides/KyloDeveloperGuide>
    Contributing <developer-guides/ContributingtoKylo>
    REST API <developer-guides/KyloRestApi>

.. _user_guides:
.. toctree::
    :maxdepth: 1
    :caption: User guides

    user-guides/KyloOperationsGuide

.. _tips_tricks:
.. toctree::
    :maxdepth: 1
    :caption: Tips and tricks

    tips-tricks/TroubleshootingandTips
    tips-tricks/KyloBestPractices


.. |image1| image:: media/common/kylo-logo-orange.png
    :width: 600px
    :height: 338px
    :scale: 50%
    :align: middle
    :alt: kylo logo


..  files that are not part of the toctree:
    how-to-guides/KyloIconsAndColors
    installation/KyloDependencies
    installation/ClouderaDockerSandboxDeploymentGuide
    installation/HDP25ClusterDeploymentGuide
    installation/HortonworksSandboxConfiguration
    installation/KerberosInstallationExample-Cloudera
    installation/KyloConfiguration
    installation/KyloDependencies
    installation/KyloManualDeploymentGuide
    installation/KyloSetupWizardDeploymentGuide
    installation/KyloTARFileInstallation
    installation/KylosConfigurationforaKerborosCluster
    installation/NiFiConfigurationforaKerberosCluster
    installation/Postgres_Hive_Metadata_Configuration




