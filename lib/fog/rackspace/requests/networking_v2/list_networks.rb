module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def list_networks
          request(:method => 'GET', :path => 'networks', :expects => 200)
        end
      end
    end
  end
end
