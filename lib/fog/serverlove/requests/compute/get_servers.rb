module Fog
  module Compute
    class Serverlove
      class Real
        def get_servers
          request(:method => "get", :path => "/servers/info", :expects => 200)
        end
      end
    end
  end
end
