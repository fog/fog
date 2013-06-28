module Fog
  module Compute
    class Vcloudng
      class Real
        require 'fog/vcloudng/generators/compute/customization'
        
        def put_vm_customization(vm_id, customization={})
          data = Fog::Generators::Compute::Vcloudng::Customization.new(customization)
          
          request(
            :body => data.generate_xml,
            :expects  => 202,                
            :headers => { 'Content-Type' => 'application/vnd.vmware.vcloud.guestCustomizationSection+xml',
                        'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'PUT',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/guestCustomizationSection"
          )
        end
      end
    end
  end
end
