module Fog
  module Rackspace
    class BlockStorage
      class Real
        def delete_snapshot(snapshot_id)
          request(
            :expects => [202],
            :method => 'DELETE',
            :path => "snapshots/#{snapshot_id}"
          )
        end
      end
    end
  end
end
