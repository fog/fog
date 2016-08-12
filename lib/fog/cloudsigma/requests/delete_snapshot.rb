module Fog
  module Compute
    class CloudSigma
      class Real
        def delete_snapshot(snap_id)
          delete_request("snapshots/#{snap_id}/")
        end
      end

      class Mock
        def delete_snapshot(snap_id)
          mock_delete(:snapshots, 204, snap_id)
        end
      end
    end
  end
end
