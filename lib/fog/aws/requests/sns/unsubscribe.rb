module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/unsubscribe'

        def unsubscribe(options = {})
          request({
            'Action'  => 'Unsubscribe',
            :parser   => Fog::Parsers::AWS::SNS::Unsubscribe.new
          }.merge!(options))
        end

      end

      class Mock

        def unsubscribe(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
