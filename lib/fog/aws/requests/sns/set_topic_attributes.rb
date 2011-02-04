module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/set_topic_attributes'

        def set_topic_attributes(options = {})
          request({
            'Action'  => 'SetTopicAttributes',
            :parser   => Fog::Parsers::AWS::SNS::SetTopicAttributes.new
          }.merge!(options))
        end

      end

      class Mock

        def set_topic_attributes(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
