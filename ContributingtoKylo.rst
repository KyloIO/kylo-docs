
====================
Contributing to Kylo
====================
  

Introducing New Functionality
=============================

Before contributing new functionality or bug fixes to the code base,
please consider how these changes may impact other projects using the
framework, and whether these changes can be considered overall
enhancements or merely enhancements need by your particular project. 
There are three basic methods of introducing new functionality: custom
plugins, a point release, and the next major release.

Plugins - Customizations for Clients
------------------------------------

Plugins are the preferred way of adding, swapping, or enhancing
functionality in the system.  We use Spring to integrate all components,
and most components and services have well-defined interfaces that allow
a plugin to override existing component implementations if necessary, or
to add new components and services that interact with the existing
services.  Plugins are JAR files developed using R&D APIs that provide
extensibility intended by the framework.

Plugins should be developed in a separate git repository unless the
plugin is intended to be maintained with the core project.

Client-specific code should go into a client project.  POMs should
reference R&D artifacts such as API libraries.

Point Release
-------------

A point release is the next best way to include new contributions driven
by project needs that cannot be implemented as a plugin.  Whenever a
major release is created a point release branch is also created for
releases that are required (if any) before the next major release. 
Generally, these are important bug fixes, but may include required
functionality that, due to project constraints, have to be deployed
sooner. 

For example, say a new release is created with version 1.1.0.  After the
release there will be a v1.1.0 tag in the git repository and a 1.1.0
release deployed to Art factory.  Additionally, the project POMs in the
master branch will be versioned to 1.2.0-SNAPSHOT and a point release
branch, called v1.1, will POM versions of 1.1.1-SNAPSHOT. 

If you are working on a project that includes accelerator assets (like
Pipeline Controller) you **MUST** deploy a major release of the
software.  If there are new changes required due to bugs found or
missing functionality, then contributing those fixes to a point release
branch first may be your best option.  New point releases are generally
created on a case-by-case basis due to demand, so changes made in a
point release will usually be available more quickly.  Additionally,
your changes will be more isolated initially which may reduce the chance
of conflict with more major changes that may be going on in the master
branch.

Major Release
-------------

If the new features being introduced are a major improvement, and those
feature can wait until the next major release, then they can be added
directly to the master branch.  Of course changes added to master will
undergo more scrutiny and have a greater chance of conflicting with
other major changes in progress, or even new architectural directions
being made.  This may increase the chances of your proposed changes of
being rejected.

Pull Requests
-------------

If you are contributing to the master branch or point release branch
your changes must be submitted in a pull request.  Generally, you will
be doing your work in a topic branch of your own and submitting the
request to pull those changes into the appropriate target branch.  Don't
forget to confirm the target branch (master or point release) before
submitting the request.  For instructions on creating pull requests
please see *Pull Requests*.

Review Criteria
===============

Before considering to contribute code, it's useful to understand how
code is reviewed, and how changes may be accepted. Simply put, changes
that have many or large positives, and few negative effects or risks,
are much more likely to be merged, and merged quickly. Risky and less
valuable changes are very unlikely to be merged, and may be rejected
outright rather than receive iterations of review.

Positives
---------

-  Fixes the root cause of a bug in existing functionality

-  Adds functionality or fixes a problem needed by a large number of
   users

-  Simple, targeted

-  Easily tested; has tests

-  Reduces complexity and lines of code

-  Change has already been discussed and is known to committers

-  Band-aids a symptom of a bug only

-  Introduces complex new functionality, especially an API that needs to
   be supported

-  Adds complexity that only helps a niche use case

-  Changes a public API or semantics (rarely allowed)

-  Adds large dependencies

-  Changes versions of existing dependencies

-  Adds a large amount of code

Negatives, Risks
----------------

-  Makes lots of modifications in one "big bang" change

-  Introduces complex new functionality, especially an API that needs to
   be supported

-  Adds complexity that only helps a niche use case

-  Changes a public API or semantics (rarely allowed)

-  Adds large dependencies

-  Changes versions of existing dependencies

-  Adds a large amount of code

-  Makes lots of modifications in one "big bang" change

 

JIRA
====

We use JIRA to track issues, including bugs and improvements, and GitHub
pull requests to manage the review and merge of specific code changes.
That is, JIRAs are used to describe what should be fixed or changed, and
high-level approaches, and pull requests describe how to implement that
change in the project's source code. For example, major design decisions
are discussed in JIRA.

