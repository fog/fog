module Fog
  module Compute
    class Vcloudng
      class Real
        
        def delete_metadata(vm_id, metadata_key)
          require 'fog/vcloudng/parsers/compute/metadata'
          
          request(
            :expects  => 202,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'DELETE',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/metadata/#{URI.escape(metadata_key)}"
          )
        end

      end
    end
  end
end
