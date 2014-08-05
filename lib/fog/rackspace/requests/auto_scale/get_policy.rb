module Fog
  module Rackspace
    class AutoScale
      class Real
        def get_policy(group_id, policy_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "groups/#{group_id}/policies/#{policy_id}"
          )
        end
      end

      class Mock
        def get_policy(group_id, policy_id)
          group = self.data[:autoscale_groups][group_id]
          if group.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          policy = group['scalingPolicies'].find { |p| p["id"] == policy_id }
          if policy.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          response(:body => {'policy' => policy})
        end
      end
    end
  end
end
