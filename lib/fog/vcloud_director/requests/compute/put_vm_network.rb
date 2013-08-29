module Fog
  module Compute
    class VcloudDirector
      class Real
        
        def put_vm_network(vm_id, network={})
          require 'fog/vcloud_director/generators/compute/vm_network'
          
          data = Fog::Generators::Compute::VcloudDirector::VmNetwork.new(network)
          
          request(
            :body => data.generate_xml,
            :expects  => 202,                
            :headers => { 'Content-Type' => 'application/vnd.vmware.vcloud.networkConnectionSection+xml' },
            :method   => 'PUT',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/networkConnectionSection/"
          )
        end
      end
    end
  end
end
