module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/list_queues'

        def list_queues
          request({
            'Action' => 'ListQueues',
            :parser  => Fog::Parsers::AWS::SQS::ListQueues.new
          })
        end
      end

      class Mock

        def list_queues
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
