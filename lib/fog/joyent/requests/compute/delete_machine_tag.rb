module Fog
  module Compute
    class Joyent
      class Real
        def delete_machine_tag(machine_id, tagname)
          request(
            :path => "/my/machines/#{machine_id}/tags/#{tagname}",
            :method => "DELETE",
            :expects => 204
          )
        end
      end
    end
  end
end
