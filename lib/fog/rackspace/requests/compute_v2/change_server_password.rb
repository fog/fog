module Fog
  module Compute
    class RackspaceV2
      class Real
        def change_server_password(server_id, password)
          data = {
            'changePassword' => {
              'adminPass' => password
            }
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => [202],
            :method => 'POST',
            :path => "servers/#{server_id}/action"
          )
        end
      end
    end
  end
end
