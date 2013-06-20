require 'fog/core/collection'
require 'fog/vcloudng/models/compute/catalog_item'

module Fog
  module Compute
    class Vcloudng

      class CatalogItems < Fog::Collection
        model Fog::Compute::Vcloudng::CatalogItem
        
        attribute :catalog
        
        def index(catalog_id = catalog.id)
          catalog_item_links(catalog_id).map{ |catalog_item| new(catalog_item)}
        end
        
        def all(catalog_id = catalog.id)
          catalog_item_ids = catalog_item_links(catalog_id).map {|catalog_item| catalog_item[:id] }
          catalog_item_ids.map{ |catalog_item_id| get(catalog_item_id)} 
        end

        def get(catalog_item_id)
          data = service.get_catalog_item(catalog_item_id).body
          data[:id] = data[:href].split('/').last
          data[:vapp_template_id] = data[:Entity][:href].split('/').last
          %w(:Link :Entity).each {|key_to_delete| data.delete(key_to_delete) }
          new(data)
        end
        
        def get_by_name(catalog_item_name, catalog_id = catalog.id)
          catalog_item = catalog_item_links(catalog_id).detect{|cat_item_link| cat_item_link[:name] == catalog_item_name }
          return nil unless catalog_item
          get(catalog_item[:id])
        end
        
        private
        
        def catalog_item_links(catalog_id)
          data = service.get_catalog(catalog_id).body
          catalog_items = data[:CatalogItems][:CatalogItem].select { |link| link[:type] == "application/vnd.vmware.vcloud.catalogItem+xml" }
          catalog_items.each{|catalog_item| catalog_item[:id] = catalog_item[:href].split('/').last }
          catalog_items
        end
      end
    end
  end
end