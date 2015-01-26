module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def delete_subnet(id)
          request(:method => 'DELETE', :path => "subnets/#{id}", :expects => 204)
        end
      end
    end
  end
end
