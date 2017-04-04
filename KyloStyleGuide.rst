====================
Kylo rST Style Guide
====================


Titles
======

The contents of each rST file begins with a Title, formatted with =
signs above and below the words and spaces in the title.

|image0|

There must be as many = signs as there are words and spaces.

This syntax produces this title in the Kylo Read-the-Docs site:

|image1|

Headings
========

The Kylo documentation uses the following heading syntax to produce the
following outputs:

Heading 1
---------

|image2|

|image3|

Heading 2
---------

|image4|

|image5|

Heading 3
---------

|image6|

Heading 4
---------

|image7|

Boldface
--------

Add two asterisks before and after the word you wish to boldface. For
example:

\*\*Setup Wizard\*\*

Reference a Document within the Kylo Read-the-Docs Site
=======================================================

The :doc: directive can be used to create a link to another document in
the Kylo RTD library:

|image8|

In the Kylo RTD output, this directive produces this (see the link
embedded in the paragraph):

|image9|

When the user clicks the *Setup Wizard Deployment Guide* link, the
document opens in a new tab in the browser.

External Links
==============

External links are done using the raw syntax, which opens the link in a
separate tab, leaving the Read the Docs page open.:

|image10|

That link syntax can be used standalone code, or it can be embedded in
text as in the following example. Either way, it produces the same
output in the Kylo RTD site.

Notice how the above rst syntax displays in the Kylo RTD site.

|image11|

This syntax requires that the link be specified with the following rst
syntax, which is included at the bottom of the rst source file:

|image12|

Bulleted Lists
==============

Bulleted lists may be indented or not, using this sample syntax:

|image13|

The above syntax produces this output:

|image14|

Notes, Tips, Warnings…
======================

A variety of special formats are available through one-word directives,
each of which produces a box (examples) below with a color scheme
determined by the theme. (Note that Kylo uses the RTD Theme.)

Starting flush left, the directive is stated as in this example:

|image15|

This produces the following note:

|image16|

Changing the key word (e.g., note, error, important, tip, waring)
changes the output, as shown in the following examples:

|image17|

|image18|

|image19|

|image20|

Code-Block
==========

Various code-block directives produce different results, highlighting words in ways appropriate to how the code-block is assigned (e.g., shell, properties, javascript, html)

Here is a code-block for standard coding, and the way it displays on the Kylo RTD site:

|image21|

|image22|

And here is code-block for displaying code properties:

|image23|

|image24|

And here is code-block for displaying inline code, as shown below:

|image25|

|image26|

.. |image0| image:: media/StyleGuideImages/Titles.png
   :width: 2.75000in
   :height: 0.73913in
.. |image1| image:: media/StyleGuideImages/TitlesRTD.png
   :width: 4.50000in
   :height: 0.74010in
.. |image2| image:: media/StyleGuideImages/Heading1.png
   :width: 2.75000in
   :height: 0.49438in
.. |image3| image:: media/StyleGuideImages/Heading1RTD.png
   :width: 4.50000in
   :height: 0.64628in
.. |image4| image:: media/StyleGuideImages/Heading2.png
   :width: 2.75000in
   :height: 0.71765in
.. |image5| image:: media/StyleGuideImages/Heading2RTD.png
   :width: 4.25000in
   :height: 0.80625in
.. |image6| image:: media/StyleGuideImages/Heading3.png
   :width: 3.12500in
   :height: 0.81667in
.. |image7| image:: media/StyleGuideImages/Heading4.png
   :width: 3.12500in
   :height: 0.78348in
.. |image8| image:: media/StyleGuideImages/Docref.png
   :width: 5.81944in
   :height: 0.43056in
.. |image9| image:: media/StyleGuideImages/DocrefRTD.png
   :width: 6.00000in
   :height: 0.73472in
.. |image10| image:: media/StyleGuideImages/Externalref.png
   :width: 2.04167in
   :height: 0.40278in
.. |image11| image:: media/StyleGuideImages/ExternalrefRTD.png
   :width: 6.00000in
   :height: 0.62083in
.. |image12| image:: media/StyleGuideImages/Externalrefspec.png
   :width: 6.00000in
   :height: 0.88056in
.. |image13| image:: media/StyleGuideImages/Bulleted.png
   :width: 6.00000in
   :height: 2.19514in
.. |image14| image:: media/StyleGuideImages/BulletedRTD.png
   :width: 6.00000in
   :height: 1.56806in
.. |image15| image:: media/StyleGuideImages/Note.png
   :width: 6.00000in
   :height: 0.42569in
.. |image16| image:: media/StyleGuideImages/NoteRTD.png
   :width: 6.00000in
   :height: 0.82708in
.. |image17| image:: media/StyleGuideImages/ErrorRTD.png
   :width: 6.00000in
   :height: 0.81528in
.. |image18| image:: media/StyleGuideImages/ImportantRTD.png
   :width: 6.00000in
   :height: 1.05833in
.. |image19| image:: media/StyleGuideImages/TipRTD.png
   :width: 6.00000in
   :height: 1.00556in
.. |image20| image:: media/StyleGuideImages/WarningRTD.png
   :width: 6.00000in
   :height: 1.04722in
.. |image21| image:: media/StyleGuideImages/Code_shell.png
   :width: 6.00000in
   :height: 1.04722in
.. |image22| image:: media/StyleGuideImages/shell.png
   :width: 6.00000in
   :height: 1.04722in
.. |image23| image:: media/StyleGuideImages/Code_properties.png
   :width: 6.00000in
   :height: 1.04722in
.. |image24| image:: media/StyleGuideImages/propertiesshell.png
   :width: 6.00000in
   :height: 1.04722in
.. |image25| image:: media/StyleGuideImages/inlinecode.png
   :width: 6.00000in
   :height: 1.04722in
.. |image26| image:: media/StyleGuideImages/inlinecodeRTD.png
   :width: 6.00000in
   :height: 1.04722in
