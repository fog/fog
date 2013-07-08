require 'fog/core/collection'
require 'fog/vcloudng/models/compute/organization'

module Fog
  module Compute
    class Vcloudng

      class Organizations < Fog::Collection
        model Fog::Compute::Vcloudng::Organization
        
        def all(details=false)
          details ? all_with_details : index
        end
        
        def get(org_id)
          org = get_by_id(org_id)
          return nil unless org
          new(org)
        end
        
        def get_by_name(org_name)
          org = org_links.detect{|org| org[:name] == org_name}
          return nil unless org
          new(org)
        end

        def index
          load(org_links)
        end
        
        def all_with_details
          orgs = org_links.map{|org| get_by_id(org[:id]) }
          load(orgs)
        end
        
#        private

        def get_by_id(org_id)
          data = service.get_organization(org_id).body
          data.delete(:Link)
          service.add_id_from_href!(data)
          data
        end
        
        def org_links
          data = service.get_organizations.body
          org = data[:Org] # there is only a single Org
          org[:description]='<reload to see it>'
          service.add_id_from_href!(org)
          [org]
        end
        
      end
    end
  end
end