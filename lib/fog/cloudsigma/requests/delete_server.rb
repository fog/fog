module Fog
  module Compute
    class CloudSigma
      class Real
        def delete_server(server_id)
          delete_request("servers/#{server_id}/")
        end
      end

      class Mock
        def delete_server(server_id)
          mock_delete(:servers, 204, server_id)
        end
      end
    end
  end
end
