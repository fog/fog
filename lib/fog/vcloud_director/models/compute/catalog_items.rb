require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/catalog_item'

module Fog
  module Compute
    class VcloudDirector
      class CatalogItems < Collection
        model Fog::Compute::VcloudDirector::CatalogItem

        attribute :catalog

        private

        def item_list
          data = service.get_catalog(catalog.id).body
          items = data[:CatalogItems][:CatalogItem].select do |link|
            link[:type] == 'application/vnd.vmware.vcloud.catalogItem+xml'
          end
          items.each {|item| service.add_id_from_href!(item)}
          items
        end

        def get_by_id(item_id)
          item = service.get_catalog_item(item_id).body
          item[:vapp_template_id] = item[:Entity][:href].split('/').last
          %w(:Link :Entity).each {|key_to_delete| item.delete(key_to_delete) }
          service.add_id_from_href!(item)
          item
        end
      end
    end
  end
end
