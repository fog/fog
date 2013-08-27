module Fog
  module Compute
    class VcloudDirector
      class Real
        
        def get_vm_network(vm_id)
          require 'fog/vcloud_director/parsers/compute/vm_network'
          
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser => Fog::Parsers::Compute::VcloudDirector::VmNetwork.new,
            :path     => "vApp/#{vm_id}/networkConnectionSection/"
          )
        end

      end
    end
  end
end
