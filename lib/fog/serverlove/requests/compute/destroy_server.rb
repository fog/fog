module Fog
  module Compute
    class Serverlove
      class Real
        def destroy_server(server_id)
          request(:method => "post", :path => "/servers/#{server_id}/destroy", :expects => 204)
        end
      end
    end
  end
end
