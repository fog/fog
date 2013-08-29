module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/customization'
        
        def put_vm_customization(vm_id, customization={})
          data = Fog::Generators::Compute::VcloudDirector::Customization.new(customization)
          
          request(
            :body => data.generate_xml,
            :expects  => 202,                
            :headers => { 'Content-Type' => 'application/vnd.vmware.vcloud.guestCustomizationSection+xml' },
            :method   => 'PUT',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/guestCustomizationSection"
          )
        end
      end
    end
  end
end
