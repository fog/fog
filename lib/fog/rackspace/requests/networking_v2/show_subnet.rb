module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def show_subnet(id)
          request(:method => 'GET', :path => "subnets/#{id}", :expects => 200)
        end
      end
    end
  end
end
