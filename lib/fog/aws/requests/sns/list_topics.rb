module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/list_topics'

        def list_topics(options = {})
          request({
            'Action'  => 'ListTopics',
            :parser   => Fog::Parsers::AWS::SNS::ListTopics.new
          }.merge!(options))
        end

      end

      class Mock

        def list_topics(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
