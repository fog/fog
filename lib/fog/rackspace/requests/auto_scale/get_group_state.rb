module Fog
  module Rackspace
    class AutoScale

      class Real

        def get_group_state(group_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "groups/#{group_id}/state",
            )
        end
      end

      class Mock
        def get_group_state(group_id)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end