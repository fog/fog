module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/get_topic_attributes'

        def get_topic_attributes(options = {})
          request({
            'Action' => 'GetTopicAttributes',
            :parser  => Fog::Parsers::AWS::SNS::GetTopicAttributes.new
          }.merge!(options))
        end

      end

      class Mock

        def get_topic_attributes
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
