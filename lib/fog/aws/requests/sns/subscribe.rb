module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/subscribe'

        def subscribe(options = {})
          request({
            'Action'  => 'Subscribe',
            :parser   => Fog::Parsers::AWS::SNS::Subscribe.new
          }.merge!(options))
        end

      end

      class Mock

        def subscribe(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
