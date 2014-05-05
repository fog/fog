module Fog
  module Compute
    class Ecloud
      class StorageUsageDetail < Fog::Ecloud::Model
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
