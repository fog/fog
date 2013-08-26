module Fog
  module Compute
    class Vcloudng
      class Real
        
        def get_metadata(vm_id)
          require 'fog/vcloudng/parsers/compute/metadata'
          
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser => Fog::Parsers::Compute::Vcloudng::Metadata.new,
            :path     => "vApp/#{vm_id}/metadata/"
          )
        end

      end
    end
  end
end
