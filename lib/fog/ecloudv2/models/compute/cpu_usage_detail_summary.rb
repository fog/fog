require 'fog/ecloudv2/models/compute/cpu_usage_detail'

module Fog
  module Compute
    class Ecloudv2
      class CpuUsageDetailSummary < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::CpuUsageDetail

        def all
          data = connection.get_cpu_usage_detail_summary(href).body[:CpuUsageDetailSummary][:CpuUsageDetail]
          load(data)
        end

        def get(uri)
          if data = connection.get_cpu_usage_detail(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
