module Fog
  module Compute
    class Vsphere
      class ResourcePool < Fog::Model
        identity :id

        attribute :name
        attribute :cluster
        attribute :datacenter
        attribute :configured_memory_mb
        attribute :overall_status

        def to_s
          name
        end
      end
    end
  end
end
