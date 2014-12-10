module Fog
  module Rackspace
    class AutoScale
      class Real
        def update_policy(group_id, policy_id, options)
          request(
            :expects => [204],
            :method => 'PUT',
            :path => "groups/#{group_id}/policies/#{policy_id}",
            :body => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def update_policy(group_id, policy_id, options)
          group = self.data[:autoscale_groups][group_id]
          if group.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          policy = group['scalingPolicies'].find { |p| p["id"] == policy_id }

          policy.merge(options)

          request(:body => policy)
        end
      end
    end
  end
end
