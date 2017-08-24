=====================
Overview
=====================


Installation Methods
=====================
Kylo has 3 build distributions:

  - **RPM** - An easy and opinionated way of installing Kylo on Redhat based systems
  - **DEB** - An easy and opinionated way of installing Kylo on Debian based systems
  - **TAR File** – Available for those who want to install Kylo in a folder other than /opt/kylo, or want to run Kylo as a different user. See the :doc:`../installation/KyloTARFileInstallation`.

Once the binary is installed Kylo can be configured a few different ways:

  - **Setup Wizard** - For local development and single node development boxes, the :doc:`../installation/KyloSetupWizardDeploymentGuide` can be used to quickly bootstrap your environment to get you up and running.
  - **Manually Run Shell Scripts** - In a test and production environment, you will likely be installing on multiple nodes. The :doc:`../installation/KyloManualDeploymentGuide` provides detailed instructions on how to install each individual component.
  - **Configuration Management Tools** – Kylo installation is designed to be automated. You can leverage tools such as Ansible, Chef, Puppet, and Salt Stack

Demo Sandbox
==============
If you are interested in running a working example of Kylo you might consider running one of our demo sandboxes located on the http://kylo.io/quickstart.html website
