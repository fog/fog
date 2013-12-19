require 'fog/core/collection'
require 'fog/xenserver/models/compute/pif_metrics'

module Fog
  module Compute
    class XenServer
      class PifsMetrics < Fog::Collection
        model Fog::Compute::XenServer::PifMetrics

        def all(options={})
          data = service.get_records 'PIF_metrics'
          load(data)
        end

        def get( pif_metrics_ref )
          if pif_metrics_ref && pif_metrics = service.get_record( pif_metrics_ref, 'PIF_metrics' )
            new(pif_metrics)
          else
            nil
          end
        end
      end
    end
  end
end
