module Fog
  module Compute
    class Joyent
      class Real
        # https://us-west-1.api.joyentcloud.com/docs#GetMachineTag
        def get_machine_tag(machine_id, tagname)
          request(
            :path => "/my/machines/#{machine_id}/tags/#{tagname}",
            :method => "GET",
            :headers => {"Accept" => "text/plain"},
            :expects => 200,
            :idempotent => true
          )
        end
      end
    end
  end
end
