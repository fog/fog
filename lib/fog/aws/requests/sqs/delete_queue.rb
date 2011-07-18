module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/delete_queue'

        def delete_queue(name)
          request({
            'Action' => 'DeleteQueue',
            :parser  => Fog::Parsers::AWS::SQS::DeleteQueue.new,
            :path    => path_from_queue_name(name)
          })
        end

      end

      class Mock

        def delete_queue(name)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
