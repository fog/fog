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
          # creates new model instance based on attributes
          new(response.body)
        end

        # TODO: list function

      end

    end
  end
end
