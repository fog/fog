module Fog
  module Rackspace
    class AutoScale
      class Real

        def update_webhook(group_id, policy_id, webhook_id, options)
          
          body = options

          request(
            :expects => [204],
            :method => 'PUT',
            :path => "groups/#{group_id}/policies/#{policy_id}/webhooks/#{webhook_id}",
            :body => Fog::JSON.encode(body)
          )
        end
      end

      class Mock
        def update_webhook(group_id, policy_id, webhook_id, options)
           Fog::Mock.not_implemented
        end
      end
    end
  end
end