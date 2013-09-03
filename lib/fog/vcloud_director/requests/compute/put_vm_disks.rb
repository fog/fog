module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/disks'
        
        # disks is the body of get_vm_disks
        def put_vm_disks(vm_id, disks=[])
          data = Fog::Generators::Compute::VcloudDirector::Disks.new(disks)
          
          request(
            :body => data.generate_xml,
            :expects  => 202,                
            :headers => { 'Content-Type' => 'application/vnd.vmware.vcloud.rasdItemsList+xml' },
            :method   => 'PUT',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/virtualHardwareSection/disks"
          )
        end
      end
    end
  end
end
