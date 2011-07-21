module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/create_queue'

        # Create a queue
        #
        # ==== Parameters
        # * name<~String> - Name of queue to create
        # * options<~Hash>:
        #   * DefaultVisibilityTimeout<~String> - Time, in seconds, to hide a message after it has been received, in 0..43200, defaults to 30
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSSimpleQueueService/latest/APIReference/Query_QueryCreateQueue.html
        #

        def create_queue(name, options = {})
          request({
            'Action'    => 'CreateQueue',
            'QueueName' => name,
            :parser     => Fog::Parsers::AWS::SQS::CreateQueue.new
          }.merge!(options))
        end

      end

    end
  end
end
