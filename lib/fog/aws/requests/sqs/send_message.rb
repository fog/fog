module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/send_message'

        def send_message(queue_name, message)
          request({
            'Action'      => 'SendMessage',
            'MessageBody' => message,
            :path         => path_from_queue_name(queue_name),
            :parser       => Fog::Parsers::AWS::SQS::SendMessage.new
          })
        end

      end

      class Mock

        def send_message(queue_name, message)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
