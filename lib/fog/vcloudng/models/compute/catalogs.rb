require 'fog/core/collection'
require 'fog/vcloudng/models/compute/catalog'

module Fog
  module Compute
    class Vcloudng

      class Catalogs < Fog::Collection
        model Fog::Compute::Vcloudng::Catalog
        
        attribute :organization
        
        def all(everyone=false)
          everyone ? get_everyone : index
        end
        
        def get(catalog_id)
          catalog = get_by_id(catalog_id)
          return nil unless catalog
          new(catalog)
        end
        
        def get_by_name(catalog_name)
          catalog = catalog_links.detect{|catalog_link| catalog_link[:name] == catalog_name }
          return nil unless catalog
          get(catalog[:id])
        end
        
        def index
          load(catalog_links)
        end 
        
        def get_everyone
          catalog_ids = catalog_links.map {|catalog| catalog[:id] }
          catalogs = catalog_ids.map{ |catalog_id| get_by_id(catalog_id)}
          load(catalogs) 
        end

        private
        
        def get_by_id(catalog_id)
          catalog = service.get_catalog(catalog_id).body
          %w(:CatalogItems :Link).each {|key_to_delete| catalog.delete(key_to_delete) }
          service.add_id_from_href!(catalog)
          catalog
        end
        
        def catalog_links
          data = service.get_organization(organization.id).body
          catalogs = data[:Link].select { |link| link[:type] == "application/vnd.vmware.vcloud.catalog+xml" }
          catalogs.each{|catalog| service.add_id_from_href!(catalog) }
          catalogs
        end
        
      end
    end
  end
end