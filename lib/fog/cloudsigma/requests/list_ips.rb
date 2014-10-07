module Fog
  module Compute
    class CloudSigma
      class Real
        def list_ips
          list_request('ips/detail/')
        end
      end

      class Mock
        def list_ips
          mock_list(:ips, 200)
        end
      end
    end
  end
end
