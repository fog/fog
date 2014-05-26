module Fog
  module Rackspace
    class AutoScale
      class Real
        def resume_group_state(group_id)
          request(
            :expects => [204],
            :method => 'POST',
            :path => "groups/#{group_id}/resume"
          )
        end
      end

      class Mock
        def resume_group_state(group_id)
           Fog::Mock.not_implemented
        end
      end
    end
  end
end
