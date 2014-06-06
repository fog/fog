module Fog
  module Compute
    class Serverlove
      class Real
        def get_server(server_id)
          request(:method => "get", :path => "/servers/#{server_id}/info", :expects => 200)
        end
      end
    end
  end
end
