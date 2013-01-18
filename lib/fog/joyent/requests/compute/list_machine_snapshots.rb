module Fog
  module Compute
    class Joyent
      class Real
        def list_machine_snapshots(machine_id)
          request(
            :method => "GET",
            :path => "/my/machines/#{machine_id}/snapshots"
          )
        end
      end
    end
  end
end
