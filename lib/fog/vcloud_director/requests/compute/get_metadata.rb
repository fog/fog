module Fog
  module Compute
    class VcloudDirector
      class Real
        
        def get_metadata(vm_id)
          require 'fog/vcloud_director/parsers/compute/metadata'
          
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::Parsers::Compute::VcloudDirector::Metadata.new,
            :path     => "vApp/#{vm_id}/metadata/"
          )
        end

      end
    end
  end
end
