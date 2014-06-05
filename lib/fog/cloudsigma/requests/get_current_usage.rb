module Fog
  module Compute
    class CloudSigma
      class Real
        def get_current_usage
          get_request("currentusage/")
        end
      end

      class Mock
        def get_current_usage
        end
      end
    end
  end
end
