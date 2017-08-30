.. Kylo Operations Guide documentation master file, created by
   sphinx-quickstart on Wed Jan  4 19:21:44 2017.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

===========================
Welcome to the Kylo Project
===========================

|image1| Kylo website: |kylo_io_link|

The documentation for the site is organized into a few sections:

* :ref:`about_toc`
* :ref:`installation_toc`
* :ref:`installation_examples_toc`
* :ref:`common_configuration_toc`
* :ref:`security_toc`
* :ref:`how_to_guides`
* :ref:`developer_guides`
* :ref:`user_guides`
* :ref:`tips_tricks`

.. _about_toc:
.. toctree::
    :maxdepth: 1
    :caption: About

    about/KyloFeatures
    about/KyloFrequentlyAskedQuestions
    about/KyloTerminology
    release-notes/ReleaseNotes
    about/Downloads

.. _installation_toc:
.. toctree::
    :maxdepth: 1
    :caption: Installation

    installation/Overview
    installation/Dependencies
    installation/DeploymentChecklist
    installation/CreateServiceAccounts
    installation/PrepareOfflineTar
    installation/InstallKylo
    installation/InstallAdditionalKyloComponents
    installation/EnableKerberos
    installation/AdditionalConfiguration
    installation/GrantHdfsPrivileges
    installation/StartServices
    installation/ImportTemplates
    installation/RunSampleFeed
    installation/ValidateConfiguration


.. _installation_examples_toc:
.. toctree::
    :maxdepth: 1
    :caption: Installation Examples

    installation/HDP25ClusterDeploymentGuide

.. _common_configuration_toc:
.. toctree::
    :maxdepth: 1
    :caption: Common Configuration

    common-config/Overview
    common-config/AdjustMemory
    common-config/ChangeJavaHome
    common-config/LogFiles
    common-config/YarnClusterConfiguration
    common-config/KyloSparkProperties
    common-config/Postgres_Hive_Metadata_Configuration

.. _security_toc:
.. toctree::
    :maxdepth: 1
    :caption: Security

    Overview <security/Overview>
    Encrypt Passwords <security/EncryptingConfigurationProperties>
    Kylo Kerberos <security/KerberosKyloConfiguration>
    NiFi Kerberos <security/KerberosNiFiConfiguration>
    Ranger <security/EnableRangerAuthorizationGuide>
    Sentry <security/EnableSentryAuthorizationGuide>
    SSL for Kylo <security/KyloUIWithSSL>
    SSL for NiFi <security/ConfigureNiFiWithSSL>
    Authentication <security/Authentication>
    Kerberos SPNEGO <security/KyloKerberosSPNEGO>
    Access Control <security/AccessControl>
    Hive User Impersonation <security/KyloUserImpersonation.rst>


.. _how_to_guides:
.. toctree::
    :maxdepth: 1
    :caption: How to guides

    NiFi Cluster <how-to-guides/SetupaNiFiClusterinaKyloSandbox>
    Kylo Cluster <how-to-guides/KyloClusterConfiguration>
    NiFi & HDFS Encryption <how-to-guides/ConfigNififorHDFSEncryption>
    NiFi & Kylo Provenance <how-to-guides/NiFiKyloProvenance>
    NiFi & Kylo Reporting Task (deprecated) <how-to-guides/NiFiKyloProvenanceReportingTask>
    Nifi Processors <how-to-guides/NiFiProcessorsDocs>
    Kylo Templates <how-to-guides/KyloTemplatesDocs>
    Kylo Datasources <how-to-guides/KyloDatasources>
    Feed Lineage <how-to-guides/FeedLineage>
    S3 & Data Wrangler <how-to-guides/AccessingS3fromtheDataWrangler>
    S3 Data Ingest Template <how-to-guides/S3DataIngestTemplate.rst>
    SUSE Configuration <how-to-guides/SuseConfigurationChanges>
    Configuration Properties <how-to-guides/ConfigurationProperties>
    Validator Tuning <how-to-guides/ValidatorTuning>
    Kylo & Global Search <how-to-guides/ConfigureKyloForGlobalSearch>
    Service Monitor Plugins <how-to-guides/ServiceMonitorPlugins>
    JMS Providers <how-to-guides/JmsProviders>
    Database Upgrades <how-to-guides/DatabaseUpgrades>
    Icons and Colors <how-to-guides/KyloIconsAndColors>
    Spark Streaming Tutorial <how-to-guides/SparkStreamingTutorial>

.. _developer_guides:
.. toctree::
    :maxdepth: 1
    :caption: Developer guides

    Developer Guide <developer-guides/KyloDeveloperGuide>
    Contributing <developer-guides/ContributingtoKylo>
    Plugin APIs <developer-guides/PluginApiIndex>
    REST API <developer-guides/KyloRestApi>
    Enable Kerberos HDP <developer-guides/KerberosInstallationExampleHDP2.4>

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
    installation/Dependencies
    installation/ClouderaDockerSandboxDeploymentGuide
    installation/HDP25ClusterDeploymentGuide
    installation/HortonworksSandboxConfiguration
    installation/KerberosInstallationExample-Cloudera
    installation/YarnClusterConfiguration
    installation/KyloDependencies
    installation/ManualDeploymentGuide
    installation/SetupWizardDeploymentGuide
    installation/KyloTARFileInstallation
    installation/KylosConfigurationforaKerborosCluster
    installation/NiFiConfigurationforaKerberosCluster
    installation/Postgres_Hive_Metadata_Configuration

.. |kylo_io_link| raw:: html

   <a href="https://kylo.io" target="_blank">https://kylo.io</a>
