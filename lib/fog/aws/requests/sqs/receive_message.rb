module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/receive_message'

        # Get a message from a queue (marks it as unavailable temporarily, but does not remove from queue, see delete_message)
        #
        # ==== Parameters
        # * queue_url<~String> - Url of queue to get message from
        # * options<~Hash>:
        #   * Attributes<~Array> - List of attributes to return, in ['All', 'ApproximateFirstReceiveTimestamp', 'ApproximateReceiveCount', 'SenderId', 'SentTimestamp'], defaults to 'All'
        #   * MaxNumberOfMessages<~Integer> - Maximum number of messages to return, defaults to 1
        #   * VisibilityTimeout<~Integer> - Duration, in seconds, to hide message from other receives. In 0..43200, defaults to visibility timeout for queue
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSSimpleQueueService/latest/APIReference/Query_QueryReceiveMessage.html
        #

        def receive_message(queue_url, options = {})
          request({
            'Action'        => 'ReceiveMessage',
            'AttributeName' => 'All',
            :path           => path_from_queue_url(queue_url),
            :parser         => Fog::Parsers::AWS::SQS::ReceiveMessage.new
          }.merge!(options))
        end

      end

    end
  end
end
