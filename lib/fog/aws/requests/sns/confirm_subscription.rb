module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/confirm_subscription'

        def confirm_subscription(options = {})
          request({
            'Action'  => 'ConfirmSubscription',
            :parser   => Fog::Parsers::AWS::SNS::ConfirmSubscription.new
          }.merge!(options))
        end

      end

      class Mock

        def confirm_subscription(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
