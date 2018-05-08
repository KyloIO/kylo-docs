Remote Process Groups
=====================
Kylo supports Remote Process Groups starting with Kylo 0.9.1.  Remote Process Group's allow flows to transfer data from one NiFi instance to another.  This is useful when you want to parallelize flow processing and leverage more processing in your NiFi Cluster.

Kylo allows you to link a given Feed Template http://kylo.readthedocs.io/en/latest/tips-tricks/KyloBestPractices.html#template-re-use that has a Remote Process Group to any reusable template http://kylo.readthedocs.io/en/latest/tips-tricks/KyloBestPractices.html#reusable-flows in your NiFi cluster.

Flows that use `Remote Process Group's` require two templates
 1. A reusable flow with an input port
 2. A feed template that contains the Remote Process Group. Once registered with Kylo this template will be able to transfer its running flow data to another NiFi node



Remote Process Groups connect to an `input port` that lives on the parent/root "NiFi Flow" canvas level.
If you have a Clustered NiFi, when you register a `Reusable Template` you will see a third option `Remote Process Group Aware` appear when you are importing the template.
When check this box Kylo will import the flow, create the reusable instance, and also create the connecting input port(s) on the parent/root NiFi Flow canvas

|image1|


Upon importing the reusable template you will be prompted to select the input ports from the flow that you wish to make available for the Remote Process Group(s) in the feed templates.

|image2|

The Input Port's you select will be added to the parent NiFi canvas and connect into this reusable template

|image3|


Once you have the reusable template created with the Remote Input Port you can then import the feed template with the Remote Process Group that connects to this template.
The `Additional Inputs` step will have your remote process groups visible and let you modify its properties.  This is where you can change the targetUris, username, transport protocol, etc.

|image3|

*Note* the `targetUris` property is used just to make the connection into the NiFi cluster.  From that point forward it will be able to talk to any of the nodes in the cluster.


When you are registering the template it will validate to ensure it is able to make the connection from the Remote Process Group(s) to its connecting input port.
If it's not able to make the connection it will notify you with an error message.

|image5|


Now that the two templates are registered and wired to communicate with each other you can start creating feeds.

|image6|

Helpful links

https://community.hortonworks.com/articles/16461/nifi-understanding-how-to-use-process-groups-and-r.html



.. |image1| image:: ../media/remote-process-groups/rpg1.png
   :width: 1021px
   :height: 547px

.. |image2| image:: ../media/remote-process-groups/rpg2.png
   :width: 1030px
   :height: 893px

.. |image3| image:: ../media/remote-process-groups/rpg3.png
   :width: 770px
   :height: 581px

.. |image4| image:: ../media/remote-process-groups/rpg4.png
   :width: 1351px
   :height: 859px

.. |image5| image:: ../media/remote-process-groups/rpg5.png
   :width: 1351px
   :height: 859px

.. |image6| image:: ../media/remote-process-groups/rpg6.png
   :width: 1025px
   :height: 398px
