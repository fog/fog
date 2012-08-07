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
    end
  end
end
