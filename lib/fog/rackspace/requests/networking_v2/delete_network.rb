module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def delete_network(id)
          request(:method => 'DELETE', :path => "networks/#{id}", :expects => 204)
        end
      end
    end
  end
end
