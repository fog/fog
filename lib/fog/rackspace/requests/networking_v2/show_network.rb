module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def show_network(id)
          request(:method => 'GET', :path => "networks/#{id}", :expects => 200)
        end
      end
    end
  end
end
