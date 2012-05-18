require 'fog/ecloudv2/models/compute/memory_usage_detail'

module Fog
  module Compute
    class Ecloudv2
      class MemoryUsageDetailSummary < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::MemoryUsageDetail

        def all
          data = connection.get_memory_usage_detail_summary(href).body[:MemoryUsageDetailSummary][:MemoryUsageDetail]
          load(data)
        end

        def get(uri)
          if data = connection.get_memory_usage_detail(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
