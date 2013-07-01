module Fog
  module Compute
    class Vcloudng
      class Real
        
        def get_vm_network(vm_id)
          require 'fog/vcloudng/parsers/compute/vm_network'
          
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser => Fog::Parsers::Compute::Vcloudng::VmNetwork.new,
            :path     => "vApp/#{vm_id}/networkConnectionSection/"
          )
        end

      end
    end
  end
end
