module Fog
  module Compute
    class OpenStack
      class Real
        def evacuate_server(server_id, host, on_shared_storage, admin_pass=nil)
          body = {
            'evacuate' => {
              'host' => host,
              'adminPass' => admin_pass,
              'onSharedStorage' => on_shared_storage,
            }
          }
          server_action(server_id, body)
        end
      end

      class Mock
        def evacuate_server(server_id, host, on_shared_storage, admin_pass=nil)
          response = Excon::Response.new
          response.status = 200
          response
        end
      end
    end
  end
end
