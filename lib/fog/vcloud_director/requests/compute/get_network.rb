module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/network'
        
        def get_network(network_id)
         request(
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::Parsers::Compute::VcloudDirector::Network.new,
            :path     => "network/#{network_id}"
          )
        end
        
      end
    end
  end
end
      