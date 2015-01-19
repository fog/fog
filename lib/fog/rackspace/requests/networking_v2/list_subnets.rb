module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def list_subnets
          request(:method => 'GET', :path => 'subnets', :expects => 200)
        end
      end
    end
  end
end
