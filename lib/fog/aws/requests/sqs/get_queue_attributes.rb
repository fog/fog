module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/get_queue_attributes'

        def get_queue_attributes(name)
          request({
            'Action'        => 'GetQueueAttributes',
            'AttributeName' => 'All',
            :path           => path_from_queue_name(name),
            :parser         => Fog::Parsers::AWS::SQS::GetQueueAttributes.new
          })
        end

      end

      class Mock

        def get_queue_attributes(name)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
