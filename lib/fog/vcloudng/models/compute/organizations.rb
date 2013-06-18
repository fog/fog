require 'fog/core/collection'
require 'fog/vcloudng/models/compute/organization'

module Fog
  module Compute
    class Vcloudng

      class Organizations < Fog::Collection
        model Fog::Compute::Vcloudng::Organization
        
        def all
          data = service.get_organizations.body
          load(data['OrgList'])
        end

        def get(organization_id)
          if organization_id
            self.class.new(:service => service).all.detect {|org| org.id == organization_id}
          end
        end
      end
    end
  end
end