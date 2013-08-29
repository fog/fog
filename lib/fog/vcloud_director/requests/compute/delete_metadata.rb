module Fog
  module Compute
    class VcloudDirector
      class Real
        
        def delete_metadata(vm_id, metadata_key)
          require 'fog/vcloud_director/parsers/compute/metadata'
          
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/metadata/#{URI.escape(metadata_key)}"
          )
        end

      end
    end
  end
end
