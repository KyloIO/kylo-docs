Release 0.8.3.3 (October 16, 2017)
==================================

Highlights
----------
- New configuration option added to the `auth-ad` security profile to control user details filtering (addresses Windows 365 issues)
- Fixes KYLO-1281 missing Kylo Upgrade Version

Download Links
--------------

Coming Soon

Upgrade Instructions from v0.8.3 & v0.8.3.1
-------------------------------------------

1. Install the new RPM:

 .. code-block:: shell

     rpm –ivh <RPM_FILE>

 ..

2. If using the ``auth-ad`` profile and having problems with accessing user info in AD (experienced by some Windows 365 deployments), add the following property to the existing AD properties 
in both kylo-services and kylo-ui application.properties files:

 .. code-block:: shell

   security.auth.ad.server.searchFilter=(&(objectClass=user)(sAMAccountName={1}))

 ..

