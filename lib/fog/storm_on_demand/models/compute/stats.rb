require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/stat'

module Fog
  module Compute
    class StormOnDemand

      class Stats < Fog::Collection
        model Fog::Compute::StormOnDemand::Stat

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
