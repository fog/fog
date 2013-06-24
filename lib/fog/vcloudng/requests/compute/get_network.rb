module Fog
  module Compute
    class Vcloudng
      class Real
        require 'fog/vcloudng/parsers/compute/network'
        
        def get_network(network_id)
         request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser => Fog::Parsers::Compute::Vcloudng::Network.new,
            :path     => "network/#{network_id}"
          )
        end
        
      end
    end
  end
end
      