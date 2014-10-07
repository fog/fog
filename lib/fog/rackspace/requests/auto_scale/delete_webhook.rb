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
          group = self.data[:autoscale_groups][group_id]
          if group.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          policy = group['policies'].find { |p| p["id"] == policy_id }
          if policy.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          policy['webhooks'].delete_if { |w| w['id'] == webhook_id }

          response(:status => 204)
        end
      end
    end
  end
end
