module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/basic'

        # Delete a message from a queue
        #
        # ==== Parameters
        # * queue_url<~String> - Url of queue to delete message from
        # * receipt_handle<~String> - Token from previous recieve message
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSSimpleQueueService/latest/APIReference/Query_QueryDeleteMessage.html
        #

        def delete_message(queue_url, receipt_handle)
          request({
            'Action'        => 'DeleteMessage',
            'ReceiptHandle' => receipt_handle,
            :parser         => Fog::Parsers::AWS::SQS::Basic.new,
            :path           => path_from_queue_url(queue_url),
          })
        end

      end

    end
  end
end
