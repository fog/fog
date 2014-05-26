module Fog
  module Compute
    class CloudSigma
      class Real
        def list_vlans
          list_request('vlans/detail/')
        end
      end

      class Mock
        def list_vlans
          mock_list(:vlans, 200)
        end
      end
    end
  end
end
