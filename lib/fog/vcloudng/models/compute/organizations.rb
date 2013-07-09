require 'fog/core/collection'
require 'fog/vcloudng/models/compute/organization'

module Fog
  module Compute
    class Vcloudng

      class Organizations < Fog::Collection
        model Fog::Compute::Vcloudng::Organization
        
        def all(lazy_load=true)
          lazy_load ? index : get_everyone
        end
        
        def get(org_id)
          org = get_by_id(org_id)
          return nil unless org
          new(org)
        end
        
        def get_by_name(org_name)
          org = org_links.detect{|org| org[:name] == org_name}
          return nil unless org
          get(org[:id])
        end

        def index
          load(org_links)
        end
        
        def get_everyone
          orgs = org_links.map{|org| get_by_id(org[:id]) }
          load(orgs)
        end
        
        private

        def get_by_id(org_id)
          org = service.get_organization(org_id).body
          org.delete(:Link)
          service.add_id_from_href!(org)
          org
        end
        
        def org_links
          data = service.get_organizations.body
          org = data[:Org] # there is only a single Org
          service.add_id_from_href!(org)
          [org]
        end
        
      end
    end
  end
end