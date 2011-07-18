module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/create_queue'

        def create_queue(name)
          request({
            'Action'    => 'CreateQueue',
            'QueueName' => name,
            :parser     => Fog::Parsers::AWS::SQS::CreateQueue.new
          })
        end

      end

      class Mock

        def create_queue(name)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
