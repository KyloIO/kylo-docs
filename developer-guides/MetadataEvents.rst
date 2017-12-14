======
Events
======

Kylo publishes events to a message bus that you can subscribe to and react to changes in the system with custom plugins.

Below is a listing of the events Kylo publishes.

+-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Event                       | Description                                                                                                                                                                                                                                                                                                               |
+=============================+===========================================================================================================================================================================================================================================================================================================================+
| CategoryChangeEvent         | Called when a Category is created, updated, or deleted                                                                                                                                                                                                                                                                    |
+-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| FeedChangeEvent             | Called when a Feed is created, updated, or deleted                                                                                                                                                                                                                                                                        |
+-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| FeedPropertyChangeEvent     | Called when a user updates the generic set of properties on a feed. See the Nifi processor `PutFeedMetadata <https://github.com/Teradata/kylo/blob/master/integrations/nifi/nifi-nar-bundles/nifi-core-bundle/nifi-core-processors/src/main/java/com/thinkbiganalytics/nifi/v2/metadata/PutFeedMetadata.java>`_           |
+-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| PreconditionTriggerEvent    | Called when a precondition is fired for a feed                                                                                                                                                                                                                                                                            |
+-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| CleanupTriggerEvent         | Called when a feed is being cleaned up after a delete                                                                                                                                                                                                                                                                     |
+-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| FeedOperationStatusEvent    | Called when a Job for a feed has started, stopped, succeeded, failed, or been abandoned                                                                                                                                                                                                                                   |
+-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| TemplateChangeEvent         | Called when a Template is created, updated, or deleted                                                                                                                                                                                                                                                                    |
+-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ServiceLevelAgreementEvent  | As of Kylo 0.8.4,  Called only when an SLA is deleted.                                                                                                                                                                                                                                                                    |
+-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+


Event Source
============
All events extends the `AbstractMetadataEvent` object.
You can find relevant source code for the events here:  https://github.com/Teradata/kylo/tree/master/metadata/metadata-api/src/main/java/com/thinkbiganalytics/metadata/api/event


Example Feed Change Listener
============================


 .. code-block:: java

    import com.thinkbiganalytics.metadata.api.event.MetadataChange;
    import com.thinkbiganalytics.metadata.api.event.MetadataEventListener;
    import com.thinkbiganalytics.metadata.api.event.MetadataEventService;
    import com.thinkbiganalytics.metadata.api.event.feed.FeedChangeEvent;
    import com.thinkbiganalytics.metadata.api.event.feed.FeedOperationStatusEvent;
    import com.thinkbiganalytics.metadata.api.feed.Feed;
    import com.thinkbiganalytics.metadata.api.op.FeedOperation;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    import org.springframework.stereotype.Component;

    import java.util.Optional;

    import javax.annotation.Nonnull;
    import javax.annotation.PostConstruct;
    import javax.inject.Inject;

    @Component
    public class ExampleFeedListener {

        private static final Logger log = LoggerFactory.getLogger(ExampleFeedListener.class);

        @Inject
        private MetadataEventService metadataEventService;

        /**
         * Listen for when feeds change
         */
        private final MetadataEventListener<FeedChangeEvent> feedPropertyChangeListener = new FeedChangeEventDispatcher();


        /**
         * Listen for when feed job executions change
         */
        private final MetadataEventListener<FeedOperationStatusEvent> feedJobEventListener = new FeedJobEventListener();


        @PostConstruct
        public void addEventListener() {
            metadataEventService.addListener(feedPropertyChangeListener);
            metadataEventService.addListener(feedJobEventListener);
        }

        private class FeedChangeEventDispatcher implements MetadataEventListener<FeedChangeEvent> {

            @Override
            public void notify(@Nonnull final FeedChangeEvent metadataEvent) {

                //feedName will be the 'categorySystemName.feedSystemName'
                Optional<String> feedName = metadataEvent.getData().getFeedName();

                //the id for the feed
                Feed.ID feedId = metadataEvent.getData().getFeedId();

                //feed state will be NEW, ENABLED, DISABLED, DELETED
                Feed.State feedState = metadataEvent.getData().getFeedState();

                if (feedName.isPresent()) {
                    log.info("Feed {} ({}) has been {} ", feedName.get(), feedId, metadataEvent.getData().getChange());
                    Feed.State state = metadataEvent.getData().getFeedState();
                    if (metadataEvent.getData().getChange() == MetadataChange.ChangeType.CREATE) {
                        //Do something on Create
                    } else if (metadataEvent.getData().getChange() == MetadataChange.ChangeType.UPDATE) {
                        //Do something on Update
                    } else if (metadataEvent.getData().getChange() == MetadataChange.ChangeType.DELETE) {
                        //Do something on Delete
                    }



                }
            }
        }

        private class FeedJobEventListener implements MetadataEventListener<FeedOperationStatusEvent> {

            @Override
            public void notify(FeedOperationStatusEvent event) {

                //feedName will be the 'categorySystemName.feedSystemName'
                String feedName = event.getData().getFeedName();

                //the id for the feed
                Feed.ID feedId = event.getData().getFeedId();

                //This is the Job Execution Id
                FeedOperation.ID jobId = event.getData().getOperationId();

                //this is {STARTED, SUCCESS, FAILURE, CANCELED, ABANDONED}
                FeedOperation.State jobState = event.getData().getState();

                //this is CHECK  or  FEED.   CHECK refers to a Data Confidence Job
                FeedOperation.FeedType feedType = event.getData().getFeedType();

                //a string message of what the event is for
                String statusMessage = event.getData().getStatus();

                if(event.getData().getState() == FeedOperation.State.SUCCESS){
                    // Do something if a Job successfully completes
                }
            }
        }


    }

 ..