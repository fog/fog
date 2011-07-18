module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/delete_message'

        def delete_message(queue_name, receipt_handle)
          request({
            'Action'        => 'DeleteMessage',
            'ReceiptHandle' => receipt_handle,
            :parser         => Fog::Parsers::AWS::SQS::DeleteMessage.new,
            :path           => path_from_queue_name(queue_name)
          })
        end

      end

      class Mock

        def delete_message(queue_name, receipt_handle)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
