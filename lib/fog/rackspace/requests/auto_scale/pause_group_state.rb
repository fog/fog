module Fog
  module Rackspace
    class AutoScale
      class Real
        def pause_group_state(group_id)
          Fog::Real.not_implemented
          # request(
          #   :expects => [204],
          #   :method => 'POST',
          #   :path => 'groups/#{group_id}/pause'
          # )
        end
      end

      class Mock
        def pause_group_state(group_id)
           Fog::Mock.not_implemented
        end
      end
    end
  end
end
