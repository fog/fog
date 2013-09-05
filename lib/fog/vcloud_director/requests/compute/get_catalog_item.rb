module Fog
  module Compute
    class VcloudDirector
      class Real

        def get_catalog_item(catalog_item_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "catalogItem/#{catalog_item_id}"
          )
        end
        

      end
    end
  end
end
