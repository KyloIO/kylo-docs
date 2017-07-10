===================
Feed Wizard Plugins
===================

Overview
========

Additional steps can be added to the Create Feed and Feed Details pages with a Feed Wizard plugin. A plugin will have access to the feed's metadata to add or modify properties.

Two plugins are included with Kylo: Data Ingest and Data Transformation. The Data Ingest plugin adds steps to define a destination Hive table. The Data Transformation plugin adds steps to generate a
Spark script that transforms the data. Both of these plugins can be used as examples.

Plugin Definition
=================

The plugin is discovered by providing a jar that contains a Spring bean in the kylo-ui app (/opt/kylo/kylo-ui/plugin/). A built-in REST API makes the bean available to JavaScript which loads the template URLs
when requested.

The metadata properties should reference a |feedMetadataLink| property using JSON dot notation.

.. code-block:: java

    import com.thinkbiganalytics.ui.api.template.TemplateTableOption

    public class MyPlugin extends TemplateTableOption {

        // A human-readable summary of this option.
        // This is displayed as the hint when registering a template.
        public String getDescription() {
            return "Example of a Feed Wizard plugin.";
        }

        // A human-readable title of this option.
        // This is displayed as the title of this option when registering a template.
        public String getDisplayName() {
            return "My Plugin";
        }

        // Template URL containing sections for viewing or editing a feed.
        public String getFeedDetailsTemplateUrl() {
            return "/my-plugin-1.0/my-plugin-feed-details.html";
        }

        // List of metadata properties that can be used in NiFi property expressions.
        public List<AnnotatedFieldProperty<MetadataField>> getMetadataProperties() {
            AnnotatedFieldProperty<MetadataField> property = new AnnotatedFieldProperty<>();
            property.setName("metadata.tableOption.myPluginProperty");
            property.setDescription("My Plugin property");
            return Collections.singletonList(property);
        }

        // Template URL containing steps for creating or editing a feed.
        public String getStepperTemplateUrl() {
            return "/my-plugin-1.0/my-plugin-stepper.html";
        }

        // Number of additional steps for creating or editing a feed.
        public int getTotalSteps() {
            return 1;
        }

        // A unique identifier for this option.
        public String getType() {
            return "MY_PLUGIN";
        }
    }

.. |feedMetadataLink| raw:: html

    <a href="https://github.com/Teradata/kylo/blob/master/services/feed-manager-service/feed-manager-rest-model/src/main/java/com/thinkbiganalytics/feedmgr/rest/model/FeedMetadata.java" target="_blank">FeedMetadata</a>
