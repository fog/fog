module Fog
  module Compute
    class CloudSigma
      class Real
        def update_profile(data)
          update_request("profile/", data)
        end
      end

      class Mock
        def update_profile(data)
          mock_update(data, :profile, 200)
        end
      end
    end
  end
end
