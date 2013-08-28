module Fog
  module Rackspace
    class AutoScale
      class Real
        def create_webhook(group_id, policy_id, options)

          body = [options]

          request(
            :method => 'POST',
            :body => Fog::JSON.encode(body),
            :path => "groups/#{group_id}/policies/#{policy_id}/webhooks",
            :expects => 201
          )
        end
      end

      class Mock
        def create_webhook(group_id, policy_id, options)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
