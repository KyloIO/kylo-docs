# Getting Started With Kylo Documentation
Kylo documents are stored in a seperate project and are published to ReadTheDocs

Below is the link to the test site

http://kylo-docs-test.readthedocs.io/en/latest/index.html

The documents are created using the RestructuredText format

http://docutils.sourceforge.net/docs/user/rst/quickstart.html

# How it works
1. You create or edit a document
2. Build and test the HTML file locally
3. Commit the file to Github
4. ReadTheDocs uses a Github hook to trigger a build on commit

# Install Sphinx and Pandoc

 $ brew install python

 $ sudo pip install sphinx

 $ sudo pip install sphinx-autobuild
 
 $ pip install sphinx_rtd_theme

Download Pandoc

The open source application Pandoc is useful for this conversion. Download the appropriate Pandoc package from https://github.com/jgm/pandoc/releases/tag/1.19.1 .
Install Pandoc

Use Homebrew and run this command:

 $ homebrew: brew install pandoc

# Adding Documents
There are two methods for creating new documents.

1. Create a word document and convert to RST.
2. Start from RST directly.

### Option 1: Convert Docx to RST

1. Author a word document.
2. Run Pandoc to convert.

 $ pandoc -f docx NameofFile.docx -t rst -o NameofFile.rst

3. Once the new .rst file is created, all additional editing is done in that file using reStructuredText syntax.
4. Run "make html" to rebuild the HTML locally.
5. View the index.html file in the _build folder to view the local build.
6. Commit and push your changes

### Option 2: Start with RST

1. Create an RST document by making a new file with the "rst" extension.
2. Run "make html" to rebuild the HTML locally.
3. View the index.html file in the _build folder to view the local build.
4. Commit and push your changes
