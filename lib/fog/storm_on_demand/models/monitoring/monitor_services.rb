require 'fog/core/collection'
require 'fog/storm_on_demand/models/monitoring/monitor_service'

module Fog
  module Monitoring
    class StormOnDemand
      class MonitorServices < Fog::Collection
        model Fog::Monitoring::StormOnDemand::MonitorService

        def get(uniq_id)
          status = service.get_service(:uniq_id => uniq_id).body
          new(status)
        end

        def monitoring_ips
          service.monitoring_ips.body['ips']
        end

        def status(uniq_id)
          service.get_service_status(:uniq_id => uniq_id).body
        end

        def update(options)
          status = service.update_service(options).body
          new(status)
        end
      end
    end
  end
end
