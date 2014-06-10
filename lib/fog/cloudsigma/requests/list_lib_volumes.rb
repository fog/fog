module Fog
  module Compute
    class CloudSigma
      class Real
        def list_lib_volumes
          list_request('libdrives/')
        end
      end

      class Mock
        def list_lib_volumes
          mock_list(:libvolumes, 200)
        end
      end
    end
  end
end
