module Fog
  module Compute
    class Serverlove
      class Real
        def stop_server(server_id)
          request(:method => "post", :path => "/servers/#{server_id}/stop", :expects => 204)
        end
      end
    end
  end
end
