module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/basic'

        # Delete a queue
        #
        # ==== Parameters
        # * queue_url<~String> - Url of queue to delete
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSSimpleQueueService/latest/APIReference/Query_QueryDeleteQueue.html
        #

        def delete_queue(queue_url)
          request({
            'Action' => 'DeleteQueue',
            :parser  => Fog::Parsers::AWS::SQS::Basic.new,
            :path    => path_from_queue_url(queue_url),
          })
        end

      end

    end
  end
end
