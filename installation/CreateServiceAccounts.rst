=======================
Create Service Accounts
=======================

Creation of users and groups is done manually because many organizations have their own user and group management system. Therefore we cannot script it as part of the RPM install.

.. note:: Each of these should be run on the node on which the software will be installed. If a machine will run nifi, kylo, activemq and vault, all users/groups should be created.
          If running individual services, only the appropriate user/group for that service should be created, not all of them.

Option 1: Install all users/groups on single node
--------------------------------------------------
To create all the users and groups on a single machine, run the following command:

.. code-block:: shell

    useradd -r -m -s /bin/bash nifi && useradd -r -m -s /bin/bash kylo && useradd -r -m -s /bin/bash activemq

..

Option 2: Run individual useradd commands
-----------------------------------------
If you are installing the Kylo components on different nodes you will need to run the commands individually. To create individual
users, run the following commands on the appropriate machines:

.. code-block:: shell

  useradd -r -m -s /bin/bash nifi
  useradd -r -m -s /bin/bash kylo
  useradd -r -m -s /bin/bash activemq

..

The following command can be used to confirm if the user and group creation was successful:

.. code-block:: shell

  grep 'nifi\|kylo\|activemq' /etc/group /etc/passwd
..

This command should give two results per user, one for the user in /etc/passwd and one in /etc/group.
For example, if you added all the users to an individual machine, there should be six lines of output.
If you just added an individual user, there will be two lines of output.

If the groups are missing, they can be added individually:

.. code-block:: shell

   groupadd -f kylo
   groupadd -f nifi
   groupadd -f activemq
..

If all groups are missing, they can be all added with the following command:

.. code-block:: shell

  groupadd -f kylo && groupadd -f nifi && groupadd -f activemq
..
