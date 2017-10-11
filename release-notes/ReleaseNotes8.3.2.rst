Release 0.8.3.2 (October 10, 2017)
==================================

Highlights
----------
- New configuration option added to the `auth-ad` security profile to control user details filtering (addresses Windows 365 issues)


Download Links
--------------

 - RPM : `<http://bit.ly/2xyb8sL>`__

 - Debian : `<http://bit.ly/2ybrIkf>`__

 - TAR : `<http://bit.ly/2i16PUQ>`__

Upgrade Instructions from v0.8.3 & v0.8.3.1
-------------------------------------------

Build or `download the RPM <http://bit.ly/2xgHsUM>`__

1. Install the new RPM:

 .. code-block:: shell

     rpm –ivh <RPM_FILE>

 ..

2. If using the ``auth-ad`` profile and having problems with accessing user info in AD (experienced by some Windows 365 deployments), add the following property to the existing AD properties 
in both kylo-services and kylo-ui application.properties files:

 .. code-block:: shell

   security.auth.ad.server.searchFilter=(&(objectClass=user)(sAMAccountName={1}))

 ..

