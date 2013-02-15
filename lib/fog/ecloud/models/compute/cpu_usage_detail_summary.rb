require 'fog/ecloud/models/compute/cpu_usage_detail'

module Fog
  module Compute
    class Ecloud
      class CpuUsageDetailSummary < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::CpuUsageDetail

        def all
          data = service.get_cpu_usage_detail_summary(href).body[:CpuUsageDetailSummary][:CpuUsageDetail]
          load(data)
        end

        def get(uri)
          if data = service.get_cpu_usage_detail(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
