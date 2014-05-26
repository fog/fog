module Fog
  module Compute
    class CloudSigma
      class Real
        def get_volume(vol_id)
          get_request("drives/#{vol_id}/")
        end
      end

      class Mock
        def get_volume(vol_id)
          mock_get(:volumes, 200, vol_id)
        end
      end
    end
  end
end
