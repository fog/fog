require 'fog/core/collection'
require 'fog/vcloudng/models/compute/organization'

module Fog
  module Compute
    class Vcloudng

      class Organizations < Fog::Collection
        model Fog::Compute::Vcloudng::Organization
        
        def all
          data = service.get_organizations.body
          org = data[:Org]
          org[:id] = org[:href].split('/').last
          load([org])
        end

        def get(organization_id)
          data = service.get_organization(organization_id).body
          data.delete(:Link)
          data[:id] = data[:href].split('/').last
          new(data)
        end
      end
    end
  end
end