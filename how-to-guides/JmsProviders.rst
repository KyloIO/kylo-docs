
=============
JMS Providers
=============

Introduction
============

Kylo supports pluggable JMS implementations. There are two JMS implementations supported out-of-the-box: ActiveMQ and Amazon SQS.
Both Kylo and Nifi should be configured with the same JMS implementation.


Kylo Configuration
==================

ActiveMQ
--------

ActiveMQ profile is selected by default. If you switched away from ActiveMQ and now want to restore default Kylo settings you can
edit ``/opt/kylo/kylo-services/conf/application.properties`` and select ActiveMQ JMS implementation by adding ``jms-activemq`` profile to
``spring.profiles.include`` property, e.g.

  .. code-block:: properties

    spring.profiles.include=native,nifi-v1,auth-kylo,auth-file,jms-activemq

  ..

In addition to selected profile, ActiveMQ configuration properties should be provided either in ``/opt/kylo/kylo-services/conf/application.properties`` or in
``/opt/kylo/kylo-services/conf/activemq.properties``. The latter is preferred for separation of concerns, but not required.
Redelivery processing properties are now available for configuration. If Kylo receives provenance events and they have errors or are unable to attach NiFi feed information
(i.e. if NiFi goes down and Kylo doesnt have the feed information in its cache) then the JMS message will be returned for redelivery based upon the following parameters.
Refer to the ActiveMQ documentation, http://activemq.apache.org/redelivery-policy.html, for assigning these values

  .. code-block:: properties

    jms.activemq.broker.url=tcp://localhost:61616
    #jms.activemq.broker.username=admin
    #jms.activemq.broker.password=admin
    ##Redeliver policy for the Listeners when they fail (http://activemq.apache.org/redelivery-policy.html)
    #jms.maximumRedeliveries=100
    #jms.redeliveryDelay=1000
    #jms.maximumRedeliveryDelay=600000L
    #jms.backOffMultiplier=5
    #jms.useExponentialBackOff=false

  ..

Amazon SQS
----------

ActiveMQ profile is selected by default. But you can switch over to Amazon SQS by replacing ``jms-activemq`` profile with ``jms-amazon-sqs`` in
``/opt/kylo/kylo-services/conf/application.properties``, e.g.

  .. code-block:: properties

    spring.profiles.include=native,nifi-v1,auth-kylo,auth-file,jms-amazon-sqs

  ..

In addition to that Amazon SQS specific properties should be provided either in ``/opt/kylo/kylo-services/conf/application.properties`` or in
``/opt/kylo/kylo-services/conf/amazon-sqs.properties``. The latter is preferred, but not required

  .. code-block:: properties

    sqs.region.name=eu-west-1

  ..

Amazon SQS uses ``DefaultAWSCredentialsProviderChain`` class to look for AWS credentials in the following order:

- Environment Variables - AWS_ACCESS_KEY_ID and AWS_SECRET_KEY
- Java System Properties - aws.accessKeyId and aws.secretKey
- Credential profiles file at the default location (~/.aws/credentials) shared by all AWS SDKs and the AWS CLI
- Instance profile credentials delivered through the Amazon EC2 metadata service

For example, add your AWS credentials to ``/home/kylo/.aws/credentials``

  .. code-block:: shell

    [default]
    aws_access_key_id=...
    aws_secret_access_key=...

  ..


Nifi Configuration
==================

Active MQ
---------



Amazon SQS
----------



