module Fog
  module Compute
    class CloudSigma
      class Real
        def get_profile
          get_request("profile/")
        end
      end

      class Mock
        def get_profile
          mock_get(:profile,  200)
        end
      end
    end
  end
end
