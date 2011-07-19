module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/send_message'

        # Add a message to a queue
        #
        # ==== Parameters
        # * queue_url<~String> - Url of queue to add message to
        # * message<~String> - Message to add to queue
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSSimpleQueueService/latest/APIReference/Query_QuerySendMessage.html
        #

        def send_message(queue_url, message)
          request({
            'Action'      => 'SendMessage',
            'MessageBody' => message,
            :path         => path_from_queue_url(queue_url),
            :parser       => Fog::Parsers::AWS::SQS::SendMessage.new
          })
        end

      end

    end
  end
end
