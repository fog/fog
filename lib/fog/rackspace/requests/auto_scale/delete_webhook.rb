module Fog
  module Rackspace
    class AutoScale
      class Real

        def delete_webhook(group_id, policy_id, webhook_id)
          request(
            :expects => [204],
            :method => 'DELETE',
            :path => "groups/#{group_id}/policies/#{policy_id}/webhooks/#{webhook_id}"
          )
        end
      end

      class Mock
        def delete_webhook(group_id, policy_id, webhook_id)
           Fog::Mock.not_implemented
        end
      end
    end
  end
end