1. Find the existing JIRA that the change pertains to.

   1. Do not create a new JIRA if creating a change to address an existing issue in JIRA; add to the existing discussion and
      work instead.

   2. Look for existing pull requests that are linked from the JIRA, to understand if someone is already working on the JIRA.

2. If the change is new, then it usually needs a new JIRA. However, trivial changes, where the "what should change" is virtually the same
   as the "how it should change" do not require a JIRA. Example: "Fix typos in doc".

3. If required, create a new JIRA:

   1. Provide a descriptive Title. "Update web UI" or "Problem in service" is not sufficient. "Thrift controller service broken pipe error after thrift service restart" is good.

   2. Write a detailed Description. For bug reports, this should ideally include a short reproduction of the problem. For new features, it may include a design document.

   3. Set required fields:

      1. **Issue Type**. Generally, Bug, Improvement and New Feature are the only types used.

      2. **Priority**. Set to Major or below; higher priorities are generally reserved for committers to set. JIRA tends to unfortunately conflate "size" and "importance" in its Priority field values. Their meaning is roughly:

        1. Blocker: pointless to release without this change as the release would be unusable to a large minority of users.

        2. Critical: a large minority of users are missing important functionality without this, and/or a workaround is difficult.

        3. Major: a small minority of users are missing important functionality without this, and there is a workaround.

        4. Minor: a niche use case is missing some support, but it does not affect usage or is easily worked around.

        5. Trivial: a nice-to-have change but unlikely to be any problem in practice otherwise. 

        6. **Component**

        7. **Affects Version**. For Bugs, assign at least one version that is known to exhibit the problem or need the change

        8. Do not set the following fields:

          1. Fix Version. This is assigned by committers only when resolved.

          2. Target Version. This is assigned by committers to indicate a PR has been accepted for possible fix by the target version.

4. Fork the GitHub repository.

5. Clone your fork, create a new branch, push commits to the branch.

6. Consider whether documentation or tests need to be added or updated as part of the change, and add them as needed.

7. Organize formats and format code ensuring it complies with style guide *Coding Conventions*.

8. Run all tests.

 

Reference: Partially adapted from \ `*Spark project* <https://cwiki.apache.org/confluence/display/SPARK/Contributing+to+Spark>`__

 

Pull Requests
=============

The Kylo team welcomes contributions from others inside Teradata or from
the open-source community. To get started, go to GitHub and fork the
`*data-lake-accelerator* <https://github.com/kyloio/kylo>`__
repository.

|image0|

This will create a copy of the repository under your personal GitHub
account with full write permissions. Now clone your repository and any
changes you make to your repository will only be visible to you.

Before you start
----------------

The easiest way to contribute code is to create a separate branch for
every feature or bug fix. This will allow you to make separate pull
requests for every contribution.

You can create your branch off our \ *master* branch to get the latest
code, or off a \ *release* branch if you need more stable code.

Every change you commit should refer to a \ `*JIRA
issue* <https://bugs.thinkbiganalytics.com/browse/PC/>`__ that describes
the feature or bug. Please open a JIRA issue if one does not already
exist.

Please review our \ `*Coding
Conventions* <http:///display/RD/Coding+Conventions>`__ and import our
style guide into your IDE.

Committing your change
----------------------

Ensure that your code has sufficient unit tests and that all unit tests
pass.

Your commit message should reference the JIRA issue and include a
sentence describing what was changed. An example of a good commit
message is "PC-826 Support for schema discovery of Parquet files."

Submitting a pull request
-------------------------

Once you are ready to have us add your changes to the
data-lake-accelerator repository, go to your repository in GitHub and
select the branch with your changes. Then click the *New pull request*
button.

|image1|

GitHub will generate a diff for your changes and determine if they can
be merged back into data-lake-accelerator. If your changes cannot be
automatically merged, please try manually merging the latest master
branch into your branch.

Also, please change the title to reference the JIRA issue and include a
sentence describing what was changed. The comment should either include
a link to the JIRA or describe the purpose of the commit.

.. |image0| image:: media/kylo-contributing/1_0doctheme.png
   :width: 4.87500in
   :height: 0.45833in
.. |image1| image:: media/kylo-contributing/2_new-pull-request.png
   :width: 4.87500in
   :height: 0.23958in
