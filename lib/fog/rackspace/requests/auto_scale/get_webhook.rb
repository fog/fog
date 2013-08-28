module Fog
  module Rackspace
    class AutoScale

      class Real

        def get_webhook(group_id, policy_id, webhook_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "groups/#{group_id}/policies/#{policy_id}/webhooks/#{webhook_id}",
          )
        end
      end

      class Mock
        def get_webhook(group_id, policy_id, webhook_id)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end