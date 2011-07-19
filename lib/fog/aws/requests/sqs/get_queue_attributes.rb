module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/get_queue_attributes'

        # Get attributes of a queue
        #
        # ==== Parameters
        # * queue_url<~String> - Url of queue to get attributes for
        # * attributes<~Array> - List of attributes to return, in ['All', 'ApproximateNumberOfMessages', 'ApproximateNumberOfMessagesNotVisible', 'CreatedTimestamp', 'LastModifiedTimestamp', 'MaximumMessageSize', 'MessageRetentionPeriod', 'Policy', 'QueueArn', 'VisibilityTimeout']
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSSimpleQueueService/latest/APIReference/Query_QueryGetQueueAttributes.html
        #

        def get_queue_attributes(queue_url, attributes)
          attributes = Fog::AWS.indexed_param('AttributeName', [*attributes])
          request({
            'Action'        => 'GetQueueAttributes',
            :path           => path_from_queue_url(queue_url),
            :parser         => Fog::Parsers::AWS::SQS::GetQueueAttributes.new
          }.merge(attributes))
        end

      end

    end
  end
end
