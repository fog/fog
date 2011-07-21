module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/list_queues'

        # List queues
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * QueueNamePrefix<~String> - String used to filter results to only those with matching prefixes
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSSimpleQueueService/latest/APIReference/Query_QueryListQueues.html
        #

        def list_queues(options = {})
          request({
            'Action' => 'ListQueues',
            :parser  => Fog::Parsers::AWS::SQS::ListQueues.new
          }.merge!(options))
        end
      end

    end
  end
end
