module Fog
  module Compute
    class CloudSigma
      class Real
        def get_lib_volume(vol_id)
          get_request("libdrives/#{vol_id}/")
        end
      end

      class Mock
        def get_lib_volume(vol_id)
          mock_get(:libvolumes, 200, vol_id)
        end
      end
    end
  end
end
