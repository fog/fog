module Fog
  module Compute
    class Serverlove
      class Real
        def shutdown_server(server_id)
          request(:method => "post", :path => "/servers/#{server_id}/shutdown", :expects => 204)
        end
      end
    end
  end
end
