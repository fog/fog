module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/disks'
        
        
        def get_vm_disks(vm_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::Parsers::Compute::VcloudDirector::Disks.new,
            :path     => "vApp/#{vm_id}/virtualHardwareSection/disks"
          )
        end

      end
    end
  end
end
