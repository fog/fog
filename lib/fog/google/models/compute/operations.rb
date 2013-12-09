require 'fog/core/collection'
require 'fog/google/models/compute/operation'

module Fog
  module Compute
    class Google

      class Operations < Fog::Collection

        model Fog::Compute::Google::Operation

        def get(identity, zone=nil)
          if zone.nil?
            response = service.get_global_operation(identity)
          else
            response = service.get_zone_operation(zone, identity)
          end
          return nil if response.nil?
          new(response.body)
        end

      end

    end
  end
end
