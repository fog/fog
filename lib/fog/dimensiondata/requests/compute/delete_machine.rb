module Fog
  module Compute
    class Joyent
      class Real
        def delete_machine(machine_id)
          request(
            :path => "/my/machines/#{machine_id}",
            :method => "DELETE",
            :expects => [200, 204, 410]
          )
        end
      end
    end
  end
end
