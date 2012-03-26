module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/get_topic_attributes'

        # Get attributes of a topic
        #
        # ==== Parameters
        # * arn<~Hash>: The Arn of the topic to get attributes for
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/sns/latest/api/API_GetTopicAttributes.html
        #

        def get_topic_attributes(arn)
          request({
            'Action'    => 'GetTopicAttributes',
            'TopicArn'  => arn.strip,
            :parser     => Fog::Parsers::AWS::SNS::GetTopicAttributes.new
          })
        end

      end

    end
  end
end
