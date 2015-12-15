module Fog
  module Compute
    class OpenStack
      class Real
        def evacuate_server(server_id, host, on_shared_storage, admin_password = nil)
          body = {
            'evacuate' => {
              'host'            => host,
              'onSharedStorage' => on_shared_storage,
              'admin_password'  => admin_password,
            }
          }
          server_action(server_id, body)
        end
      end

      class Mock
        def evacuate_server(server_id, host, on_shared_storage, admin_password = nil)
          response = Excon::Response.new
          response.status = 202
          response
        end
      end
    end
  end
end
