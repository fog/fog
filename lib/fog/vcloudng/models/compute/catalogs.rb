require 'fog/core/collection'
require 'fog/vcloudng/models/compute/catalog'

module Fog
  module Compute
    class Vcloudng

      class Catalogs < Fog::Collection
        model Fog::Compute::Vcloudng::Catalog
        
        attribute :organization
        
        def index(organization_id = organization.id)
          catalog_links(organization_id).map{ |catalog| new(catalog)}
        end 
        
        def all(organization_id = organization.id)
          catalog_ids = catalog_links(organization_id).map {|catalog| catalog[:id] }
          catalog_ids.map{ |catalog_id| get(catalog_id)} 
        end

        def get(catalog_id)
          data = service.get_catalog(catalog_id).body
          %w(:CatalogItems :Link).each {|key_to_delete| data.delete(key_to_delete) }
          data[:id] = data[:href].split('/').last
          new(data)
        end
        
        def get_by_name(catalog_name, organization_id = organization.id)
          catalog = catalog_links(organization_id).detect{|catalog_link| catalog_link[:name] == catalog_name }
          return nil unless catalog
          catalog_id = catalog[:id]
          get(catalog_id)
        end
        
        private
        
        def catalog_links(organization_id)
          data = service.get_organization(organization_id).body
          catalogs = data[:Link].select { |link| link[:type] == "application/vnd.vmware.vcloud.catalog+xml" }
          catalogs.each{|catalog| catalog[:id] = catalog[:href].split('/').last }
          catalogs
        end
        
      end
    end
  end
end