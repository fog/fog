module Fog
  module Rackspace
    class BlockStorage
      class Real
        def get_snapshot(snapshot_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "snapshots/#{snapshot_id}"
          )
        end
      end
    end
  end
end
