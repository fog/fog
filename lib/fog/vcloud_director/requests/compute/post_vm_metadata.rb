module Fog
  module Compute
    class VcloudDirector
      class Real
        
        require 'fog/vcloud_director/generators/compute/metadata'
        
        def post_vm_metadata(vm_id, metadata={})  
          
          data = Fog::Generators::Compute::VcloudDirector::Metadata.new(metadata)
          
          request(
            :body => data.generate_xml,
            :expects  => 202,                
            :headers => { 'Content-Type' => "application/vnd.vmware.vcloud.metadata+xml",
                        'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'POST',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/metadata/"
          )
        end
      end
    end
  end
end
