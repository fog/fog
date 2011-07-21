module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/basic'

        # Get attributes of a queue
        #
        # ==== Parameters
        # * queue_url<~String> - Url of queue to get attributes for
        # * attribute_name<~String> - Name of attribute to set, keys in ['MaximumMessageSize', 'MessageRetentionPeriod', 'Policy', 'VisibilityTimeout']
        # * attribute_value<~String> - Value to set for attribute
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AWSSimpleQueueService/latest/APIReference/Query_QuerySetQueueAttributes.html
        #

        def set_queue_attributes(queue_url, attribute_name, attribute_value)
          request({
            'Action'          => 'SetQueueAttributes',
            'Attribute.Name'  => attribute_name,
            'Attribute.Value' => attribute_value,
            :path             => path_from_queue_url(queue_url),
            :parser           => Fog::Parsers::AWS::SQS::Basic.new
          })
        end

      end

    end
  end
end
