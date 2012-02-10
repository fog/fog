module Fog
  module Compute
    class Joyent
      class Real
        def get_machine_snapshot(machine_id, snapshot_name)
          request(
            :path => "/my/machines/#{machine_id}/snapshots/#{snapshot_name}",
            :method => "GET"
          )
        end
      end
    end
  end
end
