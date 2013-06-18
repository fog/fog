require 'fog/core/collection'
require 'fog/vcloudng/models/compute/catalog'

module Fog
  module Compute
    class Vcloudng

      class Catalogs < Fog::Collection
        model Fog::Compute::Vcloudng::Catalog
        
        attribute :organization
        
        def all(organization_id = organization.id)
          data = service.get_organization(organization_id).body
          catalogs = data["Links"].select { |link| link["type"] == "application/vnd.vmware.vcloud.catalog+xml" }
          catalog_ids = catalogs.map {|catalog| catalog['href'].split('/').last }
          catalog_ids.map{ |catalog_id| get(catalog_id)} 
        end

        def get(catalog_id)
          data = service.get_catalog(catalog_id).body
          %w(CatalogItems Links).each {|key_to_delete| data.delete(key_to_delete) }
          new(data)
        end
      end
    end
  end
end