module Fog
  module Compute
    class CloudSigma
      class Real
        def list_volumes
          list_request('drives/detail/')
        end
      end

      class Mock
        def list_volumes
          mock_list(:volumes, 200)
        end
      end
    end
  end
end
