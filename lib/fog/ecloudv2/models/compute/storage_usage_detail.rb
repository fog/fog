module Fog
  module Compute
    class Ecloudv2
      class StorageUsageDetail < Fog::Ecloudv2::Model
        identity :href

        attribute :disk_count, :aliases => :DiskCount
        attribute :allocated, :aliases => :Allocated
        
        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
