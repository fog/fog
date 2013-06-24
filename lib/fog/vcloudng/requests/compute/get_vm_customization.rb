module Fog
  module Compute
    class Vcloudng
      class Real
        require 'fog/vcloudng/parsers/compute/vm_customization'
        
        def get_vm_customization(vm_id)
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser => Fog::Parsers::Compute::Vcloudng::VmCustomization.new,
            :path     => "vApp/#{vm_id}/guestCustomizationSection"
          )
        end

      end
    end
  end
end
