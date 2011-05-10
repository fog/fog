require 'fog/core/collection'
require 'fog/compute/models/storm_on_demand/stat'

module Fog
  module StormOnDemand
    class Compute

      class Stats < Fog::Collection
        model Fog::StormOnDemand::Compute::Stat

        def get(options)
          data = connection.get_stats(options).body
          load(data)
        rescue Excon::Errors::Forbidden
          nil
        end

      end

    end
  end
end
