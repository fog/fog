require 'fog/core/collection'
require 'fog/vcloudng/models/compute/catalog'

module Fog
  module Compute
    class Vcloudng

      class Catalogs < Collection
        model Fog::Compute::Vcloudng::Catalog
        
        attribute :organization
        

        private
        
        def get_by_id(item_id)
          catalog = service.get_catalog(item_id).body
          %w(:CatalogItems :Link).each {|key_to_delete| catalog.delete(key_to_delete) }
          service.add_id_from_href!(catalog)
          catalog
        end
        
        def item_list
          data = service.get_organization(organization.id).body
          catalogs = data[:Link].select { |link| link[:type] == "application/vnd.vmware.vcloud.catalog+xml" }
          catalogs.each{|catalog| service.add_id_from_href!(catalog) }
          catalogs
        end
        
      end
    end
  end
end