module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/receive_message'

        def receive_message(queue_name)
          request({
            'Action'        => 'ReceiveMessage',
            'AttributeName' => 'All',
            :path           => path_from_queue_name(queue_name),
            :parser         => Fog::Parsers::AWS::SQS::ReceiveMessage.new
          })
        end

      end

      class Mock

        def receive_message(queue_name)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
