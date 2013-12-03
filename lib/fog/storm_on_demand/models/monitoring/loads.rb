require 'fog/core/collection'
require 'fog/storm_on_demand/models/monitoring/load'

module Fog
  module Monitoring
    class StormOnDemand

      class Loads < Fog::Collection
        model Fog::Monitoring::StormOnDemand::Load

        def graph(options)
          service.get_load_graph(options).body
        end

        def stats(uniq_id)
          load = service.get_load_stats(:uniq_id => uniq_id).body
          new(load)
        end

      end

    end
  end
end
