module Fog
  module Compute
    class Joyent
      class Real
        def start_machine_from_snapshot(machine_id, snapshot_name)
          request(
            :method => "POST",
            :path => "/my/machines/#{machine_id}/snapshots/#{snapshot_name}",
            :expects => 202
          )
        end
      end
    end
  end
end
