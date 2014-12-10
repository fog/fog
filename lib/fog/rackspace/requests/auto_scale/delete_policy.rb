module Fog
  module Rackspace
    class AutoScale
      class Real
        def delete_policy(group_id, policy_id)
          request(
            :expects => [204],
            :method => 'DELETE',
            :path => "groups/#{group_id}/policies/#{policy_id}"
          )
        end
      end

      class Mock
        def delete_group(group_id, policy_id)
           group = self.data[:autoscale_groups][group_id]

          if group.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          group['policies'].delete_if { |p| p['id'] == policy_id }

          response(:status => 204)
        end
      end
    end
  end
end
