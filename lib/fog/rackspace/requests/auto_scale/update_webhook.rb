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
          group = self.data[:autoscale_groups][group_id]
          if group.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          policy = group['scalingPolicies'].find { |p| p["id"] == policy_id }
          if policy.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          webhook = policy['webhooks'].find { |w| w['id'] == webhook_id }
          if webhook.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          webhook.merge(options)

          response(:body => webhook)
        end
      end
    end
  end
end
