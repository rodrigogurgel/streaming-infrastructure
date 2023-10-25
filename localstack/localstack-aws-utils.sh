#!/bin/bash

# Necessary to get json attributes
apt-get install jq -y

create_aws_topic_return_arn() {
  local TOPIC_NAME=$1
  TOPIC_ARN=$(awslocal sns create-topic --name "$TOPIC_NAME" --output text)

  if [ -z "$TOPIC_ARN" ]; then
      echo "Can't create topic: '$TOPIC_NAME'" >&2
      exit 1
  else
      echo "Created topic: $TOPIC_NAME, topic arn: $TOPIC_ARN" >&2
  fi
  echo "$TOPIC_ARN"
}

create_aws_queue_return_url() {
  local QUEUE_NAME=$1
  QUEUE_URL=$(awslocal sqs create-queue --queue-name "$QUEUE_NAME" --output text)

  if [ -z "$QUEUE_URL" ]; then
      echo "Can't create queue: '$QUEUE_NAME'" >&2
      exit 1
  else
      echo "Created queue: $QUEUE_NAME, queue url: $QUEUE_URL" >&2
  fi
  echo "$QUEUE_URL"
}

get_aws_queue_arn_from_queue_url() {
  local QUEUE_URL=$1
  QUEUE_ARN=$(awslocal sqs get-queue-attributes --queue-url "$QUEUE_URL" --attribute-names QueueArn | jq -r ".Attributes.QueueArn")

  if [ -z "$QUEUE_ARN" ]; then
      echo "Can't create queue: '$QUEUE_NAME'" >&2
      exit 1
  else
      echo "Get arn from queue url: $QUEUE_URL arn: $QUEUE_ARN" >&2
  fi
  echo "$QUEUE_ARN"
}

subscribe_queue_to_topic() {
  local TOPIC_ARN=$1
  local QUEUE_ARN=$2
  SUBSCRIPTION_ARN=$(awslocal sns subscribe --topic-arn "$TOPIC_ARN" --protocol sqs --notification-endpoint "$QUEUE_ARN" --output text)

  if [ -z "$SUBSCRIPTION_ARN" ]; then
      echo "Can't create queue: '$QUEUE_NAME'" >&2
      exit 1
  else
      echo "Queue arn: $QUEUE_ARN subscribe to topic arn: $TOPIC_ARN subscription arn: $SUBSCRIPTION_ARN" >&2
  fi
  echo "$SUBSCRIPTION_ARN"
}

set_subscription_attributes() {
  local SUBSCRIPTION_ARN=$1
  local ATTRIBUTE_NAME=$2
  local ATTRIBUTE_VALUE=$3
  awslocal sns set-subscription-attributes --subscription-arn "$SUBSCRIPTION_ARN" --attribute-name "$ATTRIBUTE_NAME" --attribute-value "$ATTRIBUTE_VALUE"
}

create_bucket() {
  local BUCKET_NAME=$1
  awslocal s3 mb "s3://$BUCKET_NAME"
}