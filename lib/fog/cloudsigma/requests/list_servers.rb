module Fog
  module Compute
    class CloudSigma
      class Real
        def list_servers
          list_request('servers/detail/')
        end
      end

      class Mock
        def list_servers
          mock_list(:servers, 200)
        end
      end
    end
  end
end
