require 'fog/core/collection'
require 'fog/sakuracloud/models/compute/zone'

module Fog
  module Compute
    class SakuraCloud
      class Zones < Fog::Collection
        model Fog::Compute::SakuraCloud::Zone

        def all
          load service.list_zones.body['Zones']
        end

        def get(id)
          all.find { |f| f.id == id }
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
