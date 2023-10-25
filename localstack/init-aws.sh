#!/bin/bash
source /etc/localstack/init/utils/localstack-aws-utils.sh

STREAMING_CREATED_NOTIFICATION_TOPIC_ARN=$(create_aws_topic_return_arn "$STREAMING_CREATED_NOTIFICATION_TOPIC_NAME")

STREAMING_CREATED_QUEUE_URL=$(create_aws_queue_return_url "$STREAMING_CREATED_QUEUE_NAME")

STREAMING_CREATED_QUEUE_ARN=$(get_aws_queue_arn_from_queue_url "$STREAMING_CREATED_QUEUE_URL")

STREAMING_CREATED_SUBSCRIPTION_ARN=$(subscribe_queue_to_topic "$STREAMING_CREATED_NOTIFICATION_TOPIC_ARN" "$STREAMING_CREATED_QUEUE_ARN")

set_subscription_attributes "$STREAMING_CREATED_SUBSCRIPTION_ARN" RawMessageDelivery true

create_bucket "$VIDEOS_BUCKET"

EPISODE_UPLOADED_NOTIFICATION_TOPIC_ARN=$(create_aws_topic_return_arn "$EPISODE_UPLOADED_NOTIFICATION_TOPIC_NAME")

EPISODE_UPLOADED_QUEUE_URL=$(create_aws_queue_return_url "$EPISODE_UPLOADED_QUEUE_NAME")

EPISODE_UPLOADED_QUEUE_ARN=$(get_aws_queue_arn_from_queue_url "$EPISODE_UPLOADED_QUEUE_URL")

EPISODE_UPLOADED_SUBSCRIPTION_ARN=$(subscribe_queue_to_topic "$EPISODE_UPLOADED_NOTIFICATION_TOPIC_ARN" "$EPISODE_UPLOADED_QUEUE_ARN")

set_subscription_attributes "$EPISODE_UPLOADED_SUBSCRIPTION_ARN" RawMessageDelivery true