module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/set_topic_attributes'

        # Set attributes of a topic
        #
        # ==== Parameters
        # * arn<~Hash> - The Arn of the topic to get attributes for
        # * attribute_name<~String> - Name of attribute to set, in ['DisplayName', 'Policy']
        # * attribute_value<~String> - Value to set attribute to
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/sns/latest/api/API_SetTopicAttributes.html
        #

        def set_topic_attributes(arn, attribute_name, attribute_value)
          request({
            'Action'          => 'SetTopicAttributes',
            'AttributeName'   => attribute_name,
            'AttributeValue'  => attribute_value,
            'TopicArn'        => arn.strip,
            :parser     => Fog::Parsers::AWS::SNS::SetTopicAttributes.new
          })
        end

      end

    end
  end
end
