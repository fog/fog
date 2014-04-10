require 'fog/core/collection'
require 'fog/google/models/compute/operation'

module Fog
  module Compute
    class Google

      class Operations < Fog::Collection

        model Fog::Compute::Google::Operation

        def get(identity, zone=nil, region=nil)
          puts "Getting operation #{identity} zone=#{zone} region=#{region}"
          if not zone.nil?
            response = service.get_zone_operation(zone, identity)
          elsif not region.nil?
            response = service.get_region_operation(region, identity)
          else
            response = service.get_global_operation(identity)
          end
          return nil if response.nil?
          new(response.body)
        end

      end

    end
  end
end
