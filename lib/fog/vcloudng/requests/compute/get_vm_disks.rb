module Fog
  module Compute
    class Vcloudng
      class Real
        require 'fog/vcloudng/parsers/compute/disks'
        
        
        def get_vm_disks(vm_id)
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser => Fog::Parsers::Compute::Vcloudng::Disks.new,
            :path     => "vApp/#{vm_id}/virtualHardwareSection/disks"
          )
        end

      end
    end
  end
end
