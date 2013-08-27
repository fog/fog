require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/organization'

module Fog
  module Compute
    class VcloudDirector

      class Organizations < Collection
        model Fog::Compute::VcloudDirector::Organization
        
        
        private

        def get_by_id(org_id)
          org = service.get_organization(org_id).body
          org.delete(:Link)
          service.add_id_from_href!(org)
          org
        end
        
        def item_list
          data = service.get_organizations.body
          org = data[:Org] # there is only a single Org
          service.add_id_from_href!(org)
          [org]
        end
        
      end
    end
  end
end