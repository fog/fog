module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/vm_customization'
        
        def get_vm_customization(vm_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::Parsers::Compute::VcloudDirector::VmCustomization.new,
            :path     => "vApp/#{vm_id}/guestCustomizationSection"
          )
        end

      end
    end
  end
end
