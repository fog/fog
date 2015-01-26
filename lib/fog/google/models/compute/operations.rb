require 'fog/core/collection'
require 'fog/google/models/compute/operation'

module Fog
  module Compute
    class Google
      class Operations < Fog::Collection
        model Fog::Compute::Google::Operation

        def all(filters = {})
          if filters['zone']
            data = service.list_zone_operations(filters['zone']).body
          elsif filters['region']
            data = service.list_region_operations(filters['region']).body
          else
            data = service.list_global_operations.body
          end
          load(data['items'] || [])
        end

        def get(identity, zone=nil, region=nil)
          if not zone.nil?
            response = service.get_zone_operation(zone, identity)
          elsif not region.nil?
            response = service.get_region_operation(region, identity)
          else
            response = service.get_global_operation(identity)
          end
          return nil if response.nil?
          new(response.body)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
