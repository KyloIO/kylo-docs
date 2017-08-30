Writing Spark Function Definitions
==================================

Tern defines the definitions file format for displaying the list of functions, providing auto-completion, and showing hints. Kylo extends this format by providing additional fields that describe how to convert the function into Scala code.

The definitions are loaded from json files matching :code:`*spark-functions.json` in the Kylo classpath and merged into a single document to be used by the Kylo UI. Duplicate functions are ignored.

Data Types
----------

An expression may consist of may different data types but the end result is to produce a *DataFrame*.

**Arrays**

An array is a collection of zero or more literals of the same type.

**Booleans**

A Boolean value is either *true* or *false*.

**Columns**

A *Column* is an object that represents a *DataFrame* column. It has an optional *alias* property which defines the name of the column.

**Numbers**

Numbers can be either literal integers or floating-point values. They will be automatically converted to a *Column* if required.

**Objects**

An Object is any Scala class type. No conversions are performed on objects.

**Strings**

Strings should be enclosed in double quotes. They are automatically converted to a *Column* if required.

Definitions
-----------

Function definitions are declared in a JSON document that maps a function name to a definition. Each definition is an object with special directives indicating the function arguments, return value, documentation, and a Spark conversion string. The JSON document also has a special directive with the name of the document.

.. code-block:: javascript

   {
     "!name": "ExampleDefinition",
     "add": {
       "!type": "fn(col1: Column, col2: Column) -> Column",
       "!doc": "Add two numbers together.",
       "!spark": "%c.plus(%c)"
       "!sparkType": "column"
     }
   }

The above document is named *ExampleDefinition* as declared by the :code:`!name` directive. It contains a single function named *add* and the :code:`!type` directive indicates it takes two *Column* arguments and outputs a *Column*. The strings for the :code:`!doc` and :code:`!type` directives will be displayed in the autocomplete menu. The :code:`!spark` directive defines the Spark conversion string for converting the expression to Spark code, and the :code:`!sparkType` directive indicates is produces a Column object.

Spark Conversion String Syntax
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The conversion string consists of literal characters that are copied as-is to the Spark code and conversion specifications that either consume one of the function arguments.

The conversion specifications have the following syntax:

.. code-block:: properties

    %[flags]conversion


**Conversion**

The following conversions are supported:

+----------------+--------------------------------------------------------------------+----------------------+
| Type Specifier | Description                                                        | Example Spark Result |
+================+====================================================================+======================+
| b              | Expects the argument to be a literal boolean, either *true* |br|   | true                 |
|                | or *false*. The result is a literal boolean.                       |                      |
+----------------+--------------------------------------------------------------------+----------------------+
| c              | The result is a *Column* object. All input types are |br|          | new Column("mycol")  |
|                | supported.                                                         |                      |
+----------------+--------------------------------------------------------------------+----------------------+
| d              | Expects the argument to be a literal integer. The result is a |br| | 123                  |
|                | literal integer.                                                   |                      |
+----------------+--------------------------------------------------------------------+----------------------+
| f              | Expects the argument to be a literal floating-point |br|           | 123.5                |
|                | number. The result is a literal double.                            |                      |
+----------------+--------------------------------------------------------------------+----------------------+
| o              | The result is a Scala object.                                      |                      |
+----------------+--------------------------------------------------------------------+----------------------+
| r              | The result is a *DataFrame* object.                                |                      |
+----------------+--------------------------------------------------------------------+----------------------+
| s              | Expects the argument to be a literal of any type. The |br|         | "myval"              |
|                | result is a literal string.                                        |                      |
+----------------+--------------------------------------------------------------------+----------------------+

**Flags**

The following flags are supported:

+-------+------------------------------------------------------------------------------------------------+----------------------------------------+
| Flag  | Description                                                                                    | Example Spark Result                   |
+=======+================================================================================================+========================================+
| ``?`` | The conversion is optional and will be ignored if |br|                                         |                                        |
|       | there are no more arguments left to consume.                                                   |                                        |
+-------+------------------------------------------------------------------------------------------------+----------------------------------------+
| ``*`` | The conversion should consume all remaining |br|                                               | new Column("arg1"), new Column("arg2") |
|       | arguments, if any. Useful for var-arg functions. |br|                                          |                                        |
+-------+------------------------------------------------------------------------------------------------+----------------------------------------+
| ``,`` | The conversion should begin with a comma.                                                      | , new Column("arg1")                   |
+-------+------------------------------------------------------------------------------------------------+----------------------------------------+
| ``@`` | The result is an array of the specified type.                                                  | Array("value1", "value2")              |
+-------+------------------------------------------------------------------------------------------------+----------------------------------------+

**Spark Types**

The :code:`!sparkType` directive indicates the type produced by the :code:`!spark` directive.

+-----------+----------------------------------------------------------------------------+
| Type      | Description                                                                |
+===========+============================================================================+
| array     | A Scala array.                                                             |
+-----------+----------------------------------------------------------------------------+
| column    | A Spark SQL *Column* object.                                               |
+-----------+----------------------------------------------------------------------------+
| dataframe | A Spark SQL *DataFrame* object.                                            |
+-----------+----------------------------------------------------------------------------+
| literal   | A Scala literal value.                                                     |
+-----------+----------------------------------------------------------------------------+
| transform | A function that takes a *DataFrame* and returns a *DataFrame*.             |
+-----------+----------------------------------------------------------------------------+

Any other type is assumed to be a class type.

Column Functions
----------------

These functions are instance methods of the *Column* class.

as
 :code:`fn ( alias: string ) -> Column` |br|
 Gives the column an alias.

cast
 :code:`fn ( to: string ) -> Column` |br|
 Casts the column to a different type.

over
 :code:`fn ( window: WindowSpec ) -> Column` |br|
 Define a windowing column.

Resources
---------

Additional information on the Tern JSON format is available in the |JsonTypeDefinitionsLink| section of the Tern docs.


.. |br| raw:: html

   <br/>

.. |JsonTypeDefinitionsLink| raw:: html

   <a href="http://ternjs.net/doc/manual.html#typedef" target="_blank">JSON Type Definitions</a>
