module Fog
  module Compute
    class VcloudDirector
      class Real
                
        def put_metadata_value(vm_id, metadata_key, metadata_value)  
          body="
          <MetadataValue xmlns=\"http://www.vmware.com/vcloud/v1.5\">
              <Value>#{metadata_value}</Value>
           </MetadataValue>"
          
          
          request(
            :body => body,
            :expects  => 202,                
            :headers => { 'Content-Type' => "application/vnd.vmware.vcloud.metadata.value+xml" },
            :method   => 'PUT',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/metadata/#{URI.escape(metadata_key)}"
          )
        end
      end
    end
  end
end
