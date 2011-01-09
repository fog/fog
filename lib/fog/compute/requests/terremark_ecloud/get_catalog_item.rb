module Fog
  module TerremarkEcloud
    class Compute

      class Real

        require 'fog/compute/parsers/terremark_ecloud/get_catalog_item'

        def get_catalog_item(catalog_item_uri)
          request({
                    :uri        => catalog_item_uri,
                    :idempotent => true,
                    :parser     => Fog::Parsers::TerremarkEcloud::Compute::GetCatalogItem.new
                  })
        end

      end
    end
  end
end
