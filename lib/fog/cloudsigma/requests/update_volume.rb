module Fog
  module Compute
    class CloudSigma
      class Real
        def update_volume(vol_id, data)
          update_request("drives/#{vol_id}/", data)
        end
      end

      class Mock
        def update_volume(vol_id, data)
          mock_update(data, :volumes, 200,  vol_id)
        end
      end
    end
  end
end
