=============================
Data Ingest - Teradata - TDCH
=============================

Kylo supports ingesting data into Teradata via TDCH (Teradata Connector For Hadoop).
This is enabled via Kylo's **TdchExportHiveToTeradata** NiFi processor.

To use this functionality, please follow these steps. These are documented for HDP, please follow similar approach for CDH.

1. Get TDCH

    - Download TDCH from Teradata's website. Kylo has been tested with TDCH version 1.5.4.
    - Link: https://downloads.teradata.com/download/connectivity/teradata-connector-for-hadoop-command-line-edition
    - Download from this or a more recent section: *Teradata Connector for Hadoop 1.5.4 (Command Line Edition)*


2. Install TDCH

    - This installs the connector at ``/usr/lib/tdch/1.5``
    - The JDBC drivers to access Teradata are also provided as part of the install.

    .. code-block:: shell

        $ rpm -ivh teradata-connector-1.5.4-hadoop2.x.noarch.rpm

        $ ls /usr/lib/tdch/1.5/lib
        tdgssconfig.jar
        teradata-connector-1.5.4.jar
        terajdbc4.jar
    ..


3. Copy JDBC drivers to a folder under NiFi

    .. code-block:: shell

        $ mkdir /opt/nifi/teradata
        $ cp /usr/lib/tdch/1.5/lib/tdgssconfig.jar /opt/nifi/teradata
        $ cp /usr/lib/tdch/1.5/lib/terajdbc4.jar /opt/nifi/teradata
        $ chown -R nifi:nifi /opt/nifi/teradata
    ..


4. Update Kylo Services configuration

    .. code-block:: shell

        $ vi /opt/kylo/kylo-services/conf/application.properties

    ..

    Set values for these properties under the section in the file named *Teradata Ingest via Kylo Template*

    .. code-block:: shell

        #default: jdbc:teradata://localhost
        nifi.service.standardtdchconnectionservice.jdbc_connection_url=jdbc:teradata://<hostname-of-box-running-teradata-db>

        #default: dbc
        nifi.service.standardtdchconnectionservice.username=<teradata-db-username>

        #default: <empty-value>
        nifi.service.standardtdchconnectionservice.password=<teradata-db-user-password>

        #default: /usr/lib/tdch/1.5/lib/teradata-connector-1.5.4.jar
        nifi.service.standardtdchconnectionservice.tdch_jar_path=</path/to/teradata-connector-jar>

        #defaut: /usr/hdp/current/hive-client/conf
        nifi.service.standardtdchconnectionservice.hive_conf_path=<path-to-hive-conf-dir>

        #default: /usr/hdp/current/hive-client/lib
        nifi.service.standardtdchconnectionservice.hive_lib_path=<path-to-hive-lib-dir>

        #default: file:///opt/nifi/teradata/terajdbc4.jar,file:///opt/nifi/teradata/tdgssconfig.jar
        nifi.service.kylo-teradata-dbc.database_driver_location(s)=<path-to-teradata-jdbc-driver-jars>
    ..

5. Restart Kylo Services

    .. code-block:: shell

        $ service kylo-services restart

    ..

6. Import Kylo template for Teradata Ingest

    - Locate the teradata ingest template. You can find it at one of these locations:

    .. code-block:: shell

        #Kylo installation:
        /opt/kylo/setup/data/templates/nifi-1.0/data_ingest__teradata.template.zip

        #Kylo codebase:
        /opt/kylo/setup/data/templates/nifi-1.0/data_ingest__teradata.template.zip

    ..

    - In Kylo UI:

        - Click in left nav pane: **Admin**
        - Click **Templates**
        - Click **+ Button**
        - Choose import method -> Select **Import from a file**
        - Click **Choose File**
        - Select **data_ingest__teradata.template.zip** from location identified in earlier step
        - Tick **Yes** for *Overwrite*
        - Tick **Yes** for *Import the reusable template*
        - Click **Import Template**
        - Ensure template is imported without errors.
        - If any errors, fix them and re-import.

7. Verify import of template

    - In Kylo UI:

        - Click in left nav pane: **Admin**
        - Click **Templates**
        - In the list of **Templates** in the main window, a template with name **Data Ingest - Teradata** should be available.

8. Create a Teradata Ingest Feed

    - (optional) Create a new category for Teradata Ingest feeds (Feed Manager -> Categories)
    - Create a new feed

        - Click **Feed Manager**
        - Click **Feeds**
        - Click **+ Button**
        - Select template **Data Ingest - Teradata**
        - Step through the feed create tabs as mentioned below.

    Feed Creation Stepper

    - Tab 1: General Info
        - Enter **Display Name**
        - Select **Category**
        - Enter **Description** (optional)
    - Tab 2: Feed Details
        - Select **Data Source** and provide its details as prompted on form
    - Tab 3: Table
        - Define the target table schema for Hive.
        - Teradata ingest will first land the data in Hive, and then export it to Teradata DB
        - Define partitioning strategy for Hive table
        - Define additional feed options
    - Tab 4: Data Processing
        - Define field policies for indexing, profiling, standardization, validation
        - Define merge strategy for Hive table
        - Define target format for Hive table
    - Tab 5: Properties
        - Provide business metadata via properties and tags
    - Tab 6: Access Control (if enabled in Kylo)
        - Provide Kylo access control policies for feed
    - Tab 7: Schedule
        - Define a feed schedule

    Click **Create** and ensure feed gets created successfully.

