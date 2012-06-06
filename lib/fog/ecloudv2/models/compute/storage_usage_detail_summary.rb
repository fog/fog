require 'fog/ecloudv2/models/compute/storage_usage_detail'

module Fog
  module Compute
    class Ecloudv2
      class StorageUsageDetailSummary < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::StorageUsageDetail

        def all
          data = connection.get_storage_usage_detail_summary(href).body[:VirtualMachines][:VirtualMachine]
          load(data)
        end

        def get(uri)
          if data = connection.get_storage_usage_detail(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
