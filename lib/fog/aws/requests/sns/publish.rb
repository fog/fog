module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/publish'

        def publish(options = {})
          request({
            'Action'  => 'Publish',
            :parser   => Fog::Parsers::AWS::SNS::Publish.new
          }.merge!(options))
        end

      end

      class Mock

        def publish(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
