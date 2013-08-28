module Fog
  module Rackspace
    class AutoScale
      class Real

        def list_webhooks(group_id, policy_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "groups/#{group_id}/policies/#{policy_id}/webhooks"
          )
        end
      end

      class Mock
        def list_webhooks(group_id, policy_id)
           Fog::Mock.not_implemented
        end
      end
    end
  end
end
