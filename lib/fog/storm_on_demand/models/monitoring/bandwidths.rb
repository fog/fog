require 'fog/core/collection'
require 'fog/storm_on_demand/models/monitoring/bandwidth'

module Fog
  module Monitoring
    class StormOnDemand

      class Bandwidths < Fog::Collection
        model Fog::Monitoring::StormOnDemand::Bandwidth

        def graph(options)
          service.get_bandwidth_graph(options).body
        end

        def stats(uniq_id)
          bw = service.get_bandwidth_stats(:uniq_id => uniq_id).body
          new(bw)
        end

      end
    end
  end
end
