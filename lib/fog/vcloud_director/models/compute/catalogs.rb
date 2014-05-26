require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/catalog'

module Fog
  module Compute
    class VcloudDirector
      class Catalogs < Collection
        model Fog::Compute::VcloudDirector::Catalog

        attribute :organization

        private

        def get_by_id(item_id)
          item = service.get_catalog(item_id).body
          %w(:CatalogItems :Link).each {|key_to_delete| item.delete(key_to_delete) }
          service.add_id_from_href!(item)
          item
        end

        def item_list
          data = service.get_organization(organization.id).body
          items = data[:Link].select { |link| link[:type] == "application/vnd.vmware.vcloud.catalog+xml" }
          items.each{|item| service.add_id_from_href!(item) }
          items
        end
      end
    end
  end
end
