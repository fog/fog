module Fog
  module Compute
    class Joyent
      class Real
        # https://us-west-1.api.joyentcloud.com/docs#ListMachineTags
        def list_machine_tags(machine_id)
          request(
            :path => "/my/machines/#{machine_id}/tags",
            :method => "GET",
            :expects => 200,
            :idempotent => true
          )
        end
      end

      class Mock
      end
    end
  end
end
