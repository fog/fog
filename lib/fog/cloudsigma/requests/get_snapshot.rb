module Fog
  module Compute
    class CloudSigma
      class Real
        def get_snapshot(snap_id)
          get_request("snapshots/#{snap_id}/")
        end
      end

      class Mock
        def get_snapshot(snap_id)
          mock_get(:snapshots, 200, snap_id)
        end
      end
    end
  end
end
