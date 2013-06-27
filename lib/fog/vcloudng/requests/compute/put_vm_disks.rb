module Fog
  module Compute
    class Vcloudng
      class Real
        require 'fog/vcloudng/generators/compute/disks'
        
        # disks is the body of get_vm_disks
        def put_vm_disks(vm_id, disks=[])
          data = Fog::Generators::Compute::Vcloudng::Disks.new(disks)
          
          request(
            :body => data.generate_xml,
            :expects  => 202,                
            :headers => { 'Content-Type' => 'application/vnd.vmware.vcloud.rasdItemsList+xml',
                        'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'PUT',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/virtualHardwareSection/disks"
          )
        end
      end
    end
  end
end
