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
        def list_groups(group_id)
           Fog::Mock.not_implemented
        end
      end
    end
  end
end
