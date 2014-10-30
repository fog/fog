require 'fog/core/collection'
require 'fog/exoscale/models/compute/zone'

module Fog
  module Compute
    class Exoscale
      class Zones < Fog::Collection
        model Fog::Compute::Exoscale::Zone

        def all(filters={})
          options = {
            'templatefilter' => 'self'
          }.merge(filters)

          data = service.list_zones(options)["listzonesresponse"]["zone"] || []
          load(data)
        end

        def get(zone_id)
          if zone = service.list_zones('id' => zone_id)["listzonesresponse"]["zone"].first
            new(zone)
          end
        rescue Fog::Compute::Exoscale::BadRequest
          nil
        end
      end
    end
  end
end
