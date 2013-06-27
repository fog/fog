module Fog
  module Compute
    class Vcloudng
      class Real
        require 'fog/vcloudng/generators/compute/disks'
        
        def put_vm_disks(vm_id, items=[])
          data = Fog::Generators::Compute::Vcloudng::Disks.new(items)
          data.modify_hard_disk_size(1, 8192*2)
          puts data.generate
          request(
            :body => data.generate,
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
