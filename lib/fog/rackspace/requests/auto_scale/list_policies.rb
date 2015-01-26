module Fog
  module Rackspace
    class AutoScale
      class Real
        def list_policies(group_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "groups/#{group_id}/policies"
          )
        end
      end

      class Mock
        def list_policies(group_id)
          group = self.data[:autoscale_groups][group_id]
          response(:body => {'policies' => group['scalingPolicies']})
        end
      end
    end
  end
end
