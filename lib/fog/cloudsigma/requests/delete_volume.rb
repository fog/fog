module Fog
  module Compute
    class CloudSigma
      class Real
        def delete_volume(vol_id)
          delete_request("drives/#{vol_id}/")
        end
      end

      class Mock
        def delete_volume(vol_id)
          mock_delete(:volumes, 204, vol_id)
        end
      end
    end
  end
end
