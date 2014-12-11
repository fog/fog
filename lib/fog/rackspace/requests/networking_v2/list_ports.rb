module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def list_ports
          request(:method => 'GET', :path => 'ports', :expects => 200)
        end
      end
    end
  end
end
