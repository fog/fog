module Fog
  module Compute
    class Serverlove
      class Real
        def reset_server(server_id)
          request(:method => "post", :path => "/servers/#{server_id}/reset", :expects => 204)
        end
      end
    end
  end
end
