module Fog
  module Compute
    class Joyent
      class Real
        def create_machine_snapshot(machine_id, snapshot_name)
          request(
            :method => "POST",
            :path => "/my/machines/#{machine_id}/snapshots",
            :body => {"name" => snapshot_name },
            :expects => [201]
          )
        end
      end
    end
  end
end
