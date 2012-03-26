module Fog
  module Compute
    class Joyent
      class Real
        def delete_all_machine_tags(machine_id)
          request(
            :path => "/my/machines/#{machine_id}/tags",
            :method => "DELETE",
            :expects => 204
          )
        end
      end
    end
  end
end
