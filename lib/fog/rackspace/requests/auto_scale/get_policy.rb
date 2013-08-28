module Fog
  module Rackspace
    class AutoScale

      class Real

        def get_policy(group_id, policy_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "groups/#{group_id}/policies/#{policy_id}",
          )
        end
      end

      class Mock
        def get_policy(group_id, policy_id)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end