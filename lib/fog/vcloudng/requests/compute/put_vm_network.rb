module Fog
  module Compute
    class Vcloudng
      class Real
        
        def put_vm_network(vm_id, network={})
          require 'fog/vcloudng/generators/compute/vm_network'
          
          data = Fog::Generators::Compute::Vcloudng::VmNetwork.new(network)
          
          request(
            :body => data.generate_xml,
            :expects  => 202,                
            :headers => { 'Content-Type' => 'application/vnd.vmware.vcloud.networkConnectionSection+xml',
                        'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'PUT',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/networkConnectionSection/"
          )
        end
      end
    end
  end
end
