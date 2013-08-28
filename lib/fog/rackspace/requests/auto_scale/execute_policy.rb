module Fog
  module Rackspace
    class AutoScale
      class Real

        def execute_policy(group_id, policy_id)
          request(
            :expects => [202],
            :method => 'POST',
            :path => "groups/#{group_id}/policies/#{policy_id}/execute"
          )
        end
      end

      class Mock
        def execute_policy(group_id, policy_id)
           Fog::Mock.not_implemented
        end
      end
    end
  end
end