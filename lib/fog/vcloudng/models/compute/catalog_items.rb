require 'fog/core/collection'
require 'fog/vcloudng/models/compute/catalog_item'

module Fog
  module Compute
    class Vcloudng

      class CatalogItems < Fog::Collection
        model Fog::Compute::Vcloudng::CatalogItem
        
        attribute :catalog
        
        def all(catalog_id = catalog.id)
          data = service.get_catalog(catalog_id).body
          catalog_items = data["CatalogItems"].select { |link| link["type"] == "application/vnd.vmware.vcloud.catalogItem+xml" }
          catalog_item_ids = catalog_items.map {|catalog_item| catalog_item['id'] }
          catalog_item_ids.map{ |catalog_item_id| get(catalog_item_id)} 
        end

        def get(catalog_item_id)
          data = service.get_catalog_item(catalog_item_id).body
          %w(CatalogItems Entity).each {|key_to_delete| data.delete(key_to_delete) }
          new(data)
        end
      end
    end
  end
end