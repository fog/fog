module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/list_subscriptions'

        def list_subscriptions(options = {})
          request({
            'Action' => 'ListSubscriptions',
            :parser  => Fog::Parsers::AWS::SNS::ListSubscriptions.new
          }.merge!(options))
        end

      end

      class Mock

        def list_subscriptions
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
