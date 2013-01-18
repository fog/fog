module Fog
  module Compute
    class Joyent

      class Real
        def delete_machine_snapshot(machine_id, snapshot)
          request(
            :method => "DELETE",
            :path => "/my/machines/#{machine_id}/snapshots/#{snapshot}",
            :expects => [200, 204]
          )
        end
      end

      class Mock

      end

    end
  end
end
