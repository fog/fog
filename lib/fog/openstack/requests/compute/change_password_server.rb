module Fog
  module Compute
    class OpenStack
      class Real

        def change_password_server(server_id, admin_password)
          body = { 'changePassword' => { 'adminPass' => admin_password }}
          server_action(server_id, body)
        end

      end

      class Mock

        def change_password_server(server_id, admin_password)
          response = Excon::Response.new
          response.status = 202
          response
        end

      end
    end
  end
end
