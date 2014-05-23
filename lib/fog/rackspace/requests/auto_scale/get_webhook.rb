module Fog
  module Rackspace
    class AutoScale
      class Real
        def get_webhook(group_id, policy_id, webhook_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "groups/#{group_id}/policies/#{policy_id}/webhooks/#{webhook_id}"
          )
        end
      end

      class Mock
        def get_webhook(group_id, policy_id, webhook_id)
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

          response(:body => {'webhook' => webhook})
        end
      end
    end
  end
end