9. When the feed runs, it will ingest the data in Hive, and then export data from the final Hive table to Teradata. The job status can be tracked via Kylo Operations Manager.


Advanced configuration
======================

The template designer can override the default Teradata ingest parameters, and (optionally) allow feed creators to supply their own.
To do this, perform steps 1 to 7 as listed above. This would ensure the default teradata ingest template is available in Kylo. Then, proceed as below:

7a. Override the default ingest parameters.

    - In Kylo UI:

        - Click in left nav pane: **Admin**
        - Click **Templates**
        - Click **Data Ingest - Teradata**
        - Click **Continue to Step 2** on **Step 1: Select Template** step.
        - Click **Continue to Step 3** on **Step 2: Input Properties** step.
        - Click **Initialize Teradata Feed Parameters** menu item in Filter section on right side of page on **Step 3: Additional Properties**. Details below:

Initialize Teradata Feed Parameters
-----------------------------------

    - **Target Database**:
        - Determines target database to load data into
        - Default value: **Teradata**
        - Currently, only one option is supported.
        - Tick **Yes** for **Allow user input?** to allow users to provide a value
            - Render as: **Select**
            - If ingest to Teradata is to be skipped for any reason, users can select **Not Set** from dropdown during feed creation

    - **Teradata Database Create Options**
        - Defines database create parameters if it does not exist. The database will take the name of the feed's category.
        - Default value: **FROM dbc AS PERMANENT = 60000000, SPOOL = 120000000**
        - Modify the default value if needed.
        - Tick **Yes** for **Allow user input?** to allow users to provide a value
            - Render as: **Text**

    - **Teradata Export Batch Size**
        - Number of rows submitted in a batch, for insert into the DB.
        - Default value: **10000**
        - Modify the default value if needed. A positive integer is required.
        - Tick **Yes** for **Allow user input?** to allow users to provide a value
            - Render as: **Number**

    - **Teradata Export Force Staging**
        - Specify whether a staging table will always be used for export
        - Default value: **false**
        - Template provides an additional **true** option.
        - Tick **Yes** for **Allow user input?** to allow users to provide a value
            - Render as: **Select**

    - **Teradata Export Method**
        - Purpose: Specifies the export method. Two methods are supported: *batch.insert* and *internal.fastload*
        - Default value: **batch.insert**
        - Template provides an additional **internal.fastload** option.
        - Tick **Yes** for **Allow user input?** to allow users to provide a value
            - Render as: **Select**

    - **Teradata Export Number of Mappers**
        - Specify the number of mappers used by the export job
        - Default value: **4**
        - Modify the default value if needed. A positive integer is required.
        - Tick **Yes** for **Allow user input?** to allow users to provide a value
            - Render as: **Number**

    - **Teradata Export Query Band**
        - Set session level query band. Specified by a string in the format: key=value;
        - Default value: **(blank)**
        - Modify the default value if needed.
        - Tick **Yes** for **Allow user input?** to allow users to provide a value
            - Render as: **Text**

    - **Teradata Export Truncate Strings**
        - If *true*, strings in source data that are larger than target column width will be truncated to match column width. If *false*, such strings will cause job to fail.
        - Default value: **true**
        - Template provides an additional **false** option.
        - Tick **Yes** for **Allow user input?** to allow users to provide a value
            - Render as: **Select**

    - **Teradata Export Use XViews**
        - Specifies if Teradata XViews will be used to get system information
        - Default value: **false**
        - Template provides an additional **true** option.
        - Tick **Yes** for **Allow user input?** to allow users to provide a value
            - Render as: **Select**

    - **Teradata Export Utility**
        - Specify the export tool
        - Default value: **TDCH**
        - Currently, only one option is supported
        - Tick **Yes** for **Allow user input?** to allow users to provide a value
            - Render as: **Select**
            - If ingest to Teradata is to be skipped for any reason, users can select **Not Set** from dropdown during feed creation

    - **Teradata Merge Strategy**
        - Specifies how source table is merged into target table
        - Default value: **SYNC**
        - Two strategies are supported in the template:
            (1) *SYNC*: This will truncate the target table, and populate it with source table data
            (2) *APPEND*: This will append source table data to the existing data in target table.
        - Tick **Yes** for **Allow user input?** to allow users to provide a value
            - Render as: **Select**

    - **Teradata Table Create Options**
        - Define table create options if it does not exist. The table will take the name of the feed.
        - Default value: **NO PRIMARY INDEX**
        - Modify the  default value if needed.
            - **Note: It is recommended that the table be created with the above default option. Otherwise, ingests may fail due to constraints.**
        - Tick **Yes** for **Allow user input?** to allow users to provide a value
            - Render as: **Text**

    - **Teradata Table Default Column Definition**
        - Define the type for the columns in the target table, it is not existing and thus gets created by this feed.
        - Default value: **VARCHAR(5000)**
        - Modify the  default value if needed.
            - **Note: The type is recommended to be kept as VARCHAR. The size can be increased or decreased based upon expected maximum width of the source data.**
        - Tick **Yes** for **Allow user input?** to allow users to provide a value
            - Render as: **Text**

        - Click **Continue to Step 4** and provide access controls options, if any.
        - Click **Continue to Step 5** and click **Register**.
        - Ensure template is registered successfully.
        - Now continue with step 8 (*Create a Teradata Ingest Feed*) as documented in regular steps.
