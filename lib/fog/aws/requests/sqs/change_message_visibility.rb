module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/basic'

        # Change visibility timeout for a message
        #
        # ==== Parameters
        # * queue_url<~String> - Url of queue for message to update
        # * receipt_handle<~String> - Token from previous recieve message
        # * visibility_timeout<~Integer> - New visibility timeout in 0..43200
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSSimpleQueueService/latest/APIReference/Query_QueryChangeMessageVisibility.html
        #

        def change_message_visibility(queue_url, receipt_handle, visibility_timeout)
          request({
            'Action'            => 'ChangeMessageVisibility',
            'ReceiptHandle'     => receipt_handle,
            'VisibilityTimeout' => visibility_timeout,
            :parser             => Fog::Parsers::AWS::SQS::Basic.new,
            :path               => path_from_queue_url(queue_url)
          })
        end

      end

    end
  end
end
