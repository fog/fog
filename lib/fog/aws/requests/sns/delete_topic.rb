module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/delete_topic'

        def delete_topic(options = {})
          request({
            'Action'  => 'DeleteTopic',
            :parser   => Fog::Parsers::AWS::SNS::DeleteTopic.new
          }.merge!(options))
        end

      end

      class Mock

        def delete_topic(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
