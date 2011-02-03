module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/create_topic'

        def create_topic(options = {})
          request({
            'Action'  => 'CreateTopic',
            :parser   => Fog::Parsers::AWS::SNS::CreateTopic.new
          }.merge!(options))
        end

      end

      class Mock

        def create_topic(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
