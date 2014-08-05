module Fog
  module Compute
    class Serverlove
      class Real
        def start_server(server_id)
          request(:method => "post", :path => "/servers/#{server_id}/start", :expects => 200)
        end
      end
    end
  end
end
