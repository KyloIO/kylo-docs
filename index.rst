.. Kylo Operations Guide documentation master file, created by
   sphinx-quickstart on Wed Jan  4 19:21:44 2017.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

===========================
Welcome to the Kylo Project
===========================

Kylo is a comprehensive open-source Data Lake platform built-on Apache Hadoop, Spark, and NiFi.

The documentation for the site is organized into a few sections:

* :ref:`getting-started`
* :ref:`user-docs`
* :ref:`designer-docs`
* :ref:`operations-docs`
* :ref:`installation-docs`
* :ref:`developer-docs`

.. _getting-started:

.. toctree::
   :maxdepth: 1
   :caption: Getting Started

   KyloFrequentlyAskedQuestions
   KyloFeatures
   KyloTerminology
   KyloDependencies

.. _user-docs:

.. toctree::
   :maxdepth: 1
   :caption: User Documentation
   :titlesonly:

   FeedLineage

.. _designer-docs:

.. toctree::
   :maxdepth: 1
   :caption: Designer Documentation

   KyloBestPractices
   ImportSqoop_Processor
   Postgres_Hive_Metadata_Configuration

.. _operations-docs:

.. toctree::
   :maxdepth: 1
   :caption: Operations Documentation
   :titlesonly:

   KyloOperationsGuide
   KyloConfiguration

.. _installation-docs:

.. toctree::
   :maxdepth: 2
   :caption: Installation Documentation
   :titlesonly:

   KyloDeploymentChecklist
   KyloDeploymentGuide
   KyloManualDeploymentGuide
   KyloSetupWizardDeploymentGuide
   KyloTARFileInstallation
   NiFiKyloProvenanceReportingTask

   ConfigNififorHDFSEncryption
   SuseConfigurationChanges

   KylosConfigurationforaKerborosCluster
   NiFiConfigurationforaKerberosCluster
   KerberosHDP
   HDP25ClusterDeploymentGuide
   KerberosInstallationExample-Cloudera

   EnableRangerAuthorizationGuide
   EnableSentryAuthorizationGuide
   SentryInstallationGuide

.. _developer-docs:

.. toctree::
   :maxdepth: 1
   :caption: Developer Documentation
   :titlesonly:

   KyloDeveloperGuide
   ContributingtoKylo
   SetupaNiFiClusterinaKyloSandbox
   HortonworksSandboxConfiguration
   ClouderaDockerSandboxDeploymentGuide

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
