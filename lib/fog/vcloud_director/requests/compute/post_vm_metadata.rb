module Fog
  module Compute
    class VcloudDirector
      class Real
        
        require 'fog/vcloud_director/generators/compute/metadata'
        
        def post_vm_metadata(vm_id, metadata={})  
          metadata_klass = case api_version
                           when '5.1' ; Fog::Generators::Compute::VcloudDirector::MetadataV51
                           when '1.5' ; Fog::Generators::Compute::VcloudDirector::MetadataV15
                           else raise "API version: #{api_version} not supported"
                           end
          data = metadata_klass.new(metadata)
          
          request(
            :body => data.generate_xml,
            :expects  => 202,                
            :headers => { 'Content-Type' => "application/vnd.vmware.vcloud.metadata+xml" },
            :method   => 'POST',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/metadata/"
          )
        end
      end
    end
  end
end
