module Fog
  module Compute
    class VcloudDirector
      class Real
        
        def get_catalog(catalog_uuid)
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "catalog/#{catalog_uuid}"
          )
        end

      end
    end
  end
end
