module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/list_subscriptions_by_topic'

        def list_subscriptions_by_topic(options = {})
          request({
            'Action' => 'ListSubscriptionsByTopic',
            :parser  => Fog::Parsers::AWS::SNS::ListSubscriptionsByTopic.new
          }.merge!(options))
        end

      end

      class Mock

        def list_subscriptions_by_topic
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
