module Fog
  module Compute
    class CloudSigma
      class Real
        def update_snapshot(snap_id, data)
          update_request("snapshots/#{snap_id}/", data)
        end
      end

      class Mock
        def update_snapshot(snap_id, data)
          mock_update(data, :snapshots, 200,  snap_id)
        end
      end
    end
  end
end
