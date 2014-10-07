module Fog
  module Compute
    class CloudSigma
      class Real
        def get_server(server_id)
          get_request("servers/#{server_id}/")
        end
      end

      class Mock
        def get_server(server_id)
          mock_get(:servers, 200, server_id)
        end
      end
    end
  end
end
