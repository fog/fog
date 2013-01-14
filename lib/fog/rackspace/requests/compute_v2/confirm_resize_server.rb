module Fog
  module Compute
    class RackspaceV2
      class Real
        def confirm_resize_server(server_id)
          data = {
            'confirmResize' => nil
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => [204],
            :method => 'POST',
            :path => "servers/#{server_id}/action"
          )
        end
      end

      class Mock
        def confirm_resize_server(server_id)
          server = self.data[:servers][server_id]
          server["status"] = "ACTIVE"
          response(:status => 204)
        end
      end
    end
  end
end
